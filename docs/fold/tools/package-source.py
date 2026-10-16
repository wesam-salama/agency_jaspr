from pathlib import Path
import json,hashlib,zipfile,subprocess,re

ROOT=Path(__file__).resolve().parents[3]
ASSETS=ROOT/'web/assets/selected-work/fold'
DOCS=ROOT/'docs/fold'
DEST=ASSETS/'fold-source.zip'

def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()

# Refresh editable asset metadata without rewriting retained verification evidence.
for root in [ASSETS]:
    for side in root.rglob('*.json'):
        if side.name in ['asset-manifest.json','source-package-check.json','final-artifact-checks.json']:continue
        try:data=json.loads(side.read_text())
        except (ValueError,UnicodeError):continue
        changed=False
        rows=data if isinstance(data,list) else [data]
        for row in rows:
            if not isinstance(row,dict):continue
            for field in ['sourceFileChecksums']:
                for record in row.get(field,[]):
                    target=ROOT/record.get('file','')
                    if not target.is_file():target=DOCS/record.get('file','')
                    if target.is_file():record['sha256']=digest(target);changed=True
            target=ROOT/row.get('file','')
            if not target.is_file():target=DOCS/row.get('file','')
            if 'sha256' in row and target.is_file():row['sha256']=digest(target);changed=True
            if isinstance(row.get('records'),list):
                for record in row['records']:
                    if not isinstance(record,dict):continue
                    target=ROOT/record.get('file','')
                    if not target.is_file():target=DOCS/record.get('file','')
                    if 'sha256' in record and target.is_file():record['sha256']=digest(target);changed=True
        if changed:side.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')

products={entry['path']:entry for entry in json.loads((DOCS/'production/product-exports.json').read_text())}
screens={entry['path']:entry for entry in json.loads((DOCS/'production/screen-exports.json').read_text())}
records=[]
for file in sorted(ASSETS.rglob('*')):
    if not file.is_file() or file==DEST or file.name=='asset-manifest.json' or file.name=='.DS_Store':continue
    relative=str(file.relative_to(ASSETS))
    side=Path(str(file)+'.json')
    metadata=json.loads(side.read_text()) if side.is_file() else {}
    supplemental=products.get(relative,screens.get(relative,{}))
    generated=relative.startswith(('products/','editorial/')) or (relative.startswith('source/') and ('triptych' in relative or '-source.png' in relative))
    record={'id':relative.replace('/','--').replace('.','-'),'runtimeFilename':relative,'sourceFilename':metadata.get('origin',supplemental.get('source',relative)),'project':'fold','associatedContent':relative.rsplit('.',1)[0],'status':'verified local implementation' if relative.startswith(('site/','screens/')) else 'designed digital studio artifact','creator':metadata.get('creator','Built-in image_gen' if generated else 'CR8.Media / Codex authored source'),'provenance':'generated concept imagery' if generated else ('actual implemented browser screenshot' if relative.startswith('screens/') else 'authored source or presentation; inspect its origin record'),'rights':'Self-initiated studio concept; font files retain their bundled OFL licences; no manufactured goods or commissioning client claim','caption':supplemental.get('caption',relative),'altText':supplemental.get('alt',relative.replace('/',' ').replace('-',' ')),'crop':supplemental.get('focal','Preserve source proportions and important text; refer to the full editable source'),'bytes':file.stat().st_size,'sha256':digest(file)}
    for key in ['width','height']:
        value=metadata.get(key,supplemental.get(key))
        if value is not None:record[key]=value
    if file.suffix.lower() in ['.png','.webp','.jpg','.jpeg'] and ('width' not in record or 'height' not in record):
        probe=subprocess.run(['/usr/bin/sips','-g','pixelWidth','-g','pixelHeight',str(file)],capture_output=True,text=True,check=True).stdout
        record['width']=int(re.search(r'pixelWidth: (\d+)',probe)[1]);record['height']=int(re.search(r'pixelHeight: (\d+)',probe)[1])
    records.append(record)
(ASSETS/'source/asset-manifest.json').write_text(json.dumps({'date':'2026-10-15','project':'fold','scope':'Editable and runtime digital assets; generated artwork and actual implementation evidence remain distinct','assets':records},ensure_ascii=False,indent=2)+'\n')

files=[]
for root in [ASSETS,DOCS]:
    for file in sorted(root.rglob('*')):
        if not file.is_file() or file==DEST:continue
        parts=file.relative_to(root).parts
        if any(part in {'.git','.dart_tool','node_modules','__pycache__','build','.cache'} for part in parts):continue
        if any(part.startswith('.') and part!='.impeccable' for part in parts):continue
        if file.suffix in {'.pyc','.pyo'}:continue
        if file.name in ['preview.log','preview.json','source-package-check.json','final-artifact-checks.json'] or file.name.endswith('.log'):continue
        if '/before-finish-fixes/' in str(file):continue
        if file.parent.name=='recordings' and file.name.startswith('page@'):continue
        files.append(file)
files.append(ROOT/'docs/selected-work-context.md')
with zipfile.ZipFile(DEST,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as archive:
    for file in files:archive.write(file,'Fold-Clothing/'+str(file.relative_to(ROOT)))
    assert archive.testzip() is None
with zipfile.ZipFile(DEST) as archive:
    comparisons=all(hashlib.sha256(archive.read('Fold-Clothing/'+str(file.relative_to(ROOT)))).hexdigest()==digest(file) for file in files)
record={'date':'2026-10-15','path':str(DEST.relative_to(ROOT)),'files':len(files),'bytes':DEST.stat().st_size,'sha256':digest(DEST),'integrity':'passed','allPackagedSourceBytesMatch':comparisons,'layout':'Fold-Clothing/web and Fold-Clothing/docs retain portable relative paths','exclusions':['source ZIP itself','ephemeral preview state/logs','redundant recorder page@ copies','historical first finish captures (retained in repository)','build caches and browser-local cart state']}
(DOCS/'verification/source-package-check.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
