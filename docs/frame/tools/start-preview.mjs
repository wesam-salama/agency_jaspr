// Keep the requested loopback preview alive independently of a tool session.
import{spawn}from'node:child_process';
import{openSync,writeFileSync}from'node:fs';
import{dirname,resolve}from'node:path';
import{fileURLToPath}from'node:url';
const here=dirname(fileURLToPath(import.meta.url));
const origin='http://127.0.0.1:8803';
try{const r=await fetch(origin+'/api/catalogue',{signal:AbortSignal.timeout(1500)});if(r.ok){console.log('Frame preview already running at '+origin);process.exit(0);}}catch{}
const log=openSync(resolve(here,'../verification/logs/preview-service.log'),'a');
const child=spawn(process.execPath,[resolve(here,'../service/server.mjs')],{cwd:resolve(here,'../../..'),detached:true,stdio:['ignore',log,log]});child.unref();
for(let i=0;i<20;i++){await new Promise(r=>setTimeout(r,100));try{const r=await fetch(origin+'/api/catalogue',{signal:AbortSignal.timeout(1000)});if(r.ok){writeFileSync(resolve(here,'../verification/logs/preview-service.json'),JSON.stringify({pid:child.pid,origin,startedUTC:new Date().toISOString(),ownership:'Main task detached local preview',server:'docs/frame/service/server.mjs'},null,2)+'\n');console.log('Frame preview ready at '+origin+'; PID '+child.pid);process.exit(0);}}catch{}}
throw new Error('Read docs/frame/verification/logs/preview-service.log; preview did not start.');
