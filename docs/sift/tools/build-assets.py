#!/usr/bin/env python3
"""Build Sift's editable SVG identity and application masters from canonical data."""
from pathlib import Path
import base64, html, json, hashlib

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / 'web/assets/selected-work/sift/source'
OUT.mkdir(parents=True, exist_ok=True)
P = {'paper':'#F4EBDD','ink':'#28221F','cobalt':'#3047D9','roast':'#C56339','mist':'#D9D9D0','white':'#FFFFFF'}
PRODUCTS = [
 {'id':'everyday','name':'Everyday','role':'Rounded & familiar','notes':'Cocoa · almond · brown sugar','origin':'Brazil / Colombia blend','process':'Natural / washed blend','roast':'Medium','method':'Espresso or moka pot','color':P['roast'],'description':'A rounded starting point for your daily cup, with cocoa, almond and brown sugar notes. Begin with espresso or a moka pot, then adjust to your taste.','arabic':['بداية متوازنة لكوبك اليومي، مع نكهات الكاكاو','واللوز والسكر البني. ابدأ بالإسبريسو أو إبريق','الموكا، ثم اضبط التحضير وفق ذوقك.'],'ar_method':['إسبريسو أو','إبريق الموكا']},
 {'id':'daybreak','name':'Daybreak','role':'Bright & exploratory','notes':'Apricot · citrus · floral','origin':'Ethiopia single origin','process':'Washed','roast':'Light','method':'Pour-over','color':P['cobalt'],'description':'A brighter direction, with apricot, citrus and floral notes. Start with a pour-over to explore its lighter character.','arabic':['اتجاه أكثر إشراقاً، مع نكهات المشمش','والحمضيات والزهور. ابدأ بالترشيح لاستكشاف','طابع القهوة الأخف.'],'ar_method':['قهوة','مرشّحة']},
 {'id':'after-hours','name':'After Hours','role':'Deep & full','notes':'Dark chocolate · plum · caramel','origin':'Colombia single origin','process':'Washed','roast':'Medium-dark','method':'Espresso or French press','color':P['ink'],'description':'A deeper cup with dark chocolate, plum and caramel notes. Try espresso or French press for a fuller starting point.','arabic':['كوب أعمق مع نكهات الشوكولاتة الداكنة','والبرقوق والكراميل. جرّب الإسبريسو أو','المكبس الفرنسي لبداية أكثر امتلاءً.'],'ar_method':['إسبريسو أو','مكبس فرنسي']}
]

def enc(name):
    return base64.b64encode((OUT/'fonts'/name).read_bytes()).decode()
CSS = f'''@font-face{{font-family:Fraunces;src:url(data:font/ttf;base64,{enc('fraunces-variable.ttf')}) format('truetype');font-weight:100 900;font-style:normal}}
@font-face{{font-family:Manrope;src:url(data:font/ttf;base64,{enc('manrope-variable.ttf')}) format('truetype');font-weight:200 800;font-style:normal}}
@font-face{{font-family:PlexArabic;src:url(data:font/woff2;base64,{enc('ibm-plex-sans-arabic-regular.woff2')}) format('woff2');font-weight:400}}
@font-face{{font-family:PlexArabic;src:url(data:font/woff2;base64,{enc('ibm-plex-sans-arabic-semibold.woff2')}) format('woff2');font-weight:600}}
text{{font-family:Manrope;fill:{P['ink']};font-kerning:normal}}.editorial{{font-family:Fraunces;font-variation-settings:'opsz' 72,'SOFT' 20,'WONK' 1}}.ar{{font-family:PlexArabic;direction:rtl;unicode-bidi:plaintext;letter-spacing:normal}}'''

def e(value): return html.escape(str(value), quote=True)
def text(x,y,content,size=20,fill=None,weight=400,cls='',anchor='start',extra=''):
    fill=fill or P['ink']
    return f'<text x="{x}" y="{y}" font-size="{size}" font-weight="{weight}" text-anchor="{anchor}" class="{cls}" style="fill:{fill}" {extra}>{e(content)}</text>'
