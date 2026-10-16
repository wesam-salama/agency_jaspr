"""Rebuild Fold's authored vector geometry and editable presentation sources.

No generated garment photography is created by this script. Technical diagrams
are explanatory, not manufacturing patterns. Run with Python 3 from any cwd.
"""
from pathlib import Path
import json
import hashlib
import html
import base64

ROOT = Path(__file__).resolve().parent.parent
INK, IVORY, CITRINE, OLIVE, MIST, SLATE = '#161A18', '#F6F3EC', '#D8F16A', '#3C4A3E', '#D8DDD3', '#636F65'
F = '<path d="M0 0H59V28H28V68H94V96H28V164H0Z M69 4H116V32H69Z"/>'
O = '<path fill-rule="evenodd" d="M177 0H223C253 0 266 15 266 45V119C266 149 253 164 223 164H177C147 164 134 149 134 119V45C134 15 147 0 177 0ZM179 28C167 28 162 34 162 47V117C162 130 167 136 179 136H221C233 136 238 130 238 117V47C238 34 233 28 221 28Z"/>'
L = '<path d="M286 0H314V136H394V164H286Z"/>'
D = '<path fill-rule="evenodd" d="M414 0H491C532 0 550 20 550 61V103C550 144 532 164 491 164H414ZM442 28V136H488C512 136 522 126 522 101V63C522 38 512 28 488 28Z"/>'
WORD = F + O + L + D
def embedded_font(filename):
    return 'data:font/woff2;base64,' + base64.b64encode((ROOT/'fonts'/filename).read_bytes()).decode('ascii')

STYLE = f'''<style>@font-face{{font-family:Archivo;src:url({embedded_font('Archivo.woff2')});font-weight:400 700}}@font-face{{font-family:"DM Sans";src:url({embedded_font('DMSans.woff2')});font-weight:400 700}}@font-face{{font-family:PlexArabic;src:url({embedded_font('IBMPlexSansArabic-Regular.woff2')});font-weight:400}}text{{font-family:"DM Sans",sans-serif;fill:#161A18}}.heading{{font-family:Archivo,sans-serif;font-weight:600}}.arabic{{font-family:PlexArabic,sans-serif;letter-spacing:0}}</style>'''

def svg(w, h, title, body, background=None):
    bg = f'<rect width="{w}" height="{h}" fill="{background}"/>' if background else ''
    fonts = STYLE if '<text' in body else ''
    body = body.replace('text-anchor="end" direction="rtl"','text-anchor="start" direction="rtl"')
    return f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" role="img" aria-labelledby="title"><title id="title">{html.escape(title)}</title>{fonts}{bg}{body}</svg>\n'

def save(relative, content):
    p = ROOT / relative
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content, encoding='utf-8')

def word(x, y, width, colour=INK):
    return f'<g fill="{colour}" transform="translate({x} {y}) scale({width/550})">{WORD}</g>'

for name, colour in [('ink', INK), ('ivory', IVORY), ('black', '#000000'), ('white', '#FFFFFF')]:
    save(f'identity/fold-wordmark-{name}.svg', svg(550,164,'FOLD — manually drawn signature',f'<g fill="{colour}">{WORD}</g>'))
    save(f'identity/fold-monogram-{name}.svg', svg(116,164,'FOLD — F care-label monogram',f'<g fill="{colour}">{F}</g>'))

proof = word(150,150,1100)
proof += '<g fill="none" stroke="#636F65" stroke-width="1"><rect x="94" y="94" width="1212" height="440" stroke-dasharray="6 5"/><path d="M150 78V126M1250 78V126M78 150H126M78 478H126"/></g>'
proof += '<text x="94" y="66" font-size="22">Clear space = one 28-unit stem, all sides</text><text x="94" y="600" class="heading" font-size="40">One cut. Four whole letters.</text><text x="94" y="640" font-size="24">F terminal: 10-unit cut / 4-unit offset. Never repeat the cut elsewhere.</text>'
for x, width in [(94,72),(320,96),(620,160),(1010,240)]:
    proof += word(x,738,width) + f'<text x="{x}" y="856" font-size="22">{width} px</text>'
