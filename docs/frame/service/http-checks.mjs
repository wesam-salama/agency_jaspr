import assert from 'node:assert/strict';
import {writeFile} from 'node:fs/promises';
const origin='http://127.0.0.1:8803';const checks=[];
async function post(body,headers={}) {return fetch(origin+'/api/handoff',{method:'POST',headers:{'Content-Type':'application/json',...headers},body:JSON.stringify(body)});}
let response=await post({learner:'demo',courseId:'FA-FI-02',lang:'en'});assert.equal(response.status,400);checks.push('An unimplemented course cannot launch the simulator.');
response=await post({learner:'demo;open',courseId:'FA-PH-01',lang:'en'});assert.equal(response.status,400);checks.push('Malformed learner input is rejected before invocation.');
response=await post({learner:'demo',courseId:'FA-PH-01',lang:'fr'});assert.equal(response.status,400);checks.push('Only the two learning-journey languages are accepted.');
response=await post({learner:'demo',courseId:'FA-PH-01',lang:'en'},{Origin:'https://external.example'});assert.equal(response.status,403);checks.push('An external browser origin cannot invoke the local simulator bridge.');
response=await fetch(origin+'/docs/frame/service/data/demo-state.json');assert.equal(response.status,404);checks.push('Saved exercise records are not served as static files.');
response=await fetch(origin+'/api/catalogue');assert.equal(response.status,200);assert.equal((await response.json()).courses[0].title,'Composition Essentials');checks.push('The local catalogue serves the exact implemented course.');
await writeFile('docs/frame/verification/service-http-checks.json',JSON.stringify({date:'2026-10-14',origin,checks:checks.map(check=>({check,result:'passed'})),scope:'Real HTTP validation. Acknowledged xcrun requests are captured in verification/website/capture-record.json, request-only-en/ar.json and handoff-request-en/ar.png. Native acceptance is verified separately by the installed app helper.'},null,2)+'\n');
process.stdout.write(`${checks.length} real HTTP checks passed.\n`);
