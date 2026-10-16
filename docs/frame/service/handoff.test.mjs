import test from 'node:test';
import assert from 'node:assert/strict';
import {validateHandoff,localHandoffRequest,openHandoff,defaultSimulator} from './handoff.mjs';
test('handoff limits learner, exact course and language',()=>{
 assert.equal(validateHandoff({learner:'demo-ar',courseId:'FA-PH-01',lang:'ar'}),true);
 for(const body of [{learner:'demo;open',courseId:'FA-PH-01',lang:'en'},{learner:'demo',courseId:'FA-FI-02',lang:'en'},{learner:'demo',courseId:'FA-PH-01',lang:'fr'},{}])assert.equal(validateHandoff(body),false);
 assert.equal(localHandoffRequest('127.0.0.1','http://127.0.0.1:8803'),true);
 assert.equal(localHandoffRequest('127.0.0.1','https://external.example'),false);
 assert.equal(localHandoffRequest('192.168.1.2',undefined),false);
});
test('handoff invokes a fixed executable and separate validated arguments before success',async()=>{
 let invocation;let finished=false;
 const result=await openHandoff({learner:'demo-ar',courseId:'FA-PH-01',lang:'ar'},{executor:async(file,args,options)=>{invocation={file,args,options};await Promise.resolve();finished=true;}});
 assert.equal(finished,true);assert.equal(result.requestSent,true);
 assert.equal(invocation.file,'xcrun');assert.deepEqual(invocation.args,['simctl','openurl',defaultSimulator,'frameacademy://course/FA-PH-01?learner=demo-ar&lang=ar']);
 assert.equal(invocation.options.timeout,10000);
});
test('failed or invalid simulator never reports success',async()=>{
 const body={learner:'demo',courseId:'FA-PH-01',lang:'en'};
 await assert.rejects(openHandoff(body,{executor:async()=>{throw new Error('device unavailable');}}),error=>error.status===503);
 await assert.rejects(openHandoff(body,{simulatorId:'--help'}),error=>error.status===503);
});
