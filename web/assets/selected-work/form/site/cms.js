import { DEFAULT_PROJECTS, PREVIEW_KEY, cloneProjects, loadProjects, saveProjects, validateProject } from './data.js';

export const DRAFT_KEY = 'form-editor-draft-v1';
export function moveSection(project, index, direction) {
  const target = index + direction;
  if (index < 0 || target < 0 || index >= project.sections.length || target >= project.sections.length) return false;
  const [section] = project.sections.splice(index, 1);
  project.sections.splice(target, 0, section);
  return true;
}
export function removeProjectImage(project, imageIndex) {
  if (imageIndex < 0 || imageIndex >= project.images.length) return false;
  project.images.splice(imageIndex, 1);
  // Story text is deliberately retained. Its missing relation is reported before publishing.
  return true;
}
export function updateField(project, path, value) {
  const keys = path.split('.');
  let target = project;
  for (const key of keys.slice(0, -1)) {
    if (target[key] === undefined) target[key] = {};
    target = target[key];
  }
  target[keys.at(-1)] = path === 'year' || path.includes('.focal.') ? Number(value) : value;
}

const copy = {
  en: {
    title:'Project editor', intro:'Shape the project story, inspect its crops, then preview and publish.', demo:'Local CMS demonstration. Changes stay in this browser; there is no connected account or receiving server.', publishedSite:'View published website', language:'Editor language', projects:'Architectural studies', canon:'These are fictional architectural studies. Their original study facts remain available through Discard changes.', discard:'Discard changes', preview:'Preview changes', publish:'Publish changes', draft:'Draft saved in this browser', ready:'Draft ready', storage:'Browser storage is unavailable. Your edits remain here while this tab is open. Publishing requires browser storage; retry after enabling it.', discardPrompt:'Discard changes to this project and restore its published version? Other drafts will be preserved.', discarded:'This project now matches its published version.', details:'Project information', detailsIntro:'English and Arabic content share one project record. Both are required for the bilingual website.', stableId:'Stable ID', required:'Required', optional:'Optional', titleEn:'English title', titleAr:'Arabic title', summaryEn:'English summary', summaryAr:'Arabic summary', slug:'Project slug', slugHelp:'Lowercase letters, numbers and hyphens. Each project needs a unique address.', categoryEn:'English category', categoryAr:'Arabic category', year:'Study year', status:'Concept status', statusLabel:'Studio concept', statusHelp:'This authored demonstration cannot be published as a constructed or commissioned project.', locationEn:'English location label', locationAr:'Arabic location label', area:'Approximate area', areaHelp:'Optional; include the unit, for example 240 m².', next:'Next project', choose:'Choose an image', chooseProject:'Choose another project', imageHeading:'Images & focal points', imageIntro:'Project-page crops: preview opening, story, and material images at their implemented proportions. Desktop and mobile focal points are independent; full images stay available.', projectCrops:'Project-page crops', fullDiagram:'Full diagram · uncropped', materialDetail:'Material detail', materialOtherUse:'Material images can also appear in story chapters at 4:3. The full public preview shows every use.', source:'Image asset path', sourceHelp:'Use an existing local file in ../studies/. An image must load before publication.', altEn:'English image description', altAr:'Arabic image description', captionEn:'English caption', captionAr:'Arabic caption', desktop:'Desktop crop', mobile:'Mobile crop', horizontal:'Horizontal position', vertical:'Vertical position', fullImage:'Open full image', removeImage:'Remove image', addImage:'Add image', addSource:'Image to add', emptyGallery:'No images in this draft. Add a study image and complete its description and caption before publishing.', stories:'Ordered project story', storyIntro:'The order here is the order on the public page. Moving a section keeps its text and image together.', section:'Section', up:'Move up', down:'Move down', removeSection:'Remove section', storyTitleEn:'English chapter title', storyTitleAr:'Arabic chapter title', storyBodyEn:'English chapter explanation', storyBodyAr:'Arabic chapter explanation', storyImage:'Chapter image', missingImage:'Missing image — choose a replacement', addSection:'Add story section', materials:'Material explanation', materialsEn:'English material explanation', materialsAr:'Arabic material explanation', fieldError:'Review these fields before publishing', previewHeading:'Draft preview', closePreview:'Close preview', previewExplanation:'This is the implemented website with your draft. It is not published yet.', openPreview:'Open full preview', viewport:'Viewport', fitPanel:'Fit panel', mobileViewport:'Mobile · 390 px', previewReady:'Draft preview ready. Review the page, then publish this version.', previewRequired:'Preview your current changes before publishing. Your draft is preserved.', published:'Published in this browser. The public website now reads this project version. No external website or server was changed.', publishFailure:'Publishing could not save to browser storage. Your draft is preserved here. Enable storage, then retry.', checking:'Checking images before publishing…', imageMissing:'This image could not load. Choose an existing study asset, then retry.', invalidOther:'Another project has incomplete draft fields. Review it before publishing the collection.', draftChanged:'Draft changed — preview again before publishing', previewFailure:'The preview could not be stored for the public page. Your draft is preserved here. Enable session storage, then retry.', missingSections:'No story sections. Add a section and connect it to an image before publishing.', unnamed:'Untitled draft', image:'Image', invalid:'This field is incomplete or invalid.', footer:'Publishing updates this local browser only. The canonical source files are not overwritten.', savedDraft:'Recovered your saved draft.', localImage:'Study image', removeSectionPrompt:'Remove this story section from the draft? Its published version can be restored with Discard changes.', removeImagePrompt:'Remove this image from the draft? Story text is preserved; linked chapters will need a replacement image.'
  },
  ar: {
    title:'محرّر المشاريع', intro:'رتّب قصة المشروع، وافحص اقتصاص الصور، ثم عاين التغييرات وانشرها.', demo:'عرض توضيحي لنظام إدارة محتوى محلي. تبقى التغييرات في هذا المتصفح؛ لا يوجد حساب متصل أو خادم يستقبل البيانات.', publishedSite:'عرض الموقع المنشور', language:'لغة المحرّر', projects:'الدراسات المعمارية', canon:'هذه دراسات معمارية متخيّلة. يمكنك استعادة بيانات النسخة المنشورة من خلال «تجاهل التغييرات».', discard:'تجاهل التغييرات', preview:'معاينة التغييرات', publish:'نشر التغييرات', draft:'حُفظت المسودة في هذا المتصفح', ready:'المسودة جاهزة', storage:'تخزين المتصفح غير متاح. تبقى تعديلاتك هنا ما دامت علامة التبويب مفتوحة. يتطلّب النشر إتاحة تخزين المتصفح؛ أعد المحاولة بعد تفعيله.', discardPrompt:'هل تريد تجاهل تغييرات هذا المشروع واستعادة نسخته المنشورة؟ ستبقى مسودات المشاريع الأخرى محفوظة.', discarded:'يطابق هذا المشروع نسخته المنشورة الآن.', details:'معلومات المشروع', detailsIntro:'يشترك المحتوى الإنجليزي والعربي في سجل واحد. كلاهما مطلوب للموقع ثنائي اللغة.', stableId:'المعرّف الثابت', required:'مطلوب', optional:'اختياري', titleEn:'العنوان بالإنجليزية', titleAr:'العنوان بالعربية', summaryEn:'الملخّص بالإنجليزية', summaryAr:'الملخّص بالعربية', slug:'مسار المشروع', slugHelp:'حروف إنجليزية صغيرة وأرقام وشرطات. يحتاج كل مشروع إلى مسار فريد.', categoryEn:'التصنيف بالإنجليزية', categoryAr:'التصنيف بالعربية', year:'سنة الدراسة', status:'حالة المشروع', statusLabel:'مفهوم من الاستوديو', statusHelp:'لا يمكن نشر هذا العرض التوضيحي بوصفه مشروعاً مبنياً أو عملاً بتكليف من عميل.', locationEn:'وصف الموقع بالإنجليزية', locationAr:'وصف الموقع بالعربية', area:'المساحة التقريبية', areaHelp:'اختيارية؛ أضف الوحدة، مثل 240 m².', next:'المشروع التالي', choose:'اختر صورة', chooseProject:'اختر مشروعاً آخر', imageHeading:'الصور ونقاط التركيز', imageIntro:'اقتصاص صفحة المشروع: عاين الصورة الافتتاحية وصور القصة والمواد بنسبها المنفّذة. نقاط تركيز الحاسوب والهاتف مستقلة، وتبقى الصور الكاملة متاحة.', projectCrops:'اقتصاص صفحة المشروع', fullDiagram:'الرسم الكامل · بلا اقتصاص', materialDetail:'تفصيل المواد', materialOtherUse:'قد تظهر صور المواد أيضاً في فصول القصة بنسبة 4:3. تعرض المعاينة العامة الكاملة جميع الاستخدامات.', source:'مسار ملف الصورة', sourceHelp:'استخدم ملفاً محلياً موجوداً في ../studies/. يجب تحميل الصورة قبل النشر.', altEn:'وصف الصورة بالإنجليزية', altAr:'وصف الصورة بالعربية', captionEn:'تعليق الصورة بالإنجليزية', captionAr:'تعليق الصورة بالعربية', desktop:'اقتصاص الحاسوب', mobile:'اقتصاص الهاتف', horizontal:'الموضع الأفقي', vertical:'الموضع العمودي', fullImage:'فتح الصورة الكاملة', removeImage:'إزالة الصورة', addImage:'إضافة صورة', addSource:'الصورة المراد إضافتها', emptyGallery:'لا توجد صور في هذه المسودة. أضف صورة دراسة وأكمل وصفها وتعليقها قبل النشر.', stories:'قصة المشروع بالترتيب', storyIntro:'يظهر هذا الترتيب في الصفحة العامة. يحتفظ نقل الفصل بنصه وصورته معاً.', section:'فصل', up:'نقل لأعلى', down:'نقل لأسفل', removeSection:'إزالة الفصل', storyTitleEn:'عنوان الفصل بالإنجليزية', storyTitleAr:'عنوان الفصل بالعربية', storyBodyEn:'شرح الفصل بالإنجليزية', storyBodyAr:'شرح الفصل بالعربية', storyImage:'صورة الفصل', missingImage:'صورة مفقودة — اختر بديلاً', addSection:'إضافة فصل', materials:'شرح المواد', materialsEn:'شرح المواد بالإنجليزية', materialsAr:'شرح المواد بالعربية', fieldError:'راجع هذه الحقول قبل النشر', previewHeading:'معاينة المسودة', closePreview:'إغلاق المعاينة', previewExplanation:'هذا هو الموقع المنفّذ مع مسودتك. لم تُنشر هذه النسخة بعد.', openPreview:'فتح المعاينة الكاملة', viewport:'حجم المعاينة', fitPanel:'ملاءمة اللوحة', mobileViewport:'هاتف · 390 بكسل', previewReady:'معاينة المسودة جاهزة. راجع الصفحة ثم انشر هذه النسخة.', previewRequired:'عاين تغييراتك الحالية قبل النشر. مسودتك محفوظة.', published:'نُشرت النسخة في هذا المتصفح. يقرأ الموقع العام هذه النسخة الآن. لم يتغيّر أي موقع خارجي أو خادم.', publishFailure:'تعذّر حفظ النشر في تخزين المتصفح. مسودتك محفوظة هنا. أتح التخزين ثم أعد المحاولة.', checking:'جارٍ فحص الصور قبل النشر…', imageMissing:'تعذّر تحميل هذه الصورة. اختر ملف دراسة موجوداً ثم أعد المحاولة.', invalidOther:'توجد حقول غير مكتملة في مسودة مشروع آخر. راجعه قبل نشر المجموعة.', draftChanged:'تغيّرت المسودة — أعد المعاينة قبل النشر', previewFailure:'تعذّر تخزين المعاينة للصفحة العامة. مسودتك محفوظة هنا. أتح تخزين الجلسة ثم أعد المحاولة.', missingSections:'لا توجد فصول للقصة. أضف فصلاً واربطه بصورة قبل النشر.', unnamed:'مسودة بلا عنوان', image:'صورة', invalid:'هذا الحقل غير مكتمل أو غير صالح.', footer:'يحدّث النشر هذا المتصفح المحلي فقط، ولا يستبدل ملفات المصدر الأصلية.', savedDraft:'استُعيدت المسودة المحفوظة.', localImage:'صورة الدراسة', removeSectionPrompt:'هل تريد إزالة هذا الفصل من المسودة؟ يمكنك استعادة نسخته المنشورة من خلال «تجاهل التغييرات».', removeImagePrompt:'هل تريد إزالة هذه الصورة من المسودة؟ يبقى نص القصة محفوظاً؛ وستحتاج الفصول المرتبطة إلى صورة بديلة.'
  }
};

