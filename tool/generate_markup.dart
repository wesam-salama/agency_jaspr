import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';

const _assetPaths = <String, String>{
  'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1600&q=70':
      'assets/images/fenwick-card.jpg',
  'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&w=1600&q=70':
      'assets/images/loop-card.jpg',
  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=70':
      'assets/images/marrow-card.jpg',
  'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1600&q=70':
      'assets/images/northline-card.jpg',
};

const _svgAttributeNames = <String, String>{
  'viewbox': 'viewBox',
  'preserveaspectratio': 'preserveAspectRatio',
  'pathlength': 'pathLength',
  'textlength': 'textLength',
  'lengthadjust': 'lengthAdjust',
  'markerheight': 'markerHeight',
  'markerwidth': 'markerWidth',
  'markerunits': 'markerUnits',
  'refx': 'refX',
  'refy': 'refY',
};

void main() {
  final source = File('../agency_website.html').readAsStringSync();
  final document = parse(source);
  final body = document.body;
  if (body == null) throw StateError('Reference document has no body.');

  final children = body.nodes.where((node) => node is! Element || node.localName != 'script').toList();
  final output = StringBuffer()
    ..writeln('// GENERATED FROM ../agency_website.html. DO NOT EDIT BY HAND.')
    ..writeln("import 'package:jaspr/jaspr.dart';")
    ..writeln()
    ..writeln("import '../components/static_extras.dart';")
    ..writeln()
    ..writeln('Component buildAgencyMarkup() => Component.fragment([');

  for (final child in children) {
    _writeNode(output, child, 1);
  }
  output.writeln(']);');

  final outputFile = File('lib/generated/agency_markup.dart');
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(output.toString());

  final referenceStyles = document.querySelector('style')?.text;
  if (referenceStyles == null) throw StateError('Reference document has no stylesheet.');
  final stylesheet = File('web/assets/styles.css');
  stylesheet.parent.createSync(recursive: true);
  stylesheet.writeAsStringSync('$_fontFaces\n${referenceStyles.trim()}\n');
}

const _fontFaces = '''
@font-face{font-family:'IBM Plex Mono';font-style:normal;font-weight:400;font-display:swap;src:url('fonts/ibm-plex-mono-400.woff2') format('woff2')}
@font-face{font-family:'IBM Plex Mono';font-style:normal;font-weight:500;font-display:swap;src:url('fonts/ibm-plex-mono-500.woff2') format('woff2')}
@font-face{font-family:'IBM Plex Mono';font-style:normal;font-weight:600;font-display:swap;src:url('fonts/ibm-plex-mono-600.woff2') format('woff2')}
@font-face{font-family:'Inter';font-style:normal;font-weight:400;font-display:swap;src:url('fonts/inter-latin.woff2') format('woff2')}
@font-face{font-family:'Inter';font-style:normal;font-weight:500;font-display:swap;src:url('fonts/inter-latin.woff2') format('woff2')}
@font-face{font-family:'Inter';font-style:normal;font-weight:600;font-display:swap;src:url('fonts/inter-latin.woff2') format('woff2')}
@font-face{font-family:'Space Grotesk';font-style:normal;font-weight:400;font-display:swap;src:url('fonts/space-grotesk-latin.woff2') format('woff2')}
@font-face{font-family:'Space Grotesk';font-style:normal;font-weight:500;font-display:swap;src:url('fonts/space-grotesk-latin.woff2') format('woff2')}
@font-face{font-family:'Space Grotesk';font-style:normal;font-weight:600;font-display:swap;src:url('fonts/space-grotesk-latin.woff2') format('woff2')}
@font-face{font-family:'Space Grotesk';font-style:normal;font-weight:700;font-display:swap;src:url('fonts/space-grotesk-latin.woff2') format('woff2')}
''';

void _writeNode(StringBuffer output, Node node, int depth) {
  final indent = '  ' * depth;
  if (node is Text) {
    final normalized = node.data.replaceAll(RegExp(r'\\s+'), ' ');
    if (normalized.trim().isEmpty) return;
    output.writeln('$indent.text(${jsonEncode(normalized)}),');
    return;
  }
  if (node is! Element) return;

  final id = node.id.isEmpty ? null : node.id;
  final classes = node.className.trim().isEmpty ? null : node.className.trim();
  final attributes = <String, String>{};
  for (final entry in node.attributes.entries) {
    final key = entry.key;
    var name = key is AttributeName ? key.name : key.toString();
    if (name == 'id' || name == 'class' || name == 'onclick') continue;
    name = _svgAttributeNames[name] ?? name;
    var value = entry.value;
    if (name == 'src') value = _assetPaths[value] ?? value;
    attributes[name] = value;
  }

  output.writeln('$indent.element(');
  output.writeln('$indent  tag: ${jsonEncode(node.localName)},');
  if (id != null) output.writeln('$indent  id: ${jsonEncode(id)},');
  if (classes != null) output.writeln('$indent  classes: ${jsonEncode(classes)},');
  if (attributes.isNotEmpty) {
    output.writeln('$indent  attributes: {');
    for (final entry in attributes.entries) {
      output.writeln('$indent    ${jsonEncode(entry.key)}: ${jsonEncode(entry.value)},');
    }
    output.writeln('$indent  },');
  }

  String? customChildren;
  if (id == 'rail') {
    customChildren = 'buildRailChildren()';
  } else if (id == 'marqueeTrack' || id == 'marqueeTrackFoot') {
    customChildren = 'buildMarqueeChildren()';
  } else if (id == 'constel') {
    customChildren = 'buildConstellationChildren()';
  } else if ((classes?.split(' ').contains('num') ?? false) && attributes['data-val'] != null) {
    customChildren = 'buildStatGraphic(${jsonEncode(attributes['data-val'])})';
  }
  if (customChildren != null) {
    output.writeln('$indent  children: $customChildren,');
  } else if (node.nodes.isNotEmpty) {
    output.writeln('$indent  children: [');
    for (final child in node.nodes) {
      _writeNode(output, child, depth + 2);
    }
    output.writeln('$indent  ],');
  }
  output.writeln('$indent),');
}
