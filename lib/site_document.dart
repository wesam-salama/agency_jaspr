import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'l10n/site_content.dart';

const siteTitle = 'Creative Media — Branding, Web & App Development';
const siteDescription =
    'Creative Media: branding, rebranding, consultancy, web development, app development and maintenance. One team, one line of thought.';
const siteBasePath = String.fromEnvironment('SITE_BASE_PATH');

String get siteRootPath {
  if (siteBasePath.isEmpty) return '/';
  final leading = siteBasePath.startsWith('/') ? siteBasePath : '/$siteBasePath';
  return leading.endsWith('/') ? leading : '$leading/';
}

SiteLocale localeForRequest(String url) {
  final path = Uri.parse(url).path.replaceFirst(RegExp(r'/$'), '');
  if (path == '/ar' || path.endsWith('/ar')) return SiteLocale.ar;
  if (path == '/fr' || path.endsWith('/fr')) return SiteLocale.fr;
  return SiteLocale.en;
}

Component buildAgencyDocument() => AsyncBuilder(
  builder: (context) async {
    await Future.wait([
      ServerApp.requestRouteGeneration('/ar/'),
      ServerApp.requestRouteGeneration('/fr/'),
    ]);
    final locale = localeForRequest(context.url);
    final content = siteContentFor(locale);
    return Document(
      title: content.siteTitle,
      lang: locale.code,
      base: locale == SiteLocale.en && siteBasePath.isEmpty ? null : siteRootPath,
      meta: {'description': content.siteDescription},
      head: const [link(href: 'assets/styles.css', rel: 'stylesheet')],
      body: Component.fragment([
        Document.html(attributes: {'dir': locale.isRtl ? 'rtl' : 'ltr'}),
        App(content: content, basePath: siteRootPath),
      ]),
    );
  },
);