proof += '<text x="94" y="936" font-size="22">Digital minimum: wordmark 72 px / monogram 20 px. Test actual output.</text>'
save('identity/fold-clear-space.svg',svg(1400,1000,'FOLD clear-space and digital small-size proof',proof,IVORY))

def buttons(x, ys, radius=3):
    return ''.join(f'<circle cx="{x}" cy="{y}" r="{radius}"/>' for y in ys)

def technical(kind, back=False):
    # Shared line vocabulary; these coordinates explain construction, not size.
    if kind == 'shirt':
        outline='<path d="M80 58L124 38L144 42H176L196 38L240 58L270 116L230 138L214 111V280H106V111L90 138L50 116Z"/>'
        if back:
            inside='<path d="M124 38Q160 67 196 38M91 78H229M109 268H211"/>'
        else:
            inside='<path d="M124 38L144 72L160 48L176 72L196 38M160 48V280M167 74V277M109 268H211M184 90H208V122H184Z"/>'+buttons(163.5,[84,124,164,204,244],2.5)
        return outline+inside
    if kind == 'trouser':
        outline='<path d="M101 36H219L232 99L223 288H177L160 135L143 288H97L88 99Z"/>'
        inside='<path d="M101 55H219M160 55V135M99 276H142M178 276H224M103 37V54M133 37V54M187 37V54M216 37V54"/>'
        if not back:
            inside += '<path d="M106 62L94 104M214 62L226 104M133 60L127 133M187 60L193 133M168 56V107Q164 115 160 115"/>'+buttons(161,[46],2.5)
        else:
            inside += '<path d="M157 37V54"/>'
        return outline+inside
    if kind == 'vest':
        outline='<path d="M111 39L137 35H183L209 39L218 111L211 274H109L102 111Z"/>'
        if back:
            inside='<path d="M137 35Q160 62 183 35M110 262H210"/>'
        else:
            inside='<path d="M137 35L160 116L183 35M160 116V274M110 262H210M117 187H148V233H117ZM173 187H204V233H173Z"/>'+buttons(163,[133,171,209,247],2.6)
        return outline+inside
    outline='<path d="M99 51L126 36L144 40H176L194 36L221 51L245 112L259 258L231 263L211 127V286H109V127L89 263L61 258L75 112Z"/>'
    if back:
        inside='<path d="M126 36Q160 63 194 36M88 82H232M110 274H210M64 244L91 249M229 249L256 244"/>'
    else:
        inside='<path d="M126 36L144 70L160 46L176 70L194 36M160 46V286M168 74V284M110 274H210M116 93H145V128H116ZM177 93H206V128H177ZM64 244L91 249M229 249L256 244"/>'+buttons(164,[82,119,156,193,230,267],2.4)
    return outline+inside

products=[('FL01','Box Shirt','shirt','5 opening buttons · 1 chest pocket'),('FL02','Pleat Trouser','trouser','1 forward pleat per leg · 2 side pockets'),('FL03','Layer Vest','vest','4 opening buttons · 2 patch pockets'),('FL04','Field Overshirt','overshirt','6 opening buttons · 2 open chest pockets')]
all_diagrams=''
for i,(code,name,kind,detail) in enumerate(products):
    marks=''
    for j,back in enumerate([False,True]):
        marks += f'<g transform="translate({j*355+35} 95)" fill="none" stroke="{INK}" stroke-width="1.8" stroke-linejoin="round">{technical(kind,back)}</g>'
        marks += f'<text x="{j*355+195}" y="425" font-size="18" text-anchor="middle">{"Back" if back else "Front"}</text>'
    marks += f'<text x="40" y="46" class="heading" font-size="28">{code} / {name}</text><text x="40" y="470" font-size="18">{detail}</text><text x="40" y="505" font-size="15" fill="{SLATE}">Illustrative construction geometry. Not a manufacturing pattern.</text>'
    save(f'source/{code.lower()}-construction.svg',svg(750,540,f'{name} locked front and back construction',marks,IVORY))
    all_diagrams += f'<g transform="translate({(i%2)*750} {(i//2)*540+120})">{marks}</g>'
