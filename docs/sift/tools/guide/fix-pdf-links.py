"""Preserve authored relative hrefs in Chromium's Sift guide PDF annotations."""

from __future__ import annotations

import argparse
from html.parser import HTMLParser
import json
from pathlib import Path
import tempfile
from urllib.parse import unquote, urlsplit

from pypdf import PdfReader, PdfWriter
from pypdf.generic import NameObject, TextStringObject


class GuideLinks(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.hrefs: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag == "a":
            href = dict(attrs).get("href")
            if href:
                self.hrefs.append(href)


def fix_links(pdf: Path, html: Path) -> dict:
    parser = GuideLinks()
    parser.feed(html.read_text())
    expected = parser.hrefs
    if len(expected) != 14 or len(set(expected)) != 14:
        raise ValueError("Expected 14 distinct authored guide hrefs")
    base = html.parent.resolve()
    for href in expected:
        parts = urlsplit(href)
        if parts.scheme or parts.netloc or href.startswith("/"):
            raise ValueError(f"Guide source href must be relative: {href}")
        target = (base / unquote(parts.path)).resolve()
        target.relative_to(base)
        if not target.is_file():
            raise FileNotFoundError(f"Missing relative guide destination: {href}")

    reader = PdfReader(pdf)
    writer = PdfWriter()
    writer.clone_document_from_reader(reader)
    updated = 0
    seen: list[str] = []
    for page in writer.pages:
        for reference in page.get("/Annots", []):
            annotation = reference.get_object()
            action = annotation.get("/A")
            if not action or action.get("/S") != "/URI":
                continue
            original = str(action.get("/URI", ""))
            parsed = urlsplit(original)
            if parsed.scheme or parsed.netloc:
                prefix = "/assets/selected-work/sift/"
                if parsed.hostname not in ("127.0.0.1", "localhost") or not parsed.path.startswith(prefix):
                    raise ValueError(f"Unexpected absolute PDF URI: {original}")
                href = unquote(parsed.path[len(prefix):])
            else:
                href = original
            if href not in expected:
                raise ValueError(f"PDF URI is not an authored guide href: {href}")
            if original != href:
                action[NameObject("/URI")] = TextStringObject(href)
                updated += 1
            seen.append(href)
    if sorted(seen) != sorted(expected):
        raise ValueError("PDF URI annotations do not match all 14 authored links")
    if updated:
        with tempfile.NamedTemporaryFile(dir=pdf.parent, suffix=".pdf", delete=False) as temp:
            temporary = Path(temp.name)
            writer.write(temp)
        temporary.replace(pdf)

    verified = []
    final = PdfReader(pdf)
    for page_number, page in enumerate(final.pages, 1):
        for reference in page.get("/Annots", []):
            action = reference.get_object().get("/A")
            if not action or action.get("/S") != "/URI":
                continue
            href = str(action["/URI"])
            parsed = urlsplit(href)
            if parsed.scheme or parsed.netloc or href.startswith("/") or "localhost" in href or "127.0.0.1" in href:
                raise ValueError("An absolute or temporary-origin URI survived the correction")
            target = (base / unquote(parsed.path)).resolve()
            target.relative_to(base)
            if not target.is_file():
                raise FileNotFoundError(href)
            verified.append({"page": page_number, "uri": href, "relativeFileExists": True})
    if sorted(record["uri"] for record in verified) != sorted(expected):
        raise ValueError("Written PDF link annotations failed verification")
    return {
        "annotationCount": len(verified),
        "updatedAnnotationCount": updated,
        "containsTemporaryOrigin": False,
        "allRelativeFilesExist": True,
        "annotations": verified,
        "modificationScope": "URI annotation values only; authored HTML hrefs and page content unchanged",
    }


if __name__ == "__main__":
    arguments = argparse.ArgumentParser()
    arguments.add_argument("--pdf", type=Path, required=True)
    arguments.add_argument("--html", type=Path, required=True)
    arguments.add_argument("--report", type=Path)
    args = arguments.parse_args()
    result = fix_links(args.pdf.resolve(), args.html.resolve())
    if args.report:
        args.report.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))
