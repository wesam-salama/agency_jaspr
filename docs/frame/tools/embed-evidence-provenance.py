#!/usr/bin/env python3
"""Attach origin records to captured screens and authored presentation rasters."""
from pathlib import Path
import json, subprocess

ROOT = Path(__file__).resolve().parents[3]
FRAME = ROOT / 'web/assets/selected-work/frame'
LAUNCHER = '/Users/wesamsalama/.agents/skills/impeccable/scripts/impeccable'
records = []

def embed(path, origin):
    subprocess.run([LAUNCHER, 'embed-prompt', str(path), '--prompt', origin], check=True, capture_output=True)
    records.append({'file': str(path.relative_to(ROOT)), 'origin': origin})

exports_file = ROOT / 'docs/frame/production/export-record.json'
exports = json.loads(exports_file.read_text()) if exports_file.exists() else []
for item in exports:
    parent = FRAME / item['file']
    sources = ', '.join(item['captures'])
    origin = ('Authored Frame Academy case presentation. Actual browser render of '
              + item['source'] + '. Uses approved editable artwork and actual implementation '
              'captures: ' + sources + '. Layout labels are presentation annotations; no generated '
              'interface, fabricated learner result or physical device mockup. Original sources '
              'and full captures are retained in the editable project package.')
    for path in [parent, *sorted(FRAME.glob(parent.stem + '-*.webp')),
                 ROOT / item['source'].replace('.html', '.png')]:
        if path.exists(): embed(path, origin)

for folder, label in [('verification/website', 'actual local Chrome website'),
                      ('verification/native', 'actual running iPhone simulator app'),
                      ('verification/agency', 'actual locally built multilingual CR8.Media agency case')]:
    for path in sorted((ROOT / 'docs/frame' / folder).glob('*.png')):
        embed(path, 'Frame Academy implementation evidence: screenshot of ' + label + '. '
              'Capture file: ' + path.name + '. Recorded alongside the corresponding verification '
              'report in docs/frame. This is captured software, not generated interface artwork. '
              'Older diagnosis captures are labelled by their filename and are not final journey proof.')

(ROOT / 'docs/frame/production/evidence-provenance.json').write_text(json.dumps(records, indent=2) + '\n')
print(json.dumps({'originRecords': len(records)}))
