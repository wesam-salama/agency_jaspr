"""Refresh Fold's scoped v2 sidecar from the documented finished source.

Does not modify the agency system or the store. Primitive tokens live in DESIGN.md;
this sidecar holds panel metadata, ramps and renderable observed components.
"""
from pathlib import Path
import json
import re
import math
from datetime import datetime, timezone

ROOT=Path(__file__).resolve().parents[1]
design=(ROOT/'DESIGN.md').read_text()
sections={m[1]:m[2].strip() for m in re.finditer(r'^## ([^\n]+)\n(.*?)(?=^## |\Z)',design,re.S|re.M)}
assert list(sections)==['Overview','Colors','Typography','Layout','Elevation & Depth','Shapes','Components',"Do's and Don'ts"]
colours={'ivory':'#F6F3EC','ink':'#161A18','citrine':'#D8F16A','olive':'#3C4A3E','slate':'#636F65','mist':'#D8DDD3','rule':'#B4B8AE','error':'#9A3026'}

def ramp(value):
    rgb=[int(value[i:i+2],16)/255 for i in [1,3,5]]
    r,g,b=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in rgb]
    l=(.4122214708*r+.5363325363*g+.0514459929*b)**(1/3)
    m=(.2119034982*r+.6806995451*g+.1073969566*b)**(1/3)
    s=(.0883024619*r+.2817188376*g+.6299787005*b)**(1/3)
    a=1.9779984951*l-2.428592205*m+.4505937099*s
    q=.0259040371*l+.7827717662*m-.808675766*s
    c=(a*a+q*q)**.5
    h=math.degrees(math.atan2(q,a))%360
    return [f'oklch({v}% {c:.5f} {h:.2f})' for v in [15,27,38,49,60,71,82,95]]

base="font-family:'DM Sans',sans-serif;color:var(--ink,#161A18);border-radius:0;"
focus='outline:2px solid var(--olive,#3C4A3E);outline-offset:5px'
components=[]
def component(name,kind,description,html,css):
    components.append({'name':name,'kind':kind,'description':description,'html':html,'css':css})

component('Primary action','button','Square Ink action, Olive hover and visible keyboard focus.',
    '<button class="ds-primary" type="button">Add to demo cart</button>',
    '.ds-primary{'+base+'font-size:14px;line-height:1.4;min-height:56px;padding:16px 20px;border:1px solid var(--ink,#161A18);background:var(--ink,#161A18);color:var(--ivory,#F6F3EC);transition:transform 120ms cubic-bezier(.16,1,.3,1),background-color 120ms cubic-bezier(.16,1,.3,1)}.ds-primary:hover{background:var(--olive,#3C4A3E)}.ds-primary:focus-visible{'+focus+'}.ds-primary:active{transform:scale(.98)}.ds-primary:disabled{background:var(--mist,#D8DDD3);color:var(--slate,#636F65);border-color:var(--slate,#636F65)}@media(prefers-reduced-motion:reduce){.ds-primary{transition:none}.ds-primary:active{transform:none}}')
component('Shipping field','input','Permanent label and square 52 px minimum shipping field.',
    '<label class="ds-field">Full name<input type="text" autocomplete="name" value="Demo shopper"></label>',
    '.ds-field{'+base+'display:grid;gap:10px;font-size:12px;max-width:400px}.ds-field input{font:inherit;font-size:16px;min-height:52px;padding:10px 12px;background:var(--ivory,#F6F3EC);color:var(--ink,#161A18);border:1px solid var(--slate,#636F65);border-radius:0;caret-color:var(--olive,#3C4A3E)}.ds-field input:focus-visible{'+focus+'}')
component('Collection navigation','nav','Plain links with current underline and Olive hover.',
    '<nav class="ds-nav" aria-label="Fold navigation"><a href="#collection" aria-current="page">Collection</a><a href="#about">About Fold</a><a href="#cart">Cart (2)</a></nav>',
    '.ds-nav{'+base+'display:flex;gap:32px;flex-wrap:wrap}.ds-nav a{color:inherit;font-size:14px;min-height:44px;display:inline-flex;align-items:center;text-decoration:none}.ds-nav a[aria-current]{text-decoration:underline;text-underline-offset:8px}.ds-nav a:hover{color:var(--olive,#3C4A3E)}.ds-nav a:focus-visible{'+focus+'}')
component('Removable filter','chip','Mist filter chip with explicit removal and a 44 px minimum height.',
    '<button class="ds-filter" type="button" aria-label="Remove Chalk filter">Chalk <svg width="12" height="12" viewBox="0 0 12 12" aria-hidden="true"><path d="M2 2L10 10M10 2L2 10" fill="none" stroke="currentColor"/></svg></button>',
    '.ds-filter{'+base+'min-height:44px;display:inline-flex;align-items:center;gap:12px;padding:8px 12px;border:0;background:var(--mist,#D8DDD3);font-size:12px;cursor:pointer}.ds-filter:hover{background:var(--citrine,#D8F16A)}.ds-filter:focus-visible{'+focus+'}')
component('Garment information','card','The unboxed product name/price/colour text below a garment image.',
    '<article class="ds-garment"><div><h3><a href="#box-shirt">Box Shirt</a></h3><span>$95.00</span></div><p>Chalk / Ink · 2 colours</p></article>',
    '.ds-garment{'+base+'max-width:360px}.ds-garment>div{display:flex;align-items:start;justify-content:space-between;gap:12px}.ds-garment h3{font-family:inherit;font-size:16px;font-weight:500;letter-spacing:-.02em;margin:0}.ds-garment a{color:inherit;text-decoration:none;min-height:44px;display:inline-flex;align-items:center}.ds-garment a:hover{color:var(--olive,#3C4A3E)}.ds-garment a:focus-visible{'+focus+'}.ds-garment span{font-size:13px;font-variant-numeric:tabular-nums}.ds-garment p{font-size:11px;color:var(--slate,#636F65);margin:0}')