if (typeof document !== 'undefined') initializeEditor();

function initializeEditor() {
  const el = id => document.getElementById(id);
  const escape = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
  const valueAt = (object, path) => path.split('.').reduce((value, key) => value?.[key], object);
  const fieldId = path => `field-${path.replaceAll('.', '-')}`;
  let locale = new URLSearchParams(location.search).get('lang') === 'ar' ? 'ar' : 'en';
  let published = loadProjects();
  let projects = cloneProjects(published);
  let selectedId = projects[0].id;
  let previewSnapshot = null;
  let errors = {};
  let storageWorks = true;
  let savedDraft = false;
  try {
    const saved = JSON.parse(localStorage.getItem(DRAFT_KEY) || 'null');
    if (Array.isArray(saved?.projects) && saved.projects.length && saved.projects.every(p => p && typeof p.id === 'string' && Array.isArray(p.images) && Array.isArray(p.sections))) {
      projects = saved.projects;
      selectedId = projects.some(p => p.id === saved.selectedId) ? saved.selectedId : projects[0].id;
      savedDraft = true;
    }
  } catch (_) { storageWorks = false; }
  const t = key => copy[locale][key] || key;
  const project = () => projects.find(p => p.id === selectedId) || projects[0];
  const localized = item => item?.[locale] || item?.en || t('unnamed');
  const notify = (text, isError = false) => {
    el('feedback').textContent = text;
    el('feedback').hidden = false;
    el('feedback').classList.toggle('warning', isError);
  };
  const draftStatus = key => { el('draft-status').textContent = t(key); };
  function persistDraft() {
    try {
      localStorage.setItem(DRAFT_KEY, JSON.stringify({ projects, selectedId, updatedAt:new Date().toISOString() }));
      storageWorks = true;
      el('storage-warning').hidden = true;
      draftStatus(previewSnapshot ? 'draftChanged' : 'draft');
    } catch (_) {
      storageWorks = false;
      el('storage-warning').textContent = t('storage');
      el('storage-warning').hidden = false;
      draftStatus('draftChanged');
    }
  }
  function field(path, label, options = {}) {
    const p = project(), id = fieldId(path), value = valueAt(p,path) ?? '';
    const language = path.endsWith('.ar') ? 'ar' : 'en';
    const attrs = `id="${id}" data-field="${escape(path)}" name="${escape(path)}" aria-describedby="${id}-help ${id}-error" ${options.optional ? '' : 'required'} ${options.max ? `maxlength="${options.max}"` : ''} ${language==='ar' ? 'lang="ar" dir="rtl"' : 'lang="en" dir="ltr"'}`;
    let control;
    if (options.textarea) control = `<textarea ${attrs} rows="${options.rows || 3}">${escape(value)}</textarea>`;
    else if (options.options) control = `<select ${attrs}>${options.options.map(([v,label])=>`<option value="${escape(v)}" ${String(v)===String(value)?'selected':''}>${escape(label)}</option>`).join('')}</select>`;
    else control = `<input ${attrs} type="${options.type || 'text'}" value="${escape(value)}" ${options.type==='number'?'min="1900" max="2100" step="1"':''}>`;
    return `<div class="field ${options.wide?'wide':''}"><label for="${id}"><span>${escape(t(label))}</span><span class="required">${escape(t(options.optional?'optional':'required'))}</span></label>${control}<small id="${id}-help">${escape(options.help?t(options.help):'')}</small><p class="error" id="${id}-error"></p></div>`;
  }
  function focalFields(image, index, size, uncropped = false) {
    return `<fieldset class="focal-group"><legend>${escape(t(size))}</legend>${['x','y'].map(axis=>{
      const path=`images.${index}.focal.${size}.${axis}`, id=fieldId(path), value=image.focal?.[size]?.[axis] ?? 50;
      return `<div class="range-field"><label for="${id}">${escape(t(axis==='x'?'horizontal':'vertical'))}</label><output for="${id}" id="${id}-output">${escape(value)}%</output><input id="${id}" type="range" min="0" max="100" step="1" value="${escape(value)}" data-field="${path}" aria-describedby="${id}-error" ${uncropped?'disabled':''}><p class="error" id="${id}-error"></p></div>`;
    }).join('')}</fieldset>`;
  }
  function imageEditor(image,index) {
    const src = /^\.\.\/studies\/[a-z0-9-]+\.(webp|png|jpg|jpeg|svg)$/.test(image.src) ? image.src : '';
    const uncropped = image.id === 'diagram' || src.endsWith('-diagram.svg');
    const opening = image === (project().images.find(im => im.id === 'main') || project().images[0]);
    const material = image.id === 'detail';
    const ratio = size => uncropped ? '8/5' : size === 'desktop' && opening ? '16/9' : size === 'desktop' && material ? '16/7' : '4/3';
    return `<section class="image-editor" aria-labelledby="image-${index}-title"><div class="image-header"><h3 id="image-${index}-title">${escape(t('image'))} ${index+1} · <span dir="ltr">${escape(image.id)}</span></h3><button type="button" data-action="remove-image" data-index="${index}">${escape(t('removeImage'))}</button></div><div class="field-grid">${field(`images.${index}.src`,'source',{wide:true,max:300,help:'sourceHelp'})}</div><div class="image-preview-grid">${['desktop','mobile'].map(size=>`<figure class="crop-figure"><div class="crop-frame ${size} ${uncropped?'uncropped':''}" style="--crop-ratio:${ratio(size)}" data-crop="${index}-${size}"><img src="${escape(src)}" alt="${escape(localized(image.alt))}" style="object-position:${image.focal?.[size]?.x??50}% ${image.focal?.[size]?.y??50}%"></div><figcaption>${escape(t('projectCrops'))} · ${material?`${escape(t('materialDetail'))} · `:''}${escape(t(size))} · ${ratio(size).replace('/',':')}${uncropped?` · ${escape(t('fullDiagram'))}`:''}</figcaption></figure>`).join('')}</div>${material?`<p class="help">${escape(t('materialOtherUse'))}</p>`:''}<a href="${escape(src)}" class="full-image" data-full-image="${index}" target="_blank" rel="noopener">${escape(t('fullImage'))}</a><div class="focal-fields">${focalFields(image,index,'desktop',uncropped)}${focalFields(image,index,'mobile',uncropped)}</div><div class="field-grid">${field(`images.${index}.alt.en`,'altEn',{textarea:true,max:500})}${field(`images.${index}.alt.ar`,'altAr',{textarea:true,max:500})}${field(`images.${index}.caption.en`,'captionEn',{textarea:true,max:600})}${field(`images.${index}.caption.ar`,'captionAr',{textarea:true,max:600})}</div></section>`;
  }
  function storyEditor(section,index) {
    const available = project().images.map(image=>[image.id,`${image.id} · ${localized(image.caption).slice(0,50)}`]);
    if (!available.some(([id])=>id===section.imageId)) available.unshift([section.imageId||'',t('missingImage')]);
    return `<section class="story-editor" aria-labelledby="story-${index}-title"><div class="story-header"><h3 id="story-${index}-title">${escape(t('section'))} <span class="story-number">${index+1}</span></h3><div class="story-actions"><button type="button" data-action="move-up" data-index="${index}" ${index===0?'disabled':''}>${escape(t('up'))}</button><button type="button" data-action="move-down" data-index="${index}" ${index===project().sections.length-1?'disabled':''}>${escape(t('down'))}</button><button type="button" data-action="remove-section" data-index="${index}">${escape(t('removeSection'))}</button></div></div><div class="field-grid">${field(`sections.${index}.title.en`,'storyTitleEn',{max:160})}${field(`sections.${index}.title.ar`,'storyTitleAr',{max:160})}${field(`sections.${index}.body.en`,'storyBodyEn',{textarea:true,max:3000,rows:5})}${field(`sections.${index}.body.ar`,'storyBodyAr',{textarea:true,max:3000,rows:5})}${field(`sections.${index}.imageId`,'storyImage',{options:available,wide:true})}</div></section>`;
  }
  function renderProjectNav() {
    el('project-nav').innerHTML = projects.map(p=>`<button type="button" data-project="${escape(p.id)}" aria-current="${p.id===selectedId}"><span>${escape(localized(p.title))}</span><small>${escape(localized(p.category))} · ${escape(p.year)}</small></button>`).join('');
  }
  function renderEditor() {
    const p=project();
    el('project-editor').innerHTML = `<section class="form-section" aria-labelledby="details-heading"><h2 id="details-heading">${escape(t('details'))}</h2><p>${escape(t('detailsIntro'))}</p><p class="immutable">${escape(t('stableId'))} <span dir="ltr">${escape(p.id)}</span></p><div class="field-grid">${field('title.en','titleEn',{max:100})}${field('title.ar','titleAr',{max:100})}${field('summary.en','summaryEn',{textarea:true,max:600})}${field('summary.ar','summaryAr',{textarea:true,max:600})}${field('slug','slug',{max:100,help:'slugHelp'})}${field('year','year',{type:'number'})}${field('category.en','categoryEn',{max:100})}${field('category.ar','categoryAr',{max:100})}${field('status','status',{options:[['Studio concept',t('statusLabel')]],help:'statusHelp',wide:true})}${field('location.en','locationEn',{max:200})}${field('location.ar','locationAr',{max:200})}${field('area','area',{optional:true,max:60,help:'areaHelp'})}${field('nextProject','next',{options:[['',t('chooseProject')],...projects.filter(q=>q.id!==p.id).map(q=>[q.slug,localized(q.title)])]})}</div></section><section class="form-section" aria-labelledby="images-heading"><h2 id="images-heading">${escape(t('imageHeading'))}</h2><p>${escape(t('imageIntro'))}</p><p class="error" id="field-images-error"></p>${p.images.length?p.images.map(imageEditor).join(''):`<p class="empty-gallery">${escape(t('emptyGallery'))}</p>`}<div class="add-image"><label for="image-source">${escape(t('addSource'))}<select id="image-source">${DEFAULT_PROJECTS.flatMap(p=>p.images).map(image=>`<option value="${escape(image.src)}">${escape(image.src.replace('../studies/',''))}</option>`).join('')}</select></label><button type="button" data-action="add-image">${escape(t('addImage'))}</button></div></section><section class="form-section" aria-labelledby="stories-heading"><h2 id="stories-heading">${escape(t('stories'))}</h2><p>${escape(t('storyIntro'))}</p><p class="error" id="field-sections-error"></p>${p.sections.length?p.sections.map(storyEditor).join(''):`<p class="empty-gallery">${escape(t('missingSections'))}</p>`}<button type="button" data-action="add-section">${escape(t('addSection'))}</button></section><section class="form-section" aria-labelledby="materials-heading"><h2 id="materials-heading">${escape(t('materials'))}</h2><div class="field-grid">${field('materials.en','materialsEn',{textarea:true,max:3000,rows:5})}${field('materials.ar','materialsAr',{textarea:true,max:3000,rows:5})}</div></section><p class="editor-footer">${escape(t('footer'))}</p>`;
    renderProjectNav();
    clearErrors();
  }
  function renderLocale() {
    document.documentElement.lang=locale;
    document.documentElement.dir=locale==='ar'?'rtl':'ltr';
    el('editor-language').value=locale;
    document.title=`${t('title')} — Form Architecture`;
    const ids={'editor-title':'title','editor-description':'intro','demo-note':'demo','public-link':'publishedSite','language-label':'language','projects-heading':'projects','canonical-note':'canon','discard':'discard','preview':'preview','publish':'publish','preview-heading':'previewHeading','close-preview':'closePreview','preview-explanation':'previewExplanation','open-preview':'openPreview','viewport-label':'viewport'};
    for(const [id,key] of Object.entries(ids))el(id).textContent=t(key);
    el('preview-viewport').options[0].textContent=t('fitPanel');
    el('preview-viewport').options[1].textContent=t('mobileViewport');
    el('project-nav').setAttribute('aria-label',t('projects'));
    el('project-editor').setAttribute('aria-label',t('title'));
    el('site-preview').title=t('previewHeading');
    el('storage-warning').textContent=t('storage');
    el('storage-warning').hidden=storageWorks;
    renderEditor();
    draftStatus(savedDraft?'draft':'ready');
    if(previewSnapshot)openPreview();
  }
  function clearErrors() {
    errors={};
    el('error-summary').hidden=true;
    el('project-editor').querySelectorAll('[aria-invalid]').forEach(input=>input.removeAttribute('aria-invalid'));
    el('project-editor').querySelectorAll('.error').forEach(error=>error.textContent='');
  }
  function showErrors(nextErrors, focus=true) {
    clearErrors();errors=nextErrors;
    const entries=Object.entries(errors);
    if(!entries.length)return;
    for(const [path,message] of entries){
      const input=el(fieldId(path)), error=el(`${fieldId(path)}-error`);
      if(input)input.setAttribute('aria-invalid','true');
      if(error)error.textContent=locale==='ar'?arabicError(path,message):message;
    }
    el('error-summary').innerHTML=`<h2>${escape(t('fieldError'))}</h2><ul>${entries.map(([path,message])=>{
      const input=el(fieldId(path));
      const target=input?fieldId(path):path.startsWith('images')?'images-heading':path.startsWith('sections')?'stories-heading':'details-heading';
      const label=input?.labels?.[0]?.querySelector('span')?.textContent||input?.labels?.[0]?.textContent||'';
      return `<li><a href="#${target}">${escape(label?`${label}: `:'')}${escape(locale==='ar'?arabicError(path,message):message)}</a></li>`;
    }).join('')}</ul>`;
    el('error-summary').hidden=false;
    if(focus){const first=entries.map(([path])=>el(fieldId(path))).find(Boolean);(first||el('error-summary')).focus();}
  }
  function arabicError(path,message){
    if(message===t('imageMissing')||message.startsWith('This image could not'))return copy.ar.imageMissing;
    if(path==='slug')return 'أدخل مساراً فريداً بحروف إنجليزية صغيرة وأرقام وشرطات.';
    if(path==='status')return 'يجب إبقاء الحالة «مفهوم من الاستوديو»؛ هذا العمل ليس مشروعاً مبنياً أو بتكليف من عميل.';
    if(path==='images')return copy.ar.emptyGallery;
    if(path==='sections')return copy.ar.missingSections;
    if(path.endsWith('imageId'))return 'اختر صورة موجودة لهذا الفصل.';
    if(path.includes('focal'))return 'أدخل موضعاً بين 0 و100.';
    if(path.endsWith('src'))return 'اختر ملف صورة محلياً موجوداً في ../studies/.';
    if(path==='nextProject')return 'اختر مشروعاً آخر موجوداً ليكون المشروع التالي.';
    if(path==='year')return 'أدخل سنة دراسة بين 1900 و2100.';
    if(message.includes('characters or fewer'))return 'النص أطول من الحد المسموح. اختصره ثم أعد المحاولة.';
    return 'هذا الحقل مطلوب. أضف محتواه ثم أعد المحاولة.';
  }
  function changed() {
    persistDraft();
    if(previewSnapshot)draftStatus('draftChanged');
    el('feedback').hidden=true;
  }
  function openPreview() {
    try {
      sessionStorage.setItem(PREVIEW_KEY,JSON.stringify(projects));
    }catch(_){notify(t('previewFailure'),true);return false;}
    const href=`index.html?project=${encodeURIComponent(project().slug)}&preview=1${locale==='ar'?'&lang=ar':''}`;
    el('site-preview').src=href;
    el('open-preview').href=href;
    el('preview-panel').hidden=false;
    previewSnapshot=JSON.stringify(projects);
    notify(t('previewReady'));
    return true;
  }
  async function imageErrors(p) {
    const results=await Promise.all(p.images.map((im,index)=>new Promise(resolve=>{
      const image=new Image();let done=false;
      const finish=valid=>{if(done)return;done=true;clearTimeout(timer);resolve(valid?null:[`images.${index}.src`,t('imageMissing')]);};
      const timer=setTimeout(()=>finish(false),8000);
      image.onload=()=>finish(image.naturalWidth>0);image.onerror=()=>finish(false);
      image.src=im.src;
    })));
    return Object.fromEntries(results.filter(Boolean));
  }
  el('project-editor').addEventListener('submit',event=>event.preventDefault());
  el('project-editor').addEventListener('input',event=>{
    const path=event.target.dataset.field;if(!path)return;
    updateField(project(),path,event.target.value);
    const error=el(`${fieldId(path)}-error`);if(error)error.textContent='';
    event.target.removeAttribute('aria-invalid');
    const output=el(`${fieldId(path)}-output`);if(output)output.textContent=`${event.target.value}%`;
    if(path.includes('.focal.')){
      const [,i,,size]=path.split('.');
      const image=project().images[Number(i)], crop=el('project-editor').querySelector(`[data-crop="${i}-${size}"] img`);
      if(crop)crop.style.objectPosition=`${image.focal[size].x}% ${image.focal[size].y}%`;
    }
    if(/^images\.\d+\.src$/.test(path)){
      const i=Number(path.split('.')[1]), safe=/^\.\.\/studies\/[a-z0-9-]+\.(webp|png|jpg|jpeg|svg)$/.test(event.target.value);
      el('project-editor').querySelectorAll(`[data-crop^="${i}-"] img`).forEach(img=>img.src=safe?event.target.value:'');
      const link=el('project-editor').querySelector(`[data-full-image="${i}"]`);if(link)link.href=safe?event.target.value:'#';
    }
    if(path.startsWith('title.')||path.startsWith('category.'))renderProjectNav();
    changed();
  });
  el('project-editor').addEventListener('click',event=>{
    const button=event.target.closest('[data-action]');if(!button)return;
    const index=Number(button.dataset.index), p=project(), action=button.dataset.action;
    if(action==='remove-image'){
      if(!confirm(t('removeImagePrompt')))return;
      removeProjectImage(p,index);
    }else if(action==='move-up'||action==='move-down')moveSection(p,index,action==='move-up'?-1:1);
    else if(action==='remove-section'){
      if(!confirm(t('removeSectionPrompt')))return;
      p.sections.splice(index,1);
    }else if(action==='add-image'){
      const src=el('image-source').value, original=DEFAULT_PROJECTS.flatMap(p=>p.images).find(image=>image.src===src);
      const image=JSON.parse(JSON.stringify(original));image.id=`image-${Date.now().toString(36)}`;p.images.push(image);
    }else if(action==='add-section')p.sections.push({id:`section-${Date.now().toString(36)}`,title:{en:'',ar:''},body:{en:'',ar:''},imageId:p.images[0]?.id||''});
    changed();renderEditor();
    if(action==='move-up'||action==='move-down'){
      const target=index+(action==='move-up'?-1:1);
      const moved=el('project-editor').querySelector(`[data-action="${action}"][data-index="${target}"]`);
      if(moved&&!moved.disabled)moved.focus();
      else el('project-editor').querySelector(`[data-action="${action==='move-up'?'move-down':'move-up'}"][data-index="${target}"]`)?.focus();
    }else if(action==='add-section')el(fieldId(`sections.${p.sections.length-1}.title.en`))?.focus();
    else if(action==='add-image')el(fieldId(`images.${p.images.length-1}.src`))?.focus();
    else {
      const heading=el(action==='remove-image'?'images-heading':'stories-heading');
      if(heading){heading.tabIndex=-1;heading.focus();heading.scrollIntoView({block:'start'});}
    }
  });
  el('project-nav').addEventListener('click',event=>{
    const button=event.target.closest('[data-project]');if(!button)return;
    selectedId=button.dataset.project;persistDraft();renderEditor();
    el('project-nav').querySelector(`[data-project="${selectedId}"]`)?.focus();
    el('preview-panel').hidden=true;previewSnapshot=null;el('feedback').hidden=true;
  });
  el('editor-language').addEventListener('change',event=>{locale=event.target.value;renderLocale();});
  el('preview').addEventListener('click',()=>{showErrors(validateProject(project(),projects),false);openPreview();});
  el('close-preview').addEventListener('click',()=>{el('preview-panel').hidden=true;el('preview').focus();});
  el('preview-viewport').addEventListener('change',event=>{el('site-preview').parentElement.classList.toggle('mobile',event.target.value==='mobile');});
  el('discard').addEventListener('click',()=>{
    if(!confirm(t('discardPrompt')))return;
    const original=published.find(p=>p.id===selectedId)||DEFAULT_PROJECTS.find(p=>p.id===selectedId);
    projects[projects.findIndex(p=>p.id===selectedId)]=JSON.parse(JSON.stringify(original));
    previewSnapshot=null;el('preview-panel').hidden=true;persistDraft();renderEditor();notify(t('discarded'));el('discard').focus();
  });
  el('publish').addEventListener('click',async()=>{
    const p=project(), currentErrors=validateProject(p,projects);
    if(Object.keys(currentErrors).length){showErrors(currentErrors);return;}
    const invalidOther=projects.find(q=>q.id!==p.id&&Object.keys(validateProject(q,projects)).length);
    if(invalidOther){notify(`${t('invalidOther')} ${localized(invalidOther.title)}`,true);return;}
    if(previewSnapshot!==JSON.stringify(projects)){notify(t('previewRequired'),true);el('preview').focus();return;}
    const checkedSnapshot=JSON.stringify(projects);
    el('publish').disabled=true;el('publish').setAttribute('aria-busy','true');notify(t('checking'));
    try{
      const missing=await imageErrors(p);
      if(Object.keys(missing).length){showErrors(missing);notify(t('imageMissing'),true);return;}
      for(const other of projects.filter(q=>q.id!==p.id)){
        if(Object.keys(await imageErrors(other)).length){notify(`${t('imageMissing')} ${localized(other.title)}`,true);return;}
      }
      if(checkedSnapshot!==JSON.stringify(projects)){notify(t('previewRequired'),true);el('preview').focus();return;}
      published=saveProjects(projects);persistDraft();clearErrors();notify(t('published'));draftStatus('draft');
      el('public-link').href=`index.html?project=${encodeURIComponent(p.slug)}${locale==='ar'?'&lang=ar':''}`;
    }catch(_){notify(t('publishFailure'),true);el('storage-warning').textContent=t('storage');el('storage-warning').hidden=false;}
    finally{el('publish').disabled=false;el('publish').removeAttribute('aria-busy');}
  });
  el('error-summary').addEventListener('click',event=>{
    const anchor=event.target.closest('a');if(!anchor)return;
    const target=document.querySelector(anchor.getAttribute('href'));
    if(target){event.preventDefault();target.focus();target.scrollIntoView({block:'center'});}
  });
  renderLocale();
  if(savedDraft)notify(t('savedDraft'));
}
