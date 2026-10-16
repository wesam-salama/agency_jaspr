import {spawn} from 'node:child_process';
import {openSync,writeFileSync,mkdirSync} from 'node:fs';
import {resolve,dirname} from 'node:path';
import {fileURLToPath} from 'node:url';
const here=dirname(fileURLToPath(import.meta.url)),origin='http://127.0.0.1:8804';
try{const response=await fetch(origin+'/health',{signal:AbortSignal.timeout(1000)});if(response.ok&&(await response.json()).project==='fold'){console.log('Fold preview already running: '+origin);process.exit(0);}}catch{}
const logPath=resolve(here,'../verification/logs/preview.log');
mkdirSync(dirname(logPath),{recursive:true});
const log=openSync(logPath,'a');
const child=spawn(process.execPath,[resolve(here,'preview-server.mjs')],{cwd:resolve(here,'../../..'),detached:true,stdio:['ignore',log,log]});child.unref();
for(let i=0;i<25;i++){
  await new Promise(resolve=>setTimeout(resolve,100));
  try{const response=await fetch(origin+'/health',{signal:AbortSignal.timeout(1000)});if(response.ok){writeFileSync(resolve(here,'../verification/logs/preview.json'),JSON.stringify({pid:child.pid,origin,ownership:'Fold task detached static preview',started:new Date().toISOString()},null,2)+'\n');console.log('Fold preview ready: '+origin);process.exit(0);}}catch{}
}
throw new Error('Preview failed; inspect docs/fold/verification/logs/preview.log');
