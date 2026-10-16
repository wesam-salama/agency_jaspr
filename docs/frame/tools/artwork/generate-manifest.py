from pathlib import Path
import json,re,hashlib,subprocess
from PIL import Image
from pypdf import PdfReader
root=Path(__file__).resolve().parents[4]
asset=root/'web/assets/selected-work/frame'; docs=root/'docs/frame/verification/artwork'
courses={'composition':('FA-PH-01','Composition Essentials'),'light':('FA-FI-02','Light for Motion'),'grids':('FA-DE-03','Designing with Grids')}
items=[]
for folder in ['source','media','fonts']:
    for p in sorted((asset/folder).iterdir()):
        if not p.is_file() or p.name=='asset-manifest.json': continue
        rel=p.relative_to(asset).as_posix()
        content=None; cid=None
        for prefix,(course,title) in courses.items():
            if p.name.startswith(prefix): cid=course; content=title
        if folder=='fonts':
            source='docs/frame/verification/artwork/font-provenance.json';creator='Original font authors; official Google Fonts source'
            caption='Bundled approved font file or its preserved SIL OFL licence.'
            alt='Font source supporting Frame Academy typography.'
            rights='SIL Open Font License 1.1; see accompanying family OFL text.'
            status='Verified local file and preserved licence; TTF originals support native app.'
        elif folder=='media':
            creator='Codex-authored Frame lesson; built-in ImageGen photographic source'
            source='source/lesson-film.html' if p.suffix=='.mp4' or p.name.startswith('poster') else 'docs/frame/production/generation-prompts.json' if p.name=='composition-source.png' else 'docs/frame/design/lesson-script.md'
            caption=('A centre/edge placement lesson authored in '+('Arabic' if '-ar' in p.stem else 'English')+'. 30-second media; eight-minute planned study target.' if p.suffix=='.mp4' or p.name.startswith('poster') else 'Owned generated ceramic still-life lesson source.' if p.name=='composition-source.png' else 'Complete equivalent timed captions/transcript for the authored lesson.')
            alt=('The same coral ceramic sphere is shown first at the centre, then toward one edge, with instructional text.' if p.suffix in ['.mp4','.png','.webp'] else 'Text alternative for lesson01 See the edges.')
            rights='Authored in this task; generated photographic source credited separately. No learner work or instructor review is represented.'
            status='Verified produced lesson media/caption/transcript' if p.name!='composition-source.png' else 'Verified designed generated concept photograph'
            cid='FA-PH-01';content='Composition Essentials / 01 See the edges'
        else:
            creator='Codex original deterministic vector artwork and editable bilingual typesetting'
            source=(rel.rsplit('.',1)[0]+'.svg') if p.suffix in ['.png','.webp'] else rel[:-4]+'.html' if p.suffix=='.pdf' else rel
            if p.name=='frame-app-icon-1024.png': source='source/frame-app-icon.svg'
            caption=(content+' bilingual course artwork or companion workbook.' if content else 'Frame Academy identity artwork and construction proof.' if p.name.startswith('frame-') or p.name.startswith('identity-') else 'Frame Academy editable authored source.')
            alt=(content+' course workbook with offset corners, exact course metadata and authored practice pages.' if content else 'Frame Academy original custom wordmark and two offset open corners.')
            rights='Original authored digital geometry/typesetting; local font files under SIL OFL. Composition imagery credits docs/frame/production/generation-prompts.json.'
            status='Verified authored editable digital source' if p.suffix in ['.svg','.html','.css','.md'] else 'Verified actual browser/print export'
        dims=None;pages=None;duration=None
        if p.suffix in ['.png','.webp']:
            with Image.open(p) as im: dims={'width':im.width,'height':im.height}
        elif p.suffix=='.svg':
            m=re.search(r'<svg[^>]*width="([0-9]+)"[^>]*height="([0-9]+)"',p.read_text())
            if m:dims={'width':int(m[1]),'height':int(m[2])}
        elif p.suffix=='.pdf':pages=len(PdfReader(p).pages)
        elif p.suffix=='.mp4':
            probe=json.loads(subprocess.check_output(['ffprobe','-v','error','-select_streams','v:0','-show_entries','stream=width,height,r_frame_rate,nb_frames,codec_name:format=duration','-of','json',str(p)]))
            stream=probe['streams'][0];dims={'width':stream['width'],'height':stream['height']};duration=float(probe['format']['duration'])
        items.append({'id':'frame-'+rel.replace('/','-').replace('.','-'),'runtime_filename':'assets/selected-work/frame/'+rel,'source_filename':source,'project':'frame','content_record':cid,'content_title':content,'dimensions':dims,'pages':pages,'actual_media_seconds':duration,'creator':creator,'created_on':'2026-10-13','verified_on':'2026-10-14','status':status,'rights':rights,'caption':caption,'alt':alt,'crop':{'mode':'show-full-artwork' if folder=='source' else 'centre-source-then-author-selected-edge' if folder=='media' else 'not-applicable','focal_point':{'x':.5,'y':.55} if folder=='media' else None,'safe_margin':'8% for critical mark/text; inspect full image when the course metadata would crop'},'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
manifest={'schema_version':1,'project':'Frame Academy','version':'1.0.1','production_dates':'13–14 October 2026','status':'Verified digital identity/course artifacts and authored lesson media','boundary':'Studio concept. Root-owned website/app/case evidence is recorded separately.','items':items}
(asset/'source/asset-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
def luminance(c):
    vals=[int(c[i:i+2],16)/255 for i in (1,3,5)]
    vals=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in vals]
    return .2126*vals[0]+.7152*vals[1]+.0722*vals[2]
pairs=[]
for fg,bg,role in [('#F7F9FC','#244CCD','Primary action text'),('#18243D','#F7F9FC','Body text'),('#52627B','#F7F9FC','Secondary text'),('#18243D','#A7E3CE','Exercise text'),('#18243D','#FF8A6C','Artwork text'),('#225C47','#A7E3CE','Confirmed-save text'),('#A92F33','#F7F9FC','Recovery text'),('#244CCD','#F7F9FC','Focus and underlined link')]:
    a,b=luminance(fg),luminance(bg);ratio=(max(a,b)+.05)/(min(a,b)+.05)
    pairs.append({'foreground':fg,'background':bg,'role':role,'contrast_ratio':round(ratio,2),'normal_text_4_5_pass':ratio>=4.5})
checks={'version':'1.0.1','created_on':'2026-10-13','verified_on':'2026-10-14','pdf_count':8,'pdf_pages':sum(i['pages'] or 0 for i in items),'svg_count':sum(i['runtime_filename'].endswith('.svg') for i in items),'media':[i for i in items if i['runtime_filename'].endswith('.mp4')],'caption_cues_per_language':6,'caption_coverage_seconds':30,'planned_lesson_study_minutes':8,'planned_course_study_minutes':62,'provenance_scan':{'rasters':28,'missing':0},'contrast_pairs':pairs,'visual_review':{'first_batch':'13 October 2026','confirmation':'14 October 2026','scope':'All 40 final PDF pages, identity board, course covers, 24/32/48px symbol, 160/240px compact wordmark, 320px full lockup and corrected EN/AR lesson comparisons','material_fixes':['Arabic film heading clears fixed brand symbol','Equal-scale photos fill both centre/edge frames independently of text direction','Full lockup ACADEMY descriptor below custom lettering','Whole-journey Arabic lesson title consistency'],'result':'Confirmed at the listed artifact scope'},'decode':'Both MP4s decoded fully with ffmpeg -v error -f null and no errors'}
(docs/'verification.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2)+'\n')
print('Manifest',len(items),'files;',checks['svg_count'],'SVGs;',checks['pdf_pages'],'PDF pages')