all_diagrams='<text x="40" y="72" class="heading" font-size="44">Everyday Structure / construction canon</text>'+all_diagrams
save('source/garment-construction.svg',svg(1500,1230,'Four locked Fold silhouettes, front and back',all_diagrams,IVORY))

# Flat layouts retain editable type and are explicitly sample packaging artwork.
tag_front=word(48,110,384,IVORY)
tag_front += '<circle cx="240" cy="35" r="8" fill="#F6F3EC"/><path d="M48 440H432M48 448V432M432 448V432" stroke="#F6F3EC" stroke-width="1"/><text x="48" y="500" font-size="28" style="fill:#F6F3EC">Clothes that give</text><text x="48" y="536" font-size="28" style="fill:#F6F3EC">your day room.</text><text x="48" y="682" font-size="20" style="fill:#F6F3EC">Collection 01</text><text x="48" y="715" font-size="20" style="fill:#F6F3EC">Everyday Structure</text>'
save('packaging/hangtag-front.svg',svg(480,760,'Fold hangtag front — editable concept artwork',tag_front,INK))
tag_back='<circle cx="240" cy="35" r="8" fill="#D8DDD3"/><text x="48" y="130" class="heading" font-size="42">Box Shirt</text><text x="48" y="178" font-size="24">Chalk / M</text><path d="M48 214H432M48 552H432" stroke="#161A18"/><text x="48" y="270" font-size="20">FL01-CHK-M</text><text x="48" y="320" font-size="24">100% cotton poplin</text><text x="432" y="377" text-anchor="end" direction="rtl" class="arabic" font-size="26">بوبلين قطني ١٠٠٪</text><text x="48" y="474" class="heading" font-size="34">$95.00 USD</text><text x="48" y="604" font-size="18">Fictional product specification.</text><text x="48" y="635" font-size="18">Studio concept / sample artwork.</text><text x="432" y="700" text-anchor="end" direction="rtl" class="arabic" font-size="21">عينة تصميم لمنتج افتراضي</text>'
save('packaging/hangtag-back.svg',svg(480,760,'Fold hangtag back — Box Shirt Chalk M fictional fixture',tag_back,IVORY))
care=f'<g transform="translate(34 30) scale(.32)" fill="{INK}">{F}</g><text x="34" y="128" class="heading" font-size="30">Box Shirt / M</text><text x="34" y="171" font-size="18">FL01-CHK-M</text><path d="M34 199H286M34 522H286" stroke="#161A18"/><text x="34" y="243" font-size="20">100% cotton poplin</text><text x="286" y="285" text-anchor="end" direction="rtl" class="arabic" font-size="23">بوبلين قطني ١٠٠٪</text><text x="34" y="343" font-size="19">Illustrative care only:</text><text x="34" y="378" font-size="19">Gentle cold wash.</text><text x="34" y="412" font-size="19">Line dry. Cool iron.</text><text x="286" y="472" text-anchor="end" direction="rtl" class="arabic" font-size="21">تعليمات عناية تجريبية</text><text x="34" y="568" font-size="17">Confirm after fabric testing.</text><text x="34" y="603" font-size="17">Not a production label.</text><text x="286" y="660" text-anchor="end" direction="rtl" class="arabic" font-size="19">عينة تصميم وليست بطاقة إنتاج</text>'
save('packaging/care-label.svg',svg(320,720,'Fold bilingual sample care label — not production instructions',care,IVORY))
mailer=word(100,192,1000)
mailer += '<g stroke="#161A18" fill="none"><path d="M40 40H1160V760H40Z"/><path d="M70 110H1130" stroke-dasharray="6 5"/><path d="M100 660H1100M100 651V669M1100 651V669"/></g><text x="100" y="580" class="heading" font-size="42">Room for the everyday.</text><text x="100" y="711" font-size="23">Collection 01 / Everyday Structure</text><text x="1100" y="711" font-size="18" text-anchor="end">Concept mailer face</text>'
save('packaging/mailer-face.svg',svg(1200,800,'Fold single mailer face — editable concept application',mailer,MIST))

