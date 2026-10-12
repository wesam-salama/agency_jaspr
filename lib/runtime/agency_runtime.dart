import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../l10n/site_content.dart';
import '../utils/mailto.dart';
import 'case_runtime.dart';
import 'dom_utils.dart';
import 'motion_runtime.dart';

@client
class AgencyRuntime extends StatefulComponent {
  const AgencyRuntime({required this.localeCode, super.key});

  final String localeCode;

  @override
  State<AgencyRuntime> createState() => _AgencyRuntimeState();
}

class _AgencyRuntimeState extends State<AgencyRuntime> {
  AgencyDomRuntime? _runtime;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      Timer.run(() {
        if (mounted) _runtime = AgencyDomRuntime(localeCode: component.localeCode)..mount();
      });
    }
  }

  @override
  Component build(BuildContext context) => span(
    id: 'agencyRuntime',
    attributes: const {'hidden': '', 'aria-hidden': 'true'},
    const [],
  );

  @override
  void dispose() {
    _runtime?.dispose();
    super.dispose();
  }
}

class AgencyDomRuntime {
  AgencyDomRuntime({required String localeCode})
    : locale = SiteLocale.values.firstWhere(
        (candidate) => candidate.code == localeCode,
        orElse: () => SiteLocale.en,
      );

  static const _briefTransferKey = 'cr8:brief-transfer:v1';

  final SiteLocale locale;
  late final SiteContent content = siteContentFor(locale);
  final EventScope _events = EventScope();
  late final MotionRuntime motion;
  bool get reduceMotion => motion.reduced;
  late final CaseRuntime cases;
  late final web.HTMLElement _header;
  late final web.HTMLElement _navigation;
  late final web.HTMLButtonElement _burger;
  late final web.MediaQueryList _mobileMenu;
  late final web.HTMLFormElement _form;
  late final web.HTMLInputElement _name;
  late final web.HTMLInputElement _email;
  late final web.HTMLTextAreaElement _message;
  late final web.HTMLSelectElement _timing;
  late final web.HTMLButtonElement _draftButton;
  late final web.HTMLElement _formStatus;
  late final List<web.HTMLInputElement> _serviceInputs;
  web.IntersectionObserver? _sectionObserver;
  bool _menuOpen = false;
  bool _hasValidated = false;
  bool _draftRequested = false;
  bool _originalNoValidate = false;
  String? _currentSectionId;

  void mount() {
    motion = MotionRuntime(events: _events)..mount();
    cases = CaseRuntime(motion: motion, events: _events, content: content, rtl: locale.isRtl)..mount();
    _mountMenu();
    _mountContact();
    _mountAnchors();
    _mountSectionNavigation();
    _mountLanguageLinks();
  }

  void _mountMenu() {
    _header = elementById<web.HTMLElement>('siteHeader');
    _navigation = elementById<web.HTMLElement>('primaryNavigation');
    _burger = elementById<web.HTMLButtonElement>('burgerBtn');
    _mobileMenu = web.window.matchMedia('(max-width: 860px)');
    _events.listen(_burger, 'click', (_) => _setMenuOpen(!_menuOpen));
    _events.listen(web.document, 'keydown', (event) {
      if (!event.isA<web.KeyboardEvent>()) return;
      if ((event as web.KeyboardEvent).key == 'Escape' && _menuOpen) {
        event.preventDefault();
        _setMenuOpen(false, restoreFocus: true);
      }
    });
    _events.listen(web.document, 'click', (event) {
      final target = event.target;
      if (_menuOpen && target != null && target.isA<web.Node>() && !_header.contains(target as web.Node)) {
        _setMenuOpen(false);
      }
    });
    for (final link in childElements(_header, 'a')) {
      _events.listen(link, 'click', (_) => _setMenuOpen(false));
    }
    _events.listen(_mobileMenu, 'change', (_) {
      final focused = web.document.activeElement;
      _setMenuOpen(false, restoreFocus: _mobileMenu.matches && focused != null && _navigation.contains(focused));
    });
    _setMenuOpen(false);
    _header.classList.add('enhanced');
    _burger.disabled = false;
  }

  void _setMenuOpen(bool open, {bool restoreFocus = false}) {
    _menuOpen = open && _mobileMenu.matches;
    setClass(_header, 'open', _menuOpen);
    _burger
      ..setAttribute('aria-expanded', _menuOpen ? 'true' : 'false')
      ..setAttribute('aria-label', content.t(_menuOpen ? UiTextKey.closeMenu : UiTextKey.openMenu));
    _burger.querySelector('path')?.setAttribute('d', _menuOpen ? 'M6 6l12 12M18 6L6 18' : 'M3 6h18M3 12h18M3 18h18');
    if (_menuOpen) {
      final firstLink = _navigation.querySelector('a');
      if (firstLink != null) (firstLink as web.HTMLElement).focus();
    }
    if (restoreFocus && _mobileMenu.matches) _burger.focus();
  }

