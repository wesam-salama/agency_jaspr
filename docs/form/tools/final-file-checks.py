from pathlib import Path
import json,hashlib,zipfile,urllib.request
ROOT=Path(__file__).resolve().parents[3];A=ROOT/'web/assets/selected-work/form';B=ROOT/'build/jaspr/assets/selected-work/form'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
records=json.loads((A/'source/asset-manifest.json').read_text());report={'date':'2026-10-13','files':[],'zip':{},'http':[]}
for r in records:
 p=A/r['runtime_filename'];b=B/r['runtime_filename'];assert p.exists() and b.exists();assert sha(p)==sha(b)==r['sha256'];assert (ROOT/r['source']).exists() if r['source'].startswith(('docs/','web/')) else (A/r['source']).exists();report['files'].append({'file':r['runtime_filename'],'source_build_match':True,'manifest_sha_match':True})
with zipfile.ZipFile(A/'form-source.zip') as z:
 assert z.testzip() is None
 for required in ['site/index.html','site/editor.html','site/app.js','source/wordmark.svg','fonts/ibm-plex-sans-arabic-regular.woff2','records/production/production-record.md','records/verification/verification.md','records/.impeccable/design.json']:assert required in z.namelist(),required
 for name in ['site/style.css','site/cms.css']:assert '../../../fonts/' not in z.read(name).decode();assert '../fonts/ibm-' in z.read(name).decode()
 report['zip']={'integrity':'passed','entries':len(z.namelist()),'arabic_font_paths_portable':True,'source_build_sha_match':sha(A/'form-source.zip')==sha(B/'form-source.zip'),'sha256':sha(A/'form-source.zip')}
 assert report['zip']['source_build_sha_match']
urls=['','ar/','fr/','main.client.dart.js','assets/styles.css','assets/selected-work/form/site/index.html','assets/selected-work/form/site/editor.html','assets/selected-work/form/site/baseline.html','assets/selected-work/form/hero.webp','assets/selected-work/form/form-source.zip','assets/selected-work/sift/sift-brand-guide.pdf','assets/selected-work/sift/sift-artwork.zip']
for suffix in urls:
 url='http://127.0.0.1:8798/agency_jaspr/'+suffix
 with urllib.request.urlopen(url,timeout=30) as r:
  assert r.status==200;digest=hashlib.sha256(r.read()).hexdigest();entry={'url':url,'status':r.status,'sha256':digest}
  if suffix.endswith('form-source.zip'):assert digest==report['zip']['sha256'];entry['source_bytes_match']=True
  report['http'].append(entry)
(ROOT/'docs/form/verification/final-file-checks.json').write_text(json.dumps(report,indent=2));print(json.dumps({'manifest_files':len(report['files']),'zip':report['zip'],'http_checks':len(report['http'])}))