# Shared local-only presentation styles. Artboards are editable HTML, not UI evidence.
css='''@font-face{font-family:Archivo;src:url('../fonts/Archivo.woff2');font-weight:400 700;font-display:swap}@font-face{font-family:'DM Sans';src:url('../fonts/DMSans.woff2');font-weight:400 700;font-display:swap}@font-face{font-family:PlexArabic;src:url('../fonts/IBMPlexSansArabic-Regular.woff2');font-weight:400;font-display:swap}@font-face{font-family:PlexArabic;src:url('../fonts/IBMPlexSansArabic-SemiBold.woff2');font-weight:600;font-display:swap}*{box-sizing:border-box}body{margin:0;background:#F6F3EC;color:#161A18;font-family:'DM Sans',sans-serif}h1,h2,h3{font-family:Archivo,sans-serif;font-weight:500;letter-spacing:-.025em}img{display:block;max-width:100%}p{line-height:1.55}a{color:inherit;text-underline-offset:.2em}a:focus-visible{outline:3px solid #3C4A3E;outline-offset:5px}::selection{background:#D8F16A;color:#161A18}.ar{font-family:PlexArabic,sans-serif;letter-spacing:normal}.artboard{width:2000px;height:1500px;padding:100px;position:relative;overflow:hidden}.artboard h1{font-size:96px;line-height:1.04;margin:0}.foot{position:absolute;left:100px;right:100px;bottom:72px;border-top:1px solid #636F65;padding-top:24px;display:flex;justify-content:space-between;font-size:22px}.rule{height:1px;background:#636F65}.meta{font-size:22px;line-height:1.5}.word{width:100%;height:auto}.board-main{display:grid;grid-template-columns:1.15fr 1fr;gap:120px}.board-main p{font-size:30px;max-width:38ch}.swatches{display:flex;gap:16px}.swatch{width:144px;height:108px;padding:16px;font-size:16px;display:flex;align-items:flex-end}.caption{font-size:22px;line-height:1.45}.label{font-size:24px}.guide{max-width:1280px;margin:auto;padding:72px 48px}.guide-header{display:flex;align-items:center;justify-content:space-between;gap:40px;padding-bottom:56px;border-bottom:1px solid #636F65}.guide-header img{width:240px}.guide h1{font-size:clamp(42px,6vw,88px);line-height:1.02;margin:0 0 28px}.guide h2{font-size:38px;line-height:1.15;margin:0 0 24px}.guide h3{font-size:25px}.guide p,.guide li{font-size:18px;line-height:1.65;max-width:70ch}.guide section{padding:72px 0;border-bottom:1px solid #636F65}.columns{display:grid;grid-template-columns:1fr 1fr;gap:64px}.guide figure{margin:0}.guide figcaption{font-size:15px;line-height:1.5;margin-top:20px;color:#636F65}.guide .large-mark{padding:60px 0}.guide .large-mark img{width:100%}.guide table{width:100%;border-collapse:collapse;font-size:16px}.guide th,.guide td{text-align:left;border-bottom:1px solid #D8DDD3;padding:14px 8px;vertical-align:top}.guide th{font-weight:600}.guide .swatches{flex-wrap:wrap}.guide .swatch{width:155px;height:120px}.guide .pack{display:grid;grid-template-columns:1fr 1fr .7fr;gap:24px;align-items:start}.guide .pack img{width:100%}.guide .notice{background:#D8F16A;padding:24px;margin:40px 0 0}.guide nav{display:flex;gap:24px;flex-wrap:wrap}.guide nav a{min-height:44px;display:inline-flex;align-items:center}@media(max-width:700px){.guide{padding:32px 24px}.guide-header{display:block}.guide-header nav{margin-top:24px}.columns{grid-template-columns:1fr;gap:32px}.guide section{padding:48px 0}.guide h2{font-size:30px}.guide .pack{grid-template-columns:1fr 1fr}.guide .pack figure:last-child{max-width:70%}.guide table{font-size:14px}.guide td,.guide th{padding:12px 4px}.guide .large-mark{padding:24px 0}}@media print{@page{size:A4;margin:16mm}.guide{max-width:none;padding:0}.guide-header{padding-bottom:10mm}.guide-header img{width:40mm}.guide nav{display:none}.guide h1{font-size:42pt}.guide h2{font-size:25pt}.guide p,.guide li{font-size:10pt;line-height:1.45}.guide section{break-before:page;border:0;padding:0}.guide section:first-of-type{break-before:auto;padding-top:10mm}.guide .columns{gap:10mm}.guide .large-mark{padding:12mm 0}.guide .swatch{width:28mm;height:22mm}.guide figcaption{font-size:9pt}.guide table{font-size:9pt}.guide td,.guide th{padding:3mm 1mm}a{color:inherit;text-decoration:none}.notice{break-inside:avoid}.guide figure{break-inside:avoid}}'''
save('source/identity.css',css)

