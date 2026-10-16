#!/usr/bin/env python3
"""Check preserved projects, final exports, media and source package bytes."""
from pathlib import Path
import hashlib,json,subprocess,zipfile

ROOT=Path(__file__).resolve().parents[3]
FRAME=ROOT/'web/assets/selected-work/frame'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
baseline=json.loads((ROOT/'docs/frame/verification/preservation-baseline.json').read_text())
changed=[p for p,h in baseline.items() if not (ROOT/p).is_file() or sha(ROOT/p)!=h]
assert not changed,changed
media=[]
for file in ['see-the-edges.mp4','see-the-edges-ar.mp4']:
    p=FRAME/'media'/file
    result=json.loads(subprocess.check_output(['ffprobe','-v','quiet','-show_format','-show_streams','-of','json',str(p)]))
    video=next(s for s in result['streams'] if s['codec_type']=='video')
    duration=float(result['format']['duration'])
    assert abs(duration-30)<0.15,(file,duration)
    assert video['width']==1920 and video['height']==1080,(file,video)
    media.append({'file':file,'actualSeconds':duration,'plannedLessonMinutes':8,'plannedCurriculumMinutes':62,'dimensions':[video['width'],video['height']],'sha256':sha(p)})
for lang in ['en','ar']:
    text=(FRAME/f'media/transcript-{lang}.txt').read_text()
    vtt=(FRAME/f'media/captions-{lang}.vtt').read_text()
    assert len(text)>150 and vtt.startswith('WEBVTT') and '-->' in vtt
package=FRAME/'frame-source.zip'
with zipfile.ZipFile(package) as z:
    assert z.testzip() is None
    entries=z.namelist()
    assert 'docs/frame/app/lib/main.dart' in entries
    assert 'docs/frame/service/server.mjs' in entries
    assert not any('/.dart_tool/' in n or '/build/' in n or '/service/data/' in n for n in entries)
build=ROOT/'build/jaspr'
built=[]
for p in FRAME.rglob('*'):
    if not p.is_file():continue
    dest=build/p.relative_to(ROOT/'web')
    assert dest.is_file(),str(dest)
    assert sha(dest)==sha(p),str(p)
    built.append(str(p.relative_to(FRAME)))
record={'preservedExistingFiles':len(baseline),'changedExistingFiles':changed,'media':media,'sourcePackage':{'files':len(entries),'bytes':package.stat().st_size,'sha256':sha(package)},'matchingBuiltFrameFiles':len(built)}
(ROOT/'docs/frame/verification/final-artifact-checks.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
