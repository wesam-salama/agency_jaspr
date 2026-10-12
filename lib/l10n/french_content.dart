part of 'site_content.dart';

final _frenchCases = _localizedCases(const [
  _CaseCopy(
    tag: 'Refonte de marque et site web · 2025',
    role: 'Identité, conception et développement web',
    timeline: '9 semaines',
    deliverables: 'Système d’identité, guide, site, CMS',
    lede: CaseLede(
      'Quarante ans d’ébénisterie repensés pour un public sensible au design, ',
      'sans perdre l’esprit de l’atelier',
      '.',
    ),
    facts: [
      CaseFact('Problème', 'Une marque plus âgée que son public'),
      CaseFact('Direction', 'Garder l’atelier, renouveler le discours'),
      CaseFact('Système', 'Signature typographique, grille, palette bois'),
      CaseFact('Site', 'Développement sur mesure, CMS transmis'),
    ],
    paragraphs: [
      'Fenwick & Ash fabriquait de beaux meubles, mais sa communication évoquait une annonce dans l’annuaire. L’audit a conservé ce qui avait de la valeur — le nom, l’héritage et la clientèle — et écarté le reste.',
      'Le site reprend la même grille. Chaque page projet est un dossier : commande, essence de bois, heures passées à l’établi. L’équipe peut le mettre à jour elle-même grâce au CMS qui lui a été transmis.',
    ],
    figureCaptions: [
      'Direction artistique : des lieux de vie, pas des salles d’exposition',
      'Photographie produit : un objet, une lumière',
    ],
    chapterTitles: [],
    chapterBodies: [],
    metricLabels: [],
    metricSuffixes: [],
    quote: CaseQuote(
      '« Ils ont préservé quarante ans d’histoire tout en nous donnant une image tournée vers l’avenir. »',
      'E. Fenwick, directeur général',
    ),
  ),
  _CaseCopy(
    tag: 'Produit et application · 2024',
    role: 'Conception produit, iOS et Android',
    timeline: '11 semaines',
    deliverables: 'Système de design, application, publication dans les boutiques d’applications',
    lede: CaseLede(
      'Une application de suivi des habitudes que l’on a envie de ',
      'rouvrir',
      ', du parcours d’accueil jusqu’à l’App Store.',
    ),
    paragraphs: [
      'La plupart des applications d’habitudes cultivent la culpabilité. Loop mise sur des séries indulgentes : si vous manquez un jour, la ligne fléchit mais ne se rompt pas. Cette seule décision produit a façonné tout le système de design : courbes douces, tons sombres chaleureux, une couleur d’accent.',
    ],
    figureCaptions: [],
    chapterTitles: [
      'Accueil : 90 secondes maximum',
      'Des séries qui fléchissent sans se rompre',
      'Widgets d’écran d’accueil',
      'Bilan hebdomadaire sans culpabilité',
    ],
    chapterBodies: [null, null, null, null],
    metricLabels: [],
    metricSuffixes: [],
    quote: CaseQuote(
      '« La rétention à J+30 a doublé par rapport à l’ancien prototype. C’est cette tolérance envers les jours manqués qui a fait la différence. »',
      'Responsable produit, Loop',
    ),
  ),
  _CaseCopy(
    tag: 'Marque et conseil · 2024',
    role: 'Choix du nom, positionnement, identité',
    timeline: '6 semaines',
    deliverables: 'Nom, ton de marque, identité, emballage',
    lede: CaseLede(
      'Une boucherie en vente directe face à un ',
      'rayon saturé',
      ' : un nom, un positionnement et une identité.',
    ),
    figureCaptions: [],
    chapterTitles: ['Choix du nom', 'Positionnement', 'Identité'],
    chapterBodies: [
      'La liste est passée de quarante noms à quatre, puis à un. « Marrow » l’a emporté parce que c’est la partie de l’animal que les chefs se disputent : profondeur, richesse, substance.',
      'Le rayon proclame déjà « artisanal, en petites séries ». Marrow se distingue par la transparence de son origine : ferme, distance et durée de maturation figurent sur chaque emballage.',
      'Une signature typographique massive comme un billot de boucher, un accent rouge sang et un emballage qui se lit comme une fiche technique. L’identité se démarque par sa retenue.',
    ],
    metricLabels: [],
    metricSuffixes: [],
  ),
  _CaseCopy(
    tag: 'Développement web · 2023',
    role: 'Expérience utilisateur, refonte complète de l’interface et du serveur',
    timeline: '14 semaines',
    deliverables: 'Plateforme, moteur d’itinéraires, tableaux de bord',
    lede: CaseLede(
      'Une plateforme logistique reconstruite depuis la base de données, pour la rapidité comme pour ',
      'les personnes qui l’utilisent chaque jour',
      '.',
    ),
    paragraphs: [
      'L’ancien système mettait onze secondes à afficher le tableau du matin. Les responsables de répartition avaient appris à contourner ses lenteurs. Nous avons d’abord reconstruit la couche de requêtes, puis conçu l’interface autour de leurs trois vraies questions : qu’est-ce qui est en retard, qu’est-ce qui est disponible, quelle est la suite ?',
    ],
    figureCaptions: [
      'Le réseau : 400 véhicules, un seul tableau',
      'Moteur d’itinéraires : recalcul toutes les 90 secondes',
    ],
    chapterTitles: [],
    chapterBodies: [],
    metricLabels: [
      'Requêtes d’itinéraires plus rapides',
      'Itinéraires replanifiés chaque jour',
      'Temps médian de chargement du tableau de bord',
    ],
    metricSuffixes: ['%', '', 's'],
    quote: CaseQuote(
      '« Le tableau du matin se charge avant que mon café soit prêt. Voilà tout le compte rendu. »',
      'Directeur des opérations, Northline',
    ),
  ),
]);

