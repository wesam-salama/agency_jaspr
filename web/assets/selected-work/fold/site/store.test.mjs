import test from 'node:test';
import assert from 'node:assert/strict';
import {PRODUCTS,SIZES,COLORS,CART_VERSION,CART_KEY,sku,stock,imagePath,addLine,updateLine,validateCart,totals,serializeCart,restoreCart,filterProducts,demoReference,normalizeFilters,cartFocusTarget} from './data.mjs';
const canonical=[{id:'FL01',color:'chalk',size:'M',quantity:1},{id:'FL02',color:'ink',size:'M',quantity:1}];
test('the locked four-piece, eight-colour catalogue uses exact integer USD cents',()=>{
 assert.deepEqual(PRODUCTS.map(p=>[p.id,p.en,p.price,p.colors]),[['FL01','Box Shirt',9500,['chalk','ink']],['FL02','Pleat Trouser',14500,['ink','olive']],['FL03','Layer Vest',11000,['stone','olive']],['FL04','Field Overshirt',16500,['olive','stone']]]);
 assert.ok(PRODUCTS.every(p=>Number.isInteger(p.price)&&p.ar&&p.composition.ar&&p.fit.ar&&p.construction.ar));
 assert.deepEqual(SIZES,['XS','S','M','L','XL']);
 assert.deepEqual(Object.values(COLORS).map(c=>[c.code,c.hex]),[['CHK','#F6F3EC'],['INK','#161A18'],['OLV','#3C4A3E'],['STN','#D8DDD3']]);
});
test('all eight stock rows retain the approved canon including unavailable Stone XS',()=>{
 assert.deepEqual(PRODUCTS.flatMap(p=>Object.values(p.stock)),[[2,4,6,4,2],[2,3,5,3,2],[2,4,6,4,2],[1,3,4,3,1],[0,2,3,2,1],[1,2,1,2,1],[1,3,4,3,1],[1,2,3,2,1]]);
 assert.equal(stock('FL03','stone','XS'),0);assert.equal(stock('FL03','olive','M'),1);
});
test('canonical basket has $240 subtotal + $12 shipping + $0 tax = $252',()=>{
 assert.deepEqual(totals(canonical),{subtotal:24000,shipping:1200,tax:0,total:25200});
 assert.deepEqual(totals([]),{subtotal:0,shipping:0,tax:0,total:0});
});
test('explicit valid size and valid colour are required before adding',()=>{
 for(const size of ['',undefined,'XXL'])assert.throws(()=>addLine([],{id:'FL01',color:'chalk',size,quantity:1}));
 assert.throws(()=>sku('FL01','olive','M'));assert.equal(sku('FL01','chalk','M'),'FL01-CHK-M');
});
test('SKU and all three image paths share product and colour identity',()=>{
 for(const p of PRODUCTS)for(const color of p.colors)for(const view of ['front','back','detail']){
  assert.equal(imagePath(p.id,color,view),`../products/${p.id.toLowerCase()}-${color}-${view}.webp`);
  assert.equal(sku(p.id,color,'M'),`${p.id}-${COLORS[color].code}-M`);
 }
});
test('adding duplicate variants merges quantities and enforces aggregate stock',()=>{
 const one=addLine([],{id:'FL03',color:'olive',size:'M',quantity:1});
 assert.throws(()=>addLine(one,{...one[0],quantity:1}));assert.equal(one[0].quantity,1);
 const two=addLine([canonical[0]],canonical[0]);assert.equal(two.length,1);assert.equal(two[0].quantity,2);assert.equal(canonical[0].quantity,1);
});
test('zero, fractional, non-finite, negative, excessive and unavailable quantities cannot enter cart',()=>{
 for(const quantity of [0,-1,1.5,Infinity,NaN,7,'1'])assert.throws(()=>addLine([],{...canonical[0],quantity}));
 assert.throws(()=>addLine([],{id:'FL03',color:'stone',size:'XS',quantity:1}));
});
test('size edits recheck stock, merge matching lines and leave input untouched on rejection',()=>{
 const cart=[{id:'FL01',color:'chalk',size:'M',quantity:3},{id:'FL01',color:'chalk',size:'S',quantity:2}];
 assert.throws(()=>updateLine(cart,0,{size:'S'}));assert.equal(cart[0].size,'M');
 assert.throws(()=>updateLine(cart,0,{size:'XS'}));
 assert.deepEqual(updateLine(cart,1,{size:'M'}),[{id:'FL01',color:'chalk',size:'M',quantity:5}]);
 assert.throws(()=>updateLine([{id:'FL03',color:'stone',size:'S',quantity:1}],0,{size:'XS'}));
});
test('a removed line can be restored using the same validated add transaction',()=>{
 const removed=canonical[0],remaining=[canonical[1]];
 assert.deepEqual(addLine(remaining,removed),[canonical[1],canonical[0]]);
 assert.equal(remaining.length,1);
});
test('versioned browser cart round-trips valid contents and drops untrusted prices',()=>{
 const raw=serializeCart([{...canonical[0],price:1,extra:'ignored'},canonical[1]]);
 assert.equal(CART_VERSION,1);assert.equal(CART_KEY,'fold.demo.cart.v1');assert.deepEqual(restoreCart(raw),canonical);
 assert.equal(totals(restoreCart(raw)).total,25200);assert.ok(!raw.includes('price'));assert.deepEqual(restoreCart(null),[]);
});
test('restore rejects unknown versions, corrupt data, duplicate SKUs and stale stock',()=>{
 for(const raw of ['{bad',JSON.stringify({version:2,lines:canonical}),JSON.stringify({version:1,lines:[canonical[0],canonical[0]]}),JSON.stringify({version:1,lines:[{...canonical[0],quantity:999}]}),JSON.stringify({version:1,lines:[{id:'UNKNOWN',color:'chalk',size:'M',quantity:1}]})])assert.throws(()=>restoreCart(raw));
});
test('URL category and colour filters reproduce canonical first selection',()=>{
 assert.deepEqual(filterProducts(new URLSearchParams('category=shirts&color=chalk')).map(p=>p.id),['FL01']);
 assert.deepEqual(filterProducts(new URLSearchParams('category=shirts&color=olive')),[]);
 assert.deepEqual(filterProducts(new URLSearchParams()).map(p=>p.id),['FL01','FL02','FL03','FL04']);
});
test('URL size filters consider availability in the selected colour',()=>{
 assert.deepEqual(filterProducts(new URLSearchParams('category=layers&color=stone&size=XS')),[]);
 assert.deepEqual(filterProducts(new URLSearchParams('category=layers&color=olive&size=XS')).map(p=>p.id),['FL03']);
 assert.deepEqual(filterProducts(new URLSearchParams('price=10000')).map(p=>p.id),['FL01']);
 assert.deepEqual(filterProducts(new URLSearchParams('price=15000')).map(p=>p.id),['FL01','FL02','FL03']);
});
test('all eight laid-flat measurement rows preserve exact cm and once-rounded inch pairs',()=>{
 assert.deepEqual(PRODUCTS.flatMap(p=>p.measurements.map(m=>m.cm)),[[52,55,58,61,64],[66,68,70,72,74],[34,37,40,43,46],[72,74,76,78,80],[49,52,55,58,61],[58,60,62,64,66],[55,58,61,64,67],[69,71,73,75,77]]);
 assert.deepEqual(PRODUCTS.flatMap(p=>p.measurements.map(m=>m.inch)),[['20.5','21.7','22.8','24.0','25.2'],['26.0','26.8','27.6','28.3','29.1'],['13.4','14.6','15.7','16.9','18.1'],['28.3','29.1','29.9','30.7','31.5'],['19.3','20.5','21.7','22.8','24.0'],['22.8','23.6','24.4','25.2','26.0'],['21.7','22.8','24.0','25.2','26.4'],['27.2','28.0','28.7','29.5','30.3']]);
});
test('demo reference is stable without date, language, shipping details or line ordering',()=>{
 const reference=demoReference(canonical);assert.match(reference,/^FOLD-DEMO-[0-9A-F]{8}$/);assert.equal(demoReference([...canonical].reverse()),reference);assert.equal(demoReference(canonical),reference);assert.notEqual(demoReference([{...canonical[0],quantity:2},canonical[1]]),reference);
});
test('validation does not mutate the previous cart while computing a pending update',()=>{
 const before=JSON.stringify(canonical),next=updateLine(canonical,0,{quantity:2});assert.equal(JSON.stringify(canonical),before);assert.equal(next[0].quantity,2);assert.equal(totals(canonical).total,25200);
});

