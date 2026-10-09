import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';

const siteTitle = 'CR8.Media — Brand, web and apps. One connected studio.';
const siteDescription =
    'Branding, strategy, websites and apps for founders and marketing leads. Explore illustrative project examples and prepare a project brief with CR8.Media.';

Component buildAgencyDocument() => Document(
  title: siteTitle,
  lang: 'en',
  base: null,
  meta: const {'description': siteDescription},
  head: const [link(href: 'assets/styles.css', rel: 'stylesheet')],
  body: const App(),
);