def ar(x,y,content,size=20,fill=None,weight=400):
    return text(x,y,content,size,fill,weight,'ar','start','direction="rtl" unicode-bidi="plaintext"')
def rect(x,y,w,h,fill): return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}"/>'
def rule(x,y,w,color=None,stroke=1): return f'<path d="M{x} {y}h{w}" fill="none" stroke="{color or P["ink"]}" stroke-width="{stroke}"/>'
def wrap_words(content,maxchars):
    lines=[]; line=''
    for word in content.split():
        if len(line)+len(word)+1>maxchars and line: lines.append(line); line=word
        else: line=(line+' '+word).strip()
    if line: lines.append(line)
    return lines
def lines(x,y,items,size=20,lineheight=30,fill=None,cls='',weight=400):
    return ''.join(text(x,y+i*lineheight,line,size,fill,weight,cls) for i,line in enumerate(items))
def motif(x,y,scale=1,color=None,selected=None):
    color=color or P['ink']; selected=selected or P['cobalt']
    paths=''.join(rule(0,i*12,80 if i==2 else 60,selected if i==2 else color,3) for i in range(5))
    return f'<g transform="translate({x} {y}) scale({scale})">{paths}</g>'

# Original outlined lettering, constructed for this project. All letter contours
# are editable paths. No font rendering or substituted glyphs form the wordmark.
GLYPHS = '''<path d="M92 72C76 59 55 57 36 62C15 67 4 79 5 95C6 115 24 119 48 124C63 127 70 130 70 138C70 148 54 154 38 149C27 146 20 139 17 130H3V154C17 162 34 166 51 163C77 160 92 148 92 130C92 111 76 105 50 99C33 95 27 92 28 85C29 77 42 74 55 77C67 80 73 86 77 93H91Z"/>
<path d="M113 70H143V144C143 153 147 157 155 158V163H104V158C111 157 116 153 116 144V86C116 78 112 76 106 75V70Z"/><path d="M114 31C114 23 120 17 128 17C136 17 142 23 142 31C142 39 136 45 128 45C120 45 114 39 114 31Z"/>
<path d="M171 70V55C171 23 190 8 218 9C233 9 244 14 251 20L242 40C236 34 229 30 221 30C207 30 198 39 198 58V70H226V87H198V144C198 153 203 157 211 158V163H159V158C167 157 171 153 171 144V87H155V70Z"/>
<path d="M249 43L276 34V70H309V87H276V132C276 145 282 151 292 150C299 150 305 148 310 144V157C303 163 294 166 283 165C261 164 249 154 249 133V87H234V70H249Z"/>'''

def logo(x,y,scale=1,fill=None,descriptor=True,small=False):
    fill=fill or P['ink']
    # The small optical cut strengthens the i stem and the short t crossbar.
    optical=rect(116,70,29,85,fill)+rect(234,70,76,19,fill) if small else ''
    desc=text(157,198,'COFFEE',18,fill,600,anchor='middle',extra='letter-spacing="5"') if descriptor else ''
    return f'<g transform="translate({x} {y}) scale({scale})"><g fill="{fill}">{GLYPHS}</g>{optical}{desc}</g>'

REGISTRY=[]
def svg(name,w,h,body,title,bg=None):
    content=f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" role="img" aria-labelledby="title"><title id="title">{e(title)}</title><desc>Authored Sift Coffee studio concept. Editable SVG artwork. Sample product information is fictional.</desc><defs><style><![CDATA[{CSS}]]></style></defs>{rect(0,0,w,h,bg) if bg else ""}{body}</svg>'
    (OUT/name).write_text(content)
    REGISTRY.append({'id':name.removesuffix('.svg'),'project':'sift','source':'assets/selected-work/sift/source/'+name,'file':name,'render':name.removesuffix('.svg')+'.png','width':w,'height':h,'title':title,'caption':title,'alt':title+'; authored studio-concept artwork.','format':'editable SVG','status':'designed','provenance':'Original code-native artwork; embedded licensed typefaces','creator':'Creative Media studio concept, authored with Codex','rights':'Original vector work; bundled font files retain SIL OFL 1.1 licences. No external photography.','crop':'Full artboard; do not crop exact label text or mark clear space.','fixture_status':'Product origin, tasting and brewing information is fictional illustrative data.','sha256':hashlib.sha256(content.encode()).hexdigest()})

