import 'dart:async';
import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../components/static_extras.dart' show serviceNames;
import '../utils/mailto.dart';
import 'case_runtime.dart';
import 'dom_utils.dart';
import 'motion_runtime.dart';

@client
class AgencyRuntime extends StatefulComponent {
  const AgencyRuntime({super.key});

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
        if (mounted) _runtime = AgencyDomRuntime()..mount();
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

  void mount() {
    motion = MotionRuntime(events: _events)..mount();
    cases = CaseRuntime(motion: motion, events: _events)..mount();
    _mountMenu();
    _mountContact();
    _mountAnchors();
    _mountSectionNavigation();
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
      ..setAttribute('aria-label', _menuOpen ? 'Close menu' : 'Open menu');
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
        _formStatus.textContent = 'Please check the highlighted fields before opening a draft.';
        firstInvalid.focus();
        firstInvalid.scrollIntoView(web.ScrollIntoViewOptions(behavior: 'auto', block: 'center'));
        return;
      }
      final uri = buildProjectMailto(
        name: _name.value.trim(),
        email: _email.value.trim(),
        selectedServices: _serviceInputs.where((choice) => choice.checked).map((choice) => choice.value),
        message: _message.value.trim(),
        timing: _timing.value,
      );
      _draftRequested = true;
      _formStatus.textContent =
          'An email draft was requested. Nothing has been sent. Review and send it in your email app. '
          'If no draft opens, email hello@cr8.media; your brief remains here.';
      try {
        web.window.location.href = uri;
      } catch (_) {
        _formStatus.textContent =
            'The email draft could not be opened. Your brief remains here. Email hello@cr8.media to continue.';
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
          error = 'Enter your name.';
        } else if (_name.value.length > 120) {
          error = 'Keep your name to 120 characters or fewer.';
        }
      case 'email':
        if (_email.value.trim().isEmpty) {
          error = 'Enter your email address.';
        } else if (_email.validity.typeMismatch || _email.validity.badInput) {
          error = 'Enter an email address such as you@company.com.';
        } else if (_email.value.length > 254) {
          error = 'Keep your email address to 254 characters or fewer.';
        }
      case 'message':
        if (_message.value.trim().isEmpty) {
          error = 'Describe your project goal in a few sentences.';
        } else if (_message.value.length > 3000) {
          error = 'Keep the project goal to 3,000 characters or fewer.';
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
      _formStatus.textContent = 'Your brief has changed. Open a new email draft to include these changes.';
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
      note.textContent = 'No points selected yet.';
      return;
    }
    const centerX = 160.0;
    const centerY = 112.0;
    final points = selected.map((index) {
      final angle = index * math.pi / 3 - math.pi / 2;
      return '${centerX + math.cos(angle) * 106},${centerY + math.sin(angle) * 76}';
    }).toList();
    if (selected.length == serviceNames.length) points.add(points.first);
    shape.setAttribute('points', '$centerX,$centerY ${points.join(' ')} $centerX,$centerY');
    note.textContent = 'You + ${selected.map((index) => serviceNames[index]).join(' + ')}, the shape closes.';
    motion.redrawConstellation();
  }

  void _mountSectionNavigation() {
    final links = childElements(_navigation, 'a[href^="#"]');
    void markCurrent(String id) {
      web.Element? current;
      for (final link in links) {
        if (link.getAttribute('href') == '#$id') {
          link.setAttribute('aria-current', 'location');
          current = link;
        } else {
          link.removeAttribute('aria-current');
        }
      }
      motion.markNavigation(current);
    }

    for (final link in links) {
      _events.listen(link, 'click', (_) => markCurrent(link.getAttribute('href')!.substring(1)));
    }
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