def page(title, body, cls=''):
    return f'<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{html.escape(title)}</title><link rel="stylesheet" href="identity.css"></head><body class="{cls}">{body}</body></html>\n'

signature=f'<svg class="word" viewBox="0 0 550 164" aria-label="FOLD" role="img"><g fill="currentColor">{WORD}</g></svg>'
board=f'''<main class="artboard"><div class="board-main"><div><h1>Useful shape.<br>Clear choices.</h1><p>A clothing identity drawn from the way pieces come together.</p></div><div style="padding-top:10px"><div style="padding:0 0 100px">{signature}</div><div class="swatches"><span class="swatch" style="background:{INK};color:{IVORY}">Ink / 161A18</span><span class="swatch" style="background:{CITRINE}">Citrine / D8F16A</span><span class="swatch" style="background:{OLIVE};color:{IVORY}">Olive / 3C4A3E</span><span class="swatch" style="background:{MIST}">Stone / D8DDD3</span></div></div></div><div style="margin-top:100px;display:grid;grid-template-columns:1fr 1fr;gap:120px"><div style="border-top:1px solid #636F65;padding-top:40px"><div class="label">A controlled cut</div><div style="display:flex;gap:70px;margin-top:50px;align-items:center"><svg width="170" height="242" viewBox="0 0 116 164" aria-label="F monogram"><g fill="{INK}">{F}</g></svg><p class="caption" style="max-width:26ch">One offset terminal becomes the label mark. The rest stays whole.</p></div><p class="meta" style="margin-top:54px">Archivo / editorial<br>DM Sans / information<br><span class="ar" lang="ar" dir="rtl">ملابس تمنح يومك مساحة.</span></p></div><div style="border-top:1px solid #636F65;padding-top:40px"><div class="label">The construction vocabulary</div><img style="width:630px;margin-top:4px" src="fl01-construction.svg" alt="Box Shirt front and back construction geometry"><p class="caption">Solid edge. Limited dash. Alignment tick.<br>Explanatory geometry, never a cutting template.</p></div></div><footer class="foot"><span>Fold Clothing / Everyday Structure</span><span>Authored identity system · studio concept</span></footer></main>'''
save('source/identity-board.html',page('Fold — identity presentation',board))
packboard='''<main class="artboard" style="background:#D8DDD3"><div style="display:flex;justify-content:space-between;gap:120px"><h1>From garment<br>to parcel.</h1><p class="caption" style="width:600px;padding-top:12px">The same signature, precise product information and one clear line system.</p></div><div style="margin-top:90px;display:grid;grid-template-columns:440px 440px 220px;gap:62px;align-items:start"><img src="../packaging/hangtag-front.svg" alt="Fold hangtag front"><img src="../packaging/hangtag-back.svg" alt="Box Shirt Chalk M sample hangtag back"><img src="../packaging/care-label.svg" alt="Bilingual illustrative care label"></div><div style="position:absolute;right:100px;bottom:210px;width:550px;background:#F6F3EC;padding:32px"><img src="../packaging/mailer-face.svg" alt="Fold single mailer face"><p class="caption">One restrained mailer application.</p></div><footer class="foot"><span>Fold Clothing / editable packaging</span><span>Sample artwork · no physical production claimed</span></footer></main>'''
save('source/packaging-board.html',page('Fold — packaging presentation',packboard))

