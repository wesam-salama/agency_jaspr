import { DEFAULT_PROJECTS, loadProjects, PREVIEW_KEY } from './data.js';

const DRAFT_KEY = 'form-enquiry-draft-v1';
const LANGUAGE_KEY = 'form-language-v1';
const LIMIT = 2000;
export function validateEnquiry(draft, locale = 'en') {
  const ar = locale === 'ar';
  const errors = {};
  if (!String(draft.name || '').trim()) errors.name = ar ? 'اكتب اسمك لنُدرجه في المعاينة.' : 'Enter your name for the preview.';
  else if (String(draft.name).length > 120) errors.name = ar ? 'اختصر الاسم إلى 120 حرفاً أو أقل.' : 'Keep your name to 120 characters or fewer.';
  if (!String(draft.email || '').trim()) errors.email = ar ? 'اكتب عنوان بريدك الإلكتروني.' : 'Enter your email address.';
  else if (String(draft.email).length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(draft.email).trim())) errors.email = ar ? 'استخدم صيغة بريد مثل name@example.com. هذا يتحقق من الصيغة فقط.' : 'Use an email format such as name@example.com. This checks the format only.';
  if (!['residential', 'workplace', 'cultural', 'other'].includes(draft.type)) errors.type = ar ? 'اختر نوع المساحة التي تفكّر فيها.' : 'Choose the type of space you have in mind.';
  if (!String(draft.location || '').trim()) errors.location = ar ? 'اكتب موقع المشروع؛ يكفي اسم المدينة أو المنطقة.' : 'Enter a project location; a city or region is enough.';
  else if (String(draft.location).length > 200) errors.location = ar ? 'اختصر الموقع إلى 200 حرف أو أقل.' : 'Keep the location to 200 characters or fewer.';
  const length = String(draft.outline || '').trim().length;
  if (length < 20) errors.outline = ar ? 'اكتب وصفاً من 20 حرفاً على الأقل يوضّح ما تحتاجه من المساحة.' : 'Write at least 20 characters explaining what you need from the space.';
  else if (String(draft.outline).length > LIMIT) errors.outline = ar ? 'اختصر الوصف إلى 2000 حرف أو أقل. احتفظ بنسخة من التفاصيل الإضافية.' : 'Keep the outline to 2,000 characters or fewer. Keep a copy of any extra detail.';
  for (const field of ['area', 'budget', 'timing']) if (String(draft[field] || '').length > 200) errors[field] = ar ? 'اختصر هذه المعلومة إلى 200 حرف أو أقل.' : 'Keep this information to 200 characters or fewer.';
  return errors;
}

