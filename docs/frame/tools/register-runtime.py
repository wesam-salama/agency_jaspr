from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[3]
F=R/'web/assets/selected-work/frame'
labels={
 'card.webp':('Composition Essentials discovery and saved continuation','Actual website decision and native app with 1 of 6 and lesson 02.'),
 'hero.webp':('One system from course discovery to native continuation','Editable course cover and actual web/app screens.'),
 'identity.webp':('Carry the identity','Approved fixed open corners, palette, type and course covers.'),
 'course-discovery.webp':('Choose with clarity','Actual outcome, prerequisite and equipment before enrolment.'),
 'lesson-continuation.webp':('Keep the next step visible','Actual 1 of 6 after cold restart with lesson 02 next.'),
 'exercise-recovery.webp':('Recover without losing work','Actual retained failed note, confirmed retry and explicit completion.'),
 'arabic-journey.webp':('Complete Arabic continuity','Actual Arabic decision, captioned player, saved note and restart.')}
rows=[]
for item in json.loads((R/'docs/frame/production/export-record.json').read_text()):
 caption,alt=labels[item['file']]
 paths=[F/item['file'],*sorted(F.glob(Path(item['file']).stem+'-*.webp'))]
 for p in paths:
  rows.append({**item,'file':str(p.relative_to(R)), 'created':'2026-10-14','bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'caption':caption,'alt':alt,'cropRule':'Preserve complete presentation; contain chapter boards. Safe margin eight percent on card/hero.','rights':'Original authored digital composition; actual software captures, licensed local fonts and declared generated teaching artwork.'})
for lang,file in [('en','demo-journey.mp4'),('ar','demo-journey-ar.mp4')]:
 rec=json.loads((R/f'docs/frame/production/journey-record-{lang}.json').read_text())
 rows.append({**rec,'file':str((F/file).relative_to(R)), 'caption':'Actual website/app journey; cuts and stated playback speeds documented.','rights':'Original local implementation recording; no synthetic interface.'})
(R/'docs/frame/production/runtime-exports.json').write_text(json.dumps({'date':'2026-10-14','exports':rows},indent=2)+'\n')
print(f'Registered {len(rows)} final runtime presentation/media exports.')