guide=f'''<main class="guide"><header class="guide-header"><img src="../identity/fold-wordmark-ink.svg" alt="FOLD"><nav aria-label="Guide links"><a href="../site/index.html">Open the demo store</a><a href="identity-board.html">Identity board</a><a href="packaging-board.html">Packaging board</a></nav></header><section><h1>Clothes that give<br>your day room.</h1><p>Fold Clothing is an authored studio concept for an everyday capsule. Useful silhouettes, considered construction and clear choices guide the identity and shopping experience.</p><div class="large-mark">{signature}</div><p class="notice">Digital identity and packaging artwork. Product compositions, prices, stock and care text are fictional design fixtures. No physical manufacture, sourcing or commercial launch is established.</p></section><section><h2>The signature</h2><div class="columns"><div><p>Four compact letters. One cut in the upper arm of the F. The displaced terminal refers to a piece aligned for construction. Repeat the original vector unchanged.</p><p>Use FOLD as the signature and Fold Clothing in written language. Preserve the Latin mark in Arabic layouts. The F monogram reuses exactly the same path on narrow labels.</p><p>Clear space: one 28-unit stem on all sides. Digital minimum: 72 px wordmark, 20 px monogram. These are screen rules; physical output needs proofing.</p></div><figure><img src="../identity/fold-clear-space.svg" alt="FOLD clear-space and small-size proof"><figcaption>Master geometry and readable screen sizes. The cut appears only once.</figcaption></figure></div><div class="columns" style="margin-top:40px"><figure style="background:#161A18;padding:38px"><img src="../identity/fold-wordmark-ivory.svg" alt="Reverse ivory FOLD"></figure><figure style="padding:38px"><img src="../identity/fold-wordmark-black.svg" alt="Single-colour black FOLD"></figure></div></section><section><h2>Colour and type</h2><div class="swatches"><span class="swatch" style="background:{IVORY};border:1px solid {SLATE}">Ivory / F6F3EC</span><span class="swatch" style="background:{INK};color:{IVORY}">Ink / 161A18</span><span class="swatch" style="background:{CITRINE}">Citrine / D8F16A</span><span class="swatch" style="background:{OLIVE};color:{IVORY}">Olive / 3C4A3E</span><span class="swatch" style="background:{MIST}">Mist / D8DDD3</span><span class="swatch" style="background:{SLATE};color:{IVORY}">Slate / 636F65</span></div><div class="columns" style="margin-top:40px"><div><h3>Archivo for editorial language.</h3><p>DM Sans for information, prices and decisions. Use real local font files, 400–700 variable weights. Open letters, clear hierarchy, square edges. The signature is a drawing, not typeset Archivo.</p><p class="ar" lang="ar" dir="rtl" style="font-size:28px">مساحة للحركة. ووضوح في الاختيار.</p><p>IBM Plex Sans Arabic supplies Arabic shaping in 400 and 600. Arabic uses no tracking; Latin brand, SKU and measurement strings retain readable direction.</p></div><div><table><thead><tr><th>Pair</th><th>Contrast</th><th>Role</th></tr></thead><tbody><tr><td>Ink / Ivory</td><td>15.86:1</td><td>Body, controls</td></tr><tr><td>Ink / Citrine</td><td>13.98:1</td><td>Selected state</td></tr><tr><td>Slate / Ivory</td><td>4.75:1</td><td>Full-opacity support text</td></tr><tr><td>Ivory / Olive</td><td>8.46:1</td><td>Dark panel text</td></tr><tr><td>Mist / Ivory</td><td>1.25:1</td><td>Decoration only</td></tr></tbody></table><p>Digital HEX values. Print colour depends on stock, inks and actual proofing.</p></div></div></section><section><h2>A line with a purpose</h2><p>A solid line establishes an edge. A limited dashed line distinguishes an illustrative fold or comparison. Short ticks mark alignment. FL01–FL04 identify garment records. This is a restrained graphic language; it never impersonates manufacturing dimensions.</p><figure><img src="garment-construction.svg" alt="Technical front and back geometry for four locked garments"><figcaption>Canon: five shirt buttons / one chest pocket; one trouser forward pleat per leg; four vest buttons / two pockets; six overshirt buttons / two open chest pockets. Illustrative, not to scale.</figcaption></figure></section><section><h2>Information that travels with the garment</h2><p>The signature stays consistent from hangtag to narrow label and mailer. Sample composition, price, SKU and size follow the same product record. Care text is illustrative and requires fabric testing before production. No origin, certification or sourcing statement is invented.</p><div class="pack"><figure><img src="../packaging/hangtag-front.svg" alt="Editable front hangtag"><figcaption>Hangtag / front</figcaption></figure><figure><img src="../packaging/hangtag-back.svg" alt="Editable product-information hangtag"><figcaption>Hangtag / reverse</figcaption></figure><figure><img src="../packaging/care-label.svg" alt="Editable bilingual illustrative care label"><figcaption>Care label / sample only</figcaption></figure></div></section><section><h2>One collection. Clear decisions.</h2><figure><img src="../packaging/mailer-face.svg" alt="Flat single Fold mailer application"><figcaption>Mailer face. Digital artwork; no manufacturing die line or physical package proof.</figcaption></figure><div class="columns" style="margin-top:36px"><div><h3>Collection 01: Everyday Structure</h3><p>Box Shirt · Pleat Trouser · Layer Vest · Field Overshirt. Four products and eight colour variants. Measurements are laid-flat garment measurements; chest and waist are half-widths, not body circumferences.</p><p>“A straight leg. Room through the thigh.” Concrete observations keep product language useful. No unsupported durability, sustainability or fit-test claim.</p></div><div><h3>Editable handoff</h3><p>SVG signature/monogram variants, clear-space tests, construction diagrams, packaging layouts, this HTML guide, two editable presentation boards, source builder and local licensed fonts are supplied.</p><p>The OFL licences in the font folder travel with the source files. Name clearance, print proofing, fit tests, production care and commercial policies remain unresolved.</p></div></div><p class="notice">Fold Clothing / Self-initiated studio project / Digital design system, 15 October 2026. Store behavior and integration status are established by the separate production and verification evidence.</p></section></main>'''
save('source/fold-brand-guide.html',page('Fold Clothing — editable brand guide',guide))

manifest=[]
for folder in ['identity','packaging']:
    for p in sorted((ROOT/folder).glob('*.svg')):
        manifest.append({'id':p.stem,'file':str(p.relative_to(ROOT)),'source':'source/build-identity.py','creator':'CR8.Media / Codex authored vector geometry and typesetting','status':'designed digital artwork','rights':'Authored studio-concept artwork; included fonts retain OFL licences','sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
save('source/identity-manifest.json',json.dumps({'version':'1.0','created':'2026-10-15','artworkOnly':True,'assets':manifest},indent=2)+'\n')
print(f'Wrote {len(manifest)} identity/packaging masters plus 5 construction diagrams, 2 boards and printable guide.')
