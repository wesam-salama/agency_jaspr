const fs=require('node:fs'),path=require('node:path');
const sharp=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp');
const directory=path.resolve(__dirname,'../../../web/assets/selected-work/fold');
(async()=>{
 const records=[];
 for(const register of ['primary-register.json','variant-register.json']){
  const registry=path.join(__dirname,'../generated',register);if(!fs.existsSync(registry))continue;
  for(const entry of JSON.parse(fs.readFileSync(registry))){
   const source=path.join(directory,'source',entry.id+'-triptych.png');fs.copyFileSync(entry.original,source);
   fs.writeFileSync(source+'.json',JSON.stringify({prompt:entry.prompt,origin:entry.original,kind:entry.kind},null,2)+'\n');
   const m=await sharp(source).metadata(),panel=Math.floor(m.width/3),height=m.height;
   for(const [index,view]of ['front','back','detail'].entries()){
    const outfile=path.join(directory,'products',entry.id+'-'+view+'.webp');
    let img=sharp(source).extract({left:index*panel+5,top:0,width:panel-10,height});
    if(view!=='detail')img=img.resize(Math.round(height*.75),height,{fit:'contain',background:'#E8E7E1'});
    const buffer=await img.webp({quality:90}).toBuffer();fs.writeFileSync(outfile,buffer);
    const info=await sharp(buffer).metadata();
    fs.writeFileSync(outfile+'.json',JSON.stringify({prompt:entry.prompt,origin:path.relative(directory,source),operation:'Equal-panel crop; front/back canvas padded to 3:4 without altering garment geometry; native-height export. Generated artwork, not software evidence.'},null,2)+'\n');
    records.push({id:entry.id+'-'+view,path:path.relative(directory,outfile),source:path.relative(directory,source),width:info.width,height:info.height,caption:'Generated Fold garment concept — '+entry.id+' '+view,alt:entry.id.replaceAll('-',' ')+' '+view+' garment view',focal:'Full silhouette; contain for front/back. Detail may crop.',status:'designed',creator:'Built-in image_gen with locked garment canon; deterministic crop/export',rights:'Self-initiated generated concept imagery; no manufactured goods or third-party photographer claim',prompt:entry.prompt});
   }
  }
 }
 fs.writeFileSync(path.join(__dirname,'../production/product-exports.json'),JSON.stringify(records,null,2)+'\n');console.log(records.length+' garment views exported');
})();