def front(product,kg=False):
    if not kg:
        b=logo(44,44,.92)+text(44,262,'Good coffee. Clearly chosen.',17)
        b+=motif(44,307,.82)+text(44,439,product['name'],55,cls='editorial',weight=500)
        b+=text(44,482,product['role'],20,weight=500)+text(44,519,product['notes'],17)
        b+=rule(44,555,392,product['color'],2)+text(44,591,'WHOLE BEAN COFFEE',14,weight=600,extra='letter-spacing="1.5"')+text(436,593,'250 g',27,anchor='end')
        b+=rect(0,648,480,72,product['color'])+motif(44,665,.64,P['paper'],P['paper'])
        return b,480,720
    b=logo(56,52,1.06)+text(56,294,'Good coffee. Clearly chosen.',21)
    b+=motif(56,343,1.05)+text(56,505,product['name'],76,cls='editorial',weight=500)
    b+=text(56,553,product['role'],26,weight=500)+text(56,598,product['notes'],22)
    b+=rule(56,640,568,product['color'],2)+text(56,692,'WHOLE BEAN COFFEE',18,weight=600,extra='letter-spacing="1.5"')+text(624,695,'1 kg',40,anchor='end')
    b+=text(56,741,'More room for your everyday ritual.',18)+rect(0,780,680,60,product['color'])
    return b,680,840

for p in PRODUCTS:
    b,w,h=front(p); svg(f'pack-{p["id"]}-250g-front.svg',w,h,b,f'{p["name"]} 250 g front label',P['paper'])
b=''.join(f'<g transform="translate({100+i*550} 90)">{front(p)[0]}</g>' for i,p in enumerate(PRODUCTS))
b+=text(100,882,'Three coffees. Three clear starting points.',30,cls='editorial')+text(100,945,'Flat artwork · 250 g collection · Self-initiated studio project',17)
svg('label-front-sheet.svg',1800,1000,b,'Sift Coffee three-label front artwork reference',P['paper'])

def back(product,kg=False):
    w,h=(680,840) if kg else (480,720)
    left,right=(56,624) if kg else (44,436)
    gap=568 if kg else 392
    b=logo(left,30,.36 if not kg else .45)+text(left,150,product['name'],32 if not kg else 42,cls='editorial',weight=500)
    b+=rule(left,170,gap,product['color'],2)
    english=wrap_words(product['description'],39 if not kg else 53)
    b+=lines(left,204,english,19 if not kg else 22,27 if not kg else 31)
    arabic_start=204+len(english)*(27 if not kg else 31)+35
    for i,line in enumerate(product['arabic']): b+=ar(right,arabic_start+i*29,line,20 if not kg else 25)
    data_y=arabic_start+3*29+30
    for i,(label,value) in enumerate([('Origin',product['origin']),('Process',product['process']),('Roast',product['roast'])]):
        b+=text(left,data_y+i*30,label,13,weight=600)+text(left+115,data_y+i*30,value,16 if not kg else 20)
    b+=text(left,data_y+104,'Start with',13,weight=600)+text(left+115,data_y+104,product['method'],16 if not kg else 20)
    b+=rule(left,data_y+128,gap,P['ink'],1)
    b+=text(left,data_y+156,'ROAST DATE',10,weight=600,extra='letter-spacing="1"')+text(left+115,data_y+156,'{ROAST_DATE}',15)
    b+=text(left,data_y+184,'BATCH',10,weight=600,extra='letter-spacing="1"')+text(left+115,data_y+184,'{BATCH_ID}',15)
    # Fixture disclosure is part of the artwork, not merely an external caption.
    b+=text(left,h-52,'Studio concept · sample origin and tasting information',11 if not kg else 15)
    b+=ar(right,h-27,'مشروع تصوّري · بيانات القهوة توضيحية',17 if not kg else 20)
    return b,w,h

