// Form Architecture: authored fixtures for a self-initiated studio concept.
export const STORAGE_KEY = 'form-projects-v1';
export const PREVIEW_KEY = 'form-editor-preview-v1';
const pair = (en, ar) => ({ en, ar });
const image = (slug, suffix, alt, caption, focal = [50, 50, 50, 50]) => ({
  id: suffix || 'main', src: `../studies/${slug}${suffix ? `-${suffix}` : ''}.${suffix === 'diagram' ? 'svg' : 'webp'}`,
  alt, caption, focal: { desktop: { x: focal[0], y: focal[1] }, mobile: { x: focal[2], y: focal[3] } },
});
export const DEFAULT_PROJECTS = [
  {
    id: 'form-courtyard-house', slug: 'courtyard-house', title: pair('Courtyard House', 'منزل الفناء'),
    summary: pair('One planted opening organizes light, privacy, and movement across a compact home.', 'فتحة مزروعة واحدة تنظّم الضوء والخصوصية والحركة داخل منزل مدمج.'),
    category: pair('Residential study', 'دراسة سكنية'), year: 2025, status: 'Studio concept',
    location: pair('Fictional Mediterranean setting', 'موقع متخيّل في منطقة المتوسط'), area: '240 m²',
    images: [
      image('courtyard-house', '', pair('A planted courtyard beside pale mineral walls, warm timber and a shaded stone threshold.', 'فناء مزروع بجانب جدران بتشطيبات طبيعية فاتحة وخشب دافئ وعتبة حجرية مظلّلة.'), pair('A planted opening brings daylight to the rooms around it. Architectural study image.', 'فتحة مزروعة تُدخل ضوء النهار إلى الغرف المحيطة. صورة لدراسة معمارية.'), [50, 50, 53, 50]),
      image('courtyard-house', 'exterior', pair('The restrained exterior and shaded entry of the conceptual Courtyard House.', 'واجهة هادئة ومدخل مظلّل لمنزل الفناء المتخيّل.'), pair('A threshold that slows the arrival. Architectural study image.', 'عتبة تُهدّئ لحظة الوصول. صورة لدراسة معمارية.')),
      image('courtyard-house', 'detail', pair('Close view of pale mineral walls, warm timber and a shaded stone threshold.', 'تفصيل للجدران ذات التشطيبات الطبيعية الفاتحة والخشب الدافئ والعتبة الحجرية المظلّلة.'), pair('Conceptual material study: pale mineral walls, warm timber, and a shaded stone threshold.', 'دراسة مواد مفاهيمية: جدران بتشطيبات طبيعية فاتحة وخشب دافئ وعتبة حجرية مظلّلة.')),
      image('courtyard-house', 'diagram', pair('Conceptual relationship diagram connecting arrival, living, courtyard, and quiet rooms.', 'رسم للعلاقات المكانية يربط الوصول والمعيشة والفناء والغرف الهادئة.'), pair('Authored conceptual diagram. Spatial relationships only; not a construction drawing.', 'رسم مفاهيمي من إعداد الاستوديو. يوضّح العلاقات المكانية فقط، وليس مخطّط بناء.')),
    ],
    sections: [
      { id: 'threshold', title: pair('A threshold that slows the arrival.', 'عتبة تُهدّئ لحظة الوصول.'), body: pair('The entrance shifts from an exposed edge to a shaded pause. A recessed opening gives the transition between outside and home a clear sense of depth.', 'ينتقل المدخل من حافة مكشوفة إلى وقفة مظلّلة. تمنح الفتحة الغائرة الانتقال من الخارج إلى المنزل عمقاً واضحاً.'), imageId: 'exterior' },
      { id: 'courtyard', title: pair('One opening, many relationships.', 'فتحة واحدة، وعلاقات متعددة.'), body: pair('The planted courtyard is the organizing space. Shared rooms face its light while quieter rooms sit behind a second layer, keeping daily movement simple without exposing every room.', 'الفناء المزروع هو المساحة المنظّمة. تتجه الغرف المشتركة نحو ضوئه، فيما تقع الغرف الأهدأ خلف طبقة ثانية؛ لتبقى الحركة اليومية واضحة من دون كشف جميع الغرف.'), imageId: 'diagram' },
      { id: 'light', title: pair('Light with room for privacy.', 'ضوء يفسح مجالاً للخصوصية.'), body: pair('Deep openings temper the light and frame the planting. The proposed response makes the courtyard present in daily life through views and short connections, rather than a long internal corridor.', 'تلطّف الفتحات العميقة الضوء وتؤطّر الزراعة. يربط التصوّر المقترح الحياة اليومية بالفناء عبر الإطلالات والمسارات القصيرة، بدلاً من ممر داخلي طويل.'), imageId: 'main' },
    ],
    materials: pair('Pale mineral walls, warm timber, and stone form a restrained palette. Their relationship is explored as a concept, with no claim of specified products or constructed work.', 'تشكّل الجدران ذات التشطيبات الطبيعية الفاتحة والخشب الدافئ والحجر لوحة مواد هادئة. تُدرس علاقتها ضمن تصور مفاهيمي، من دون ادّعاء تحديد منتجات أو تنفيذ مبنى.'),
    nextProject: 'line-studio',
  },
  {
    id: 'form-line-studio', slug: 'line-studio', title: pair('Line Studio', 'استوديو الخط'),
    summary: pair('Distinct but connected zones give shared work and quiet concentration their own space.', 'مناطق مستقلة ومترابطة تمنح العمل المشترك والتركيز الهادئ مساحتهما الخاصة.'),
    category: pair('Workplace study', 'دراسة مكان عمل'), year: 2026, status: 'Studio concept',
    location: pair('Fictional international urban setting', 'موقع حضري دولي متخيّل'), area: '180 m²',
    images: [
      image('line-studio', '', pair('A calm shared workplace with timber surfaces, daylight and connected work zones.', 'مكان عمل مشترك هادئ بأسطح خشبية وضوء نهار ومناطق عمل مترابطة.'), pair('Shared work and quiet concentration occupy connected zones. Architectural study image.', 'العمل المشترك والتركيز الهادئ في مناطق مترابطة. صورة لدراسة معمارية.'), [50, 50, 48, 50]),
      image('line-studio', 'exterior', pair('The entrance and street threshold of the conceptual Line Studio workplace.', 'مدخل وعتبة الشارع لمكان العمل المتخيّل استوديو الخط.'), pair('An urban threshold separates the street from a calm place to work. Architectural study image.', 'عتبة حضرية تفصل الشارع عن مكان هادئ للعمل. صورة لدراسة معمارية.')),
      image('line-studio', 'detail', pair('Timber joinery and a work surface within the conceptual studio.', 'تفصيل نجارة خشبية وسطح عمل داخل الاستوديو المتخيّل.'), pair('Conceptual material study: timber surfaces, pale walls, and quiet junctions.', 'دراسة مواد مفاهيمية: أسطح خشبية وجدران فاتحة والتقاءات هادئة.')),
      image('line-studio', 'diagram', pair('Conceptual relationship diagram connecting arrival, shared work, and quiet work.', 'رسم للعلاقات المكانية يربط الوصول والعمل المشترك والعمل الهادئ.'), pair('Authored conceptual diagram. Spatial relationships only; not a construction drawing.', 'رسم مفاهيمي من إعداد الاستوديو. يوضّح العلاقات المكانية فقط، وليس مخطّط بناء.')),
    ],
    sections: [
      { id: 'arrival', title: pair('An arrival that leaves the street behind.', 'وصول يترك الشارع خلفه.'), body: pair('A modest threshold creates a transition from the street to the shared studio. The entrance leads toward the social space before opening into the quieter work areas.', 'تُنشئ عتبة بسيطة انتقالاً من الشارع إلى الاستوديو المشترك. يقود المدخل إلى المساحة الاجتماعية قبل الانفتاح على مناطق العمل الأهدأ.'), imageId: 'exterior' },
      { id: 'zones', title: pair('Connected, without competing.', 'ترابط من دون تنافس.'), body: pair('A clear circulation line connects the shared table, meeting space and focused work. Each zone has a distinct use, allowing collaboration and concentration to remain close without occupying the same place.', 'يربط مسار حركة واضح بين الطاولة المشتركة ومساحة الاجتماع والعمل المركّز. لكل منطقة استخدام مستقل، بما يُبقي التعاون والتركيز قريبين من دون جمعهما في المكان نفسه.'), imageId: 'diagram' },
      { id: 'daylight', title: pair('A useful rhythm of light.', 'إيقاع مفيد للضوء.'), body: pair('Work surfaces sit near daylight while deeper zones provide quieter moments. The spatial response gives a small workplace variety through planning and material, rather than decorative separation.', 'تقترب أسطح العمل من ضوء النهار، وتوفّر المناطق الأعمق لحظات أهدأ. يمنح التصوّر المكاني مكان العمل الصغير تنوّعاً عبر التخطيط والمواد، بدلاً من الفصل الزخرفي.'), imageId: 'main' },
    ],
    materials: pair('Warm timber, pale walls, and carefully expressed joints give work surfaces a common language. This is an exploration of material relationships, rather than a product specification.', 'يمنح الخشب الدافئ والجدران الفاتحة والالتقاء الواضح بين المواد أسطحَ العمل لغة مشتركة. هذه دراسة لعلاقات المواد، وليست مواصفة منتجات.'),
    nextProject: 'shore-library',
  },
  {
    id: 'form-shore-library', slug: 'shore-library', title: pair('Shore Library', 'مكتبة الساحل'),
    summary: pair('A shaded threshold connects public gathering with quieter places to read.', 'عتبة مظلّلة تربط التجمع العام بأماكن أهدأ للقراءة.'),
    category: pair('Cultural-space study', 'دراسة مساحة ثقافية'), year: 2026, status: 'Studio concept',
    location: pair('Fictional coastal setting', 'موقع ساحلي متخيّل'), area: '620 m²',
    images: [
      image('shore-library', '', pair('A shaded library reading space with a calm material palette and coastal light.', 'مساحة قراءة مظلّلة في مكتبة بلوحة مواد هادئة وضوء ساحلي.'), pair('A shaded threshold connects gathering and reading. Architectural study image.', 'عتبة مظلّلة تربط التجمع بالقراءة. صورة لدراسة معمارية.'), [50, 50, 52, 50]),
      image('shore-library', 'exterior', pair('The shaded exterior threshold of the conceptual Shore Library.', 'العتبة الخارجية المظلّلة لمكتبة الساحل المتخيّلة.'), pair('A generous sheltered edge welcomes public gathering. Architectural study image.', 'حافة محمية واسعة تستقبل التجمع العام. صورة لدراسة معمارية.')),
      image('shore-library', 'detail', pair('A reading surface and the junction of timber and pale mineral material.', 'سطح للقراءة والتقاء الخشب بتشطيب طبيعي فاتح.'), pair('Conceptual material study: pale mineral surfaces, timber shelving, and filtered daylight.', 'دراسة مواد مفاهيمية: أسطح بتشطيبات طبيعية فاتحة ورفوف خشبية وضوء نهار مُرشّح.')),
      image('shore-library', 'diagram', pair('Conceptual relationship diagram connecting arrival, gathering, and quieter reading.', 'رسم للعلاقات المكانية يربط الوصول والتجمع والقراءة الهادئة.'), pair('Authored conceptual diagram. Spatial relationships only; not a construction drawing.', 'رسم مفاهيمي من إعداد الاستوديو. يوضّح العلاقات المكانية فقط، وليس مخطّط بناء.')),
    ],
    sections: [
      { id: 'threshold', title: pair('A shared edge before a quiet room.', 'حافة مشتركة قبل الغرفة الهادئة.'), body: pair('The shaded threshold is both an entrance and a place to pause. Its generous depth proposes a meeting point between the public setting and the quieter interior.', 'العتبة المظلّلة مدخل ومكان للتوقف معاً. يقترح عمقها الواسع نقطة لقاء بين المحيط العام والداخل الأهدأ.'), imageId: 'exterior' },
      { id: 'sequence', title: pair('From gathering to reading.', 'من التجمع إلى القراءة.'), body: pair('The conceptual relationship diagram organizes a gradual sequence: sheltered arrival, shared gathering, then smaller reading places. Circulation stays legible while offering a choice of quieter spaces.', 'ينظّم رسم العلاقات المفاهيمي تسلسلاً تدريجياً: وصول محمي، ثم تجمع مشترك، ثم أماكن قراءة أصغر. تبقى الحركة واضحة، مع إتاحة الاختيار بين مساحات أهدأ.'), imageId: 'diagram' },
      { id: 'shade', title: pair('Daylight, gently held.', 'ضوء نهار محتوى بلطف.'), body: pair('Deep openings and sheltered edges filter coastal light. The proposed spatial response holds books, people, and views within one calm rhythm without turning the reading room into a display.', 'ترشّح الفتحات العميقة والحواف المحمية الضوء الساحلي. يجمع التصوّر المكاني الكتب والناس والإطلالات في إيقاع هادئ واحد، من دون تحويل غرفة القراءة إلى مساحة عرض.'), imageId: 'main' },
    ],
    materials: pair('Pale mineral surfaces, timber shelving, and shaded openings connect the public edge with quieter rooms. These relationships are conceptual and do not establish constructed architectural work.', 'تربط الأسطح ذات التشطيبات الطبيعية الفاتحة والرفوف الخشبية والفتحات المظلّلة بين الحافة العامة والغرف الأهدأ. هذه العلاقات مفاهيمية، ولا تثبت تنفيذ عمل معماري.'),
    nextProject: 'courtyard-house',
  },
];
export const cloneProjects = projects => JSON.parse(JSON.stringify(projects));
export function validateProject(p, all = []) {
  const errors = {};
  const text = (path, value, min, max, label) => {
    if (typeof value !== 'string' || value.trim().length < min) errors[path] = `${label} is required.`;
    else if (value.length > max) errors[path] = `${label} must be ${max} characters or fewer.`;
  };
  text('id', p?.id, 1, 100, 'Stable ID');
  text('slug', p?.slug, 1, 100, 'Slug');
  if (p?.slug && !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(p.slug)) errors.slug = 'Use lowercase letters, numbers and single hyphens.';
  if (all.some(q => q !== p && q.slug === p?.slug && q.id !== p?.id)) errors.slug = 'Another project already uses this slug.';
  if (all.filter(q => q.id === p?.id).length > 1) errors.id = 'Stable IDs must be unique.';
  for (const locale of ['en', 'ar']) {
    text(`title.${locale}`, p?.title?.[locale], 1, 100, `${locale === 'en' ? 'English' : 'Arabic'} title`);
    text(`summary.${locale}`, p?.summary?.[locale], 1, 600, `${locale === 'en' ? 'English' : 'Arabic'} summary`);
    text(`category.${locale}`, p?.category?.[locale], 1, 100, `${locale === 'en' ? 'English' : 'Arabic'} category`);
    text(`location.${locale}`, p?.location?.[locale], 1, 200, `${locale === 'en' ? 'English' : 'Arabic'} location`);
    text(`materials.${locale}`, p?.materials?.[locale], 1, 3000, `${locale === 'en' ? 'English' : 'Arabic'} material explanation`);
  }
  if (!Number.isInteger(Number(p?.year)) || Number(p?.year) < 1900 || Number(p?.year) > 2100) errors.year = 'Enter a study year between 1900 and 2100.';
  if (p?.status !== 'Studio concept') errors.status = 'Status must be Studio concept; this demo cannot publish constructed or client work.';
  if (p?.area && (typeof p.area !== 'string' || p.area.length > 60)) errors.area = 'Area must be 60 characters or fewer.';
  if (!Array.isArray(p?.images) || !p.images.length) errors.images = 'Add at least one study image.';
  else p.images.forEach((im, i) => {
    text(`images.${i}.id`, im.id, 1, 100, 'Image ID');
    text(`images.${i}.src`, im.src, 1, 300, 'Image source');
    if (im.src && !/^\.\.\/studies\/[a-z0-9-]+\.(?:webp|png|jpg|jpeg|svg)$/.test(im.src)) errors[`images.${i}.src`] = 'Use a local study image from ../studies/.';
    if (p.images.filter(q => q.id === im.id).length > 1) errors[`images.${i}.id`] = 'Image IDs must be unique.';
    for (const locale of ['en', 'ar']) {
      text(`images.${i}.alt.${locale}`, im.alt?.[locale], 1, 500, 'Image description');
      text(`images.${i}.caption.${locale}`, im.caption?.[locale], 1, 600, 'Image caption');
    }
    for (const size of ['desktop', 'mobile']) for (const axis of ['x', 'y']) {
      const value = im.focal?.[size]?.[axis];
      if (typeof value !== 'number' || !Number.isFinite(value) || value < 0 || value > 100) errors[`images.${i}.focal.${size}.${axis}`] = 'A focal point must be a number from 0 to 100.';
    }
  });
  if (!Array.isArray(p?.sections) || !p.sections.length) errors.sections = 'Add at least one ordered story section.';
  else p.sections.forEach((section, i) => {
    text(`sections.${i}.id`, section.id, 1, 100, 'Story section ID');
    if (p.sections.filter(q => q.id === section.id).length > 1) errors[`sections.${i}.id`] = 'Story section IDs must be unique.';
    for (const locale of ['en', 'ar']) {
      text(`sections.${i}.title.${locale}`, section.title?.[locale], 1, 160, 'Story title');
      text(`sections.${i}.body.${locale}`, section.body?.[locale], 1, 3000, 'Story text');
    }
    if (!p.images?.some(im => im.id === section.imageId)) errors[`sections.${i}.imageId`] = 'Choose an existing image for this section.';
  });
  if (!p?.nextProject || (all.length && !all.some(q => q.slug === p.nextProject && q.id !== p.id))) errors.nextProject = 'Choose another existing project as the next project.';
  return errors;
}
export function loadProjects() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null');
    if (Array.isArray(saved) && saved.length && saved.every(p => !Object.keys(validateProject(p, saved)).length)) return saved;
  } catch (_) { /* A private or unavailable store falls back to the authored fixtures. */ }
  return cloneProjects(DEFAULT_PROJECTS);
}
export function saveProjects(projects) {
  if (!Array.isArray(projects) || !projects.length) throw new Error('A project collection is required.');
  const invalid = projects.map(p => ({ p, errors: validateProject(p, projects) })).find(item => Object.keys(item.errors).length);
  if (invalid) throw new Error(Object.values(invalid.errors)[0]);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(projects));
  return cloneProjects(projects);
}
