part of 'site_content.dart';

final _frenchCases = _localizedCases(const [
  _CaseCopy(
    tag: 'Stratégie de marque et identité · 2026',
    client: 'Projet personnel du studio',
    role: 'Stratégie, nom, identité et packaging',
    timeline: 'Étude de design',
    deliverables: 'Système d’identité, packaging bilingue, fiches de préparation et guide de marque',
    lede: CaseLede(
      'Une identité de café conçue autour de ',
      'choix clairs',
      ', de la première étiquette au plus petit détail.',
    ),
    facts: [],
    paragraphs: [
      'Sift Coffee est une étude de marque initiée par le studio pour les amateurs de café à la maison. L’idée est simple : une petite collection, un point de départ clair et des informations utiles sur chaque support. Un bon café. Un choix clair.',
      'Trois directions donnent un rythme clair à la collection : Everyday pour une tasse quotidienne équilibrée, Daybreak pour des saveurs plus vives, et After Hours pour un profil plus profond. Des règles d’étiquetage communes rendent les différences faciles à repérer tout en maintenant la cohérence de la gamme.',
    ],
    chapterTitles: [
      'Une ligne qui rend le choix visible',
      'Trois points de départ clairs',
      'L’anglais et l’arabe, avec la même attention',
      'Une identité au-delà du sachet',
    ],
    chapterBodies: [
      'Sift évoque la sélection et l’affinement. La ligne choisie donne une forme visible à cette idée : cinq lignes horizontales, dont une plus longue en bleu cobalt. Papier chaleureux, encre sombre et signature aux espacements optiques créent une identité précise sans froideur. Le même motif fonctionne sur une étiquette, une fiche de préparation et une petite icône de profil.',
      'Everyday est le point de départ quotidien et équilibré, Daybreak la direction plus vive, et After Hours la tasse plus profonde. Orange torréfié, cobalt et encre sombre les distinguent, tandis que leurs noms restent lisibles en niveaux de gris. Chaque étiquette présente le produit, la direction aromatique et le poids avant les détails spécialisés.',
      'L’anglais et l’arabe partagent une hiérarchie réfléchie. L’arabe conserve ses formes naturelles, ses espacements et son interligne ; il ne devient pas une traduction reléguée en petits caractères. Origine, traitement et champs variables de date de torréfaction restent faciles à trouver. Les formats 250 g et 1 kg suivent les mêmes règles à des tailles confortables.',
      'Fiches de préparation, coffret découverte, supports d’expédition et mises en page réutilisables prolongent l’identité au-delà de l’étiquette. Les fichiers modifiables et le guide rendent les décisions inspectables : tailles optiques du logo, hiérarchie bilingue, repères de gamme et informations variables. La livraison associe fichiers réutilisables et règles d’utilisation claires, pour conserver le même soin sur chaque nouvelle application.',
    ],
    downloads: [
      CaseDownload(label: 'Guide de marque', href: 'assets/selected-work/sift/sift-brand-guide.pdf', format: 'PDF'),
      CaseDownload(label: 'Fichiers modifiables', href: 'assets/selected-work/sift/sift-artwork.zip', format: 'ZIP'),
    ],
  ),
  _CaseCopy(
    tag: 'Refonte de marque et relancement du site · 2026',
    heroAlt:
        'Identité Form Architecture et extrait réel de sa page d’accueil avec une image générée de l’étude spatiale Courtyard House.',
    client: 'Projet personnel du studio',
    role: 'Stratégie conceptuelle, identité, direction artistique, UX/UI et réalisation du site',
    timeline: 'Étude de design et de réalisation',
    deliverables:
        'Identité, images d’études architecturales, site responsive, éditeur de projets et demande de démonstration',
    lede: CaseLede(
      'Une identité inspirée des matières et un site de projets pour mieux explorer les ',
      'décisions architecturales',
      '.',
    ),
    paragraphs: [
      'Form Architecture est une étude de refonte de marque et de site initiée par le studio. Le positionnement, « Une architecture façonnée autour de la vie quotidienne », fait de la lumière, des matières, du mouvement et de l’usage une manière d’expliquer chaque espace. Les trois études architecturales sont fictives ; leurs images générées et leurs schémas conceptuels sont documentés dans le registre des sources.',
      'L’identité de départ fictive présentait les projets comme des images déconnectées. Nous avons créé cette version pour l’exercice, puis défini une manière plus claire de relier espace, contexte et demande. Les deux versions utilisent Courtyard House, Line Studio et Shore Library, afin de conserver les mêmes projets dans la comparaison.',
      'La reconnaissance passe par le maintien du nom Form et du cadre ouvert. Une signature vectorielle affinée, un cadre vertical de proportion 3:4 ouvert en bas à droite et une palette craie, charbon, sauge et argile portent la même idée dans la navigation, la papeterie et les faits des projets. Cormorant Garamond donne de l’espace aux textes éditoriaux ; Instrument Sans et IBM Plex Sans Arabic gardent l’information utile dans les deux sens de lecture.',
      'Le site responsive place le brief à côté de la réponse spatiale et donne à chaque étude un récit ordonné. Faits, légendes et détails de matières expliquent ce que montre l’image. L’anglais et l’arabe partagent les mêmes données, avec des formes arabes naturelles et des noms de projets latins lisibles.',
      '« Discuter d’un projet similaire » conserve l’étude choisie dans la page Contact. La validation près des champs préserve le brouillon, indique les informations manquantes et place le focus sur le premier champ invalide. L’aperçu du récapitulatif se termine clairement : « Démonstration terminée. Cette demande n’a pas été envoyée. »',
      'L’éditeur local rend le contenu inspectable : identifiants stables, slugs uniques, titres bilingues, faits, chapitres ordonnés, descriptions d’images et points focaux distincts pour ordinateur et mobile. Modifier, prévisualiser et publier démontrent un changement local du contenu ; les champs obligatoires bloquent une publication incomplète. Site, éditeur et récapitulatif sont des démonstrations fonctionnelles, sans lancement commercial ni construction architecturale revendiqués.',
    ],
    facts: [
      CaseFact('Positionnement', 'Une architecture façonnée autour de la vie quotidienne.'),
      CaseFact('Repères conservés', 'Nom Form · cadre structurel ouvert'),
      CaseFact('Études de référence', 'Courtyard House · Line Studio · Shore Library'),
      CaseFact('Courtyard House', 'Étude résidentielle · 2025 · cadre méditerranéen fictif · 240 m²'),
      CaseFact('Line Studio', 'Étude de lieu de travail · 2026 · cadre urbain international fictif · 180 m²'),
      CaseFact('Shore Library', 'Étude d’espace culturel · 2026 · cadre côtier fictif · 620 m²'),
      CaseFact(
        'Périmètre numérique',
        'Site responsive · éditeur local de projets · demande contextualisée de démonstration',
      ),
      CaseFact(
        'Origine des images',
        'Images générées d’études architecturales et schémas conceptuels créés pour le projet ; registre des sources inclus.',
      ),
    ],
    figureCaptions: [
      'Identité de départ fictive créée pour cette étude. La véritable page d’accueil initiale utilise les trois mêmes études, une signature sur deux lignes et un cadre bleu ardoise.',
      'La page d’accueil au même format après la refonte : repères conservés, couleurs inspirées des matières, proportions d’images cohérentes et informations à côté de l’image concernée.',
      'Un système d’identité relie la signature sur mesure, le cadre ouvert 3:4, les rôles des couleurs, les typographies éditoriales et fonctionnelles, et les applications anglaises et arabes.',
      'Véritable page du projet Courtyard House : lumière, intimité et cour plantée organisent le récit avec les faits de l’étude et sa surface de 240 m².',
      'La page mobile réalisée place image, légende et explication dans une séquence réfléchie, avec des faits et des commandes confortablement lisibles.',
      'Brouillon réellement saisi, validation près des champs et récapitulatif de démonstration. Une demande invalide conserve le brouillon et explique la suite ; le récapitulatif précise que rien n’a été envoyé.',
      'L’éditeur de projets réalisé et le changement correspondant dans la page : modification, aperçu et publication locale, avec champs obligatoires et points focaux structurés.',
      'La règle d’espace libre de la signature reste cohérente dans une navigation étroite et sur l’artwork de couverture imprimée.',
      'Les cadrages ordinateur et mobile conservent le même élément spatial significatif ; leurs points focaux sont modifiables et l’image complète reste consultable.',
      'Faits, unités et légendes gardent un ordre de lecture cohérent en anglais et en arabe ; les faits facultatifs absents sont omis.',
    ],
    downloads: [
      CaseDownload(
        label: 'Explorez le site Form',
        href: 'assets/selected-work/form/site/index.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Ouvrez l’éditeur de projets',
        href: 'assets/selected-work/form/site/editor.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(label: 'Sources modifiables', href: 'assets/selected-work/form/form-source.zip', format: 'ZIP'),
    ],
  ),
  _CaseCopy(
    tag: 'Marque, site et application · 2026',
    heroAlt:
        'Cahier Frame Academy avec de véritables écrans de découverte du cours et de reprise dans l’application native.',
    client: 'Projet personnel du studio',
    role: 'Stratégie, identité, supports de cours, web et application mobile Flutter',
    timeline: 'Étude de design et de réalisation',
    deliverables: 'Identité et cahiers modifiables, leçon sous-titrée, site EN/AR, démo iOS et progression partagée',
    lede: CaseLede(
      'Une académie créative organisée autour de ',
      'la prochaine étape utile',
      ', du choix d’un cours au retour à la leçon.',
    ),
    paragraphs: [
      'Frame Academy est une marque d’apprentissage pratique en photographie, cinéma et design visuel, initiée par le studio. Make your next idea invite à trouver un point de départ clair, essayer un petit exercice et suivre une prochaine étape utile. Composition Essentials relie le site de découverte à une application Flutter en fonctionnement.',
      'Deux angles ouverts et décalés donnent un point de vue aux supports de cours. Space Grotesk, Inter et IBM Plex Sans Arabic aux formes naturelles composent une surface claire, une encre sombre et des actions bleues précises. Le cahier expressif devient une interface d’apprentissage plus calme, avec résultat attendu et équipement visibles avant l’inscription.',
      'Les parcours enregistrés en anglais et en arabe commencent à 0 sur 6. Une leçon produite dispose de sous-titres et d’une transcription ; sa durée réelle est distincte du temps prévu au programme. La sauvegarde confirmée, la validation explicite de l’exercice et le redémarrage conservent 1 leçon sur 6 terminée et reprennent à la leçon 02, Find the subject. Un échec de sauvegarde contrôlé préserve la note jusqu’à la réussite du nouvel essai. Cette démonstration locale ne revendique ni correction par un enseignant ni lancement commercial.',
    ],
    chapterTitles: [
      'Choisir en connaissance de cause',
      'Une identité qui vous accompagne',
      'Garder la suite visible',
      'Réessayer sans perdre le travail',
    ],
    chapterBodies: [
      'La véritable page du cours présente résultat, équipement et prérequis près de la décision. Composition Essentials, FA-PH-01, comprend six leçons et 62 minutes d’étude prévues. L’aperçu produit explique l’exercice avant de poursuivre comme Demo learner.',
      'Signature personnalisée, deux angles en L décalés, couvertures et fiches d’exercice partagent un système mesuré. Le symbole conserve son orientation selon la langue ; les formes arabes restent naturelles et les contrôles directionnels suivent la lecture.',
      'Après redémarrage, l’application native affiche 1 leçon sur 6 terminée et la prochaine action : 02 Find the subject. Inscription, progression et brouillons utilisent le même enregistrement local que le site. Ouvrir le lecteur ne termine jamais une leçon.',
      'Un échec de sauvegarde contrôlé laisse la note intacte. Le nouvel essai confirme la persistance avant le message de sauvegarde ; la validation reste une action distincte. De véritables captures anglaises et arabes montrent le travail préservé, l’exercice sauvegardé et la prochaine étape utile.',
    ],
    downloads: [
      CaseDownload(
        label: 'Explorer Frame Academy',
        href: 'assets/selected-work/frame/site/index.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Voir le parcours enregistré',
        href: 'assets/selected-work/frame/demo-journey.mp4',
        format: 'MP4',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Sources modifiables du projet',
        href: 'assets/selected-work/frame/frame-source.zip',
        format: 'ZIP',
      ),
    ],
  ),
  _CaseCopy(
    tag: 'Marque et boutique e-commerce · 2026',
    heroAlt:
        'Signature FOLD dessinée pour le projet avec une capsule de quatre vêtements, représentés par des images conceptuelles générées.',
    client: 'Projet personnel du studio',
    role: 'Stratégie, identité, direction artistique des vêtements, UX/UI et réalisation de la boutique',
    timeline: 'Étude de design et de réalisation',
    deliverables: 'Identité et packaging modifiables, images de vêtements, boutique EN/AR et commande simulée',
    lede: CaseLede(
      'Une identité de vêtements réfléchie et une boutique organisée autour de ',
      'choix de produits clairs',
      '.',
    ),
    metricLabels: [],
    metricSuffixes: [],
    quote: null,
    paragraphs: [
      'Fold Clothing est une étude de marque et de boutique e-commerce initiée par le studio. Clothes that give your day room exprime la proposition : des silhouettes utiles, une construction réfléchie et des choix clairs. Collection 01: Everyday Structure réunit Box Shirt, Pleat Trouser, Layer Vest et Field Overshirt.',
      'La signature FOLD et les lignes de patron s’inspirent de la construction des vêtements. Ivoire, encre, jaune citronné et olive foncé encadrent la collection ; Archivo porte la voix éditoriale et DM Sans les informations d’achat. IBM Plex Sans Arabic conserve des formes naturelles et un rythme de lecture confortable dans la boutique arabe.',
      'Un patron fixe définit chaque vêtement avant la production des images : cinq boutons et une poche poitrine pour la chemise, un pli avant par jambe et des poches latérales pour le pantalon, quatre boutons et deux poches plaquées pour le gilet, six boutons et deux poches poitrine pour la surchemise. Les visuels générés sont des images conceptuelles, enregistrées séparément des véritables captures de la boutique. Matières, stocks et prix sont des données illustratives du catalogue.',
      'La boutique réalisée en anglais et en arabe associe couleur, images, taille et SKU. Les filtres dans l’URL conservent la sélection ; il faut choisir une taille avant d’ajouter un article. Layer Vest Stone/XS est indiqué indisponible. Un changement de taille vérifie à nouveau le stock, sans accepter implicitement une autre variante.',
      'Le guide explique la méthode avant le tableau : mesures du vêtement posé à plat, poitrine et taille indiquées en demi-largeurs et non en tours de corps. Centimètres et pouces restent lisibles près des tailles XS–XL, y compris dans la version arabe.',
      'Le parcours complet sélectionne Box Shirt Chalk/M à \$95 et Pleat Trouser Ink/M à \$145. Le panier est de \$240, avec \$12 de livraison de démonstration et \$0 de taxe de test, soit \$252. La validation précise qu’il s’agit d’une démonstration : aucun paiement ni commande ne sera effectué. Une action simulée affiche une référence de démonstration déterministe et le même récapitulatif.',
      'Le panier de démonstration versionné reste dans ce navigateur, avec limites de stock, annulation d’une suppression et action pour le vider. Une erreur récupérable conserve le panier valide et les coordonnées de livraison pour réessayer. La première version fonctionnelle a révélé un problème clavier : modifier la quantité ou la taille renvoyait le focus au corps de la page. La version 1.1 conserve l’ordre du panier et replace le focus sur la commande modifiée ou suivante prévue, y compris après un nouvel essai. Les fichiers modifiables, le code et un véritable enregistrement du parcours rendent la réalisation locale inspectable ; aucun lancement commercial ni résultat économique n’est revendiqué.',
    ],
    figureCaptions: [
      'L’identité FOLD créée pour le projet : une découpe dans la signature, des lignes de patron utiles, une hiérarchie bilingue et un packaging modifiable.',
      'Images conceptuelles générées de face, de dos et de construction, examinées selon le patron et les couleurs fixés. Ce ne sont pas des photographies de vêtements fabriqués.',
      'Le véritable guide précise la mesure à plat. Poitrine et taille sont des demi-largeurs ; cm et pouces restent associés à chaque taille en anglais et en arabe.',
      'Les véritables écrans relient la sélection explicite des variantes au panier de \$240 et au total de démonstration de \$252. Le stock indisponible est nommé et la simulation clairement expliquée.',
      'Véritables preuves de maintenance avant et après : modifier quantité ou taille faisait perdre le focus clavier. La version 1.1 conserve l’ordre du panier et replace le focus sur la commande modifiée ou suivante prévue, y compris après un nouvel essai.',
    ],
    downloads: [
      CaseDownload(
        label: 'Explorer la boutique Fold',
        href: 'assets/selected-work/fold/site/index.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Voir le parcours d’achat',
        href: 'assets/selected-work/fold/shopping-flow.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Sources modifiables du projet',
        href: 'assets/selected-work/fold/fold-source.zip',
        format: 'ZIP',
      ),
    ],
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
      'Stratégie · Identité · Packaging',
      'Stratégie de marque et identité',
      'Une identité de café fondée sur des choix clairs, un packaging réfléchi et la même attention en anglais et en arabe.',
      status: 'Concept du studio',
    ),
    _WorkCopy(
      'Refonte · UX/UI · Web',
      'Refonte de marque et relancement du site',
      'Une identité inspirée des matières et un site de projets pour mieux explorer les décisions architecturales.',
      status: 'Concept du studio',
      cardAlt: 'Aperçu réel du site Form Architecture avec une image générée d’étude de cour architecturale.',
    ),
    _WorkCopy(
      'Stratégie · Identité · Web · Application mobile',
      'Marque, site et application',
      'Un concept d’apprentissage créatif reliant la découverte des cours à une expérience claire et continue.',
      status: 'Concept du studio',
      cardAlt:
          'Page réelle Composition Essentials et application native Frame avec progression sauvegardée de 1 sur 6.',
    ),
    _WorkCopy(
      'Stratégie · Identité · E-commerce · Maintenance',
      'Marque et boutique e-commerce',
      'Une identité de vêtements réfléchie et un concept de boutique organisé autour de choix de produits clairs.',
      status: 'Concept du studio',
      cardAlt: 'Signature FOLD dessinée pour le projet à côté d’une image conceptuelle générée de Field Overshirt.',
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