def side(product,kg=False):
    w,h=(220,840) if kg else (180,720)
    right=w-26
    b=logo(26,30,.40,P['paper'])
    b+=lines(26,186,wrap_words(product['name'],13),24,30,P['paper'],'editorial',500)
    b+=ar(right,249,'قهوة مختارة بعناية',17,P['paper'])
    b+=motif(26,297,1.1,P['paper'],P['paper'])
    b+=text(26,416,'Start with',15,P['paper'],600)
    b+=lines(26,451,wrap_words(product['method'],14),18,27,P['paper'])
    for i,line in enumerate(product['ar_method']): b+=ar(right,565+i*27,line,20,P['paper'])
    b+=text(26,h-60,'Whole bean',15,P['paper'])+text(26,h-30,'1 kg' if kg else '250 g',22,P['paper'])
    return b,w,h

for p in PRODUCTS:
    b,w,h=back(p); svg(f'pack-{p["id"]}-250g-reverse.svg',w,h,b,f'{p["name"]} bilingual 250 g reverse label',P['paper'])
    b,w,h=side(p); svg(f'pack-{p["id"]}-250g-side.svg',w,h,b,f'{p["name"]} bilingual 250 g side artwork',P['ink'])
for face,fn in [('front',front),('reverse',back),('side',side)]:
    b,w,h=fn(PRODUCTS[0],True); svg(f'pack-everyday-1kg-{face}.svg',w,h,b,f'Everyday 1 kg {face} artwork',P['paper'] if face!='side' else P['ink'])

svg('sift-wordmark-horizontal.svg',700,390,logo(96,86,1)+motif(491,143,1.25),'Sift Coffee horizontal brand lockup')
svg('sift-wordmark-stacked.svg',500,500,logo(94,80,1)+motif(211,338,.97),'Sift Coffee stacked brand lockup')
svg('sift-wordmark-mono.svg',500,390,logo(94,86,1),'Sift Coffee one-colour brand lockup')
svg('sift-wordmark-reverse.svg',500,390,logo(94,86,1,P['paper']),'Sift Coffee reverse brand lockup',P['ink'])
svg('sift-wordmark-small.svg',380,230,logo(35,32,1,descriptor=False,small=True),'Sift small optical wordmark')
svg('sift-selected-line.svg',260,240,motif(65,65,1.5),'The Selected Line five-rule motif')
clear=logo(172,157,1)+f'<rect x="79" y="73" width="496" height="385" fill="none" stroke="{P["cobalt"]}" stroke-width="2" stroke-dasharray="8 6"/>'
clear+=rule(172,110,310,P['cobalt'])+text(330,99,'U = 93 units',15,P['cobalt'],anchor='middle')
clear+=f'<path d="M620 227v93m-8-93h16m-16 93h16" fill="none" stroke="{P["cobalt"]}" stroke-width="2"/>'
clear+=text(646,276,'i stem',15)+text(79,512,'Clear space uses the 93-unit height of the lowercase i stem.',19)+text(79,551,'Construction reference · natural wordmark width: 310 units',16)
svg('sift-clearspace.svg',850,640,clear,'Sift Coffee clear-space construction',P['paper'])

board=logo(128,114,2.55)
board+=lines(1110,230,['Good coffee.','Clearly chosen.'],86,110,cls='editorial',weight=500)
board+=text(1110,540,'Warm materials. Clear choices.',31)+text(1110,602,'Fraunces / Editorial',32,cls='editorial')+text(1110,652,'Manrope / Information',27)+ar(1890,714,'قهوة مختارة بعناية',35)
board+=lines(128,842,['A considered identity,','from choice to cup.'],54,69,cls='editorial')+motif(1590,815,2.8)
for i,(key,label) in enumerate([('paper','Warm Paper'),('ink','Coffee Ink'),('cobalt','Cobalt'),('roast','Roast Orange'),('mist','Mist')]):
    x=128+i*355
    board+=rect(x,1080,325,202,P[key])+text(x,1325,label,22)+text(x,1362,P[key],17)