  void _mountAnchors() {
    for (final link in documentElements('.skip-link')) {
      _events.listen(link, 'click', (_) {
        elementById<web.HTMLElement>('mainContent').focus(web.FocusOptions(preventScroll: true));
      });
    }
    for (final link in documentElements('a[data-service]')) {
      _events.listen(link, 'click', (event) {
        event.preventDefault();
        final index = int.tryParse(link.getAttribute('data-service') ?? '');
        if (index != null) {
          for (final input in _serviceInputs) {
            if (input.getAttribute('data-i') == '$index') input.checked = true;
          }
          _updateConstellation();
          _markBriefChanged();
        }
        _message.focus(web.FocusOptions(preventScroll: true));
        _message.scrollIntoView(web.ScrollIntoViewOptions(behavior: reduceMotion ? 'auto' : 'smooth', block: 'center'));
      });
    }
  }

  void _mountContact() {
    _form = elementById<web.HTMLFormElement>('contactForm');
    _name = elementById<web.HTMLInputElement>('name');
    _email = elementById<web.HTMLInputElement>('email');
    _message = elementById<web.HTMLTextAreaElement>('message');
    _timing = elementById<web.HTMLSelectElement>('timing');
    _draftButton = elementById<web.HTMLButtonElement>('draftButton');
    _formStatus = elementById<web.HTMLElement>('formStatus');
    _serviceInputs = documentElements('input[name="services"][data-i]').cast<web.HTMLInputElement>();
    _originalNoValidate = _form.noValidate;

    _events.listen(_form, 'submit', (event) {
      event.preventDefault();
      _hasValidated = true;
      web.HTMLElement? firstInvalid;
      for (final id in const ['name', 'email', 'message']) {
        if (!_validateField(id)) firstInvalid ??= elementById<web.HTMLElement>(id);
      }
      if (firstInvalid != null) {
        _formStatus.textContent = content.t(UiTextKey.formValidationSummary);
        firstInvalid.focus();
        firstInvalid.scrollIntoView(web.ScrollIntoViewOptions(behavior: 'auto', block: 'center'));
        return;
      }
      final uri = buildProjectMailto(
        name: _name.value.trim(),
        email: _email.value.trim(),
        selectedServices: _serviceInputs.where((choice) => choice.checked).map((choice) => choice.value),
        message: _message.value,
        timing: _timing.value,
        locale: locale,
      );
      _draftRequested = true;
      _formStatus.textContent = content.t(UiTextKey.formDraftRequested);
      try {
        web.window.location.href = uri;
      } catch (_) {
        _formStatus.textContent = content.t(UiTextKey.formDraftFailed);
      }
    });
    for (final id in const ['name', 'email', 'message']) {
      _events.listen(elementById<web.HTMLElement>(id), 'input', (_) {
        _markBriefChanged();
        if (_hasValidated) _validateField(id);
      });
    }
    _events.listen(_timing, 'change', (_) => _markBriefChanged());
    for (final input in _serviceInputs) {
      _events.listen(input, 'change', (_) {
        _markBriefChanged();
        _updateConstellation();
      });
    }
    final clearServices = elementById<web.HTMLButtonElement>('constelReset');
    _events.listen(clearServices, 'click', (_) {
      for (final input in _serviceInputs) {
        input.checked = false;
      }
      _markBriefChanged();
      _updateConstellation();
    });
    _restoreBrief();
    _updateConstellation();
    // Keep native required/type semantics, but provide persistent inline errors.
    // The static button stays disabled until this enhanced handoff is ready.
    _form.noValidate = true;
    _draftButton.disabled = false;
    clearServices.disabled = false;
  }

