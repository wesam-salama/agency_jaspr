import {stat,writeFile} from 'node:fs/promises';
import {spawn} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {dirname,resolve} from 'node:path';
import assert from 'node:assert/strict';

const lang=process.argv[2];assert.ok(lang==='en'||lang==='ar','Specify en or ar.');
const ready='/private/tmp/frame-handoff-ready';
const waiting='/private/tmp/frame-web-request-waiting.json';
const completed='/private/tmp/frame-web-request-completed.json';
const started=Date.now();const deadline=started+10*60*1000;
const here=dirname(fileURLToPath(import.meta.url));
const projectRoot=resolve(here,'../../..');
await writeFile(waiting,JSON.stringify({lang,startedUTC:new Date(started).toISOString(),ready,method:'Wait for a newly created native helper readiness flag; then perform the existing learner website Open action without reset.'},null,2)+'\n');
process.stdout.write(`${lang} actual website request watcher armed; waiting for fresh native readiness.\n`);
let readyStat;
while(Date.now()<deadline) {
 try {const candidate=await stat(ready);if(candidate.mtimeMs>=started) {readyStat=candidate;break;}}catch(error) {if(error.code!=='ENOENT')throw error;}
 await new Promise(resolve=>setTimeout(resolve,100));
}
assert.ok(readyStat,'Native readiness flag was not freshly created within ten minutes; no website request sent.');
process.stdout.write(`${lang} native readiness confirmed; running actual website Open action.\n`);
const child=spawn(process.execPath,[resolve(here,'capture-request.mjs')],{cwd:projectRoot,env:{...process.env,FRAME_CAPTURE_LANG:lang,FRAME_NATIVE_READY_UTC:new Date(readyStat.mtimeMs).toISOString()},stdio:'inherit'});
const exitCode=await new Promise((resolve,reject)=>{child.once('error',reject);child.once('exit',code=>resolve(code));});
await writeFile(completed,JSON.stringify({lang,startedUTC:new Date(started).toISOString(),nativeReadyUTC:new Date(readyStat.mtimeMs).toISOString(),completedUTC:new Date().toISOString(),exitCode,proof:`docs/frame/verification/website/request-only-${lang}.json`},null,2)+'\n');
assert.equal(exitCode,0,'Actual website request capture failed.');