board+=text(128,1450,'Sift Coffee · Self-initiated studio project · Original identity artwork',19)
svg('sift-identity-board.svg',2000,1500,board,'Sift Coffee identity system board',P['paper'])

board=logo(120,130,1.85)+text(120,580,'Main lockup',25)
board+=rect(990,75,890,610,P['ink'])+logo(1127,175,1.95,P['paper'])+text(1127,624,'Reverse lockup',25,P['paper'])
board+=motif(145,803,2.6)+text(145,1028,'The Selected Line',28,cls='editorial')+text(145,1072,'Five rules. One chosen line.',21)
board+=logo(850,825,.21,descriptor=False,small=True)+logo(1050,811,.32,descriptor=False,small=True)+logo(1310,793,.52,descriptor=False,small=True)
board+=text(850,1028,'Small optical cut',28,cls='editorial')+text(850,1072,'Shown at 65, 99 and 161 px wordmark widths',20)
board+=rule(120,1170,1760,P['ink'])+text(120,1250,'One identity, carefully sized.',54,cls='editorial')+text(120,1320,'The small cut strengthens the i stem and short t crossbar.',25)+text(120,1420,'Recommended digital starting points: 64 px mark / 176 px complete lockup. Print proof pending.',20)
svg('sift-wordmark-system.svg',2000,1500,board,'Sift Coffee wordmark variants and optical sizing',P['paper'])

# Shipping family: flat panel and repeat artwork, not a simulated photograph.
carton=logo(68,68,1.28,P['paper'])+text(68,395,'Good coffee.',58,P['paper'],cls='editorial')+text(68,470,'Clearly chosen.',58,P['paper'],cls='editorial')+motif(734,410,1.45,P['paper'],P['paper'])
svg('shipping-carton-panel.svg',1000,650,carton,'Sift Coffee shipping carton face artwork',P['ink'])
tape=''.join(logo(26+i*420,27,.57)+motif(257+i*420,58,.72) for i in range(3))
svg('shipping-tape-repeat.svg',1260,230,tape,'Sift Coffee shipping tape repeat artwork',P['paper'])
board=text(92,117,'From the collection to your door.',63,cls='editorial')
board+=f'<g transform="translate(90 250)">{rect(0,0,1000,650,P["ink"])}{carton}</g>'
board+=f'<g transform="translate(90 986) scale(1.38)">{tape}</g>'
board+=text(92,1420,'Flat carton panel and repeat tape artwork · Supplier dielines pending',22)
svg('sift-shipping-carton.svg',2000,1500,board,'Sift Coffee shipping carton and tape application board',P['paper'])

# Brewing cards: actual source typesetting, bilingual without Latin-style Arabic tracking.
brew_front=logo(46,38,.40)+text(46,213,'Daybreak',65,cls='editorial',weight=500)+text(46,259,'Apricot · citrus · floral',21)
brew_front+=motif(442,330,1.06)
brew_front+=text(46,371,'15 g',61,weight=500)+text(46,409,'coffee',21)+text(46,492,'250 g',61,weight=500)+text(46,530,'water',21)
brew_front+=rule(46,568,508,P['cobalt'],2)+text(46,610,'Medium grind',24)+text(46,652,'3-minute starting target',24)
brew_front+=ar(554,704,'١٥ غ قهوة · ٢٥٠ غ ماء',22)+ar(554,743,'طحن متوسط · وقت مبدئي ٣ دقائق',20)
brew_front+=text(46,783,'Suggested recipe · concept fixture',14)
svg('brew-card-daybreak-front.svg',600,840,brew_front,'Daybreak bilingual brewing card front',P['paper'])
brew_reverse=logo(46,38,.40)+text(46,212,'Start here.',61,cls='editorial')
brew_reverse+=lines(46,297,['Too sharp?','Try a slightly finer grind.'],28,42)
brew_reverse+=ar(554,432,'الطعم حادّ أكثر من اللازم؟',26)+ar(554,477,'جرّب طحناً أدقّ قليلاً.',26)
brew_reverse+=motif(46,569,1.3)+lines(46,689,['A starting point, not a fixed rule.','Adjust to your taste.'],22,34)
brew_reverse+=text(46,786,'Brewing guidance is illustrative; physical test pending.',13)
svg('brew-card-daybreak-reverse.svg',600,840,brew_reverse,'Daybreak bilingual brewing card reverse',P['paper'])
board=text(96,126,'A useful starting point.',64,cls='editorial')
board+=f'<g transform="translate(94 245) scale(1.28)">{rect(0,0,600,840,P["paper"])}{brew_front}</g>'
board+=f'<g transform="translate(1062 245) scale(1.28)">{rect(0,0,600,840,P["paper"])}{brew_reverse}</g>'
board+=text(96,1430,'Bilingual Daybreak card · 15 g coffee / 250 g water / medium grind / 3-minute starting target',20)
svg('sift-brewing-cards.svg',2000,1500,board,'Sift Coffee bilingual brewing card application board',P['mist'])

