#!/usr/bin/env python3
"""Audit the Selected Work move, public bytes, links, tools and source archives.

Run from any directory after packaging and the production build. This reads
project evidence without regenerating captures, provenance or application state.
"""
from pathlib import Path
import ast
import hashlib
import json
import re
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[3]
PROJECTS = ('sift', 'form', 'frame', 'fold')
EXCLUDED = {'.dart_tool', 'build', 'ephemeral', '__pycache__', 'node_modules'}
ARCHIVE_LIMIT_BYTES = 100 * 1024 * 1024
FRAME_PACKAGE_EXCLUDED = {
    '.git', '.cxx', '.kotlin', '.dart_tool', 'build', '.idea', '.gradle',
    'Pods', '.symlinks', 'ephemeral', '__pycache__', 'node_modules', 'data',
}


def is_frame_recording(name):
    path = Path(name)
    return name.startswith('docs/frame/') and path.suffix in {'.mp4', '.webm'}


def frame_recording_files():
    """Match the packager's recording exclusions without importing its writer."""
    base = ROOT / 'docs/frame'
    return {
        str(path.relative_to(ROOT)): path
        for path in base.rglob('*')
        if path.is_file()
        and path.suffix in {'.mp4', '.webm'}
        and not any(
            part in FRAME_PACKAGE_EXCLUDED or part.startswith('.plugin')
            for part in path.relative_to(base).parts
        )
        and not (path.name.startswith('page@') and path.suffix == '.webm')
        and '.sb-' not in path.name
    }


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check():
    mapping = json.loads((ROOT / 'docs/selected-work/organization-map.json').read_text())
    failures = []
    preserved_evidence = 0
    for item in mapping['moves']:
        old, new = ROOT / item['from'], ROOT / item['to']
        if old.exists() or not new.is_file():
            failures.append({'move': item, 'reason': 'Old path exists or destination is missing'})
            continue
        # Text references were rebased; visual/audio evidence and dated logs stay exact.
        if new.suffix in {'.png', '.jpg', '.webp', '.mp4', '.webm', '.pdf', '.zip', '.log'} or '/verification/logs/' in item['to']:
            preserved_evidence += 1
            if digest(new) != item['sha256Before']:
                failures.append({'file': item['to'], 'reason': 'Moved evidence bytes changed'})

    protected = 0
    for name, before in mapping['protectedBefore'].items():
        path = ROOT / name
        # Authorized changes are guides, path metadata, archives and proof helpers.
        strict = name.startswith(('lib/', 'test/')) or (
            name.startswith('web/') and path.suffix not in {'.md', '.json', '.zip'}
        ) or (
            name.startswith(('docs/frame/app/', 'docs/frame/service/'))
            and path.suffix not in {'.md', '.json'}
            and '/tool/' not in name
            and not path.name.startswith(('capture-', 'browser-checks', 'http-checks', 'enrolment-race'))
        )
        if strict:
            protected += 1
            if not path.is_file() or digest(path) != before:
                failures.append({'file': name, 'reason': 'Runtime/source/artwork bytes changed'})

    markdown = [ROOT / 'README.md', * (ROOT / 'docs/selected-work').glob('*.md')]
    for project in PROJECTS:
        markdown.extend((ROOT / 'docs' / project).rglob('*.md'))
        markdown.extend((ROOT / 'web/assets/selected-work' / project).rglob('*.md'))
    checked_links = 0
    for path in markdown:
        if EXCLUDED.intersection(path.parts):
            continue
        for match in re.finditer(r'!?\[[^\]\n]*\]\(([^)\s]+)\)', path.read_text()):
            target = match[1].strip('<>').split('#')[0]
            if not target or ':' in target:
                continue
            checked_links += 1
            if not (path.parent / target).exists():
                failures.append({'file': str(path.relative_to(ROOT)), 'link': target, 'reason': 'Missing local link'})

    scripts = {'python': 0, 'node': 0}
    node = shutil.which('node')
    for project in PROJECTS:
        for path in (ROOT / 'docs' / project).rglob('*'):
            if not path.is_file() or EXCLUDED.intersection(path.parts):
                continue
            if path.suffix == '.py':
                ast.parse(path.read_text(), filename=str(path))
                scripts['python'] += 1
            elif path.suffix in {'.cjs', '.mjs'}:
                subprocess.run([node, '--check', str(path)], check=True, capture_output=True)
                scripts['node'] += 1

    manifests = {}
    archives = []
    built_files = 0
    for project in PROJECTS:
        base = ROOT / 'web/assets/selected-work' / project
        if project == 'frame':
            assert (base / 'frame-source.zip').is_file(), 'Missing Frame source archive'
            assert (base / 'frame-recordings.zip').is_file(), 'Missing Frame recordings archive'
        manifest = json.loads((base / 'source/asset-manifest.json').read_text())
        entries = manifest if isinstance(manifest, list) else manifest.get('items', manifest.get('assets', []))
        manifests[project] = len(entries)
        for item in entries:
            name = item.get('runtime_filename', item.get('runtimeFilename', item.get('source', '')))
            path = ROOT / 'web' / name if name.startswith('assets/') else base / name
            if not path.is_file() or digest(path) != item['sha256']:
                failures.append({'file': str(path), 'reason': 'Asset manifest mismatch'})
        for path in base.rglob('*'):
            if not path.is_file() or path.name == '.DS_Store':
                continue
            built_files += 1
            built = ROOT / 'build/jaspr' / path.relative_to(ROOT / 'web')
            if not built.is_file() or digest(path) != digest(built):
                failures.append({'file': str(path.relative_to(ROOT)), 'reason': 'Production build differs'})
        for archive in base.glob('*.zip'):
            assert archive.stat().st_size <= ARCHIVE_LIMIT_BYTES, f'Archive exceeds 100 MiB: {archive}'
            with zipfile.ZipFile(archive) as contents:
                assert contents.testzip() is None, str(archive)
                names = contents.namelist()
                required = {
                    'form': ['records/tools/package_source.py', 'records/production/production-record.md'],
                    'frame': ['docs/frame/tools/package-source.py', 'docs/frame/verification/verification.md', 'docs/frame/app/lib/main.dart'],
                    'fold': ['Fold-Clothing/docs/fold/tools/package-source.py', 'Fold-Clothing/docs/fold/production/production-record.md'],
                }.get(project, [])
                if project == 'frame' and archive.name == 'frame-recordings.zip':
                    required = [
                        'README.md',
                        'docs/frame/verification/native/native-core-en-raw.mp4',
                        'docs/frame/verification/native/native-core-ar-raw.mp4',
                    ]
                    assert len(names) == len(set(names)), f'Duplicate recording entries: {archive}'
                    assert all(name == 'README.md' or is_frame_recording(name) for name in names), f'Unexpected recording archive entry: {archive}'
                    expected = frame_recording_files()
                    recorded = {name for name in names if name != 'README.md'}
                    assert recorded == set(expected), {
                        'archive': str(archive),
                        'missingRecordings': sorted(set(expected) - recorded),
                        'unexpectedRecordings': sorted(recorded - set(expected)),
                    }
                    for name, original in expected.items():
                        assert hashlib.sha256(contents.read(name)).hexdigest() == digest(original), f'Recording differs from source: {name}'
                elif project == 'frame':
                    assert not any(is_frame_recording(name) for name in names), f'Recording duplicated in source archive: {archive}'
                assert all(name in names for name in required), str(archive)
                assert not any(EXCLUDED.intersection(Path(name).parts) or Path(name).name == '.DS_Store' for name in names), str(archive)
                archives.append({'project': project, 'file': str(archive.relative_to(ROOT)), 'entries': len(names), 'integrity': 'passed', 'sha256': digest(archive)})

    result = {
        'date': '2026-10-16',
        'scope': 'Physical folder organization and current local verification; no publication',
        'movedFiles': len(mapping['moves']),
        'movedEvidencePreservedExactly': preserved_evidence,
        'protectedRuntimeSourceAndArtworkFiles': protected,
        'localLinksChecked': checked_links,
        'scriptsChecked': scripts,
        'manifestAssetsChecked': manifests,
        'publicFilesMatchingProductionBuild': built_files,
        'sourceArchives': archives,
        'failures': failures,
    }
    return result


if __name__ == '__main__':
    result = check()
    output = ROOT / 'docs/selected-work/organization-validation.json'
    output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: v for k, v in result.items() if k != 'sourceArchives'}, indent=2))
    raise SystemExit(bool(result['failures']))