  bool _validateField(String id) {
    final field = elementById<web.HTMLElement>(id);
    String? error;
    switch (id) {
      case 'name':
        if (_name.value.trim().isEmpty) {
          error = content.t(UiTextKey.nameRequired);
        } else if (_name.value.length > 120) {
          error = content.t(UiTextKey.nameTooLong);
        }
      case 'email':
        if (_email.value.trim().isEmpty) {
          error = content.t(UiTextKey.emailRequired);
        } else if (_email.validity.typeMismatch || _email.validity.badInput) {
          error = content.t(UiTextKey.emailInvalid);
        } else if (_email.value.length > 254) {
          error = content.t(UiTextKey.emailTooLong);
        }
      case 'message':
        if (_message.value.trim().isEmpty) {
          error = content.t(UiTextKey.messageRequired);
        } else if (_message.value.length > 3000) {
          error = content.t(UiTextKey.messageTooLong);
        }
    }
    final errorElement = elementById<web.HTMLElement>('$id-error');
    errorElement.textContent = error ?? '';
    if (error == null) {
      errorElement.setAttribute('hidden', '');
    } else {
      errorElement.removeAttribute('hidden');
    }
    if (error == null) {
      field.removeAttribute('aria-invalid');
    } else {
      field.setAttribute('aria-invalid', 'true');
    }
    return error == null;
  }

  void _markBriefChanged() {
    if (_draftRequested) {
      _formStatus.textContent = content.t(UiTextKey.formBriefChanged);
      _draftRequested = false;
    } else {
      _formStatus.textContent = '';
    }
  }

  void _updateConstellation() {
    final selected = <int>[];
    for (final input in _serviceInputs) {
      final index = int.tryParse(input.getAttribute('data-i') ?? '');
      if (input.checked && index != null) selected.add(index);
    }
    selected.sort();
    final constellation = elementById<web.HTMLElement>('constel');
    for (final part in childElements(constellation, '.cd[data-i], .cl[data-i]')) {
      final index = int.tryParse(part.getAttribute('data-i') ?? '');
      setClass(part, 'sel', selected.contains(index));
    }
    final shape = elementById<web.SVGElement>('constShape');
    final note = elementById<web.HTMLElement>('constelNote');
    setClass(shape, 'on', selected.isNotEmpty);
    if (selected.isEmpty) {
      shape.setAttribute('points', '');
      note.textContent = content.t(UiTextKey.constellationEmpty);
      return;
    }
    const centerX = 160.0;
    const centerY = 112.0;
    final points = selected.map((index) {
      final angle = index * math.pi / 3 - math.pi / 2;
      return '${centerX + math.cos(angle) * 106},${centerY + math.sin(angle) * 76}';
    }).toList();
    if (selected.length == content.serviceNames.length) points.add(points.first);
    shape.setAttribute('points', '$centerX,$centerY ${points.join(' ')} $centerX,$centerY');
    note.textContent = content.t(
      UiTextKey.constellationSelectionSummary,
      values: {'services': selected.map((index) => content.serviceNames[index]).join(' + ')},
    );
    motion.redrawConstellation();
  }

  void _restoreBrief() {
    try {
      final storage = web.window.sessionStorage;
      final saved = storage.getItem(_briefTransferKey);
      if (saved == null) return;
      storage.removeItem(_briefTransferKey);
      final value = jsonDecode(saved);
      if (value is! Map<String, dynamic> || value['targetLocale'] != locale.code) return;
      final savedAt = value['savedAt'];
      if (savedAt is! int ||
          DateTime.now().millisecondsSinceEpoch - savedAt > const Duration(minutes: 5).inMilliseconds) {
        return;
      }
      _name.value = value['name'] is String ? value['name'] as String : '';
      _email.value = value['email'] is String ? value['email'] as String : '';
      _message.value = value['message'] is String ? value['message'] as String : '';
      final timing = value['timing'];
      if (timing is String && content.timingLabels.containsKey(timing)) _timing.value = timing;
      final selected = value['services'];
      if (selected is List) {
        final ids = selected.whereType<String>().toSet();
        for (final input in _serviceInputs) {
          input.checked = ids.contains(input.value);
        }
      }
    } catch (_) {
      // The current page remains usable if tab storage is unavailable or malformed.
    }
  }

