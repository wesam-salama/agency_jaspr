#!/usr/bin/env python3
"""Register sources, embed provenance and package editable local delivery."""
from pathlib import Path
import json, hashlib, subprocess, re
import sys
sys.path.append('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/lib/python3.12/site-packages')
from PIL import Image
from fontTools.ttLib import TTFont

ROOT=Path(__file__).resolve().parents[3]
ASSETS=ROOT/'web/assets/selected-work/form'
TOOL='/Users/wesamsalama/.agents/skills/impeccable/scripts/impeccable'
prompts=json.loads((ROOT/'docs/form/production/generation-prompts.json').read_text())
byid={r['id']:r for r in prompts}
records=[]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def embed(p,prompt):
    result=subprocess.run([TOOL,'embed-prompt',str(p),'--prompt',prompt],capture_output=True,text=True)
    if result.returncode:raise RuntimeError(result.stdout+result.stderr)
for p in sorted(ASSETS.rglob('*')):
    if p.suffix.lower() not in ['.png','.webp']:continue
    stem=p.stem.removesuffix('-source')
    generated=byid.get(stem)
    if generated:
        origin=generated['prompt']
        provenance='Generated with built-in ImageGen on 2026-10-13. '+('Approved primary study supplied as reference. ' if 'reference' in generated else '')+'Synthetic architectural study imagery; no real building, architect or commission attribution.'
        source=f'studies/{stem}-source.png'
        caption='Architectural concept study: '+stem.replace('-',' ')+'.'
        rights='Generated concept asset; no sourced photography. No trademark, client, construction or design-clearance claim.'
    else:
        origin=f'Origin: Original Form Architecture vector proof or deterministic case presentation. Authored SVG/HTML sources and genuine local implementation captures saved under web/assets/selected-work/form/source and docs/form/presentation-sources / verification/website. Rendered with local Chrome on 2026-10-13; no generated interface. File: {p.relative_to(ASSETS)}. Source composition script: docs/form/tools/compose-exports.cjs or render-identity.cjs.'
        provenance='Original editable vector render or actual implementation screenshot composition.'
        if p.suffix=='.webp':
            parent=re.sub(r'-(480|960)(?=\.webp$)','',str(p.relative_to(ASSETS)))
            source='docs/form/presentation-sources/'+parent.replace('/','-')+'.html'
        else:
            candidate=p.with_suffix('.svg')
            source=str(candidate.relative_to(ROOT)) if candidate.exists() else 'docs/form/tools/render-identity.cjs'
        assert (ROOT/source).exists(),source
        caption='Form Architecture '+p.stem.replace('-',' ')+'; self-initiated studio project.'
        rights='Original authored digital presentation. Bundled fonts retain their SIL OFL licences; generated studies retain separate provenance.'
    embed(p,origin)
    with Image.open(p) as image:dimensions=list(image.size)
    records.append({'id':str(p.relative_to(ASSETS)).replace('/','-'),'runtime_filename':str(p.relative_to(ASSETS)),'source':source,'dimensions':dimensions,'creator':'Creative Media studio concept, authored with Codex','provenance':provenance,'rights_status':rights,'truth_label':'Self-initiated studio project; fictional architectural studies','status':'designed' if generated or 'source' in p.parts else 'implementation capture / designed presentation','caption':caption,'alt':caption,'crop':{'focal_desktop':[50,50],'focal_mobile':[53,50],'instruction':'Public per-image focal points are authoritative in site/data.js; full-image links remain available. Preserve whole presentation board for exact typography.'},'sha256':sha(p),'bytes':p.stat().st_size})
(ASSETS/'source/asset-manifest.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')
checks=[]
for filename,proof in [('cormorant-garamond-latin.woff2','Architecture shaped around how people live. É œ 240 m²'),('instrument-sans-latin.woff2','Project facts / Français / 240 m² / €100,000'),('../../../fonts/ibm-plex-sans-arabic-regular.woff2','عمارة تتشكّل حول حياة الناس')]:
    fontpath=(ASSETS/'fonts'/filename).resolve();font=TTFont(fontpath);cmap=font.getBestCmap();missing=[ch for ch in set(proof) if not ch.isspace() and ord(ch) not in cmap]
    checks.append({'file':str(fontpath.relative_to(ROOT)),'proof':proof,'missing':missing,'sha256':sha(fontpath)})
(ROOT/'docs/form/verification/font-checks.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2)+'\n')
# Instrument Sans omits superscript two upstream. The explicit Form Symbols
# fallback uses the approved locally bundled Cormorant glyph for U+00B2 only.
for r in checks:
    if 'instrument-sans' in r['file'] and r['missing']==['²']:
        r['fallback']={'family':'Form Symbols','source':'cormorant-garamond-latin.woff2','unicode':'U+00B2','coverage_verified':True}
        r['resolved_missing']=r.pop('missing');r['missing']=[]
assert all(not r['missing'] for r in checks),checks
(ROOT/'docs/form/verification/font-checks.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2)+'\n')
# Screenshot and presentation proof pixels are unchanged by provenance metadata.
for p in sorted((ROOT/'docs/form').rglob('*.png')):
    origin='Origin: Genuine local Form/agency browser capture or deterministic SVG/HTML presentation proof, 2026-10-13. Sources and route/viewport/flow records are retained in docs/form. No generated software interface. File: '+str(p.relative_to(ROOT))
    embed(p,origin)
# Packaging is separate so reorganizing documentation never rewrites image metadata.
from package_source import package_source
zip_path = package_source()
print(json.dumps({'rasters':len(records),'font_checks':checks,'zip':str(zip_path),'zip_bytes':zip_path.stat().st_size},ensure_ascii=False))
