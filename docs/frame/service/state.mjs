import {readFile,writeFile,mkdir,rename} from 'node:fs/promises';
import {dirname} from 'node:path';
import {randomUUID} from 'node:crypto';

export function initialSession(learner='demo') {
  return {learner,displayName:'Demo learner',enrolments:[],completed:[],drafts:{'01':{note:'',attachment:false}},revision:0};
}
export class DemoStore {
  constructor(file) {this.file=file;this.sessions={};this.failure=new Set();this.queue=Promise.resolve();}
  async load() {
    try {const data=JSON.parse(await readFile(this.file,'utf8'));this.sessions=data.sessions||{};}
    catch(error) {if(error.code!=='ENOENT')throw error;}
  }
  session(learner) {return structuredClone(this.sessions[learner]||initialSession(learner));}
  async write(sessions) {
    await mkdir(dirname(this.file),{recursive:true});
    const temporary=`${this.file}.${randomUUID()}.tmp`;
    await writeFile(temporary,JSON.stringify({schemaVersion:1,sessions},null,2)+'\n',{mode:0o600});
    await rename(temporary,this.file);
  }
  mutate(learner,operation,body) {
    const work=this.queue.then(async()=>{
      if((operation==='draft'||operation==='complete')&&this.failure.delete(learner)) {
        const error=new Error('Controlled save failure. Your exercise has not changed. Retry the same request.');error.status=503;throw error;
      }
      let current=this.session(learner);
      if(operation==='reset')current=initialSession(learner);
      else if(operation==='enrol') {
        if(!current.enrolments.includes('FA-PH-01'))current.enrolments.push('FA-PH-01');
      } else {
        if(!current.enrolments.includes('FA-PH-01')) {const error=new Error('Enrol in Composition Essentials first.');error.status=409;throw error;}
        current.drafts[body.lessonId]={note:body.note,attachment:body.attachment};
        if(operation==='complete'&&!current.completed.includes(body.lessonId))current.completed.push(body.lessonId);
        current.completed.sort();
      }
      if(operation!=='reset')current.revision++;
      const next={...this.sessions,[learner]:current};
      await this.write(next);
      this.sessions=next;
      return structuredClone(current);
    });
    this.queue=work.catch(()=>{});
    return work;
  }
}
export function validateLearner(value) {
  if(typeof value!=='string'||!/^demo(?:-[a-z0-9-]{1,40})?$/.test(value))return false;
  return true;
}
export function validateDraft(body) {
  return /^0[1-6]$/.test(body.lessonId)&&typeof body.note==='string'&&body.note.length<=4000&&typeof body.attachment==='boolean';
}