test('unknown and markup-bearing filter values are discarded before interface rendering',()=>{
 const normalized=normalizeFilters('category=%3Cimg%20onerror%3Dalert(1)%3E&color=%3Csvg%20onload%3Dalert(1)%3E&size=XXL&price=abc&lang=ar');
 assert.equal(normalized.toString(),'lang=ar');
 assert.equal(normalizeFilters('category=shirts&color=chalk&size=M&price=10000').toString(),'category=shirts&color=chalk&size=M&price=10000');
});

test('cart edits keep line positions stable so keyboard focus can follow the same garment',()=>{
 const changed=updateLine(canonical,0,{size:'L'});
 assert.deepEqual(changed.map(l=>l.id),['FL01','FL02']);
 assert.equal(changed[0].size,'L');
 assert.equal(updateLine(canonical,0,{quantity:2})[0].id,'FL01');
 const merged=updateLine([{id:'FL01',color:'chalk',size:'M',quantity:1},{id:'FL02',color:'ink',size:'M',quantity:1},{id:'FL01',color:'chalk',size:'S',quantity:1}],2,{size:'M'});
 assert.deepEqual(merged.map(l=>[l.id,l.quantity]),[['FL01',2],['FL02',1]]);
});

test('focus targets follow edited/merged/restored variants and choose a surviving line after removal',()=>{
 assert.deepEqual(cartFocusTarget(canonical,canonical[0],'quantity'),{control:'quantity',line:0});
 assert.deepEqual(cartFocusTarget([canonical[1]],canonical[0],'remove',0),{control:'remove',line:0});
 assert.deepEqual(cartFocusTarget([canonical[1]],canonical[0],'remove',1),{control:'remove',line:0});
 assert.deepEqual(cartFocusTarget([],canonical[0],'remove',0),{control:'collection'});
 assert.deepEqual(cartFocusTarget(addLine([canonical[1]],canonical[0]),canonical[0],'size'),{control:'size',line:1});
 const resized=updateLine(canonical,0,{size:'L'});
 assert.deepEqual(cartFocusTarget(resized,{...canonical[0],size:'L'},'size'),{control:'size',line:0});
});
