import 'package:jaspr/jaspr.dart';

import 'components/site_sections.dart';
import 'runtime/agency_runtime.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) => Component.fragment([
    const AgencyPage(),
    const AgencyRuntime(),
  ]);
}
