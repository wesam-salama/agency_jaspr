import 'package:jaspr/jaspr.dart';

import 'generated/agency_markup.dart';
import 'runtime/agency_runtime.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) => Component.fragment([
    buildAgencyMarkup(),
    const AgencyRuntime(),
  ]);
}
