import 'package:jaspr/jaspr.dart';

import 'components/site_sections.dart';
import 'l10n/site_content.dart';
import 'runtime/agency_runtime.dart';

class App extends StatelessComponent {
  const App({required this.content, required this.basePath, super.key});

  final SiteContent content;
  final String basePath;

  @override
  Component build(BuildContext context) => Component.fragment([
    AgencyPage(content: content, basePath: basePath),
    AgencyRuntime(localeCode: content.locale.code),
  ]);
}
