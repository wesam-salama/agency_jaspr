from pathlib import Path
import json,subprocess,sys
root=Path(__file__).resolve().parents[4]
asset=root/'web/assets/selected-work/frame'
launcher='/Users/wesamsalama/.agents/skills/impeccable/scripts/impeccable'
prompt=json.loads((root/'docs/frame/production/generation-prompts.json').read_text())['prompt']
for folder in ['source','media']:
    for p in sorted((asset/folder).iterdir()):
        if p.suffix not in ['.png','.webp'] or (sys.argv[1:] and p.name not in sys.argv[1:]): continue
        if p.name=='composition-source.png': provenance=prompt
        elif p.name.startswith('poster'): provenance='Authored Frame Academy silent visual lesson proof. Actual browser render of source/lesson-film.html at18.000 seconds in '+('Arabic' if '-ar' in p.stem else 'English')+'. Original geometric frame and exact editable typesetting; generated coral-ceramic source is credited in docs/frame/production/generation-prompts.json. No generated interface or learner work.'
        elif p.stem=='frame-app-icon-1024': provenance='Authored Frame Academy app icon. Actual browser render of source/frame-app-icon.svg at1024×1024. Original deterministic two-offset-L identity, fixed orientation, white on #244CCD. No generated imagery.'
        else: provenance='Authored Frame Academy digital artwork proof. Actual browser render/export of source/'+p.stem+'.svg; '+('WebP derived from exact PNG proof; ' if p.suffix=='.webp' else '')+'original editable vector/typesetting with licensed bundled fonts. Course artwork uses owned generated photograph only where specified in docs/frame/production/generation-prompts.json; no physical printing or interface behavior is represented.'
        subprocess.run([launcher,'embed-prompt',str(p),'--prompt',provenance],check=True,capture_output=True)
print('Embedded provenance into all source/media PNG and WebP files',flush=True)
