export const SIZES = ['XS','S','M','L','XL'];
export const CART_VERSION = 1;
export const CART_KEY = 'fold.demo.cart.v1';
export const COLORS = {
  chalk: { en:'Chalk', ar:'طباشيري', code:'CHK', hex:'#F6F3EC' },
  ink: { en:'Ink', ar:'حبري', code:'INK', hex:'#161A18' },
  olive: { en:'Olive', ar:'زيتوني', code:'OLV', hex:'#3C4A3E' },
  stone: { en:'Stone', ar:'حجري', code:'STN', hex:'#D8DDD3' },
};
export const PRODUCTS = [
  { id:'FL01', slug:'box-shirt', en:'Box Shirt', ar:'قميص بقصّة صندوقية', category:'shirts', price:9500, colors:['chalk','ink'], composition:{en:'100% cotton poplin',ar:'بوبلين من القطن 100%'}, description:{en:'A clean collar. Room through the body. A straight hem that sits easily over the next layer.',ar:'ياقة واضحة، وقصّة رحبة، وحافة مستقيمة تنسدل بسهولة فوق الطبقة التالية.'}, construction:{en:'Five-button opening, one chest pocket and a clean back yoke.',ar:'فتحة بخمسة أزرار، وجيب واحد على الصدر، وقصّة كتف خلفية واضحة.'}, fit:{en:'A relaxed, box-shaped silhouette with a straight hem. Compare its half-chest width with a shirt you already wear.',ar:'قصّة صندوقية رحبة بحافة مستقيمة. قارن نصف عرض الصدر بقميص يناسبك.'}, care:{en:'Illustrative care: gentle cool wash, reshape while damp and air dry.',ar:'عناية توضيحية: غسيل لطيف بماء بارد، وإعادة التشكيل وهو رطب، وتجفيف في الهواء.'}, stock:{chalk:[2,4,6,4,2],ink:[2,3,5,3,2]}, measurements:[{en:'Chest · half-width',ar:'الصدر · نصف العرض',cm:[52,55,58,61,64],inch:['20.5','21.7','22.8','24.0','25.2']},{en:'Length',ar:'الطول',cm:[66,68,70,72,74],inch:['26.0','26.8','27.6','28.3','29.1']}] },
  { id:'FL02', slug:'pleat-trouser', en:'Pleat Trouser', ar:'بنطال بثنية', category:'trousers', price:14500, colors:['ink','olive'], composition:{en:'65% cotton, 35% linen twill',ar:'نسيج تويل من القطن 65% والكتان 35%'}, description:{en:'A straight leg. Room through the thigh. A single forward pleat gives the silhouette its quiet structure.',ar:'ساق مستقيمة ومساحة مريحة عند الفخذ. ثنية أمامية واحدة تمنح القصّة بنيتها الهادئة.'}, construction:{en:'One forward pleat per leg, side pockets and a straight hem.',ar:'ثنية أمامية واحدة لكل ساق، وجيوب جانبية، وحافة مستقيمة.'}, fit:{en:'A straight silhouette with room through the thigh. Compare the laid-flat waistband with trousers you already wear.',ar:'قصّة مستقيمة ورحبة عند الفخذ. قارن عرض الخصر وهو مفرود ببنطال يناسبك.'}, care:{en:'Illustrative care: gentle cool wash, reshape while damp and air dry.',ar:'عناية توضيحية: غسيل لطيف بماء بارد، وإعادة التشكيل وهو رطب، وتجفيف في الهواء.'}, stock:{ink:[2,4,6,4,2],olive:[1,3,4,3,1]}, measurements:[{en:'Waist · half-width',ar:'الخصر · نصف العرض',cm:[34,37,40,43,46],inch:['13.4','14.6','15.7','16.9','18.1']},{en:'Inseam',ar:'طول الساق الداخلي',cm:[72,74,76,78,80],inch:['28.3','29.1','29.9','30.7','31.5']}] },
  { id:'FL03', slug:'layer-vest', en:'Layer Vest', ar:'صديري للطبقات', category:'layers', price:11000, colors:['stone','olive'], composition:{en:'100% cotton canvas',ar:'كانفاس من القطن 100%'}, description:{en:'An open neckline and a compact shape. A practical layer with two generous patch pockets.',ar:'فتحة رقبة واضحة وقصّة متوازنة. طبقة عملية بجيبين خارجيين واسعين.'}, construction:{en:'V-neck, four-button opening and two patch pockets. A plain back keeps the shape clear.',ar:'رقبة بشكل V، وفتحة بأربعة أزرار، وجيبان خارجيان. ظهر بسيط يبرز القصّة.'}, fit:{en:'A compact layering silhouette. Compare its half-chest width over the layer you plan to wear beneath.',ar:'قصّة متوازنة للارتداء فوق طبقة أخرى. قارن نصف عرض الصدر مع مراعاة القطعة التي سترتديها تحته.'}, care:{en:'Illustrative care: gentle cool wash, reshape while damp and air dry.',ar:'عناية توضيحية: غسيل لطيف بماء بارد، وإعادة التشكيل وهو رطب، وتجفيف في الهواء.'}, stock:{stone:[0,2,3,2,1],olive:[1,2,1,2,1]}, measurements:[{en:'Chest · half-width',ar:'الصدر · نصف العرض',cm:[49,52,55,58,61],inch:['19.3','20.5','21.7','22.8','24.0']},{en:'Length',ar:'الطول',cm:[58,60,62,64,66],inch:['22.8','23.6','24.4','25.2','26.0']}] },
  { id:'FL04', slug:'field-overshirt', en:'Field Overshirt', ar:'قميص خارجي عملي', category:'overshirts', price:16500, colors:['olive','stone'], composition:{en:'100% cotton twill',ar:'تويل من القطن 100%'}, description:{en:'A generous collar and a defined shoulder. A useful outer layer with two chest pockets.',ar:'ياقة واسعة وكتف محدد. طبقة خارجية عملية بجيبين على الصدر.'}, construction:{en:'Six-button opening, two chest pockets, a back yoke and a straight hem.',ar:'فتحة بستة أزرار، وجيبان على الصدر، وقصّة كتف خلفية، وحافة مستقيمة.'}, fit:{en:'A roomy outer layer with a straight hem. Compare its half-chest width with a layer that fits over your clothes.',ar:'طبقة خارجية رحبة بحافة مستقيمة. قارن نصف عرض الصدر بقطعة تناسبك فوق ملابسك.'}, care:{en:'Illustrative care: gentle cool wash, reshape while damp and air dry.',ar:'عناية توضيحية: غسيل لطيف بماء بارد، وإعادة التشكيل وهو رطب، وتجفيف في الهواء.'}, stock:{olive:[1,3,4,3,1],stone:[1,2,3,2,1]}, measurements:[{en:'Chest · half-width',ar:'الصدر · نصف العرض',cm:[55,58,61,64,67],inch:['21.7','22.8','24.0','25.2','26.4']},{en:'Length',ar:'الطول',cm:[69,71,73,75,77],inch:['27.2','28.0','28.7','29.5','30.3']}] },
];
export const getProduct = id => PRODUCTS.find(p=>p.id===id);
export function sku(id,color,size) { const p=getProduct(id); if(!p || !p.colors.includes(color) || !SIZES.includes(size)) throw new Error('variant'); return `${id}-${COLORS[color].code}-${size}`; }
export const stock = (id,color,size) => getProduct(id)?.stock[color]?.[SIZES.indexOf(size)] ?? 0;
export const imagePath = (id,color,view='front') => `../products/${id.toLowerCase()}-${color}-${view}.webp`;
export function validateCart(cart) {
  if(!Array.isArray(cart)) throw new Error('cart');
  const seen=new Set();
  return cart.map(line=>{ const key=sku(line.id,line.color,line.size); if(seen.has(key)||!Number.isInteger(line.quantity)||line.quantity<1||line.quantity>stock(line.id,line.color,line.size)) throw new Error('stock'); seen.add(key); return {id:line.id,color:line.color,size:line.size,quantity:line.quantity}; });
}
export function addLine(cart,line) {
  const key=sku(line.id,line.color,line.size), next=cart.map(l=>({...l})), existing=next.find(l=>sku(l.id,l.color,l.size)===key);
  if(existing) existing.quantity+=line.quantity; else next.push({...line}); return validateCart(next);
}
export function updateLine(cart,index,changes) {
  if(!cart[index]) throw new Error('line');
  const target={...cart[index],...changes}, key=sku(target.id,target.color,target.size), merge=cart.findIndex((line,i)=>i!==index&&sku(line.id,line.color,line.size)===key);
  const next=cart.map((line,i)=>i===index?target:{...line});
  if(merge!==-1){next[merge].quantity+=target.quantity;next.splice(index,1);}
  return validateCart(next);
}
export function totals(cart) {
  validateCart(cart); const subtotal=cart.reduce((sum,line)=>sum+getProduct(line.id).price*line.quantity,0); const shipping=cart.length?1200:0; return {subtotal,shipping,tax:0,total:subtotal+shipping};
}
export function serializeCart(cart) { return JSON.stringify({version:CART_VERSION,lines:validateCart(cart)}); }
export function restoreCart(raw) {
  if(!raw) return [];
  const parsed=JSON.parse(raw); if(parsed.version!==CART_VERSION) throw new Error('version'); return validateCart(parsed.lines);
}
export function filterProducts(params) {
  const category=params.get('category'), color=params.get('color'), size=params.get('size'), price=params.get('price');
  return PRODUCTS.filter(p=>(!category||p.category===category)&&(!color||p.colors.includes(color))&&(!price||p.price<=Number(price))&&(!size||p.colors.some(c=>(!color||c===color)&&stock(p.id,c,size)>0)));
}
export function demoReference(cart) { validateCart(cart); const value=cart.map(l=>`${sku(l.id,l.color,l.size)}:${l.quantity}`).sort().join('|'); let hash=2166136261; for(const ch of value){hash^=ch.charCodeAt(0);hash=Math.imul(hash,16777619);} return `FOLD-DEMO-${(hash>>>0).toString(16).toUpperCase().padStart(8,'0')}`; }

export function normalizeFilters(input) {
  const next=new URLSearchParams(input);
  const allowed={category:['shirts','trousers','layers','overshirts'],color:Object.keys(COLORS),size:SIZES,price:['10000','15000']};
  for(const [key,values] of Object.entries(allowed))if(next.has(key)&&!values.includes(next.get(key)))next.delete(key);
  return next;
}

export function cartFocusTarget(cart,variant,control='size',fallbackIndex) {
  let line=cart.findIndex(item=>item.id===variant.id&&item.color===variant.color&&item.size===variant.size);
  if(line<0&&Number.isInteger(fallbackIndex)&&cart.length)line=Math.min(Math.max(fallbackIndex,0),cart.length-1);
  return line<0?{control:'collection'}:{control,line};
}
