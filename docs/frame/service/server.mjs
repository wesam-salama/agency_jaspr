import http from 'node:http';
import {readFile,stat} from 'node:fs/promises';
import {createReadStream} from 'node:fs';
import {resolve,extname,dirname} from 'node:path';
import {fileURLToPath} from 'node:url';
import {DemoStore,validateLearner,validateDraft} from './state.mjs';
import {courses} from './catalogue.mjs';
import {openHandoff,localHandoffRequest} from './handoff.mjs';

const here=dirname(fileURLToPath(import.meta.url));
const root=resolve(here,'../../../web');
const store=new DemoStore(resolve(here,'data/demo-state.json'));
await store.load();
const types={'.ico':'image/vnd.microsoft.icon','.html':'text/html; charset=utf-8','.css':'text/css; charset=utf-8','.js':'text/javascript; charset=utf-8','.mjs':'text/javascript; charset=utf-8','.svg':'image/svg+xml','.webp':'image/webp','.png':'image/png','.woff2':'font/woff2','.mp4':'video/mp4','.vtt':'text/vtt; charset=utf-8','.txt':'text/plain; charset=utf-8','.json':'application/json'};
function respond(res,status,value) {res.writeHead(status,{'Content-Type':'application/json; charset=utf-8','Cache-Control':'no-store'});res.end(JSON.stringify(value));}
async function bodyOf(req) {
  let body='';for await(const part of req) {body+=part;if(body.length>16384) {const error=new Error('Request too large.');error.status=413;throw error;}}
  try {return JSON.parse(body);}catch {const error=new Error('Provide a JSON request.');error.status=400;throw error;}
}
const server=http.createServer(async(req,res)=>{
  res.setHeader('Access-Control-Allow-Origin','*');
  res.setHeader('Access-Control-Allow-Headers','Content-Type');
  res.setHeader('Access-Control-Allow-Methods','GET,POST,OPTIONS');
  res.setHeader('X-Content-Type-Options','nosniff');
  if(req.method==='OPTIONS') {res.writeHead(204);res.end();return;}
  try {
    const url=new URL(req.url,'http://127.0.0.1');
    if(url.pathname==='/api/catalogue'&&req.method==='GET') {respond(res,200,{courses});return;}
    if(url.pathname==='/api/session'&&req.method==='GET') {
      const learner=url.searchParams.get('learner')||'demo';
      if(!validateLearner(learner)) {respond(res,400,{error:'Invalid demo learner.'});return;}
      respond(res,200,store.session(learner));return;
    }
    if(url.pathname.startsWith('/api/')&&req.method==='POST') {
      const body=await bodyOf(req);const learner=body.learner||'demo';
      if(!validateLearner(learner)) {respond(res,400,{error:'Invalid demo learner.'});return;}
      if(url.pathname==='/api/handoff') {
        if(!localHandoffRequest(req.socket.remoteAddress,req.headers.origin)) {respond(res,403,{error:'App handoff is available only from the local demonstration.'});return;}
        const opened=await openHandoff(body);respond(res,200,opened);return;
      }
      if(url.pathname==='/api/test/fail-next') {store.failure.add(learner);respond(res,200,{armed:true,learner});return;}
      let operation;
      if(url.pathname==='/api/test/reset')operation='reset';
      if(url.pathname==='/api/enrol') {operation='enrol';if(body.courseId!=='FA-PH-01') {respond(res,400,{error:'Only Composition Essentials is available for demo enrolment.'});return;}}
      if(url.pathname==='/api/draft'||url.pathname==='/api/complete') {
        operation=url.pathname.slice(5);
        if(!validateDraft(body)) {respond(res,400,{error:'Provide lesson 01–06, a note up to 4000 characters and an attachment choice.'});return;}
        if(operation==='complete'&&!body.note.trim()&&!body.attachment) {respond(res,422,{error:'Add a practice note or the sample attachment before completing the exercise.'});return;}
      }
      if(!operation) {respond(res,404,{error:'Unknown demonstration operation.'});return;}
      const result=await store.mutate(learner,operation,body);respond(res,200,result);return;
    }
    if(url.pathname.startsWith('/api/')) {respond(res,404,{error:'Unknown demonstration endpoint.'});return;}
    if(req.method!=='GET'&&req.method!=='HEAD') {res.writeHead(405);res.end();return;}
    let pathname=decodeURIComponent(url.pathname);
    let servingRoot=root;
    if(pathname.startsWith('/agency_jaspr/')) {
      pathname=pathname.slice('/agency_jaspr'.length);
      try {const built=resolve(here,'../../../build/jaspr');await stat(resolve(built,'index.html'));servingRoot=built;}catch {servingRoot=root;}
    }
    if(pathname==='/'&&!url.pathname.startsWith('/agency_jaspr/'))pathname='/assets/selected-work/frame/site/index.html';
    if(pathname.endsWith('/'))pathname+='index.html';
    const path=resolve(servingRoot,'.'+pathname);
    if(!path.startsWith(servingRoot+'/')) {res.writeHead(403);res.end();return;}
    const info=await stat(path);
    if(!info.isFile()) {res.writeHead(404);res.end();return;}
    const headers={'Content-Type':types[extname(path)]||'application/octet-stream','Accept-Ranges':'bytes','Cache-Control':'no-cache'};
    const range=req.headers.range;
    if(range&&extname(path)==='.mp4') {
      const match=/^bytes=(\d+)-(\d*)$/.exec(range);
      if(!match) {res.writeHead(416,{'Content-Range':`bytes */${info.size}`});res.end();return;}
      const start=Number(match[1]);const end=match[2]?Math.min(Number(match[2]),info.size-1):info.size-1;
      if(start>end||start>=info.size) {res.writeHead(416,{'Content-Range':`bytes */${info.size}`});res.end();return;}
      res.writeHead(206,{...headers,'Content-Range':`bytes ${start}-${end}/${info.size}`,'Content-Length':end-start+1});
      if(req.method==='HEAD')res.end();else createReadStream(path,{start,end}).pipe(res);return;
    }
    res.writeHead(200,{...headers,'Content-Length':info.size});if(req.method==='HEAD')res.end();else createReadStream(path).pipe(res);
  }catch(error) {if(error.code==='ENOENT') {res.writeHead(404);res.end('Not found');return;}respond(res,error.status||500,{error:error.status?error.message:'The demonstration could not save. Keep your exercise and retry.'});}
});
server.listen(Number(process.env.FRAME_PORT)||8803,'127.0.0.1',()=>process.stdout.write(`Frame demo ready http://127.0.0.1:${server.address().port}/assets/selected-work/frame/site/\n`));
