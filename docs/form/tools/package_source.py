#!/usr/bin/env python3
"""Build the editable source ZIP without changing artwork or provenance."""
from pathlib import Path
import json
import zipfile

ROOT = Path(__file__).resolve().parents[3]
ASSETS = ROOT / 'web/assets/selected-work/form'
PROJECT = ROOT / 'docs/form'


def package_source():
    zip_path = ASSETS / 'form-source.zip'
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(ASSETS.rglob('*')):
            if not path.is_file() or path.suffix == '.zip' or path.name == '.DS_Store':
                continue
            name = str(path.relative_to(ASSETS))
            if path.suffix in ('.html', '.css', '.js'):
                archive.writestr(name, path.read_text().replace('../../../fonts/', '../fonts/'))
            else:
                archive.write(path, name)
        for path in sorted(PROJECT.rglob('*')):
            if path.is_file() and '__pycache__' not in path.parts and path.suffix != '.pyc' and path.name != '.DS_Store':
                archive.write(path, Path('records') / path.relative_to(PROJECT))
        for name in ('ibm-plex-sans-arabic-regular.woff2',
                     'ibm-plex-sans-arabic-semibold.woff2',
                     'IBM-Plex-Sans-Arabic-OFL.txt'):
            archive.write(ROOT / 'web/assets/fonts' / name, Path('fonts') / name)
    with zipfile.ZipFile(zip_path) as archive:
        assert archive.testzip() is None
        required = ('site/index.html', 'site/editor.html', 'source/wordmark.svg',
                    'records/README.md', 'records/tools/package_source.py',
                    'records/production/production-record.md',
                    'records/verification/verification.md')
        assert all(name in archive.namelist() for name in required)
    return zip_path


if __name__ == '__main__':
    result = package_source()
    print(json.dumps({'zip': str(result), 'zip_bytes': result.stat().st_size}))
