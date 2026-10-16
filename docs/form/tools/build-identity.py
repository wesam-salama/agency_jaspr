#!/usr/bin/env python3
"""Editable, deterministic Form identity and conceptual spatial diagrams."""
from pathlib import Path
from html import escape
import base64, json

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / 'web/assets/selected-work/form'
SOURCE = OUT / 'source'
SOURCE.mkdir(parents=True, exist_ok=True)
P = {'chalk':'#F1F0EA','charcoal':'#2D3331','sage':'#69766A','functional':'#4E5E51','clay':'#A56B50','rule':'#D2D5CB','slate':'#546D85'}
def encoded(path): return base64.b64encode(path.read_bytes()).decode()
def fonts():
    css = ''
    for family, path, fmt, weights in [('Cormorant',OUT/'fonts/cormorant-garamond-latin.woff2','woff2','300 700'),('Instrument',OUT/'fonts/instrument-sans-latin.woff2','woff2','400 700'),('PlexArabic',ROOT/'web/assets/fonts/ibm-plex-sans-arabic-regular.woff2','woff2','400')]:
        if path.exists(): css += f'@font-face{{font-family:{family};src:url(data:font/{fmt};base64,{encoded(path)}) format("{fmt}");font-weight:{weights}}}'
    return css + 'text{font-family:Instrument;fill:#2D3331}.editorial{font-family:Cormorant}.ar{font-family:PlexArabic;direction:rtl;unicode-bidi:plaintext;letter-spacing:normal}'
def text(x,y,s,size=32,cls='',fill=None,anchor='start'):
    return f'<text x="{x}" y="{y}" font-size="{size}" class="{cls}" text-anchor="{anchor}"'+(f' style="fill:{fill}"' if fill else '')+f'>{escape(s)}</text>'
def line(x1,y1,x2,y2,color=P['rule'],width=1): return f'<path d="M{x1},{y1}L{x2},{y2}" fill="none" stroke="{color}" stroke-width="{width}"/>'
def frame(x,y,h,color=P['charcoal'],width=4):
    w=h*.75
    return f'<path d="M{x+w},{y+h*.76}V{y}H{x}V{y+h}H{x+w*.68}" fill="none" stroke="{color}" stroke-width="{width}"/>'
# Original optically spaced outline lettering: high-contrast uprights, generous
# counters, flat serifs and a cut-in R shoulder. Not a font converted to outlines.
LETTER = [
 ('F',0,'M0 0H116V16H111L108 7H28V73H83L88 65H92V93H88L83 82H28V143L43 148V154H0V148L12 143V10L0 6Z'),
 ('O',134,'M68 -3C24 -3 0 28 0 77C0 127 24 157 68 157C112 157 136 127 136 77C136 28 112 -3 68 -3ZM68 4C103 4 116 37 116 77C116 117 103 150 68 150C33 150 20 117 20 77C20 37 33 4 68 4Z'),
 ('R',292,'M0 0H62C103 0 122 15 122 42C122 65 107 79 81 83L129 145L140 148V154H106L59 86H28V143L41 148V154H0V148L12 143V10L0 6ZM28 7V79H57C87 79 102 66 102 43C102 20 89 7 60 7Z'),
 ('M',451,'M0 0H33L86 120L137 0H166V6L154 11V143L166 148V154H124V148L138 143V18L79 151H74L18 22V143L32 148V154H0V148L10 143V10L0 6Z')
]
def wordmark(x,y,width,color=P['charcoal']):
    k=width/617
    return f'<g transform="translate({x},{y}) scale({k})" fill="{color}" fill-rule="evenodd">'+''.join(f'<path transform="translate({dx},0)" d="{d}"/>' for _,dx,d in LETTER)+'</g>'
def svg(w,h,title,body,bg=P['chalk']):
    return f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" role="img"><title>{escape(title)}</title><metadata>Original editable vector. Form Architecture self-initiated studio concept. Created 2026-10-13.</metadata><style>{fonts()}</style>'+(f'<rect width="{w}" height="{h}" fill="{bg}"/>' if bg else '')+body+'</svg>'
