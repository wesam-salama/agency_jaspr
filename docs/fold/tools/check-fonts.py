"""Inspect exact local font masters without a third-party parser dependency."""
from pathlib import Path
import struct
import json
import hashlib

ROOT = Path(__file__).resolve().parents[3] / 'web/assets/selected-work/fold/fonts'
OUTPUT = Path(__file__).resolve().parents[1] / 'verification/font-checks.json'

def u16(data, offset):
    return struct.unpack_from('>H',data,offset)[0]

def u32(data, offset):
    return struct.unpack_from('>I',data,offset)[0]

def inspect_ttf(filename, sample):
    data=(ROOT/filename).read_bytes()
    assert data[:4] in [b'\x00\x01\x00\x00',b'OTTO']
    tables={}
    for i in range(u16(data,4)):
        pos=12+i*16
        tag=data[pos:pos+4].decode('ascii')
        offset,length=u32(data,pos+8),u32(data,pos+12)
        assert offset+length <= len(data), (filename,tag,'truncated')
        tables[tag]=data[offset:offset+length]
    name=tables['name']
    names={}
    for i in range(u16(name,2)):
        pos=6+i*12
        platform,encoding,lang,nameid,length,offset=struct.unpack_from('>6H',name,pos)
        if nameid in [1,2,6] and platform in [0,3]:
            value=name[u16(name,4)+offset:u16(name,4)+offset+length].decode('utf-16-be')
            names[nameid]=value
    cmap=tables['cmap']
    subtables=[]
    for i in range(u16(cmap,2)):
        pos=4+i*8
        platform,encoding,offset=struct.unpack_from('>HHI',cmap,pos)
        if platform in [0,3]:
            subtables.append(offset)
    def has_glyph(cp):
        for offset in subtables:
            fmt=u16(cmap,offset)
            if fmt==12:
                for n in range(u32(cmap,offset+12)):
                    start,end,glyph=struct.unpack_from('>III',cmap,offset+16+n*12)
                    if start<=cp<=end:
                        return glyph+cp-start != 0
            elif fmt==4 and cp<=65535:
                count=u16(cmap,offset+6)//2
                ends=offset+14
                starts=ends+count*2+2
                deltas=starts+count*2
                ranges=deltas+count*2
                for n in range(count):
                    if u16(cmap,starts+n*2)<=cp<=u16(cmap,ends+n*2):
                        delta=u16(cmap,deltas+n*2)
                        rel=u16(cmap,ranges+n*2)
                        if not rel:
                            return (cp+delta)%65536 != 0
                        address=ranges+n*2+rel+2*(cp-u16(cmap,starts+n*2))
                        glyph=u16(cmap,address)
                        return glyph!=0 and (glyph+delta)%65536!=0
        return False
    missing=sorted({char for char in sample if not has_glyph(ord(char))})
    axes=[]
    if 'fvar' in tables:
        fvar=tables['fvar']
        offset,count,size=u16(fvar,4),u16(fvar,8),u16(fvar,10)
        for i in range(count):
            pos=offset+i*size
            tag=fvar[pos:pos+4].decode('ascii')
            vals=[struct.unpack_from('>i',fvar,pos+4+4*j)[0]/65536 for j in range(3)]
            axes.append({'axis':tag,'min':vals[0],'default':vals[1],'max':vals[2]})
    return {'filename':filename,'family':names.get(1),'subfamily':names.get(2),'postscriptName':names.get(6),'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'variableAxes':axes,'gsub': 'GSUB' in tables,'gpos':'GPOS' in tables,'sample':sample,'missingGlyphs':missing}

latin='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$—– /:,.%+-()éèàçœ'
arabic='ملابس تمنح يومك مساحة بوبلين قطني تعليمات عناية تجريبية عينة تصميم وليست بطاقة إنتاج ١٠٠٪'
results=[inspect_ttf('Archivo.ttf',latin),inspect_ttf('DMSans.ttf',latin),inspect_ttf('IBMPlexSansArabic-Regular.ttf',arabic),inspect_ttf('IBMPlexSansArabic-SemiBold.ttf',arabic)]
for file in ROOT.glob('*.woff2'):
    data=file.read_bytes()
    assert data[:4]==b'wOF2' and u32(data,8)==len(data), (file.name,'invalid WOFF2 header')
    results.append({'filename':file.name,'format':'woff2','bytes':len(data),'headerLengthMatches':True,'sha256':hashlib.sha256(data).hexdigest()})
assert all(not r.get('missingGlyphs') for r in results), results
OUTPUT.write_text(json.dumps({'created':'2026-10-15','method':'Pure Python SFNT table-bound, names, cmap 4/12 and fvar inspection; WOFF2 container length; shaping visually checked in Chrome','checks':results},ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'fonts':len(results),'missingGlyphs':0,'masters':[{k:r[k] for k in ['filename','family','subfamily','variableAxes']} for r in results if 'family' in r]},ensure_ascii=False))
