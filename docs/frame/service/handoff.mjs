import {execFile} from 'node:child_process';
import {promisify} from 'node:util';
import {validateLearner} from './state.mjs';

const execute=promisify(execFile);
export const defaultSimulator='8BDFE212-1DE0-4F67-928E-65C3E9B24533';
export function validateHandoff(body) {
  return body?.courseId==='FA-PH-01'&&validateLearner(body.learner)&&(body.lang==='en'||body.lang==='ar');
}
export function localHandoffRequest(address,origin) {
  return (address==='127.0.0.1'||address==='::1'||address==='::ffff:127.0.0.1')&&(!origin||/^https?:\/\/(?:localhost|127\.0\.0\.1)(?::\d+)?$/.test(origin));
}
export async function openHandoff(body,{executor=execute,simulatorId=process.env.FRAME_SIMULATOR_ID||defaultSimulator}={}) {
  if(!validateHandoff(body)) {const error=new Error('Choose the demo learner, Composition Essentials and English or Arabic.');error.status=400;throw error;}
  if(!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(simulatorId)) {const error=new Error('The local simulator is unavailable. Open the app using your learner code.');error.status=503;throw error;}
  const deepLink=`frameacademy://course/FA-PH-01?learner=${encodeURIComponent(body.learner)}&lang=${body.lang}`;
  try {await executor('xcrun',['simctl','openurl',simulatorId,deepLink],{timeout:10000,maxBuffer:65536});}
  catch {const error=new Error('The local simulator could not open Frame. Keep your learner code and try again, or use the app link.');error.status=503;throw error;}
  return {requestSent:true,learner:body.learner,courseId:body.courseId,lang:body.lang,deepLink,target:'iPhone simulator'};
}