sample_lid=logo(70,55,.62)+lines(70,348,['Three coffees.','Three clear','starting points.'],76,92,cls='editorial',weight=500)+motif(753,83,1.85)
sample_lid+=text(70,670,'Everyday / Daybreak / After Hours',24)
svg('sample-box-lid.svg',1000,740,sample_lid,'Sift Coffee three-coffee sample box lid artwork',P['paper'])
sample_insert=text(50,80,'Find your starting point.',49,cls='editorial')
for i,p in enumerate(PRODUCTS):
    x=50+i*300
    sample_insert+=rule(x,145,270,p['color'],5)+text(x,207,p['name'],32,cls='editorial',weight=500)
    sample_insert+=lines(x,255,wrap_words(p['notes'],24),18,27)
    sample_insert+=text(x,345,'Start with',13,weight=600)+lines(x,384,wrap_words(p['method'],23),19,29)
    for j,line in enumerate(p['ar_method']): sample_insert+=ar(x+270,481+j*27,line,22)
sample_insert+=text(50,595,'Studio concept · Sample origin, tasting and brewing information',16)+ar(920,636,'مشروع تصوّري · بيانات القهوة والتحضير توضيحية',21)
svg('sample-box-insert.svg',1000,680,sample_insert,'Sift Coffee bilingual collection insert',P['paper'])
board=text(90,126,'One collection. Three directions.',64,cls='editorial')
board+=f'<g transform="translate(90 270) scale(.83)">{rect(0,0,1000,740,P["paper"])}{sample_lid}</g>'
board+=f'<g transform="translate(1080 420) scale(.83)">{rect(0,0,1000,680,P["paper"])}{sample_insert}</g>'
board+=motif(1100,290,1.0)+text(90,1250,'A shared structure keeps the range coherent.',43,cls='editorial')+text(90,1325,'Colour and written descriptions distinguish each coffee.',25)+text(90,1425,'Flat lid and bilingual insert artwork · Not a fabricated physical pack',20)
svg('sift-sample-box.svg',2000,1500,board,'Sift Coffee sample box lid and bilingual insert board',P['mist'])

wholesale=logo(78,68,.75)+lines(78,409,['Three coffees.','One clear collection.'],74,93,cls='editorial')
wholesale+=text(78,572,'A proposed range for wholesale conversations.',25)+rule(78,626,1044)
wholesale+=text(78,670,'Coffee',17,weight=600)+text(392,670,'Tasting notes',17,weight=600)+text(815,670,'Start with',17,weight=600)
for i,p in enumerate(PRODUCTS):
    y=747+i*154
    wholesale+=rect(78,y-29,8,50,p['color'])+text(101,y,p['name'],34,cls='editorial',weight=500)
    wholesale+=lines(392,y,wrap_words(p['notes'],30),21,31)+lines(815,y,wrap_words(p['method'],22),21,31)+rule(78,y+94,1044,P['ink'])
wholesale+=text(78,1259,'Formats',18,weight=600)+text(392,1259,'250 g / 1 kg',31)+text(78,1340,'Enquiries: {WHOLESALE_CONTACT}',25)
wholesale+=text(78,1430,'Product information and formats are illustrative studio-concept data.',19)+text(78,1480,'No minimum orders, trade prices or stock commitments are represented.',18)
svg('sift-wholesale-sheet.svg',1200,1600,wholesale,'Sift Coffee wholesale information sheet',P['paper'])