const COPY = {
  en: {
    work: 'Work', studio: 'Studio', contact: 'Contact', skip: 'Skip to content', navigation: 'Main navigation', language: 'Language', home: 'Form Architecture home',
    positioning: 'Architecture shaped around how people live.', heroBody: 'Light, material, movement, and use. A thoughtful relationship between space and daily life.', explore: 'Explore the studies',
    approachTitle: 'Space, considered from the inside out.', approachBody: 'We start with the way a space will be used. Where does the day begin? What should connect, and what needs a little distance? The answers shape the plan before they shape its appearance.', approachBody2: 'These three architectural studies make that approach visible through one spatial idea at a time.', viewAll: 'View all work', openStudy: 'Explore the study',
    processTitle: 'From a question to a spatial response.', processBody: 'A clear process brings everyday needs into the same conversation as light, movement, and material.',
    process: [['Understand the brief', 'Discuss daily routines, priorities, constraints, and the character of the place. A useful starting brief can leave room for uncertainty.'], ['Develop the space', 'Explore connections, proportions, thresholds, and daylight through conceptual plans and spatial studies.'], ['Resolve the relationships', 'Bring the plan, material palette, and details together. Decisions are explained alongside the space they shape.']],
    inviteTitle: 'What could your space make possible?', inviteBody: 'Tell us what you have in mind, what matters to you, and what is still undecided.', startEnquiry: 'Describe your project',
    footer: 'Self-initiated studio project. Architectural studies are fictional.', baseline: 'Starting identity', editor: 'Project editor · local demo',
    workTitle: 'Three spaces. Three starting points.', workIntro: 'Homes, places to work, and places to gather. Each study explores how a clear spatial idea can support everyday use.',
    concept: 'Architectural study · Studio concept', allWork: 'All work', factsCategory: 'Study', factsYear: 'Study year', factsLocation: 'Setting', factsArea: 'Area', briefTitle: 'The brief',
    authorship: 'Architectural study imagery; source and authorship recorded in the asset register. These studies describe fictional spaces, not constructed projects.',
    fullImage: 'Inspect full image', materialsTitle: 'A material relationship.', similar: 'Discuss a similar project', nextStudy: 'Next study', noGallery: 'No gallery images are available in this draft. Add an image in the project editor.',
    studioTitle: 'A thoughtful relationship between space and life.', studioLead: 'Form is an imagined architecture practice interested in useful spaces: homes, small workplaces, and cultural places. This self-initiated project explores how its identity and website could explain that approach.',
    studioBody: 'Planning begins with use. Light reveals the rhythm of a day, material gives a room its character, and movement connects one activity with the next. We consider those relationships together.',
    studioCraftTitle: 'The plan and the material belong together.', studioCraftBody: 'Conceptual diagrams make relationships legible. Spatial images show the quality of an opening, the depth of a threshold, or the pause beside a shared table. Details are read alongside the decisions they support.',
    studioDisclosureTitle: 'A self-initiated studio project.', studioDisclosureBody: 'Form Architecture is a fictional practice created for this rebrand and website study by CR8.Media. The name, website, content, and architectural studies are concept work. No client commission, built project, office, or professional qualification is claimed.', frameAlt: 'Form’s open structural frame: a vertical rectangle with one lower-right opening.',
    contactTitle: 'Tell us about the space you have in mind.', contactIntro: 'A few practical details help explain a useful starting point. It is fine to leave the area, budget, or timing undecided.', demoTitle: 'An enquiry demonstration.', demoBody: 'This form previews a local demo receipt. It has no receiving service and does not send your enquiry. Please use fictional details when testing.', reference: 'Reference study', noReference: 'No reference study', referenceNote: 'Choose or change the study that prompted your enquiry.', required: 'Required', optional: 'Optional', name: 'Your name', email: 'Email address', type: 'Project type', location: 'Project location', outline: 'Project outline', area: 'Approximate area', budget: 'Indicative budget', timing: 'Preferred timing',
    typePlaceholder: 'Choose a project type', types: { residential: 'Home / residential', workplace: 'Workplace', cultural: 'Cultural space', other: 'Another type of space' }, locationHint: 'A city or region is enough; no full address is needed.', outlineHint: 'What will the space be used for? What matters most? 20–2,000 characters.', areaHint: 'For example, 200 m² — or leave undecided.', notDecided: 'Not decided',
    budgetOptions: { undecided: 'Not decided', 'under-100': 'Under €100,000', '100-250': '€100,000–€250,000', '250-500': '€250,000–€500,000', 'over-500': 'Over €500,000', discuss: 'Prefer to discuss' }, timingOptions: { undecided: 'Not decided', exploring: 'Exploring possibilities', '3-6': 'Within 3–6 months', '6-12': 'Within 6–12 months', later: 'Later than 12 months' },
    optionalIntro: 'The following details are optional. A useful starting point does not need to be a finished brief.', previewReceipt: 'Preview demo receipt', processing: 'Preparing the local demo receipt…', submitNote: 'This action previews a receipt. Your enquiry is not sent.', draftNote: 'Your draft stays in this browser, including its reference study. You can return to it or change language.', storageUnavailable: 'Browser storage is unavailable. Your draft stays in this tab; keep a copy before closing or reloading.',
    controls: 'Demonstration controls', simulate: 'Simulate one unsuccessful preview, then offer retry.', controlsNote: 'A local test of recovery; no network request or delivery takes place.', failure: 'The demo preview could not be completed. Your draft is intact. Select Preview demo receipt to retry.', invalid: 'Check the highlighted fields. Your draft has been kept.', receiptTitle: 'Demo complete. This enquiry has not been sent.', receiptBody: 'The preview below shows the details a future receiving service could receive. This demonstration saved no external enquiry and contacted no one.', editEnquiry: 'Edit enquiry', returnWork: 'Return to the work', count: 'characters',
    previewBanner: 'Unpublished editor preview. These changes have not been published.', missingTitle: 'This study is not available.', missingBody: 'Return to the work to explore the published studies.',
  },
  ar: {
    work: 'الأعمال', studio: 'الاستوديو', contact: 'تواصل', skip: 'انتقل إلى المحتوى', navigation: 'التنقل الرئيسي', language: 'اللغة', home: 'الصفحة الرئيسية لـ Form Architecture',
    positioning: 'عمارة تتشكّل حول حياة الناس.', heroBody: 'الضوء والمواد والحركة والاستخدام. علاقة مدروسة بين المكان والحياة اليومية.', explore: 'استكشف الدراسات',
    approachTitle: 'مكان يُدرس من الداخل إلى الخارج.', approachBody: 'نبدأ بطريقة استخدام المكان. أين يبدأ اليوم؟ ما الذي ينبغي أن يتصل، وما الذي يحتاج إلى بعض المسافة؟ تُشكّل الإجابات المخطّط قبل أن تُشكّل مظهره.', approachBody2: 'تُظهر هذه الدراسات المعمارية الثلاث هذا النهج من خلال فكرة مكانية واضحة في كل مرة.', viewAll: 'استعرض جميع الأعمال', openStudy: 'استكشف الدراسة',
    processTitle: 'من سؤال إلى استجابة مكانية.', processBody: 'تجمع عملية واضحة الاحتياجات اليومية مع الضوء والحركة والمواد في حوار واحد.',
    process: [['فهم الاحتياجات', 'مناقشة الروتين اليومي والأولويات والقيود وطبيعة المكان. يمكن للملخص الأولي المفيد أن يترك مجالاً لما لم يُحسم بعد.'], ['تطوير المكان', 'استكشاف الروابط والنسب والعتبات وضوء النهار عبر مخطّطات مفاهيمية ودراسات مكانية.'], ['ضبط العلاقات', 'جمع المخطّط ولوحة المواد والتفاصيل. نوضح القرارات بجانب المساحة التي تشكّلها.']],
    inviteTitle: 'ما الذي يمكن أن يتيحه مكانك؟', inviteBody: 'أخبرنا بما تفكّر فيه، وما يهمك، وما لا يزال غير محسوم.', startEnquiry: 'صِف مشروعك',
    footer: 'مشروع بمبادرة ذاتية من الاستوديو. الدراسات المعمارية متخيّلة.', baseline: 'الهوية الأولى', editor: 'محرر المشاريع · تجربة محلية',
    workTitle: 'ثلاث مساحات. ثلاث نقاط بداية.', workIntro: 'منازل وأماكن للعمل وأماكن للقاء. تستكشف كل دراسة كيف تدعم فكرة مكانية واضحة الاستخدام اليومي.',
    concept: 'دراسة معمارية · تصور من الاستوديو', allWork: 'جميع الأعمال', factsCategory: 'الدراسة', factsYear: 'عام الدراسة', factsLocation: 'الموقع', factsArea: 'المساحة', briefTitle: 'الاحتياجات',
    authorship: 'صور لدراسات معمارية؛ المصدر والإعداد موثّقان في سجل الأصول. تصف الدراسات مساحات متخيّلة، وليست مشاريع مبنية.',
    fullImage: 'افحص الصورة كاملة', materialsTitle: 'علاقة بين المواد.', similar: 'ناقش مشروعاً مشابهاً', nextStudy: 'الدراسة التالية', noGallery: 'لا توجد صور في هذه المسودة. أضف صورة عبر محرر المشاريع.',
    studioTitle: 'علاقة مدروسة بين المكان والحياة.', studioLead: 'Form ممارسة معمارية متخيّلة تهتم بالمساحات المفيدة: المنازل وأماكن العمل الصغيرة والمساحات الثقافية. يستكشف هذا المشروع الذاتي كيف يمكن للهوية والموقع شرح هذا النهج.',
    studioBody: 'يبدأ التخطيط بالاستخدام. يكشف الضوء إيقاع اليوم، وتمنح المواد الغرفة طابعها، وتربط الحركة نشاطاً بآخر. ندرس هذه العلاقات معاً.',
    studioCraftTitle: 'المخطّط والمواد ينتميان إلى بعضهما.', studioCraftBody: 'توضح الرسوم المفاهيمية العلاقات. وتُظهر الصور المكانية طبيعة فتحة، أو عمق عتبة، أو وقفة بجانب طاولة مشتركة. تُقرأ التفاصيل بجانب القرارات التي تدعمها.',
    studioDisclosureTitle: 'مشروع بمبادرة ذاتية من الاستوديو.', studioDisclosureBody: 'Form Architecture ممارسة متخيّلة أنشأها CR8.Media لهذه الدراسة في إعادة بناء الهوية والموقع. الاسم والموقع والمحتوى والدراسات المعمارية عمل مفاهيمي. لا ندّعي وجود تكليف من عميل، أو مشروع مبني، أو مكتب، أو مؤهل مهني.', frameAlt: 'الإطار الإنشائي المفتوح لهوية Form: مستطيل رأسي بفتحة واحدة أسفل اليمين.',
    contactTitle: 'أخبرنا عن المكان الذي تفكّر فيه.', contactIntro: 'تساعد بعض التفاصيل العملية على توضيح نقطة بداية مفيدة. يمكن أن تبقى المساحة أو الميزانية أو التوقيت غير محددة.', demoTitle: 'تجربة استفسار.', demoBody: 'يُظهر هذا النموذج تأكيداً تجريبياً محلياً. لا توجد خدمة لاستقبال الاستفسار، ولا يُرسل النموذج شيئاً. استخدم بيانات متخيّلة عند الاختبار.', reference: 'الدراسة المرجعية', noReference: 'دون دراسة مرجعية', referenceNote: 'اختر الدراسة التي ألهمت استفسارك أو غيّرها.', required: 'مطلوب', optional: 'اختياري', name: 'اسمك', email: 'البريد الإلكتروني', type: 'نوع المشروع', location: 'موقع المشروع', outline: 'وصف المشروع', area: 'المساحة التقريبية', budget: 'الميزانية المبدئية', timing: 'التوقيت المفضّل',
    typePlaceholder: 'اختر نوع المشروع', types: { residential: 'منزل / سكن', workplace: 'مكان عمل', cultural: 'مساحة ثقافية', other: 'نوع آخر من المساحات' }, locationHint: 'يكفي اسم المدينة أو المنطقة؛ لا حاجة إلى عنوان كامل.', outlineHint: 'كيف سيُستخدم المكان؟ ما الذي يهمك أكثر؟ من 20 إلى 2000 حرف.', areaHint: 'مثلاً 200 م²، أو اتركها غير محددة.', notDecided: 'غير محدد',
    budgetOptions: { undecided: 'غير محددة', 'under-100': 'أقل من 100,000 يورو', '100-250': '100,000–250,000 يورو', '250-500': '250,000–500,000 يورو', 'over-500': 'أكثر من 500,000 يورو', discuss: 'أفضّل المناقشة' }, timingOptions: { undecided: 'غير محدد', exploring: 'أستكشف الاحتمالات', '3-6': 'خلال 3–6 أشهر', '6-12': 'خلال 6–12 شهراً', later: 'بعد أكثر من 12 شهراً' },
    optionalIntro: 'التفاصيل التالية اختيارية. لا تحتاج نقطة البداية المفيدة إلى ملخص مكتمل.', previewReceipt: 'عاين التأكيد التجريبي', processing: 'جارٍ تجهيز التأكيد التجريبي المحلي…', submitNote: 'يُظهر هذا الإجراء تأكيداً تجريبياً. لا يُرسل استفسارك.', draftNote: 'تبقى مسودتك في هذا المتصفح، بما فيها الدراسة المرجعية. يمكنك العودة إليها أو تغيير اللغة.', storageUnavailable: 'تخزين المتصفح غير متاح. تبقى مسودتك في علامة التبويب هذه؛ احتفظ بنسخة قبل إغلاقها أو إعادة تحميلها.',
    controls: 'أدوات التجربة', simulate: 'حاكِ محاولة معاينة غير ناجحة واحدة، ثم جرّب التعافي.', controlsNote: 'اختبار محلي للتعافي؛ لا يحدث طلب عبر الشبكة أو إرسال.', failure: 'تعذّر إكمال المعاينة التجريبية. مسودتك محفوظة. اختر معاينة التأكيد التجريبي للمحاولة مجدداً.', invalid: 'راجع الحقول الموضحة. احتُفظ بمسودتك.', receiptTitle: 'اكتملت التجربة. لم يُرسل هذا الاستفسار.', receiptBody: 'توضح المعاينة التالية التفاصيل التي يمكن لخدمة استقبال مستقبلية تلقيها. لم تُحفظ بيانات لدى جهة خارجية، ولم يُتواصل مع أحد.', editEnquiry: 'عدّل الاستفسار', returnWork: 'عُد إلى الأعمال', count: 'حرفاً',
    previewBanner: 'معاينة لمسودة المحرر. لم تُنشر هذه التغييرات.', missingTitle: 'هذه الدراسة غير متاحة.', missingBody: 'عُد إلى الأعمال لاستكشاف الدراسات المنشورة.',
  },
};
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const arrow = '<svg class="link-arrow" aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M5 19 19 5M5 5h14v14" stroke="currentColor" stroke-width="1.5"/></svg>';
const backArrow = '<svg aria-hidden="true" width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M19 12H5m0 0 6-6m-6 6 6 6" stroke="currentColor" stroke-width="1.5"/></svg>';