registry=[]
def save(name,w,h,title,body,bg=P['chalk']):
    (SOURCE/name).write_text(svg(w,h,title,body,bg))
    registry.append({'id':name[:-4],'source':f'source/{name}','dimensions':[w,h],'caption':title,'alt':title,'provenance':'Original code-native vector authored with Codex','rights':'Original artwork; font files retain bundled SIL OFL licences','status':'designed','crop':'Full artboard; preserve wordmark clear space','concept':True})

save('wordmark.svg',760,240,'Form Architecture wordmark',frame(16,25,160)+wordmark(172,35,560)+text(172,210,'ARCHITECTURE',32),None)
save('wordmark-dark.svg',760,240,'Form Architecture light wordmark',frame(16,25,160,P['chalk'])+wordmark(172,35,560,P['chalk'])+text(172,210,'ARCHITECTURE',32,fill=P['chalk']),P['charcoal'])
save('wordmark-mono.svg',760,240,'Form Architecture monochrome wordmark',frame(16,25,160,'#000')+wordmark(172,35,560,'#000')+text(172,210,'ARCHITECTURE',32,fill='#000'),'#FFF')
save('frame-mark.svg',96,128,'Form open frame, 3:4 with lower-right opening',frame(4,4,120,width=5),None)
baseline=frame(125,160,240,P['slate'],8)+text(440,275,'FORM',124,'editorial',P['slate'])+text(445,350,'ARCHITECTURE',32,fill=P['slate'])
save('starting-identity.svg',2000,1500,'Fictional starting identity created for this rebrand study',text(120,100,'Fictional starting identity created for this rebrand study',30)+baseline+line(120,460,1880,460)+text(120,575,'FORM ARCHITECTURE',70,'editorial')+text(120,680,'An image-led portfolio, serif brochure and slate-blue accents.',34)+text(120,740,'Recognition retained: the name, the open frame, architectural space.',34)+text(120,860,'Baseline strengths',30)+text(120,920,'A compact signature. Spacious imagery. A simple project index.',30)+text(120,1030,'Rebrand opportunity',30)+text(120,1090,'Bring facts beside images, keep enquiry context and standardise crops.',30)+text(120,1340,'Authored baseline • Self-initiated studio project • 2026',26))

body=text(120,110,'Form Architecture',38)+text(120,230,'Recognition, made useful.',92,'editorial')+frame(120,330,270)+wordmark(435,355,800)+text(438,610,'ARCHITECTURE',32)+line(120,705,1880,705)
palette=[('Chalk','chalk'),('Charcoal','charcoal'),('Sage','sage'),('Functional Sage','functional'),('Clay','clay')]
for i,(n,c) in enumerate(palette):
    x=120+i*352
    body+=f'<rect x="{x}" y="775" width="296" height="160" fill="{P[c]}"/>'+text(x,988,n,27)+text(x,1032,P[c],26)
body+=text(120,1155,'Cormorant Garamond',64,'editorial')+text(120,1210,'Editorial headings: space to read.',30)+text(1030,1155,'Instrument Sans',40)+text(1030,1210,'Navigation, project facts, controls.',30)+text(1850,1300,'عمارة تتشكّل حول حياة الناس',42,'ar',anchor='start')+text(120,1400,'Studio concept • 8-unit spacing • 1px rules • square corners',26)
save('identity-system.svg',2000,1500,'Form identity: original wordmark, frame, palette and bilingual typography',body)

body=text(120,100,'The clear-space rule',52,'editorial')+text(120,165,'Half the wordmark cap height on every side.',30)+frame(180,330,300)+wordmark(545,380,1000)
body+=f'<rect x="420" y="255" width="1250" height="500" fill="none" stroke="{P["functional"]}" stroke-dasharray="8 8" stroke-width="2"/>'
body+=line(420,290,545,290,P['functional'],2)+text(420,250,'½H',30)+line(120,760,1880,760)
body+=text(120,870,'Screen',36)+text(120,930,'Full lockup: tested at 192px wide.',30)+text(120,985,'Standalone frame: tested at 24px high, with nearby name.',30)+text(120,1040,'Minimum is a digital proof, not a print-production claim.',30)
body+=text(120,1170,'Print master',36)+text(120,1230,'Vector proportions and clear space carry to a cover.',30)+text(120,1285,'Final print stock, inks and supplier proofing remain unverified.',30)
save('clear-space.svg',2000,1500,'Original wordmark clear space and inspected digital minima',body)