social_launch=logo(92,70,1.32)+lines(92,607,['Three coffees.','Three clear','starting points.'],85,105,cls='editorial')+motif(780,943,1.75)
social_launch+=text(92,1170,'Everyday / Daybreak / After Hours',27)+text(92,1240,'Good coffee. Clearly chosen.',25)
svg('social-launch-template.svg',1080,1350,social_launch,'Sift Coffee collection launch social template',P['paper'])
social_product=logo(92,70,1.32,P['paper'])+text(92,650,'Daybreak',120,P['paper'],cls='editorial',weight=500)+text(92,732,'Bright & exploratory',36,P['paper'])+motif(92,840,2.2,P['paper'],P['paper'])
social_product+=text(92,1122,'Apricot · citrus · floral',32,P['paper'])+text(92,1181,'Start with a pour-over.',27,P['paper'])+text(92,1260,'Studio concept · sample product information',19,P['paper'])
svg('social-product-template.svg',1080,1350,social_product,'Sift Coffee Daybreak social product template',P['cobalt'])
board=text(80,128,'Clear words. A consistent voice.',62,cls='editorial')
board+=f'<g transform="translate(80 250) scale(.78)">{rect(0,0,1080,1350,P["paper"])}{social_launch}</g>'
board+=f'<g transform="translate(1077 250) scale(.78)">{rect(0,0,1080,1350,P["cobalt"])}{social_product}</g>'
board+=text(80,1415,'Editable collection and product templates · Actual authored type and vector marks',21)
svg('sift-social-templates.svg',2000,1500,board,'Sift Coffee collection and product social templates',P['mist'])

counter=logo(150,92,2.2)+text(150,650,'Good coffee. Clearly chosen.',39)
counter+=motif(150,752,1.7)+lines(150,979,['Three coffees.','Three clear','starting points.'],79,100,cls='editorial')
counter+=text(150,1360,'Everyday / Daybreak / After Hours',30)
for i,p in enumerate(PRODUCTS): counter+=rect(i*1000/3,1430,1000/3,70,p['color'])
svg('sift-counter-display.svg',1000,1500,counter,'Sift Coffee counter display artwork',P['paper'])

# Information and bilingual boards give portfolio readers inspectable flat artwork.
board=text(84,124,'Product choice comes first.',65,cls='editorial')+text(84,198,'Name, flavour direction and format establish the first reading.',25)
board+=f'<g transform="translate(84 325) scale(1.38)">{rect(0,0,480,720,P["paper"])}{front(PRODUCTS[0])[0]}</g>'
board+=lines(997,449,['The product has','the strongest voice.'],57,74,cls='editorial')+text(997,676,'Everyday / product name',28)+text(997,738,'Rounded & familiar / flavour direction',24)+text(997,800,'Cocoa · almond · brown sugar / tasting notes',22)+text(997,862,'Whole bean / product type',24)+text(997,924,'250 g / net weight',24)+motif(997,1061,2.1)
board+=text(84,1430,'Colour supports written differences; the collection also works without colour cues.',22)
svg('sift-detail-information.svg',2000,1500,board,'Sift Coffee product information hierarchy detail',P['mist'])
board=text(84,124,'Two languages. Equal consideration.',62,cls='editorial')
board+=f'<g transform="translate(84 265) scale(1.35)">{rect(0,0,480,720,P["paper"])}{back(PRODUCTS[1])[0]}</g>'
board+=f'<g transform="translate(1020 265) scale(1.35)">{rect(0,0,180,720,P["ink"])}{side(PRODUCTS[1])[0]}</g>'
board+=lines(1368,405,['Real fonts.','Correct shaping.','Readable space.'],40,64,cls='editorial')+ar(1860,675,'قهوة مختارة بعناية',32)+text(1368,840,'IBM Plex Sans Arabic',26)+text(1368,895,'No artificial tracking.',24)+text(1368,950,'Independent line height.',24)+text(1368,1005,'Right-to-left reading.',24)
board+=text(84,1430,'Arabic descriptions are authored concept translations; final production editorial review remains pending.',20)
svg('sift-detail-bilingual.svg',2000,1500,board,'Sift Coffee bilingual label hierarchy detail',P['mist'])