component('Explicit size choice','custom','Selected radio, named unavailable size and focus around the full visible target.',
    '<fieldset class="ds-sizes"><legend>Choose a size</legend><label><input type="radio" name="ds-size" value="M" checked><span>M</span></label><label class="ds-unavailable"><input type="radio" name="ds-size" value="XS" disabled><span>XS <small>Unavailable</small></span></label></fieldset>',
    '.ds-sizes{'+base+'border:0;padding:0;display:flex;gap:8px;max-width:320px}.ds-sizes legend{font-size:13px;margin-bottom:12px}.ds-sizes label{position:relative;flex:1;cursor:pointer}.ds-sizes input{position:absolute;opacity:0;width:1px;height:1px}.ds-sizes span{min-height:50px;display:flex;align-items:center;justify-content:center;flex-direction:column;gap:4px;border:1px solid var(--slate,#636F65);font-size:13px}.ds-sizes input:checked+span{border:2px solid var(--ink,#161A18);background:var(--citrine,#D8F16A)}.ds-sizes input:focus-visible+span{outline:2px solid var(--olive,#3C4A3E);outline-offset:3px}.ds-sizes label:not(.ds-unavailable):hover span{background:var(--mist,#D8DDD3)}.ds-sizes .ds-unavailable span{border-style:dashed;color:var(--slate,#636F65)}.ds-sizes small{font-size:8px;line-height:1.3}')
component('In-flow cart feedback','custom','A state region that reserves space instead of covering shopping content.',
    '<div class="ds-status" role="status"><span>Removed Box Shirt from the demo cart.</span><button type="button">Undo</button><button type="button">Dismiss</button></div>',
    '.ds-status{'+base+'position:static;display:flex;flex-wrap:wrap;align-items:center;gap:8px 20px;padding:16px 20px;border:1px solid var(--olive,#3C4A3E);background:var(--citrine,#D8F16A);font-size:13px;line-height:1.5}.ds-status>span{flex:1 1 180px}.ds-status button{font:inherit;font-size:12px;min-height:44px;min-width:44px;background:none;border:0;color:inherit;text-decoration:underline;text-underline-offset:4px}.ds-status button:hover{color:var(--olive,#3C4A3E)}.ds-status button:focus-visible{'+focus+'}')

overview=sections['Overview'].split('**Key Characteristics:**')[0]
overview=re.sub(r'^\*\*Creative North Star:[^\n]*\n\n','',overview).strip()
chars=[s[2:] for s in sections['Overview'].split('**Key Characteristics:**')[1].strip().splitlines() if s.startswith('- ')]
dos=[s[2:] for s in sections["Do's and Don'ts"].splitlines() if s.startswith('- Do ')]
donts=[s[2:] for s in sections["Do's and Don'ts"].splitlines() if s.startswith("- Don't ")]
rules=[]
for section,body in sections.items():
    for m in re.finditer(r'\*\*(The .+? Rule)\.\*\* (.+)',body):
        rules.append({'name':m[1],'body':m[2],'section':section.lower()})
for item in components:
    item['css']=item['css'].replace('.ds-filter:hover{background:var(--citrine,#D8F16A)}','').replace('.ds-garment a:hover{color:var(--olive,#3C4A3E)}','').replace('.ds-status button:hover{color:var(--olive,#3C4A3E)}','')

data={'schemaVersion':2,'generatedAt':datetime.now(timezone.utc).isoformat(),'title':'Design System: Fold Clothing',
    'extensions':{'colorMeta':{k:{'canonical':v,'displayName':k.title(),'role':'primary' if k=='ink' else 'secondary' if k in ['olive','citrine'] else 'neutral','tonalRamp':ramp(v)} for k,v in colours.items()},
    'typographyMeta':{'display':{'displayName':'Latin title','purpose':'Local Archivo 600 editorial titles.'},'headline':{'displayName':'Latin heading','purpose':'Archivo hierarchy in natural document flow.'},'body':{'displayName':'Interface information','purpose':'Local DM Sans for prose, controls, captions and product information.'},'arabic':{'displayName':'Arabic text','purpose':'Actual IBM Plex Sans Arabic 400/600, normal tracking, RTL.'},'price':{'displayName':'Numeric information','purpose':'DM Sans tabular numerals for prices, totals and measurements.'}},
    'shadows':[],'motion':[{'name':'action-press','value':'transform 120ms cubic-bezier(.16,1,.3,1)','purpose':'User-triggered press feedback.'},{'name':'arrow','value':'transform 160ms cubic-bezier(.16,1,.3,1)','purpose':'Useful link direction feedback.'},{'name':'product-preview','value':'transform 350ms cubic-bezier(.16,1,.3,1)','purpose':'Fine-pointer garment preview feedback.'},{'name':'reduced-motion','value':'animation:none;transition:none;transform:none;scroll-behavior:auto','purpose':'Keep content and controls stable when reduction is requested.'}],
    'breakpoints':[{'name':'compact-desktop','value':'1100px'},{'name':'linear-mobile','value':'760px'},{'name':'narrow-mobile','value':'370px'}]},
    'components':components,'narrative':{'northStar':'Everyday Structure','overview':overview,'keyCharacteristics':chars,'rules':rules,'dos':dos,'donts':donts}}
(ROOT/'.impeccable/design.json').write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps({'canonicalSections':len(sections),'renderableComponents':len(components),'colourRamps':len(colours),'shadows':0}))