body=wordmark(120,120,580)+frame(1650,110,190)+text(120,400,'Architecture shaped around',78,'editorial')+text(120,490,'how people live.',78,'editorial')+line(120,590,1880,590)+text(120,700,'Courtyard House',52,'editorial')+text(120,770,'Residential study • 2025 • Fictional Mediterranean setting',30)+text(120,830,'Concept area: 240 m²',30)+text(120,1010,'A threshold that slows the arrival.',52,'editorial')+text(120,1080,'Pale mineral walls, warm timber and a shaded stone threshold.',30)+text(1840,1210,'دراسة تصورية: الضوء والخصوصية والحركة',38,'ar',anchor='start')+text(120,1400,'Self-initiated studio project • Editorial cover / stationery master',26)
save('stationery-cover.svg',2000,1500,'Form editorial project cover and bilingual stationery',body)

for slug,title,zones in [('courtyard-house','Courtyard House',['Arrival','Living','Planted courtyard','Quiet rooms']),('line-studio','Line Studio',['Shared work','Glazed threshold','Quiet focus','Daylight']),('shore-library','Shore Library',['Public terrace','Shaded threshold','Reading room','Coast'])]:
    body=text(64,95,title,58,'editorial')+text(64,150,'Conceptual spatial diagram — relationships, not construction drawings',23)
    rects=[(64,235,240,320),(354,235,150,320),(554,235,270,320),(874,235,240,320)]
    for i,((x,y,w,h),label) in enumerate(zip(rects,zones)):
        body+=f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{P["rule"] if i%2==0 else P["chalk"]}" stroke="{P["functional"]}" stroke-width="2"/>'+text(x+18,y+65,label,25)
    body+=line(175,475,1000,475,P['functional'],4)+f'<path d="M980 460L1000 475L980 490" stroke="{P["functional"]}" fill="none" stroke-width="4"/>'+text(64,660,'Movement connects distinct spaces; light and material define the transitions.',24)
    path=OUT/'studies'/f'{slug}-diagram.svg';path.write_text(svg(1200,750,title+' conceptual relationship diagram',body))
    registry.append({'id':slug+'-diagram','source':f'studies/{slug}-diagram.svg','dimensions':[1200,750],'caption':'Conceptual spatial relationship diagram; not a construction drawing.','alt':title+' relationships shown as four connected spaces.','provenance':'Original geometric vector diagram authored with Codex','rights':'Original code-native artwork','status':'designed','crop':'Full image','concept':True})
# Plausible baseline brochure: the same Courtyard study, compact identity,
# slate-blue accent and serif-led hierarchy; no manufactured print claim.
photo = base64.b64encode((OUT/'studies/courtyard-house-source.png').read_bytes()).decode()
body=frame(80,85,150,P['slate'],4)+text(250,155,'FORM',78,'editorial',P['slate'])+text(254,210,'ARCHITECTURE',22,fill=P['slate'])
body+=f'<image x="80" y="300" width="1040" height="650" href="data:image/png;base64,{photo}" preserveAspectRatio="xMidYMid slice"/>'
body+=text(80,1055,'Courtyard House',72,'editorial')+text(80,1130,'A home around a planted courtyard.',38,'editorial')+text(80,1220,'Residential study • 2025 • Concept area 240 m²',26)+text(80,1275,'Fictional Mediterranean setting',26)
body+=text(80,1430,'Fictional starting identity created for this rebrand study.',24)+text(80,1490,'Editable brochure-cover artwork; no physical printing claimed.',22)
save('starting-brochure.svg',1200,1600,'Fictional starting brochure cover for the Form rebrand study',body)
(SOURCE/'identity-manifest.json').write_text(json.dumps(registry,indent=2)+'\n')
print(json.dumps({'masters':len(registry),'output':str(SOURCE)}))
