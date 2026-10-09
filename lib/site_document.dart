import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';

const siteTitle = 'Creative Media — Branding, Web & App Development';
const siteDescription =
    'Creative Media: branding, rebranding, consultancy, web development, app development and maintenance. One team, one line of thought.';
const siteBasePath = String.fromEnvironment('SITE_BASE_PATH');

Component buildAgencyDocument() => Document(
  title: siteTitle,
  lang: 'en',
  base: siteBasePath.isEmpty ? null : siteBasePath,
  meta: const {'description': siteDescription},
  head: const [link(href: 'assets/styles.css', rel: 'stylesheet')],
  body: const App(),
);
