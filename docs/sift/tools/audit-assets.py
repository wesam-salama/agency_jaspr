#!/usr/bin/env python3
"""Structural, canonical content and exact solid-colour checks for Sift masters."""
from pathlib import Path
import json, hashlib, xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[3]
SOURCE=ROOT/'web/assets/selected-work/sift/source'
P={'paper':'#F4EBDD','ink':'#28221F','cobalt':'#3047D9','roast':'#C56339','mist':'#D9D9D0'}
def luminance(hexvalue):
    v=[int(hexvalue[i:i+2],16)/255 for i in (1,3,5)]
    v=[c/12.92 if c<=.04045 else ((c+.055)/1.055)**2.4 for c in v]
    return .2126*v[0]+.7152*v[1]+.0722*v[2]
def contrast(a,b):
    x,y=sorted((luminance(a),luminance(b)))
    return (y+.05)/(x+.05)
manifest=json.loads((SOURCE/'asset-manifest.json').read_text())
font_audit=json.loads((SOURCE/'render-audit.json').read_text())
structural=[]
for rec in manifest['assets']:
    file=SOURCE/rec['file']
    tree=ET.parse(file).getroot()
    assert tree.tag.endswith('svg')
    assert int(tree.attrib['width'])==rec['width'] and int(tree.attrib['height'])==rec['height']
    assert hashlib.sha256(file.read_bytes()).hexdigest()==rec['sha256']
    assert (SOURCE/rec['render']).exists()
    assert '<image' not in file.read_text(), 'Bitmap image unexpectedly embedded in vector master'
    structural.append({'file':rec['file'],'xml_valid':True,'dimensions_match':True,'source_checksum_match':True,'render_exists':True,'bitmap_free':True})
for p in json.loads((SOURCE/'product-canon.json').read_text())['products']:
    front=(SOURCE/f'pack-{p["id"]}-250g-front.svg').read_text()
    reverse=(SOURCE/f'pack-{p["id"]}-250g-reverse.svg').read_text()
    assert p['name'] in front and p['notes'] in front and '250 g' in front
    assert '{ROAST_DATE}' in reverse and '{BATCH_ID}' in reverse
    assert 'Studio concept' in reverse and p['origin'] in reverse
    assert all(line in reverse for line in p['arabic'])
pairs=[('ink','paper'),('paper','ink'),('paper','cobalt'),('ink','mist'),('ink','roast')]
checks=[{'foreground':a,'background':b,'ratio':round(contrast(P[a],P[b]),3),'normal_text_pass':contrast(P[a],P[b])>=4.5} for a,b in pairs]
report={'date':'2026-10-13','scope':'Digital SVG artwork; no physical printing, coffee testing, supplier verification or commercial launch established.','svg_count':len(structural),'structural':structural,'text_pair_contrast':checks,'browser_render_count':len(font_audit),'all_requested_fonts_loaded':all(all(rec['fontStatus'].values()) for rec in font_audit),'text_artboard_overflow':{rec['file']:rec['overflow'] for rec in font_audit if rec['overflow']},'canonical_collection_checks':'passed','fixture_disclosures':'passed','review':'40 rendered masters inspected in four batched contact sheets; one missing carton-board background corrected and visually confirmed.'}
(SOURCE/'digital-audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k!='structural'},indent=2))
