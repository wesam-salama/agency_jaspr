import {catalogue,copy,lessonTitles,lessonTitlesAr,plannedMinutes,filterCourses,nextLesson,courseTitle,deepLink} from './data.mjs';

const params=new URLSearchParams(location.search);
let lang=params.get('lang')==='ar'?'ar':'en';
let learner=params.get('learner')||'demo';
if(!/^demo(?:-[a-z0-9-]{1,40})?$/.test(learner))learner='demo';
let session=null;
let catalogueState='loading';
let filters={discipline:'all',level:'all'};
let missingPreview=false;
let enrolPending=false;
let sessionGeneration=0;
let handoffState='';
let feedback='';
let lastPreviewControl=null;
const main=document.querySelector('main');
const dialog=document.querySelector('dialog');
const root='/assets/selected-work/frame';
const apiOrigin=location.port==='8803'?location.origin:'http://127.0.0.1:8803';
const t=key=>copy[lang][key];
const e=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const arrow='<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14m-6-6 6 6-6 6"/></svg>';
const symbol=`<img class="symbol" src="../source/frame-symbol.svg" alt="">`;
const bdi=value=>`<bdi dir="ltr">${e(value)}</bdi>`;
const title=course=>courseTitle(course,lang);
const announce=message=>{document.querySelector('#announce').textContent=message;};
function route() {return location.hash.slice(1)||'home';}
function courseLink(course) {return `#course/${course.id}`;}
function button(label,href,secondary=false) {return `<a class="button ${secondary?'secondary':''}" href="${href}">${e(label)}${arrow}</a>`;}
function appButton() {return `<a class="button" data-action="handoff" href="${deepLink(learner,lang)}" ${handoffState==='handoffPending'?'aria-busy="true" aria-disabled="true"':''}>${e(t(handoffState==='handoffPending'?'handoffPending':'openApp'))}${arrow}</a>`;}
function cover(course,className='') {return `<img class="course-cover ${className}" src="../source/${course.cover}${lang==='ar'?'-ar':''}.webp" alt="${e(title(course))} — ${e(t(course.discipline))}" width="800" height="1000">`;}
function canonical(course) {return lang==='ar'?`<p class="canonical">${bdi(course.title)} · ${bdi(course.id)}</p>`:`<p class="canonical">${bdi(course.id)}</p>`;}
function metadata(course) {return `<div class="metadata"><span>${e(t(course.discipline))}</span><span>${e(t('beginner'))}</span><span>${bdi(course.lessons)} ${e(t('lessons'))}</span><span>${bdi(course.minutes)} ${e(t('minutes'))} ${e(t('planned'))}</span></div>`;}
function courseCard(course) {return `<article class="course-card"><a class="cover-link" href="${courseLink(course)}" aria-label="${e(t('details')+' — '+title(course))}">${cover(course)}</a><div class="course-caption"><p class="discipline">${e(t(course.discipline))} · ${e(t('beginner'))}</p><h3><a href="${courseLink(course)}">${e(title(course))}</a></h3>${canonical(course)}<p class="course-time">${bdi(course.lessons)} ${e(t('lessons'))} · ${bdi(course.minutes)} ${e(t('minutes'))} ${e(t('planned'))}</p><p class="availability">${e(t(course.enrol?'free':'previewOnly'))}</p><a class="text-link" href="${courseLink(course)}">${e(t('details'))}${arrow}</a></div></article>`;}
function header() {
 document.documentElement.lang=lang;document.documentElement.dir=lang==='ar'?'rtl':'ltr';document.title=lang==='ar'?'Frame Academy — اصنع فكرتك التالية':'Frame Academy — Make your next idea';
 document.querySelector('.skip-link').textContent=t('skip');
 const current=route().split('/')[0];
 document.querySelector('header').innerHTML=`<div class="header-inner"><a class="brand" href="#home" aria-label="Frame Academy — ${e(t('home'))}">${symbol}<span dir="ltr">Frame <span class="academy">Academy</span></span></a><nav aria-label="${e(t('courses'))}"><a href="#courses" ${current==='courses'||current==='course'?'aria-current="page"':''}>${e(t('courses'))}</a><a href="#how" ${current==='how'?'aria-current="page"':''}>${e(t('how'))}</a><a href="#enrol" class="nav-demo" ${current==='enrol'?'aria-current="page"':''}>${e(t('enrol'))}</a></nav><button class="language" data-action="language" aria-label="${e(t('language'))}: ${e(t('other'))}">${e(t('other'))}</button></div>`;
}
function footer() {document.querySelector('footer').innerHTML=`<div class="footer-top"><a class="brand" href="#home">${symbol}<span dir="ltr">Frame Academy</span></a><p>${e(t('footer'))}</p><span class="studio-label">${e(t('studio'))}</span></div><div class="footer-bottom"><p>${e(t('footerText'))}</p><details class="demo-checks"><summary>${e(t('check'))}</summary><p>${e(t('checkText'))}</p><div><button data-action="fail">${e(t('fail'))}</button><button data-action="missing">${e(t('missing'))}</button><button data-action="error">${e(t('error'))}</button><button data-action="reset">${e(t('reset'))}</button></div><p id="check-feedback" role="status"></p></details></div>`;}
function home() {
 const course=catalogue[0];
 return `<section class="hero"><div class="hero-copy"><h1>${e(t('hero'))}</h1><p class="hero-support">${e(t('support'))}</p><div class="actions">${button(t('explore'),'#courses')}<button class="text-link" data-action="preview">${e(t('preview'))}${arrow}</button></div><p class="hero-note">${e(t('heroNote'))}</p></div><a href="${courseLink(course)}" class="hero-art" aria-label="${e(t('first'))}"><div class="open-corner top"></div>${cover(course)}<div class="hero-art-caption"><span>${e(t('first'))}</span>${arrow}</div><div class="open-corner bottom"></div></a></section><section class="featured"><div class="section-intro"><h2>${e(t('courseIntro'))}</h2><p>${e(t('courseSub'))}</p></div><div class="course-grid">${catalogue.map(courseCard).join('')}</div></section><section class="preview-section"><div class="preview-art"><img src="../media/poster${lang==='ar'?'-ar':''}.webp" alt="${e(t('previewSub'))}" width="1920" height="1080"><button class="play-button" data-action="preview" aria-label="${e(t('watch'))}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m9 5 11 7-11 7z"/></svg></button></div><div class="preview-copy"><h2>${e(t('previewHeading'))}</h2><p>${e(t('previewHint'))}</p><p class="small">${e(t('actual'))}<br>${e(t('access'))}</p><button class="text-link" data-action="preview">${e(t('watch'))}${arrow}</button></div></section>${sequence()}<section class="end-action"><h2>${e(t('see'))}</h2>${button(t('explore'),'#courses')}</section>`;
}
function sequence() {return `<section class="sequence"><h2>${e(t('choose'))}</h2><p class="sequence-intro">${e(t('howSub'))}</p><ol>${[1,2,3].map(n=>`<li><span class="step-index">${bdi('0'+n)}</span><div><h3>${e(t('step'+n))}</h3><p>${e(t('step'+n+'Text'))}</p></div></li>`).join('')}</ol></section>`;}
function courses() {
 let content;
 if(catalogueState==='loading')content=`<div class="catalogue-message" role="status"><h2>${e(t('loading'))}</h2><div class="loading-shapes" aria-hidden="true"><i></i><i></i><i></i></div></div>`;
 else if(catalogueState==='error')content=`<div class="catalogue-message" role="alert"><h2>${e(t('catalogueError'))}</h2><button class="button" data-action="retry-catalogue">${e(t('retry'))}${arrow}</button></div>`;
 else {const items=filterCourses(filters.discipline,filters.level);content=items.length?`<p class="result-count" role="status">${bdi(items.length)} ${e(t('filterSummary'))}</p><div class="course-grid">${items.map(courseCard).join('')}</div>`:`<div class="catalogue-message"><h2>${e(t('empty'))}</h2><p>${e(t('emptySub'))}</p><button class="button" data-action="clear">${e(t('clear'))}${arrow}</button></div>`;}
 return `<section class="page-intro"><h1>${e(t('courses'))}</h1><p>${e(t('courseSub'))}</p></section><section class="catalogue"><form class="filters" aria-label="${e(t('courses'))}"><label>${e(t('discipline'))}<select name="discipline">${['all','photography','filmmaking','design'].map(v=>`<option value="${v}" ${filters.discipline===v?'selected':''}>${e(t(v))}</option>`).join('')}</select></label><label>${e(t('level'))}<select name="level">${['all','beginner','intermediate'].map(v=>`<option value="${v}" ${filters.level===v?'selected':''}>${e(t(v==='all'?'allLevels':v))}</option>`).join('')}</select></label><button type="button" class="text-link" data-action="clear">${e(t('clear'))}</button></form><div id="course-results">${content}</div></section>`;
}
function courseDetail(id) {
 const course=catalogue.find(c=>c.id===id)||catalogue[0];
 const complete=session?.completed?.length||0;
 return `<section class="detail-head"><a class="text-link back-link" href="#courses">${arrow}${e(t('back'))}</a><div class="detail-grid"><div class="detail-copy">${metadata(course)}<h1>${e(title(course))}</h1>${canonical(course)}<p class="detail-overview">${e(lang==='ar'?course.overviewAr:course.overview)}</p><dl class="decision-facts"><div><dt>${e(t('outcome'))}</dt><dd>${e(lang==='ar'?course.outcomeAr:course.outcome)}</dd></div><div><dt>${e(t('prerequisite'))}</dt><dd>${e(t('prerequisiteText'))}</dd></div><div><dt>${e(t('equipment'))}</dt><dd>${e(lang==='ar'?course.equipmentAr:course.equipment)}</dd></div></dl><div class="actions">${course.enrol?button(t(session?.enrolments?.length?'viewRecord':'enrolAction'),'#enrol'):button(t('goFirst'),'#course/FA-PH-01')}</div><p class="small">${e(t(course.enrol?'free':'previewScope'))}</p></div><div class="detail-art">${cover(course)}${course.enrol?`<button class="button preview-control" data-action="preview">${e(t('preview'))}<svg viewBox="0 0 24 24" aria-hidden="true"><path d="m9 5 11 7-11 7z"/></svg></button><p class="small">${e(t('actual'))}</p>`:`<div class="preview-unavailable"><h2>${e(t('previewMissing'))}</h2><p>${e(t('previewScope'))}</p></div>`}</div></div></section>${course.enrol?`<section class="curriculum"><div><h2>${e(t('curriculum'))}</h2><p>${e(t('curriculumHelp'))}</p><p class="small">${e(t('durationHelp'))}</p><p class="access-note">${e(t('access'))}</p></div><ol>${lessonTitles.map((value,i)=>`<li><span class="lesson-number">${bdi('0'+(i+1))}</span><div><h3>${e(lang==='ar'?lessonTitlesAr[i]:value)}</h3><p>${bdi(plannedMinutes[i])} ${e(t('lessonTime'))}</p></div>${i===0?`<button class="text-link" data-action="preview">${e(t('preview'))}${arrow}</button>`:''}</li>`).join('')}</ol></section><section class="exercise-teaser"><div class="practice-mark" aria-hidden="true"><span></span><span></span></div><div><h2>${e(t('learn'))}</h2><p>${e(t('exercise'))}</p><p class="small">${e(t('enrolNotice'))}</p></div></section>`:''}`;
}
function record() {
 const complete=session?.completed||[];
 const next=nextLesson(complete);const index=Number(next||'06')-1;
 const draft=session?.drafts?.['01'];
 return `<section class="shared-record" aria-labelledby="record-title"><div class="record-head"><h2 id="record-title">${e(t('shared'))}</h2><button class="text-link" data-action="refresh">${e(t('refresh'))}${arrow}</button></div><div class="record-grid"><div class="record-progress"><p class="progress-count">${bdi(complete.length)} <span>${lang==='ar'?'من':'of'} ${bdi(6)}</span></p><p>${e(t('progress'))}</p><div class="progress-track" role="progressbar" aria-valuemin="0" aria-valuemax="6" aria-valuenow="${complete.length}" aria-label="${e(t('progress'))}"><span style="width:${complete.length/6*100}%"></span></div><p class="small">${e(t('restart'))}</p></div><div class="record-next"><p>${e(t('next'))}</p><h3>${bdi(next||'06')} ${e(lang==='ar'?lessonTitlesAr[index]:lessonTitles[index])}</h3><p class="small">${bdi(plannedMinutes[index])} ${e(t('lessonTime'))}</p>${appButton()}</div><div class="record-draft"><h3>${e(t('draft'))}</h3>${draft?.note?`<p class="practice-note" dir="auto">${e(draft.note)}</p><p class="saved-status">${e(t('saved'))}</p>`:`<p>${e(t('noDraft'))}</p>`}${draft?.attachment?`<p class="saved-status">${e(t('attachment'))}</p>`:''}</div></div></section>`;
}
function enrol() {
 const enrolled=session?.enrolments?.includes('FA-PH-01');
 return `<section class="enrol-layout"><div class="enrol-copy"><h1>${e(t(enrolled?'enrolled':'enrolTitle'))}</h1><p class="hero-support">${e(t('enrolSub'))}</p><div class="enrol-course">${cover(catalogue[0])}<div><h2>${e(title(catalogue[0]))}</h2>${canonical(catalogue[0])}<p>${e(t('free'))}</p><p>${e(t('plannedTotal'))}</p></div></div>${enrolled?`<div class="handoff"><p class="session-label">${e(t('session'))} · ${e(t('learner'))}</p>${appButton()}<p class="feedback ${handoffState==='handoffError'?'error-status':''}" id="handoff-feedback" role="status">${handoffState?e(t(handoffState)):''}</p><p class="app-help">${e(t('appHelp'))}</p><a class="text-link" href="${deepLink(learner,lang)}">${e(t('handoffFallback'))}</a><p class="learner-code">${e(t('code'))}: ${bdi(learner)}</p></div>`:`<button class="button" data-action="enrol" ${enrolPending?'disabled aria-busy="true"':''}>${e(t(enrolPending?'saving':'continueDemo'))}${arrow}</button><p class="small">${e(t('notComplete'))}</p>`}<p id="enrol-feedback" class="feedback ${feedback==='enrolFailed'?'error-status':''}" role="status">${feedback?e(t(feedback)):''}</p><p class="small">${e(t('enrolNotice'))}</p></div><aside class="enrol-steps"><h2>${e(t('choose'))}</h2><ol><li>${e(t('website'))}<strong>${e(t('step1'))}</strong></li><li>${e(t('app'))}<strong>${e(t('step2'))}</strong></li><li>${e(t('next'))}<strong>${e(t('step3'))}</strong></li></ol><p>${e(t('access'))}</p></aside></section>${enrolled?record():''}`;
}
function render(focus=false) {
 header();footer();const current=route();
 if(current==='courses')main.innerHTML=courses();
 else if(current.startsWith('course/'))main.innerHTML=courseDetail(current.split('/')[1]);
 else if(current==='how')main.innerHTML=`<section class="page-intro"><h1>${e(t('how'))}</h1><p>${e(t('howSub'))}</p></section>${sequence()}<section class="exercise-teaser"><div class="practice-mark" aria-hidden="true"><span></span><span></span></div><div><h2>${e(t('learn'))}</h2><p>${e(t('exercise'))}</p></div></section><section class="end-action"><h2>${e(t('see'))}</h2>${button(t('enrolAction'),'#course/FA-PH-01')}</section>`;
 else if(current==='enrol')main.innerHTML=enrol();
 else main.innerHTML=home();
 if(focus) {main.querySelector('h1')?.setAttribute('tabindex','-1');(main.querySelector('h1')||main).focus({preventScroll:true});}
}
async function request(path,body) {
 const response=await fetch(apiOrigin+'/api/'+path,body?{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({learner,...body})}:{cache:'no-store'});
 const data=await response.json();if(!response.ok)throw new Error(data.error||'Service unavailable');return data;
}
async function loadCatalogue() {
 catalogueState='loading';if(route()==='courses')render();
 try {const data=await request('catalogue');if(data.courses.length!==3)throw new Error('Incomplete catalogue');catalogueState='ready';}catch {catalogueState='error';}
 if(route()==='courses')render();
}
async function refresh(silent=false) {
 const generation=sessionGeneration;
 if(!silent) {feedback='pending';if(route()==='enrol')render();announce(t('pending'));}
 try {const record=await request('session?learner='+encodeURIComponent(learner));if(generation!==sessionGeneration)return;session=record;if(!silent)feedback='synced';if(route()==='enrol'||route().startsWith('course/'))render();if(!silent)announce(t('synced'));}
 catch {if(!silent) {feedback='syncError';if(route()==='enrol')render();announce(t('syncError'));}}
}
async function preview(origin) {
 lastPreviewControl=origin;
 dialog.innerHTML=`<div class="dialog-head"><h2 id="preview-title">${e(t('lesson'))}</h2><button class="close-button" data-action="close-preview" aria-label="${e(t('close'))}"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m6 6 12 12M18 6 6 18"/></svg></button></div>${missingPreview?`<div class="preview-error" role="alert"><h3>${e(t('previewMissing'))}</h3><p>${e(t('previewMissingSub'))}</p><button class="button" data-action="retry-preview">${e(t('retry'))}</button></div>`:`<video id="lesson-preview" controls playsinline preload="metadata" poster="../media/poster${lang==='ar'?'-ar':''}.webp" aria-label="${e(t('lesson'))}" dir="ltr"><source src="../media/see-the-edges${lang==='ar'?'-ar':''}.mp4" type="video/mp4"><track src="../media/captions-${lang}.vtt" kind="captions" srclang="${lang}" label="${lang==='ar'?'العربية':'English'}" default><track src="../media/captions-${lang==='ar'?'en':'ar'}.vtt" kind="captions" srclang="${lang==='ar'?'en':'ar'}" label="${t('other')}"><p>${e(t('previewMissing'))}</p></video><p class="media-time">${e(t('actual'))} · ${e(t('time'))}</p><p class="small">${e(t('access'))}</p><details class="transcript"><summary>${e(t('fullTranscript'))}</summary><div id="transcript-text"><p>${e(t('loading'))}</p></div></details><div class="preview-exercise"><h3>${e(t('learn'))}</h3><p>${e(t('exercise'))}</p><p class="small">${e(t('enrolNotice'))}</p></div>${button(t('enrolAction'),'#enrol')}`} `;
 if(!dialog.open)dialog.showModal();
 dialog.querySelector('button').focus();
 if(!missingPreview) {
  const video=dialog.querySelector('video');
  video.addEventListener('error',()=>{video.insertAdjacentHTML('afterend',`<p role="alert" class="error-status">${e(t('previewMissing'))} ${e(t('previewMissingSub'))}</p>`);},{once:true});
  try {const response=await fetch(`../media/transcript-${lang}.txt`);if(!response.ok)throw new Error();const text=await response.text();const target=dialog.querySelector('#transcript-text');if(target)target.innerHTML=text.split('\n\n').filter(Boolean).map(p=>`<p>${e(p)}</p>`).join('');}catch {const target=dialog.querySelector('#transcript-text');if(target)target.innerHTML=`<p>${e(t('previewMissing'))}</p>`;}
 }
}
function closePreview() {dialog.querySelector('video')?.pause();dialog.close();lastPreviewControl?.focus({preventScroll:true});}
dialog.addEventListener('cancel',()=>{dialog.querySelector('video')?.pause();});
dialog.addEventListener('close',()=>lastPreviewControl?.focus({preventScroll:true}));
document.addEventListener('click',async event=>{
 const control=event.target.closest('[data-action]');if(!control)return;
 const action=control.dataset.action;
 if(action==='handoff') {event.preventDefault();if(handoffState==='handoffPending')return;handoffState='handoffPending';render();announce(t(handoffState));try {const opened=await request('handoff',{courseId:'FA-PH-01',lang});if(!opened.requestSent)throw new Error('App open request was not sent');handoffState='handoffSuccess';}catch {handoffState='handoffError';}render();announce(t(handoffState));main.querySelector('.handoff [data-action="handoff"]')?.focus({preventScroll:true});return;}
 if(action==='language') {lang=lang==='en'?'ar':'en';params.set('lang',lang);params.set('learner',learner);history.replaceState(null,'',location.pathname+'?'+params+location.hash);render(true);return;}
 if(action==='preview') {await preview(control);return;}
 if(action==='close-preview') {closePreview();return;}
 if(action==='retry-preview') {missingPreview=false;await preview(lastPreviewControl);return;}
 if(action==='clear') {filters={discipline:'all',level:'all'};render();main.querySelector('select')?.focus();return;}
 if(action==='retry-catalogue') {await loadCatalogue();return;}
 if(action==='refresh') {await refresh();return;}
 if(action==='enrol') {
  sessionGeneration++;
  enrolPending=true;feedback='';render();announce(t('saving'));
  try {session=await request('enrol',{courseId:'FA-PH-01'});feedback='';announce(t('enrolled'));}
  catch {feedback='enrolFailed';announce(t('enrolFailed'));}
  enrolPending=false;render();main.querySelector('.handoff .button, [data-action="enrol"]')?.focus({preventScroll:true});return;
 }
 const check=()=>document.querySelector('#check-feedback');
 if(action==='missing') {missingPreview=true;check().textContent=t('previewMissing');await preview(control);return;}
 if(action==='error') {catalogueState='error';location.hash='courses';render(true);return;}
 if(action==='fail') {try {await request('test/fail-next',{});check().textContent=t('armed');announce(t('armed'));}catch {check().textContent=t('noService');}return;}
 if(action==='reset') {sessionGeneration++;try {session=await request('test/reset',{});feedback='';render();check().textContent=t('resetDone');announce(t('resetDone'));}catch {check().textContent=t('noService');}return;}
});
document.addEventListener('change',event=>{if(event.target.matches('.filters select')) {filters[event.target.name]=event.target.value;const active=event.target.name;render();main.querySelector(`[name="${active}"]`)?.focus({preventScroll:true});}});
window.addEventListener('hashchange',()=>{if(dialog.open)closePreview();feedback='';render(true);window.scrollTo({top:0,behavior:'instant'});if(route()==='enrol')refresh(true);});
document.addEventListener('visibilitychange',()=>{if(document.hidden)dialog.querySelector('video')?.pause();else refresh(true);});
render();loadCatalogue();refresh(true);
