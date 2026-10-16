import {spawn, execFileSync} from 'node:child_process';
import {writeFileSync, mkdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
export const udid = '8BDFE212-1DE0-4F67-928E-65C3E9B24533';
export const proofRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../verification/native');
export const delay = ms => new Promise(r=>setTimeout(r,ms));
export class Vm {
  constructor(uri) { this.uri=uri; this.id=0; this.pending=new Map(); }
  async connect() {
    this.socket = new WebSocket(this.uri);
    this.socket.addEventListener('message',e=>{ const data=JSON.parse(e.data); const p=this.pending.get(data.id); if(p){ this.pending.delete(data.id); data.error?p.reject(new Error(JSON.stringify(data.error))):p.resolve(data.result); }});
    await new Promise((resolve,reject)=>{ this.socket.addEventListener('open',resolve,{once:true}); this.socket.addEventListener('error',reject,{once:true}); setTimeout(()=>reject(new Error('VM socket timed out')),15000).unref(); });
    const vm=await this.rpc('getVM'); this.isolateId=vm.isolates.find(x=>x.name==='main')?.id ?? vm.isolates[0].id;
    return this;
  }
  rpc(method,params={}){ const id=++this.id; return new Promise((resolve,reject)=>{ this.pending.set(id,{resolve,reject}); this.socket.send(JSON.stringify({jsonrpc:'2.0',id,method,params})); setTimeout(()=>{if(this.pending.has(id)){this.pending.delete(id);reject(new Error('RPC timed out: '+method));}},20000).unref();}); }
  ext(name,params={}){ return this.rpc('ext.flutter.'+name,{isolateId:this.isolateId,...Object.fromEntries(Object.entries(params).map(([k,v])=>[k,String(v)]))}); }
  state(){return this.ext('frameState');}
  async elements(){return this.ext('marionette.interactiveElements');}
  async tap(key){await this.ext('marionette.tap',{key});await delay(450);}
  async scroll(key){await this.ext('marionette.scrollTo',{key});await delay(250);}
  close(){this.socket.close();}
}
export function shot(name){mkdirSync(proofRoot,{recursive:true});execFileSync('xcrun',['simctl','io',udid,'screenshot',path.join(proofRoot,name)],{stdio:'ignore'});console.log('Screenshot '+name);}
export async function api(action,body){const r=await fetch('http://127.0.0.1:8803/api/'+action,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)}); if(!r.ok) throw new Error('API '+r.status);return r.json();}
export function openUri(learner,lang){execFileSync('xcrun',['simctl','openurl',udid,`frameacademy://course/FA-PH-01?learner=${learner}&lang=${lang}`],{stdio:'ignore'});}
async function until(fn,predicate,max=15000){let state;for(let n=0;n<max/300;n++){state=await fn();if(predicate(state))return state;await delay(300);}throw new Error('State assertion timed out: '+JSON.stringify(state));}
export async function journey(uri,learner,lang){
  const vm=await new Vm(uri).connect(); const log=[]; const suffix=lang;
  let recorder;
  try {
    const received = await vm.state();
    if (received.learner !== learner || received.arabic !== (lang === 'ar')) openUri(learner,lang);
    await until(()=>vm.state(),s=>s.learner===learner&&s.record&&s.record.completed.length===0);
    const zero=await vm.state();if(!zero.record.enrolments.includes('FA-PH-01'))throw new Error('Missing website enrolment');log.push({scenario:'website handoff same learner and course,0/6',state:zero});
    recorder=spawn('xcrun',['simctl','io',udid,'recordVideo','--codec=h264',path.join(proofRoot,`native-core-${suffix}-raw.mp4`)],{stdio:'ignore'});await delay(900);
    shot(`course-zero-${suffix}.png`);
    const homeControls = await vm.elements();
    const startKey = homeControls.elements.some(e=>e.key === 'continue') ? 'continue' : 'enrol-or-continue';
    await vm.scroll(startKey);await vm.tap(startKey);
    await until(()=>vm.elements(),r=>r.elements.some(e=>e.key==='play-pause'),30000);
    await vm.tap('play-pause');await delay(4400);shot(`lesson-player-${suffix}.png`);await vm.tap('play-pause');
    log.push({scenario:'authored video played; no completion from playback',state:await vm.state()});
    await vm.scroll('exercise');await vm.tap('exercise');await vm.scroll('practice-note');await vm.tap('practice-note');
    const note=lang==='ar'?'عندما قرّبت العنصر من الحافة، أصبحت المساحة المجاورة أوضح. أبقيت الضوء نفسه في الصورتين.':'Moving the object toward the edge made the surrounding space more visible. I kept the light the same in both photographs.';
    await vm.ext('marionette.enterText',{key:'practice-note',input:note});
    await api('test/fail-next',{learner});
    await vm.scroll('save-draft');await vm.tap('save-draft');
    const failure=await until(()=>vm.state(),s=>s.error==='save'&&!s.pending);
    if(failure.note!==note||failure.confirmed)throw new Error('Failure did not retain draft or falsely confirmed save');
    log.push({scenario:'controlled503 save failed; exact note retained; no saved status',state:failure});
    shot(`exercise-failed-${suffix}.png`);
    await vm.scroll('retry-save');await vm.tap('retry-save');
    const saved=await until(()=>vm.state(),s=>s.confirmed&&!s.pending);
    if(saved.note!==note||saved.record.completed.length!==0)throw new Error('Draft save changed completion');
    log.push({scenario:'retry acknowledged; draft saved; still0/6',state:saved});shot(`exercise-saved-${suffix}.png`);
    await vm.scroll('complete-exercise');await vm.tap('complete-exercise');
    const completed=await until(()=>vm.state(),s=>s.record.completed.includes('01')&&s.confirmed&&!s.pending);
    log.push({scenario:'explicit exercise completion1/6 with next02',state:completed});shot(`completed-${suffix}.png`);
    writeFileSync(path.join(proofRoot,`native-checks-${suffix}.json`),JSON.stringify({platform:'iOS26.5 iPhone17Pro simulator',learner,lang,checks:log},null,2));
    console.log('Completed native journey '+learner+'; cold restart remains.');
  } finally {if(recorder){recorder.kill('SIGINT');await delay(1000);}vm.close();}
}
if(process.argv[2]==='journey')await journey(process.argv[3],process.argv[4],process.argv[5]);
if(process.argv[2]==='state'){const vm=await new Vm(process.argv[3]).connect();console.log(JSON.stringify(await vm.state()));vm.close();}