board=text(90,121,'Three coffees. One coherent collection.',64,cls='editorial')
for i,p in enumerate(PRODUCTS):
    x=100+i*640
    board+=f'<g transform="translate({x} 212) scale(.9)">{rect(0,0,480,720,P["paper"])}{front(p)[0]}</g>'
    board+=text(x,921,p['name']+' / 250 g',25,cls='editorial')
    board+=f'<g transform="translate({x} 972) scale(.62)">{rect(0,0,480,720,P["paper"])}{back(p)[0]}</g>'
    board+=f'<g transform="translate({x+320} 972) scale(.62)">{rect(0,0,180,720,P["ink"])}{side(p)[0]}</g>'
svg('sift-range-board.svg',2000,1500,board,'Sift Coffee collection front reverse and side artwork',P['mist'])

board=text(90,122,'One identity. Every touchpoint.',65,cls='editorial')
board+=f'<g transform="translate(90 205) scale(.75)">{rect(0,0,480,720,P["paper"])}{front(PRODUCTS[0])[0]}</g>'
board+=text(90,794,'250 g collection',25,cls='editorial')
board+=f'<g transform="translate(90 887) scale(.50)">{rect(0,0,680,840,P["paper"])}{front(PRODUCTS[0],True)[0]}</g>'
board+=text(90,1380,'1 kg format',25,cls='editorial')
board+=f'<g transform="translate(657 205) scale(.56)">{rect(0,0,1000,650,P["ink"])}{carton}</g>'
board+=f'<g transform="translate(657 615) scale(.45)">{rect(0,0,1260,230,P["paper"])}{tape}</g>'
board+=text(657,790,'Shipping carton + tape',25,cls='editorial')
board+=f'<g transform="translate(657 887) scale(.53)">{rect(0,0,600,840,P["paper"])}{brew_front}</g>'
board+=text(657,1395,'Brewing cards',25,cls='editorial')
board+=f'<g transform="translate(1065 887) scale(.38)">{rect(0,0,1000,740,P["paper"])}{sample_lid}</g>'
board+=f'<g transform="translate(1065 1214) scale(.27)">{rect(0,0,1000,680,P["paper"])}{sample_insert}</g>'
board+=text(1065,1450,'Sample box + insert',23,cls='editorial')
board+=f'<g transform="translate(1510 205) scale(.23)">{rect(0,0,1200,1600,P["paper"])}{wholesale}</g>'
board+=text(1510,624,'Wholesale sheet',25,cls='editorial')
board+=f'<g transform="translate(1510 710) scale(.18)">{rect(0,0,1080,1350,P["paper"])}{social_launch}</g>'
board+=f'<g transform="translate(1730 710) scale(.18)">{rect(0,0,1080,1350,P["cobalt"])}{social_product}</g>'
board+=text(1510,1005,'Social templates',25,cls='editorial')
board+=f'<g transform="translate(1580 1070) scale(.23)">{rect(0,0,1000,1500,P["paper"])}{counter}</g>'
board+=text(1510,1470,'Counter display',25,cls='editorial')
svg('sift-applications-board.svg',2000,1500,board,'Sift Coffee eight application families overview',P['mist'])

(OUT/'product-canon.json').write_text(json.dumps({'name':'Sift Coffee','tagline':'Good coffee. Clearly chosen.','supporting_line':'Three coffees. Three clear starting points.','status':'Fictional studio-concept product fixtures','products':PRODUCTS},ensure_ascii=False,indent=2)+'\n')

if __name__=='__main__':
    (OUT/'asset-manifest.json').write_text(json.dumps({'project':'Sift Coffee','created_on':'2026-10-13','assets':REGISTRY},ensure_ascii=False,indent=2)+'\n')
    print(f'Built {len(REGISTRY)} SVG masters in {OUT}')