SiteContent _frenchContent() => SiteContent(
  locale: SiteLocale.fr,
  siteTitle: 'Creative Media — Identité de marque, web et applications',
  siteDescription:
      'Creative Media : identité de marque, refonte, conseil, développement web et d’applications, maintenance. Une équipe, une vision, de la première esquisse au produit lancé.',
  heroEyebrow: 'Studio de marque et de produit',
  heroHeadline: 'Chaque marque est faite de quelques points. Nous traçons la ligne qui les relie.',
  heroHeadlineParts: const CaseLede(
    'Chaque marque est faite de quelques points. Nous traçons la ',
    'ligne',
    ' qui les relie.',
  ),
  heroDescription:
      'Creative Media est un petit studio qui réunit création et refonte de marques, conseil, développement de sites et d’applications, ainsi que la maintenance qui les fait durer. Une seule équipe, une même vision, de la première esquisse au produit livré.',
  heroHint: 'Survolez les six points pour tracer la ligne · déplacez le curseur pour laisser une trace',
  sectionCopy: const {
    'services': SectionCopy(
      'Nos métiers',
      'Six services. Un point chacun.',
      'Six points ne racontent pas tout le studio. Ajoutez le septième — vous, notre client — et la forme se referme. Chaque service peut être mené seul ou intégré à un programme plus vaste.',
    ),
    'work': SectionCopy(
      'Réalisations choisies',
      'Quelques lignes récemment tracées.',
      'Au survol, les points s’écartent pour dévoiler l’image. Ouvrez une étude de cas : chacune possède sa propre transition.',
    ),
    'process': SectionCopy(
      'Notre méthode',
      'Six étapes, dans l’ordre, reliées au fil du projet.',
      'Le périmètre change d’un projet à l’autre. L’ordre des étapes et leurs livrables, rarement. Les délais ci-dessous sont indicatifs.',
    ),
    'engagement': SectionCopy(
      'Travailler ensemble',
      'Trois façons de commencer.',
      'La plupart des projets commencent sous l’une de ces formes. Nous vous dirons franchement laquelle convient avant tout engagement.',
    ),
    'faq': SectionCopy(
      'Questions',
      'Avant de nous écrire.',
      'Une autre question ? Utilisez le formulaire ci-dessous. Nous répondons sous un jour ou deux.',
    ),
    'studio': SectionCopy('Le studio', 'Une petite équipe, par choix.', ''),
    'contact': SectionCopy(
      'Parlons de votre projet',
      'Dites-nous ce dont vous avez besoin. Nous nous occupons du reste.',
      'Choisissez vos points. La ligne vers « Vous » se trace, la forme se referme et les détails accompagnent votre e-mail.',
    ),
  },
  processSteps: const [
    ProcessStep(
      name: 'Échanger',
      duration: '3 à 5 jours',
      description:
          'Nous commençons par comprendre votre activité, votre marché et l’écart entre votre situation actuelle et votre ambition, avant toute proposition.',
      deliverables: [
        'Échange de découverte et entretiens avec les parties prenantes',
        'Étude rapide du marché et des concurrents',
        'Synthèse écrite de ce que nous avons compris',
      ],
    ),
    ProcessStep(
      name: 'Définir',
      duration: 'Environ 1 semaine',
      description:
          'Positionnement, recherche de nom et périmètre sont arrêtés ici, avant le début du design, plutôt que résolus en parallèle.',
      deliverables: [
        'Atelier de positionnement et de recherche de nom',
        'Document de cadrage et calendrier',
        'Indicateurs de réussite définis ensemble',
      ],
    ),
    ProcessStep(
      name: 'Concevoir',
      duration: '2 à 4 semaines',
      description:
          'Identité, interface ou les deux : le design traduit les décisions de l’étape précédente au lieu de chercher seulement à séduire visuellement.',
      deliverables: [
        'Direction créative et système de design',
        'Cycles de validation structurés',
        'Retours suivis, pas des commentaires dispersés',
      ],
    ),
    ProcessStep(
      name: 'Développer',
      duration: '3 à 8 semaines',
      description:
          'Sites et applications sont codés à la main et testés avec vos vrais contenus, sur de vrais appareils, pas avec du texte provisoire sur un seul ordinateur.',
      deliverables: [
        'Développement en cycles hebdomadaires',
        'Environnement de préproduction pour les revues',
        'Tests qualité sur navigateurs et appareils',
      ],
    ),
    ProcessStep(
      name: 'Lancer',
      duration: 'Environ 1 semaine',
      description:
          'Nous mettons en ligne, vérifions les appareils accessibles et vous transmettons un produit que votre équipe sait réellement utiliser.',
      deliverables: [
        'Liste de vérification avant lancement',
        'DNS ou soumission à l’App Store et au Play Store',
        'Présentation pratique à votre équipe',
      ],
    ),
    ProcessStep(
      name: 'Maintenir',
      duration: 'En continu',
      description:
          'Le suivi garde le produit rapide et à jour, pour que le jour du lancement ne reste pas son meilleur jour.',
      deliverables: [
        'Points mensuels',
        'Mises à jour et suivi de disponibilité',
        'Correctifs prioritaires et petites évolutions',
      ],
    ),
  ],
  engagements: const [
    Engagement(
      name: 'Projet',
      tag: 'Ponctuel',
      description:
          'Un livrable défini, du début à la fin : une refonte de marque, un nouveau site ou une nouvelle application.',
      features: [
        'Périmètre et prix fixes',
        'Une discipline ou deux étroitement liées',
        'Transmission claire en fin de mission',
      ],
      terms: 'Généralement 4 à 10 semaines',
    ),
    Engagement(
      name: 'Programme',
      tag: 'Le plus fréquent',
      description:
          'Plusieurs disciplines coordonnées : une refonte de marque et un site, ou une application avec un accompagnement design continu.',
      features: [
        'Coordination entre marque, web et produit',
        'Un seul interlocuteur pour l’ensemble',
        'Livraisons par étapes, revues au fil du travail',
      ],
      terms: 'Généralement 2 à 4 mois',
    ),
    Engagement(
      name: 'Partenariat',
      tag: 'En continu',
      description:
          'Un forfait mensuel pour les équipes qui souhaitent disposer d’un partenaire design et développement mobilisable à la demande, plutôt que d’un prestataire ponctuel.',
      features: [
        'Capacité réservée chaque mois',
        'Maintenance et nouveaux travaux inclus',
        'Renouvellement mensuel, sans engagement durable',
      ],
      terms: 'Mensuel, résiliable à tout moment',
    ),
  ],
  studioParagraphs: const [
    'Creative Media reste assez petit pour que les personnes qui présentent le projet soient aussi celles qui le réalisent. Aucun transfert vers une autre équipe après la signature.',
    'Nous travaillons avec des fondateurs et des responsables marketing pour qui une marque et son site forment un seul système cohérent, plutôt qu’un logo d’un côté, un site de l’autre et l’espoir qu’ils s’accordent.',
  ],
  studioValues: const [
    'Une équipe, de la stratégie jusqu’au produit livré',
    'Tout est créé sur mesure, sans thème ni modèle prêt à l’emploi',
    'Les choix de design répondent aux objectifs du projet, pas à une tendance',
    'La maintenance est prévue dès le départ',
  ],
  faqs: const [
    (
      'Combien de temps dure un projet en général ?',
      'La plupart des projets relevant d’une seule discipline durent de 4 à 10 semaines : une identité se situe plutôt en bas de cette fourchette, une application plutôt en haut. Les programmes combinés, par exemple marque et web, prennent généralement 2 à 4 mois. Vous recevrez un calendrier précis avant toute validation.',
    ),
    (
      'Travaillez-vous avec des jeunes entreprises ou seulement des marques établies ?',
      'Avec les deux. Les jeunes équipes commencent souvent par le conseil et l’identité de marque ; les marques établies viennent plus fréquemment pour une refonte de marque ou de site. Le périmètre s’adapte à votre stade de développement.',
    ),
    (
      'Que comprend exactement la maintenance ?',
      'Les mises à jour logicielles et des extensions, le suivi de disponibilité et des erreurs, les correctifs prioritaires ainsi que les petites modifications de contenu ou de fonctionnalités : cet entretien que l’on remet souvent à plus tard, jusqu’à la panne.',
    ),
    (
      'Travaillez-vous avec des équipes hors du Royaume-Uni ?',
      'Oui. L’essentiel de la collaboration passe par des appels et des validations asynchrones ; quelques heures de chevauchement entre fuseaux horaires suffisent. Si un projet demande davantage de présence sur place, nous vous le signalerons tôt.',
    ),
    (
      'Pouvons-nous vous confier une seule partie, par exemple le site ?',
      'Oui. Chacun des six services peut être commandé seul sous forme de Projet. S’il faut ensuite lui associer un volet complémentaire, comme une identité pour ce site, nous pouvons l’intégrer à un Programme sans repartir de zéro.',
    ),
  ],
  services: const [
    Service(
      name: 'Identité de marque',
      ctaLabel: 'Construisons votre marque →',
      duration: '2 à 4 semaines',
      description:
          'Des systèmes d’identité qui fonctionnent à toutes les échelles : favicon, emballage ou façade d’immeuble.',
      deliverables: [
        'Contribution à la stratégie et au positionnement',
        'Logo, couleurs, typographies et système d’identité',
        'Guide de marque',
      ],
    ),
    Service(
      name: 'Refonte de marque',
      ctaLabel: 'Faisons évoluer votre marque →',
      duration: '3 à 5 semaines',
      description:
          'Pour les entreprises qui ont dépassé leur histoire de départ. Nous gardons ce qui a fait ses preuves et écartons le reste.',
      deliverables: [
        'Audit du capital de marque existant',
        'Système d’identité actualisé ou reconstruit',
        'Plan de déploiement sur les points de contact',
      ],
    ),
    Service(
      name: 'Conseil',
      ctaLabel: 'Clarifions votre stratégie →',
      duration: '1 à 2 semaines',
      description:
          'Positionnement, recherche de nom et réflexion sur la mise sur le marché, avant de déplacer le moindre pixel.',
      deliverables: [
        'Étude rapide du marché et des concurrents',
        'Atelier de positionnement et de recherche de nom',
        'Recommandations écrites et document de cadrage',
      ],
    ),
    Service(
      name: 'Développement web',
      ctaLabel: 'Créons votre site →',
      duration: '3 à 8 semaines',
      description:
          'Des sites rapides et soignés, codés à la main plutôt qu’assemblés à partir d’un thème ou d’un constructeur de pages.',
      deliverables: [
        'Conception et développement sur mesure, sans modèle',
        'Transmission du CMS si vous souhaitez modifier le contenu',
        'Contrôle des performances et des bases du référencement',
      ],
    ),
    Service(
      name: 'Développement d’applications',
      ctaLabel: 'Créons votre application →',
      duration: '6 à 12 semaines',
      description:
          'Des produits natifs et multiplateformes conçus pour que l’on ait envie de les rouvrir demain, pas seulement une fois.',
      deliverables: [
        'Design produit et parcours d’interaction',
        'Développement iOS, Android ou multiplateforme',
        'Soumission à l’App Store et au Play Store',
      ],
    ),
    Service(
      name: 'Maintenance',
      ctaLabel: 'Assurons le suivi →',
      duration: 'En continu',
      description:
          'Un suivi continu : mises à jour, surveillance et petites corrections avant qu’elles ne deviennent de gros problèmes.',
      deliverables: [
        'Mises à jour mensuelles et suivi de disponibilité',
        'Corrections de bogues prioritaires',
        'Petites modifications de contenu et de fonctionnalités',
      ],
    ),
  ],
  caseStudies: _frenchCases,
  workProjects: _localizedWork(_frenchCases, const [
    _WorkCopy(
      'Identité · Web · CMS',
      'Refonte de marque et site web',
      'L’identité d’un fabricant de meubles fort de 40 ans d’histoire, repensée pour un public sensible au design sans perdre l’esprit de l’atelier.',
    ),
    _WorkCopy(
      'Produit · iOS · Android',
      'Produit et application',
      'Une application de suivi des habitudes menée du parcours d’accueil à l’App Store : système de design, développement et lancement.',
    ),
    _WorkCopy(
      'Nom · Positionnement · Identité',
      'Marque et conseil',
      'Recherche de nom et positionnement pour une marque de boucherie en vente directe entrant dans un marché saturé.',
    ),
    _WorkCopy(
      'Expérience utilisateur · Développement · Base de données',
      'Développement web',
      'Une plateforme logistique reconstruite depuis la base de données, pour la rapidité et pour ceux qui l’utilisent chaque jour.',
    ),
  ]),
  serviceNames: const ['Identité', 'Refonte', 'Conseil', 'Web', 'Applications', 'Maintenance'],
  timingLabels: const {
    'unsure': 'Pas encore défini',
    'soon': 'Dès que possible',
    'oneToThree': 'Sous 1 à 3 mois',
    'later': 'Plus tard',
  },
  uiText: _frenchUi,
);