if (typeof document !== 'undefined') {
  const app = document.querySelector('#app');
  const query = new URLSearchParams(location.search);
  let language = query.get('lang') === 'ar' ? 'ar' : 'en';
  if (!query.has('lang')) try { language = localStorage.getItem(LANGUAGE_KEY) === 'ar' ? 'ar' : 'en'; } catch (_) {}
  let projects = loadProjects();
  const preview = query.get('preview') === '1';
  if (preview) try { const drafts = JSON.parse(sessionStorage.getItem(PREVIEW_KEY) || 'null'); if (Array.isArray(drafts) && drafts.length) projects = drafts; } catch (_) {}
  const state = { draft: {name:'',email:'',type:'',location:'',outline:'',area:'',budget:'undecided',timing:'undecided',reference:''}, errors:{}, status:'', receipt:false, pending:false, storageUnavailable:false, token:0 };
  try { const saved = JSON.parse(localStorage.getItem(DRAFT_KEY) || 'null'); if (saved && typeof saved === 'object' && !Array.isArray(saved)) for (const key of Object.keys(state.draft)) if (typeof saved[key] === 'string') state.draft[key] = saved[key]; } catch (_) { state.storageUnavailable = true; }
  const t = key => COPY[language][key];
  const text = value => typeof value === 'object' && value ? String(value[language] || value.en || '') : String(value || '');
  const projectBySlug = slug => projects.find(p => p.slug === slug);
  function route() {
    const raw = location.hash.slice(1) || (query.get('project') ? `project/${query.get('project')}` : 'home');
    const [path, parameters = ''] = raw.split('?');
    const [name, slug] = path.split('/');
    return {name: ['home','work','project','studio','contact'].includes(name) ? name : 'home', slug, parameters:new URLSearchParams(parameters)};
  }
  function safeImage(im) { return im && /^\.\.\/studies\/[a-z0-9-]+\.(webp|png|jpg|jpeg|svg)$/.test(im.src || ''); }
  function imageMarkup(im, className = '', eager = false) {
    if (!safeImage(im)) return `<p class="truth-note">${esc(t('noGallery'))}</p>`;
    const point = size => `${Math.max(0,Math.min(100,Number(im.focal?.[size]?.x ?? 50)))}% ${Math.max(0,Math.min(100,Number(im.focal?.[size]?.y ?? 50)))}%`;
    return `<img src="${esc(im.src)}" alt="${esc(text(im.alt))}" width="1586" height="992" ${eager ? 'fetchpriority="high"' : 'loading="lazy"'} class="${esc(className)}" style="--focal-desktop:${point('desktop')};--focal-mobile:${point('mobile')}">`;
  }
  function figure(im, className='', full=true, eager=false) {
    return `<figure class="${className}">${imageMarkup(im,im?.id==='diagram'?'diagram-image':'',eager)}${safeImage(im) ? `<figcaption>${esc(text(im.caption))}</figcaption>${full?`<a class="image-full-link" href="${esc(im.src)}" target="_blank" rel="noopener">${esc(t('fullImage'))}<span class="sr-only"> — ${esc(text(im.alt))}</span></a>`:''}`:''}</figure>`;
  }
  function link(label, href, className='text-link') { return `<a class="${className}" href="${esc(href)}">${esc(label)}${arrow}</a>`; }
  function previewCard(p) {
    return `<article class="project-preview"><a class="image-link" href="#project/${esc(p.slug)}" aria-label="${esc(text(p.title))}">${imageMarkup(p.images?.[0])}</a><h3><a href="#project/${esc(p.slug)}">${esc(text(p.title))}</a></h3><p class="preview-facts"><span>${esc(text(p.category))}</span><span dir="ltr">${esc(p.year)}</span><span>${esc(t('concept'))}</span></p><p>${esc(text(p.summary))}</p>${link(t('openStudy'),`#project/${p.slug}`)}</article>`;
  }
  function process() { return `<section class="page-section process-section"><div class="process-head"><h2>${esc(t('processTitle'))}</h2><p>${esc(t('processBody'))}</p></div><ol class="process-list">${t('process').map(([title,body])=>`<li><h3>${esc(title)}</h3><p>${esc(body)}</p></li>`).join('')}</ol></section>`; }
  function invitation(reference='') { return `<section class="enquiry-invitation"><h2>${esc(t('inviteTitle'))}</h2><div><p>${esc(t('inviteBody'))}</p>${link(reference?t('similar'):t('startEnquiry'),`#contact${reference?`?project=${encodeURIComponent(reference)}`:''}`)}</div></section>`; }
  function homePage() {
    const first = projects[0] || DEFAULT_PROJECTS[0];
    const compact = projects[2];
    return `<section class="home-hero"><div class="hero-copy"><h1 class="route-heading" tabindex="-1">${esc(t('positioning'))}</h1><p>${esc(t('heroBody'))}</p>${link(t('explore'),'#work')}</div><figure class="hero-image"><a href="#project/${esc(first.slug)}" aria-label="${esc(text(first.title))}">${imageMarkup(first.images?.[0],'',true)}</a><figcaption><a href="#project/${esc(first.slug)}">${esc(text(first.title))}</a><span>${esc(text(first.category))} · <bdi>${esc(first.year)}</bdi></span></figcaption></figure></section><section class="page-section approach"><h2>${esc(t('approachTitle'))}</h2><div><p>${esc(t('approachBody'))}</p><p>${esc(t('approachBody2'))}</p>${link(t('viewAll'),'#work')}</div></section><div class="home-work">${projects.slice(0,2).map(previewCard).join('')}</div>${compact?`<article class="compact-preview"><a href="#project/${esc(compact.slug)}" class="image-link" aria-label="${esc(text(compact.title))}">${imageMarkup(compact.images?.[0])}</a><div class="compact-copy"><h3><a href="#project/${esc(compact.slug)}">${esc(text(compact.title))}</a></h3><p class="preview-facts">${esc(text(compact.category))} · <bdi>${esc(compact.year)}</bdi><br>${esc(t('concept'))}</p><p>${esc(text(compact.summary))}</p>${link(t('openStudy'),`#project/${compact.slug}`)}</div></article>`:''}${process()}${invitation()}`;
  }
  function workPage() { return `<section class="page-heading"><h1 class="route-heading" tabindex="-1">${esc(t('workTitle'))}</h1><p>${esc(t('workIntro'))}</p></section><div class="work-grid">${projects.map(previewCard).join('')}</div>${invitation()}`; }
  function projectPage(slug) {
    const p = projectBySlug(slug);
    if (!p) return `<section class="empty-page"><h1 class="route-heading" tabindex="-1">${esc(t('missingTitle'))}</h1><p>${esc(t('missingBody'))}</p>${link(t('allWork'),'#work')}</section>`;
    const next = projectBySlug(p.nextProject);
    const main = p.images?.find(im => im.id === 'main') || p.images?.[0];
    const detail = p.images?.find(im => im.id === 'detail');
    const facts = [[t('factsCategory'),text(p.category)],[t('factsYear'),p.year],[t('factsLocation'),text(p.location)],...(p.area?[[t('factsArea'),p.area]]:[])];
    return `<section class="project-heading"><a href="#work" class="back-link">${backArrow}${esc(t('allWork'))}</a><div class="project-title-row"><h1 class="route-heading" tabindex="-1">${esc(text(p.title))}<span class="concept-label">${esc(t('concept'))}</span></h1><p>${esc(text(p.summary))}</p></div></section><section class="project-main-image">${figure(main,'',true,true)}</section><section class="project-brief"><dl class="facts">${facts.map(([label,value])=>`<div><dt>${esc(label)}</dt><dd ${label===t('factsYear')||label===t('factsArea')?'dir="ltr"':''}>${esc(value)}</dd></div>`).join('')}</dl><div><h2>${esc(t('briefTitle'))}</h2><p>${esc(text(p.summary))}</p><p class="truth-note">${esc(t('authorship'))}</p></div></section>${(p.sections||[]).map(section=>`<section class="story-section">${figure(p.images?.find(im=>im.id===section.imageId),'',true)}<div><h2>${esc(text(section.title))}</h2><p>${esc(text(section.body))}</p></div></section>`).join('')}${detail?`<section class="material-section">${figure(detail,'',true)}<div class="material-text"><h2>${esc(t('materialsTitle'))}</h2><p>${esc(text(p.materials))}</p></div></section>`:''}${invitation(p.slug)}<div class="project-next">${link(t('allWork'),'#work')}${next?link(`${t('nextStudy')}: ${text(next.title)}`,`#project/${next.slug}`):''}</div>`;
  }
  function studioPage() {
    const line = projectBySlug('line-studio') || projects[0];
    return `<section class="page-heading"><h1 class="route-heading" tabindex="-1">${esc(t('studioTitle'))}</h1><p>${esc(t('studioLead'))}</p></section><section class="studio-intro"><figure class="frame-study"><img src="../source/frame-mark.svg" alt="${esc(t('frameAlt'))}" width="150" height="200"></figure><div><p>${esc(t('studioBody'))}</p>${link(t('explore'),'#work')}</div></section><section class="studio-craft">${figure(line?.images?.find(im=>im.id==='diagram') || line?.images?.[0],'',true)}<div><h2>${esc(t('studioCraftTitle'))}</h2><p>${esc(t('studioCraftBody'))}</p></div></section>${process()}<section class="studio-disclosure"><h2>${esc(t('studioDisclosureTitle'))}</h2><p>${esc(t('studioDisclosureBody'))}</p></section>${invitation()}`;
  }
  function options(items, selected) { return Object.entries(items).map(([value,label])=>`<option value="${esc(value)}" ${selected===value?'selected':''}>${esc(label)}</option>`).join(''); }
  function field(name, content, required=false, full=false, hint='') {
    const error = state.errors[name] || '';
    return `<div class="field ${full?'full':''}"><label for="enquiry-${name}">${esc(t(name))}<small>${esc(t(required?'required':'optional'))}</small></label>${content}<p id="${name}-hint" class="field-hint">${esc(hint)}</p><p id="${name}-error" class="field-error">${esc(error)}</p></div>`;
  }
  function attrs(name) { return `id="enquiry-${name}" name="${name}" aria-describedby="${name}-hint ${name}-error" ${state.errors[name]?'aria-invalid="true"':''}`; }
  function contactPage() {
    const reference = projectBySlug(state.draft.reference);
    const d = state.draft;
    return `<section class="page-heading"><h1 class="route-heading" tabindex="-1">${esc(t('contactTitle'))}</h1><p>${esc(t('contactIntro'))}</p></section><div class="contact-layout"><aside class="contact-aside"><h2>${esc(t('demoTitle'))}</h2><p>${esc(t('demoBody'))}</p>${reference?`<div class="context-summary">${imageMarkup(reference.images?.[0])}<h3>${esc(text(reference.title))}</h3><p>${esc(text(reference.category))} · <bdi>${esc(reference.year)}</bdi><br>${esc(t('concept'))}</p></div>`:''}</aside><form class="enquiry-form" id="enquiry-form" novalidate><div class="form-grid"><div class="field full"><label for="enquiry-reference">${esc(t('reference'))}<small>${esc(t('optional'))}</small></label><select id="enquiry-reference" name="reference" aria-describedby="reference-hint"><option value="">${esc(t('noReference'))}</option>${projects.map(p=>`<option value="${esc(p.slug)}" ${d.reference===p.slug?'selected':''}>${esc(text(p.title))}</option>`).join('')}</select><p id="reference-hint" class="field-hint">${esc(t('referenceNote'))}</p></div>${field('name',`<input ${attrs('name')} type="text" value="${esc(d.name)}" autocomplete="name" maxlength="120" required>`,true)}${field('email',`<input ${attrs('email')} type="email" value="${esc(d.email)}" autocomplete="email" inputmode="email" dir="ltr" maxlength="254" required>`,true)}${field('type',`<select ${attrs('type')} required><option value="">${esc(t('typePlaceholder'))}</option>${options(t('types'),d.type)}</select>`,true)}${field('location',`<input ${attrs('location')} type="text" value="${esc(d.location)}" autocomplete="address-level2" maxlength="200" required>`,true,false,t('locationHint'))}${field('outline',`<textarea ${attrs('outline')} required minlength="20" rows="6">${esc(d.outline)}</textarea><p class="outline-counter" id="outline-counter" ${d.outline.length<1700?'hidden':''}>${d.outline.length} / 2,000 ${esc(t('count'))}</p>`,true,true,t('outlineHint'))}<div class="form-divider"><p>${esc(t('optionalIntro'))}</p></div>${field('area',`<input ${attrs('area')} type="text" value="${esc(d.area)}" placeholder="${esc(t('notDecided'))}" maxlength="200">`,false,false,t('areaHint'))}${field('budget',`<select ${attrs('budget')}>${options(t('budgetOptions'),d.budget)}</select>`)}${field('timing',`<select ${attrs('timing')}>${options(t('timingOptions'),d.timing)}</select>`)}</div><div class="submit-row"><button class="button-primary" type="submit" ${state.pending?'disabled':''}>${esc(t(state.pending?'processing':'previewReceipt'))}${arrow}</button><p class="submit-note">${esc(t('submitNote'))}</p></div><p class="form-status ${state.status?'error':''}" role="status" aria-live="polite" aria-atomic="true">${esc(state.status)}</p><p class="draft-note">${esc(t(state.storageUnavailable?'storageUnavailable':'draftNote'))}</p><details class="demo-controls"><summary>${esc(t('controls'))}</summary><label><input type="checkbox" name="simulateFailure">${esc(t('simulate'))}</label><p>${esc(t('controlsNote'))}</p></details></form></div>`;
  }
  function receiptPage() {
    const d = state.draft;
    const ref = projectBySlug(d.reference);
    const facts = [[t('name'),d.name],[t('email'),d.email],[t('type'),t('types')[d.type]||d.type],[t('location'),d.location],[t('reference'),ref?text(ref.title):t('noReference')],[t('outline'),d.outline],[t('area'),d.area||t('notDecided')],[t('budget'),t('budgetOptions')[d.budget]||t('notDecided')],[t('timing'),t('timingOptions')[d.timing]||t('notDecided')]];
    return `<section class="receipt-wrap"><h1 class="route-heading" tabindex="-1">${esc(t('receiptTitle'))}</h1><p role="status" aria-live="polite">${esc(t('receiptBody'))}</p><dl class="receipt-facts">${facts.map(([label,value])=>`<div><dt>${esc(label)}</dt><dd dir="auto">${esc(value)}</dd></div>`).join('')}</dl><div class="receipt-actions"><button class="button-primary" type="button" data-edit-enquiry>${esc(t('editEnquiry'))}</button>${link(t('returnWork'),'#work')}</div></section>`;
  }
  function persistDraft() {
    try { localStorage.setItem(DRAFT_KEY,JSON.stringify(state.draft)); } catch (_) { state.storageUnavailable=true; }
  }
  function readForm(form) {
    if (!form) return;
    const data = new FormData(form);
    for (const key of Object.keys(state.draft)) state.draft[key]=String(data.get(key)||'');
    persistDraft();
  }
  function updateDocument() {
    document.documentElement.lang=language; document.documentElement.dir=language==='ar'?'rtl':'ltr';
    document.querySelector('.skip-link').textContent=t('skip');
    document.querySelector('.brand').setAttribute('aria-label',t('home'));
    document.querySelector('.primary-nav').setAttribute('aria-label',t('navigation'));
    for (const a of document.querySelectorAll('[data-nav]')) { a.textContent=t(a.dataset.nav); const current = a.dataset.nav===route().name || (a.dataset.nav==='work'&&route().name==='project'); if(current)a.setAttribute('aria-current','page');else a.removeAttribute('aria-current'); }
    document.querySelector('.languages').setAttribute('aria-label',t('language'));
    for (const a of document.querySelectorAll('[data-lang]')) { if(a.dataset.lang===language)a.setAttribute('aria-current','true');else a.removeAttribute('aria-current'); }
    for (const el of document.querySelectorAll('[data-footer]')) el.textContent=el.dataset.footer==='agency'?'CR8.Media':t(el.dataset.footer==='disclosure'?'footer':el.dataset.footer);
    const p=route().name==='project'?projectBySlug(route().slug):null;
    document.title=p?`${text(p.title)} — Form Architecture`:`Form Architecture — ${t('positioning')}`;
  }
  function render(focus=false) {
    updateDocument();
    const current = route();
    if(current.name==='contact' && current.parameters.has('project')) {
      const ref=current.parameters.get('project'); if(projectBySlug(ref)) { state.draft.reference=ref; persistDraft(); }
      history.replaceState(null,'',`${location.pathname}${location.search}#contact`);
    }
    const page = current.name==='home'?homePage():current.name==='work'?workPage():current.name==='project'?projectPage(current.slug):current.name==='studio'?studioPage():state.receipt?receiptPage():contactPage();
    app.className=`route-${current.name}`;
    app.innerHTML=`${preview?`<div class="preview-banner">${esc(t('previewBanner'))}</div>`:''}${page}`;
    if(focus){window.scrollTo({top:0,behavior:'instant'});app.querySelector('.route-heading')?.focus({preventScroll:true});}
  }
  function applyErrors() {
    const form=app.querySelector('form');
    for (const name of ['name','email','type','location','outline','area','budget','timing']) {
      const input=form?.elements.namedItem(name);const error=document.getElementById(`${name}-error`);
      if(state.errors[name]) input?.setAttribute('aria-invalid','true'); else input?.removeAttribute('aria-invalid');
      if(error)error.textContent=state.errors[name]||'';
    }
    const status=app.querySelector('.form-status');if(status){status.textContent=state.status;status.classList.toggle('error',Boolean(state.status));}
  }
  app.addEventListener('input',event=>{
    const form=event.target.closest('#enquiry-form');if(!form)return;
    readForm(form);
    if(event.target.name==='outline'){const counter=app.querySelector('#outline-counter');counter.hidden=state.draft.outline.length<1700;counter.textContent=`${state.draft.outline.length} / 2,000 ${t('count')}`;}
    if(state.errors[event.target.name]){state.errors=validateEnquiry(state.draft,language);applyErrors();}
    const note=app.querySelector('.draft-note');if(note)note.textContent=t(state.storageUnavailable?'storageUnavailable':'draftNote');
  });
  app.addEventListener('change',event=>{
    if(event.target.name==='reference'){readForm(event.target.closest('form'));render(false);app.querySelector('#enquiry-reference')?.focus();}
  });
  app.addEventListener('submit',async event=>{
    if(event.target.id!=='enquiry-form')return;
    event.preventDefault();if(state.pending)return;
    const form=event.target;readForm(form);
    state.errors=validateEnquiry(state.draft,language);
    if(Object.keys(state.errors).length){state.status=t('invalid');applyErrors();form.elements.namedItem(Object.keys(state.errors)[0])?.focus();return;}
    const fail=Boolean(form.elements.namedItem('simulateFailure')?.checked);
    const token=++state.token;state.pending=true;state.status='';
    const button=form.querySelector('[type="submit"]');button.disabled=true;button.textContent=t('processing');
    const live=form.querySelector('.form-status');live.classList.remove('error');live.textContent=t('processing');
    await new Promise(resolve=>setTimeout(resolve,420));
    if(token!==state.token)return;
    state.pending=false;
    if(fail){state.status=t('failure');form.elements.namedItem('simulateFailure').checked=false;button.disabled=false;button.innerHTML=`${esc(t('previewReceipt'))}${arrow}`;applyErrors();button.focus();return;}
    state.receipt=true;state.status='';render(true);
  });
  app.addEventListener('click',event=>{
    if(event.target.closest('[data-edit-enquiry]')){state.receipt=false;render(true);}
  });
  document.querySelector('.languages').addEventListener('click',event=>{
    const a=event.target.closest('[data-lang]');if(!a)return;event.preventDefault();
    readForm(app.querySelector('#enquiry-form'));language=a.dataset.lang;state.errors=Object.keys(state.errors).length?validateEnquiry(state.draft,language):{};
    if(state.status)state.status=t(Object.keys(state.errors).length?'invalid':'failure');
    try{localStorage.setItem(LANGUAGE_KEY,language);}catch(_){}
    const url=new URL(location.href);url.searchParams.set('lang',language);history.replaceState(null,'',url);render(false);
  });
  document.querySelector('.skip-link').addEventListener('click',event=>{event.preventDefault();document.querySelector('#main').focus();document.querySelector('#main').scrollIntoView();});
  window.addEventListener('hashchange',()=>{readForm(app.querySelector('#enquiry-form'));state.token++;state.pending=false;state.receipt=false;state.status='';state.errors={};render(true);});
  window.addEventListener('storage',event=>{if(event.key==='form-projects-v1'&&!preview){readForm(app.querySelector('#enquiry-form'));projects=loadProjects();render(false);}});
  render(false);
}
