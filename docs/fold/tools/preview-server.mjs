import http from 'node:http';
import {createReadStream, existsSync} from 'node:fs';
import {stat} from 'node:fs/promises';
import {resolve, extname} from 'node:path';
import {fileURLToPath} from 'node:url';

const root=resolve(fileURLToPath(new URL('../../..',import.meta.url)));
const types={'.html':'text/html; charset=utf-8','.css':'text/css; charset=utf-8','.js':'text/javascript; charset=utf-8','.mjs':'text/javascript; charset=utf-8','.svg':'image/svg+xml','.webp':'image/webp','.png':'image/png','.jpg':'image/jpeg','.woff2':'font/woff2','.mp4':'video/mp4','.webm':'video/webm','.json':'application/json','.zip':'application/zip','.ico':'image/vnd.microsoft.icon','.txt':'text/plain; charset=utf-8'};
const server=http.createServer(async(req,res)=>{
  try {
    const url=new URL(req.url,'http://127.0.0.1');
    let pathname=decodeURIComponent(url.pathname);
    if(pathname==='/health'){res.writeHead(200,{'Content-Type':'application/json'});res.end(JSON.stringify({project:'fold',mode:'local-static-preview',root}));return;}
    let directory=resolve(root,'web');
    if(pathname.startsWith('/agency_jaspr/')){directory=resolve(root,'build/jaspr');pathname=pathname.slice('/agency_jaspr'.length);}
    if(pathname==='/'&&directory===resolve(root,'web'))pathname='/assets/selected-work/fold/site/index.html';
    if(pathname.endsWith('/'))pathname+='index.html';
    const path=resolve(directory,'.'+pathname);
    if(!path.startsWith(directory+'/')){res.writeHead(403);res.end();return;}
    const info=await stat(path);
    if(!info.isFile()){res.writeHead(404);res.end();return;}
    const headers={'Content-Type':types[extname(path)]||'application/octet-stream','Cache-Control':'no-store','Content-Length':info.size,'X-Content-Type-Options':'nosniff'};
    const range=req.headers.range;
    if(range&&/\.(mp4|webm)$/.test(path)){
      const match=/^bytes=(\d+)-(\d*)$/.exec(range);
      if(!match){res.writeHead(416);res.end();return;}
      const start=Number(match[1]),end=match[2]?Math.min(Number(match[2]),info.size-1):info.size-1;
      if(start>end||start>=info.size){res.writeHead(416);res.end();return;}
      res.writeHead(206,{...headers,'Content-Length':end-start+1,'Accept-Ranges':'bytes','Content-Range':`bytes ${start}-${end}/${info.size}`});
      createReadStream(path,{start,end}).pipe(res);return;
    }
    res.writeHead(200,headers);if(req.method==='HEAD')res.end();else createReadStream(path).pipe(res);
  }catch(error){res.writeHead(error.code==='ENOENT'?404:500);res.end('Local preview file unavailable');}
});
server.listen(Number(process.env.FOLD_PORT)||8804,'127.0.0.1',()=>console.log('Fold preview: http://127.0.0.1:'+server.address().port));
