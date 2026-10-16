from pathlib import Path
import json,hashlib,zipfile,subprocess,shutil

ROOT=Path(__file__).resolve().parents[3]
ASSETS=ROOT/'web/assets/selected-work/fold'
BUILT=ROOT/'build/jaspr/assets/selected-work/fold'
DOCS=ROOT/'docs/fold'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
protected=json.loads((DOCS/'verification/preservation-baseline.json').read_text())['files']
changed=[p for p,h in protected.items() if not (ROOT/p).is_file() or sha(ROOT/p)!=h]
assert not changed,changed
matches=[]
for file in ASSETS.rglob('*'):
    if not file.is_file():continue
    destination=BUILT/file.relative_to(ASSETS)
    assert destination.is_file(),str(destination)
    assert sha(file)==sha(destination),str(file)
    matches.append(str(file.relative_to(ASSETS)))
manifest=json.loads((ASSETS/'source/asset-manifest.json').read_text())['assets']
assert all((ASSETS/a['runtimeFilename']).is_file() and sha(ASSETS/a['runtimeFilename'])==a['sha256'] for a in manifest)
archive=ASSETS/'fold-source.zip'
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    required=['web/assets/selected-work/fold/site/index.html','web/assets/selected-work/fold/fonts/IBMPlexSansArabic-Regular.woff2','docs/fold/presentation-sources/shopping.html']
    for name in required:assert 'Fold-Clothing/'+name in z.namelist()
videos=[]
for lang in ['en','ar']:
    film=ASSETS/f'shopping-flow-{lang}.mp4'
    subprocess.run(['ffmpeg','-v','error','-i',str(film),'-f','null','-'],check=True,capture_output=True)
    probe=json.loads(subprocess.run(['ffprobe','-v','error','-show_entries','stream=codec_name,width,height,avg_frame_rate:format=duration','-of','json',str(film)],check=True,capture_output=True,text=True).stdout)
    timeline=json.loads((DOCS/f'production/recordings/shopping-flow-{lang}-timeline.json').read_text())
    assert timeline['steps'][-1]['reference']=='FOLD-DEMO-76895E88'
    assert timeline['steps'][-1]['totalCents']=='25200'
    videos.append({'locale':lang,'path':str(film.relative_to(ROOT)),'sha256':sha(film),'decode':'passed',**probe})
record={'date':'2026-10-15','protectedFilesChecked':len(protected),'protectedFilesChanged':changed,'sourceBuildFilesMatched':len(matches),'manifestAssetsChecked':len(manifest),'zipIntegrity':'passed','zipSHA256':sha(archive),'recordings':videos,'originalReferenceSHA256':sha(ROOT.parent/'agency_website.html')}
(DOCS/'verification/final-artifact-checks.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
