library;

import 'package:jaspr/server.dart';

import 'main.server.options.dart';
import 'site_document.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);
  runApp(buildAgencyDocument());
}
