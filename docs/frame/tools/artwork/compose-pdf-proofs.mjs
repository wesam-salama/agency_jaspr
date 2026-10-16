import {createRequire}from'node:module';import fs from'node:fs';import path from'node:path';
const require=createRequire(import.meta.url);const sharp=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp');
const base='/Users/wesamsalama/Desktop/Agency/website/agency_jaspr/docs/frame/verification/artwork/pdf-proofs';
const selected=new Set(process.argv.slice(2));let count=0;
for(const dir of fs.readdirSync(base)){if(!fs.statSync(path.join(base,dir)).isDirectory()||(selected.size&&!selected.has(dir)))continue;const files=fs.readdirSync(path.join(base,dir)).filter(f=>f.endsWith('.png')).sort();const cols=files.length===1?1:2,w=596,h=844,rows=Math.ceil(files.length/cols);const overlay=[];for(let i=0;i<files.length;i++)overlay.push({input:await sharp(path.join(base,dir,files[i])).resize(w,h,{fit:'contain',background:'#ffffff'}).png().toBuffer(),left:(i%cols)*w,top:Math.floor(i/cols)*h});await sharp({create:{width:cols*w,height:rows*h,channels:4,background:'#CBD4E2'}}).composite(overlay).png().toFile(path.join(base,dir+'-contact.png'));count++;}
console.log(count+' complete PDF contact proofs created');
