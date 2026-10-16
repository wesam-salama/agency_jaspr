from pathlib import Path
import hashlib,json,subprocess

ROOT=Path(__file__).resolve().parents[3]
ASSETS=ROOT/'web/assets/selected-work/fold'
DOCS=ROOT/'docs/fold'
CLI='/Users/wesamsalama/.agents/skills/impeccable/scripts/impeccable'
entries=[]
for name in ['primary','variant','editorial']:
    entries.extend(json.loads((DOCS/'generated'/f'{name}-register.json').read_text()))
(DOCS/'production/generation-prompts.json').write_text(json.dumps({'date':'2026-10-15','mode':'built-in image_gen','scope':'Eight garment triptychs and two editorial concepts; generated artwork is separate from actual implementation evidence','outputs':entries},indent=2)+'\n')

records=[]
for root in [ASSETS,DOCS]:
    for image in sorted(root.rglob('*')):
        if image.suffix.lower() not in ['.png','.webp','.jpg','.jpeg']:continue
        side=Path(str(image)+'.json')
        meta=json.loads(side.read_text()) if side.is_file() else {}
        if not meta:
            meta={'origin':str(image.relative_to(ROOT)),'creator':'Local Chrome / Playwright capture','kind':'Actual implemented store or authored artwork capture; not generated software imagery'}
        prompt=meta.get('prompt')
        if not prompt:
            prompt='Origin: '+str(meta.get('origin',image.relative_to(ROOT)))+'. '+str(meta.get('operation',meta.get('kind','Actual local authored capture; not generated software imagery.')))
        subprocess.run([CLI,'embed-prompt',str(image),'--prompt',prompt],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
        digest=hashlib.sha256(image.read_bytes()).hexdigest()
        if 'sha256' in meta:meta['sha256']=digest
        meta['prompt']=prompt
        meta['provenanceStorage']='native image metadata' if image.suffix.lower()=='.png' else 'installed tool sidecar fallback for this format'
        meta.pop('embeddedProvenance',None)
        side.write_text(json.dumps(meta,ensure_ascii=False,indent=2)+'\n')
        records.append({'file':str(image.relative_to(ROOT)),'sha256':digest,'provenance':str(side.relative_to(ROOT))})

(DOCS/'production/provenance-embedding.json').write_text(json.dumps({'date':'2026-10-15','method':'Installed Impeccable embed-prompt: native PNG metadata and supported WebP sidecar fallback. Exact tool prompts identify generated sources; origin metadata identifies authored captures and derivatives.','files':records},indent=2)+'\n')
print('Embedded provenance for',len(records),'raster files')