  void _mountLanguageLinks() {
    final languageStatus = web.document.querySelector('.language-switch-status') as web.HTMLElement?;
    for (final link in documentElements('a[data-language-link]')) {
      _events.listen(link, 'click', (event) {
        final originalHref = link.getAttribute('href');
        if (originalHref == null || originalHref.isEmpty) return;
        final section = _sectionForLanguageSwitch();
        final target = Uri.parse(originalHref);
        final destination = section == null ? originalHref : target.replace(fragment: section).toString();
        link.setAttribute('href', destination);

        // A new tab has its own session storage; preserve its section link only.
        if (event.isA<web.MouseEvent>()) {
          final mouse = event as web.MouseEvent;
          if (mouse.button != 0 || mouse.ctrlKey || mouse.metaKey || mouse.shiftKey || mouse.altKey) return;
        }
        final checkedServices = _serviceInputs.where((choice) => choice.checked).map((choice) => choice.value).toList();
        final hasBrief =
            _name.value.isNotEmpty ||
            _email.value.isNotEmpty ||
            _message.value.isNotEmpty ||
            checkedServices.isNotEmpty ||
            (_timing.value.isNotEmpty && _timing.value != 'unsure');
        if (hasBrief) {
          if (languageStatus != null) languageStatus.textContent = '';
          final targetLocale = _localeForPath(target.path);
          try {
            web.window.sessionStorage.setItem(
              _briefTransferKey,
              jsonEncode({
                'targetLocale': targetLocale.code,
                'savedAt': DateTime.now().millisecondsSinceEpoch,
                'name': _name.value,
                'email': _email.value,
                'message': _message.value,
                'timing': _timing.value,
                'services': checkedServices,
              }),
            );
          } catch (_) {
            event.preventDefault();
            final status = languageStatus ?? _formStatus;
            status.textContent = content.t(UiTextKey.languageSwitchFailed);
            status
              ..setAttribute('tabindex', '-1')
              ..focus();
            status.scrollIntoView(web.ScrollIntoViewOptions(behavior: 'auto', block: 'center'));
            return;
          }
        }
        // Use the freshly computed section URL. Some browsers activate an
        // anchor's original href even when a click listener changes it.
        event.preventDefault();
        web.window.location.href = destination;
      });
    }
  }

  SiteLocale _localeForPath(String path) {
    final segments = path.split('/').where((segment) => segment.isNotEmpty).toList();
    if (segments.isNotEmpty && segments.last == 'ar') return SiteLocale.ar;
    if (segments.isNotEmpty && segments.last == 'fr') return SiteLocale.fr;
    return SiteLocale.en;
  }

  String? _sectionForLanguageSwitch() {
    // A deep link remains authoritative even when opening the language menu
    // scrolls the viewport toward the header before its link is activated.
    return _sectionFromHash() ?? _currentSectionId;
  }

  String? _sectionFromHash() {
    final hash = web.window.location.hash;
    if (hash.length > 1) {
      try {
        final id = Uri.decodeComponent(hash.substring(1));
        final element = web.document.getElementById(id);
        if (element?.tagName.toLowerCase() == 'section') return id;
      } catch (_) {
        // An invalid hash is ignored; the observed section remains available.
      }
    }
    return null;
  }

  void _updateLanguageLinkSections(String section) {
    for (final link in documentElements('a[data-language-link]')) {
      final href = link.getAttribute('href');
      if (href == null || href.isEmpty) continue;
      link.setAttribute('href', Uri.parse(href).replace(fragment: section).toString());
    }
  }

  void _mountSectionNavigation() {
    final links = childElements(_navigation, 'a[data-section]');
    void markCurrent(String id) {
      _currentSectionId = id;
      web.Element? current;
      for (final link in links) {
        if (link.getAttribute('data-section') == id) {
          link.setAttribute('aria-current', 'location');
          current = link;
        } else {
          link.removeAttribute('aria-current');
        }
      }
      motion.markNavigation(current);
      _updateLanguageLinkSections(id);
    }

    for (final link in links) {
      _events.listen(link, 'click', (_) => markCurrent(link.getAttribute('data-section')!));
    }
    final initialSection = _sectionFromHash();
    if (initialSection != null) markCurrent(initialSection);
    _events.listen(web.window, 'hashchange', (_) {
      final id = _sectionFromHash();
      if (id != null) markCurrent(id);
    });
    try {
      _sectionObserver = web.IntersectionObserver(
        ((JSArray<web.IntersectionObserverEntry> entries, web.IntersectionObserver observer) {
          for (final entry in entries.toDart) {
            if (entry.isIntersecting) markCurrent(entry.target.id);
          }
        }).toJS,
        web.IntersectionObserverInit(rootMargin: '-10% 0px -65% 0px'),
      );
      for (final section in documentElements('main > section[id]')) {
        _sectionObserver!.observe(section);
      }
    } catch (_) {
      // Anchor navigation remains functional when observation is unavailable.
      _sectionObserver?.disconnect();
      _sectionObserver = null;
    }
  }

  void dispose() {
    cases.dispose();
    motion.dispose();
    _sectionObserver?.disconnect();
    _setMenuOpen(false);
    _header.classList.remove('enhanced');
    _burger.disabled = true;
    _form.noValidate = _originalNoValidate;
    _draftButton.disabled = true;
    elementById<web.HTMLButtonElement>('constelReset').disabled = true;
    _events.dispose();
  }
}
