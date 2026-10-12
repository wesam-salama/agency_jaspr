part of '../site_sections.dart';

extension _StudioSection on AgencyPage {
  Component _studio() => _el('section', [
    _el('div', [
      _el('div', [
        _sectionLabel(content.sectionCopy['studio']!.label),
        _el('h2', [_text(content.sectionCopy['studio']!.title)]),
        for (final paragraph in content.studioParagraphs) _el('p', [_text(paragraph)], classes: 'studio-lead'),
      ], classes: 'studio-story'),
      _el('div', [
        _el('ul', [
          for (final value in content.studioValues) _el('li', [_text(value)]),
        ], classes: 'studio-guidance'),
      ], classes: 'studio-brief'),
    ], classes: 'wrap studio-grid'),
  ], id: 'studio');
}
