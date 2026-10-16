import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'content.dart';
import 'session.dart';

const canvas = Color(0xFFF7F9FC);
const ink = Color(0xFF18243D);
const blue = Color(0xFF244CCD);
const mint = Color(0xFFA7E3CE);
const coral = Color(0xFFFF8A6C);
const muted = Color(0xFF52627B);
const recovery = Color(0xFFA92F33);
final appKey = GlobalKey<FrameAppState>();

void main() {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(FrameApp(key: appKey));
}

class FrameApp extends StatefulWidget {
  const FrameApp({
    super.key,
    this.session,
    this.initialArabic = false,
    this.links = true,
  });
  final LearningSession? session;
  final bool initialArabic;
  final bool links;
  @override
  State<FrameApp> createState() => FrameAppState();
}

class FrameAppState extends State<FrameApp> with WidgetsBindingObserver {
  late final LearningSession session;
  late bool arabic;
  final navigator = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? linkSubscription;
  SharedPreferences? preferences;
  Uri? lastDeliveredLink;
  DateTime? lastDeliveredAt;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    session = widget.session ?? LearningSession();
    arabic = widget.initialArabic;
    if (!widget.links) {
      session.refresh();
    }
    if (widget.links) {
      initializeDemo();
    }
    if (kDebugMode && widget.links) {
      registerMarionetteExtension(
        name: 'frameState',
        description: 'Read the actual demo session and current UI language.',
        callback: (_) async => MarionetteExtensionResult.success({
          'learner': session.learner,
          'record': session.record,
          'note': session.localNote,
          'confirmed': session.confirmed,
          'pending': session.pending,
          'error': session.error,
          'arabic': arabic,
          'latestLink': (await AppLinks().getLatestLink())?.toString(),
        }),
      );
    }
  }

  Future<void> initializeDemo() async {
    preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      arabic = preferences!.getBool('frame.arabic') ?? widget.initialArabic;
    });
    await session.refresh(
      learnerId: preferences!.getString('frame.learner') ?? 'demo',
    );
    final links = AppLinks();
    linkSubscription = links.uriLinkStream.listen(openLink);
    final initial = await links.getInitialLink();
    if (initial != null) await openLink(initial);
  }

  Future<void> openLink(Uri uri) async {
    if (uri.scheme != 'frameacademy' ||
        uri.host != 'course' ||
        uri.path != '/FA-PH-01') {
      return;
    }
    final now = DateTime.now();
    if (lastDeliveredLink == uri &&
        lastDeliveredAt != null &&
        now.difference(lastDeliveredAt!).inMilliseconds < 1000) {
      return;
    }
    lastDeliveredLink = uri;
    lastDeliveredAt = now;
    setState(() {
      arabic = uri.queryParameters['lang'] == 'ar';
    });
    final learner = uri.queryParameters['learner'] ?? 'demo';
    await preferences?.setString('frame.learner', learner);
    await preferences?.setBool('frame.arabic', arabic);
    await session.refresh(learnerId: learner);
    if (!mounted) return;
    navigator.currentState?.popUntil((route) => route.isFirst);
    navigator.currentState?.push(route(CourseOverview(session: session)));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) session.refresh();
  }

  @override
  void dispose() {
    linkSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.light,
        ).copyWith(
          primary: blue,
          onPrimary: Colors.white,
          surface: canvas,
          onSurface: ink,
          error: recovery,
          outline: muted,
          secondaryContainer: mint,
          onSecondaryContainer: ink,
        );
    final baseType = ThemeData.light().textTheme.apply(
      fontFamily: arabic ? 'IBM Plex Sans Arabic' : 'Inter',
      bodyColor: ink,
      displayColor: ink,
    );
    final type = arabic
        ? baseType.copyWith(
            displayLarge: baseType.displayLarge?.copyWith(letterSpacing: 0),
            displayMedium: baseType.displayMedium?.copyWith(letterSpacing: 0),
            displaySmall: baseType.displaySmall?.copyWith(letterSpacing: 0),
            headlineLarge: baseType.headlineLarge?.copyWith(letterSpacing: 0),
            headlineMedium: baseType.headlineMedium?.copyWith(letterSpacing: 0),
            headlineSmall: baseType.headlineSmall?.copyWith(letterSpacing: 0),
            titleLarge: baseType.titleLarge?.copyWith(letterSpacing: 0),
            titleMedium: baseType.titleMedium?.copyWith(letterSpacing: 0),
            titleSmall: baseType.titleSmall?.copyWith(letterSpacing: 0),
            bodyLarge: baseType.bodyLarge?.copyWith(letterSpacing: 0),
            bodyMedium: baseType.bodyMedium?.copyWith(letterSpacing: 0),
            bodySmall: baseType.bodySmall?.copyWith(letterSpacing: 0),
            labelLarge: baseType.labelLarge?.copyWith(letterSpacing: 0),
            labelMedium: baseType.labelMedium?.copyWith(letterSpacing: 0),
            labelSmall: baseType.labelSmall?.copyWith(letterSpacing: 0),
          )
        : baseType;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator,
      locale: Locale(arabic ? 'ar' : 'en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: canvas,
        textTheme: type.copyWith(
          headlineLarge: type.headlineLarge?.copyWith(
            fontFamily: arabic ? 'IBM Plex Sans Arabic' : 'Space Grotesk',
            fontWeight: FontWeight.w600,
            fontSize: 34,
            height: 1.18,
          ),
          headlineMedium: type.headlineMedium?.copyWith(
            fontFamily: arabic ? 'IBM Plex Sans Arabic' : 'Space Grotesk',
            fontWeight: FontWeight.w600,
            fontSize: 28,
            height: 1.25,
          ),
          titleLarge: type.titleLarge?.copyWith(
            fontFamily: arabic ? 'IBM Plex Sans Arabic' : 'Space Grotesk',
            fontWeight: FontWeight.w600,
            fontSize: 23,
            height: 1.25,
          ),
          bodyLarge: type.bodyLarge?.copyWith(fontSize: 17, height: 1.5),
          bodyMedium: type.bodyMedium?.copyWith(fontSize: 15, height: 1.45),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 52),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(
              fontFamily: arabic ? 'IBM Plex Sans Arabic' : 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: muted),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: muted),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: muted),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: blue, width: 2),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: canvas,
          indicatorColor: mint,
          elevation: 0,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) => FrameScope(app: this, child: child!),
      home: LearningHome(session: session),
    );
  }

  void toggleLanguage() {
    setState(() {
      arabic = !arabic;
    });
    preferences?.setBool('frame.arabic', arabic);
  }
}

class FrameScope extends InheritedWidget {
  const FrameScope({super.key, required this.app, required super.child});
  final FrameAppState app;
  static FrameAppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FrameScope>()!.app;
  @override
  bool updateShouldNotify(FrameScope oldWidget) => true;
}

bool ar(BuildContext c) => Localizations.localeOf(c).languageCode == 'ar';
String tr(BuildContext c, String en, String arabic) => ar(c) ? arabic : en;
String title(BuildContext c, int index) =>
    ar(c) ? lessonTitlesAr[index] : lessonTitles[index];
Route<void> route(Widget page) => MaterialPageRoute<void>(builder: (_) => page);
void push(BuildContext c, Widget page) => Navigator.of(c).push(route(page));
Widget ltr(String value, {TextStyle? style}) => Directionality(
  textDirection: TextDirection.ltr,
  child: Text(
    value,
    style: (style ?? const TextStyle()).copyWith(
      fontFamily: 'Inter',
      letterSpacing: 0,
    ),
  ),
);
Widget heading(BuildContext c, String value) =>
    Text(value, style: Theme.of(c).textTheme.headlineMedium);
Widget body(BuildContext c, String value) =>
    Text(value, style: Theme.of(c).textTheme.bodyLarge);

class FrameMark extends StatelessWidget {
  const FrameMark({super.key, this.size = 32, this.color = blue});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Frame Academy',
    image: true,
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MarkPainter(color)),
    ),
  );
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.color);
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = color
      ..strokeWidth = s.width * .12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    c.drawPath(
      Path()
        ..moveTo(s.width * .14, s.height * .60)
        ..lineTo(s.width * .14, s.height * .14)
        ..lineTo(s.width * .62, s.height * .14),
      p,
    );
    c.drawPath(
      Path()
        ..moveTo(s.width * .86, s.height * .38)
        ..lineTo(s.width * .86, s.height * .86)
        ..lineTo(s.width * .40, s.height * .86),
      p,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter old) => color != old.color;
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const ValueKey('page-scroll'),
    padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 40),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 660),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key, this.label, this.home = false});
  final String? label;
  final bool home;
  @override
  Size get preferredSize => const Size.fromHeight(62);
  @override
  Widget build(BuildContext context) => AppBar(
    title: home
        ? const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FrameMark(size: 27),
              SizedBox(width: 10),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  'Frame',
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          )
        : Text(label!, style: Theme.of(context).textTheme.titleMedium),
    actions: [
      TextButton(
        key: const ValueKey('language'),
        onPressed: () => FrameScope.of(context).toggleLanguage(),
        child: Text(ar(context) ? 'English' : 'العربية'),
      ),
      const SizedBox(width: 8),
    ],
  );
}

class SessionLabel extends StatelessWidget {
  const SessionLabel({super.key, required this.session});
  final LearningSession session;
  @override
  Widget build(BuildContext c) => Row(
    children: [
      const Icon(CupertinoIcons.person_crop_circle, size: 18, color: muted),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          tr(c, 'Demo learner · Demo session', 'متعلّم تجريبي · جلسة تجريبية'),
          style: Theme.of(c).textTheme.bodySmall?.copyWith(color: muted),
        ),
      ),
    ],
  );
}

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.session});
  final LearningSession session;
  @override
  Widget build(BuildContext c) => Semantics(
    liveRegion: true,
    child: Text(
      tr(
        c,
        '${session.count} of 6 lessons complete',
        'اكتمل ${session.count} من 6 دروس',
      ),
      key: const ValueKey('progress-text'),
      style: Theme.of(c).textTheme.bodyMedium?.copyWith(color: muted),
    ),
  );
}

class CourseArt extends StatelessWidget {
  const CourseArt({super.key, this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext c) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: AspectRatio(
      aspectRatio: compact ? 2.4 : 1.65,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            '$apiBase/assets/selected-work/frame/media/composition-source.png',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: mint,
              child: Center(child: FrameMark(size: 92, color: ink)),
            ),
          ),
          PositionedDirectional(
            bottom: 14,
            start: 14,
            end: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: canvas,
              child: Text(
                tr(c, 'Composition Essentials', 'أساسيات التكوين'),
                style: Theme.of(c).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class LearningHome extends StatefulWidget {
  const LearningHome({super.key, required this.session});
  final LearningSession session;
  @override
  State<LearningHome> createState() => _LearningHomeState();
}

class _LearningHomeState extends State<LearningHome> {
  int tab = 0;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: widget.session,
    builder: (c, _) {
      final s = widget.session;
      return Scaffold(
        appBar: const TopBar(home: true),
        body: s.loading && s.record == null
            ? const Center(child: CircularProgressIndicator())
            : tab == 1
            ? ProgressBody(session: s)
            : PageBody(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    tr(c, 'My learning', 'تعلّمي'),
                    style: Theme.of(c).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  SessionLabel(session: s),
                  const SizedBox(height: 28),
                  if (s.offline) ...[
                    RecoveryBlock(
                      message: tr(
                        c,
                        'We couldn’t load your learning. Check the local demo service and try again.',
                        'تعذّر تحميل تعلّمك. تحقّق من الخدمة التجريبية المحلية وحاول مجدداً.',
                      ),
                      action: tr(c, 'Try again', 'حاول مجدداً'),
                      onPressed: s.refresh,
                    ),
                    const SizedBox(height: 24),
                  ],
                  const CourseArt(compact: true),
                  const SizedBox(height: 24),
                  Text(
                    tr(c, 'Composition Essentials', 'أساسيات التكوين'),
                    style: Theme.of(c).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr(
                      c,
                      'Photography · Beginner',
                      'التصوير الفوتوغرافي · مبتدئ',
                    ),
                    style: Theme.of(c).textTheme.bodyMedium
                        ?.copyWith(color: muted),
                  ),
                  const SizedBox(height: 22),
                  StatusText(session: s),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: s.count / 6,
                    minHeight: 4,
                    color: blue,
                    backgroundColor: const Color(0xFFE0E6F1),
                  ),
                  const SizedBox(height: 24),
                  if (s.enrolled) ...[
                    Text(
                      tr(c, 'Next lesson', 'الدرس التالي'),
                      style: Theme.of(c).textTheme.bodyMedium
                          ?.copyWith(color: muted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${s.nextLesson}  ${title(c, s.firstComplete ? 1 : 0)}',
                      style: Theme.of(c).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      key: const ValueKey('continue'),
                      onPressed: () => push(
                        c,
                        LessonScreen(
                          session: s,
                          index: s.firstComplete ? 1 : 0,
                        ),
                      ),
                      icon: Icon(
                        ar(c)
                            ? CupertinoIcons.arrow_left
                            : CupertinoIcons.arrow_right,
                      ),
                      label: Text(tr(c, 'Continue lesson', 'تابع الدرس')),
                    ),
                  ] else ...[
                    body(
                      c,
                      tr(
                        c,
                        'A clear place to start. A next step to follow.',
                        'بداية واضحة. وخطوة تالية تتابعها.',
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      key: const ValueKey('course-overview'),
                      onPressed: () => push(c, CourseOverview(session: s)),
                      child: Text(
                        tr(c, 'See what you’ll make', 'شاهد ما ستصنعه'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  TextButton(
                    key: const ValueKey('overview-link'),
                    onPressed: () => push(c, CourseOverview(session: s)),
                    child: Text(tr(c, 'Course overview', 'نظرة على الدورة')),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tr(
                      c,
                      'Studio concept · Make your next idea.',
                      'تصوّر من الاستوديو · اصنع فكرتك التالية.',
                    ),
                    style: Theme.of(c).textTheme.bodySmall
                        ?.copyWith(color: muted),
                  ),
                ],
              ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() {
            tab = v;
          }),
          destinations: [
            NavigationDestination(
              icon: const Icon(CupertinoIcons.book),
              selectedIcon: const Icon(CupertinoIcons.book_fill),
              label: tr(c, 'My learning', 'تعلّمي'),
            ),
            NavigationDestination(
              icon: const Icon(CupertinoIcons.chart_bar),
              selectedIcon: const Icon(CupertinoIcons.chart_bar_fill),
              label: tr(c, 'Progress', 'التقدّم'),
            ),
          ],
        ),
      );
    },
  );
}

class CourseOverview extends StatelessWidget {
  const CourseOverview({super.key, required this.session});
  final LearningSession session;
  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: session,
    builder: (c, _) => Scaffold(
      appBar: TopBar(label: tr(c, 'Course overview', 'نظرة على الدورة')),
      body: PageBody(
        children: [
          const CourseArt(),
          const SizedBox(height: 24),
          heading(c, tr(c, 'Composition Essentials', 'أساسيات التكوين')),
          const SizedBox(height: 12),
          if (ar(c)) ...[
            ltr(
              'Composition Essentials',
              style: Theme.of(c).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            tr(c, 'Photography · Beginner', 'التصوير الفوتوغرافي · مبتدئ'),
            style: Theme.of(c).textTheme.bodyMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          ltr(
            'FA-PH-01',
            style: Theme.of(c).textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 22),
          body(
            c,
            tr(
              c,
              'Make a six-image series that uses subject placement, balance and negative space deliberately.',
              'اصنع سلسلة من ست صور تستخدم فيها موضع الموضوع والتوازن والمساحة السلبية بقصد.',
            ),
          ),
          const SizedBox(height: 24),
          _Fact(
            label: tr(c, 'Planned curriculum', 'المنهج المخطّط'),
            text: tr(
              c,
              '6 lessons · 62 minutes of study',
              '6 دروس · 62 دقيقة للدراسة',
            ),
          ),
          _Fact(
            label: tr(c, 'Start with', 'ابدأ بـ'),
            text: tr(
              c,
              'No prior course required.',
              'لا تحتاج إلى دورة سابقة.',
            ),
          ),
          _Fact(
            label: tr(c, 'Bring', 'ستحتاج إلى'),
            text: tr(
              c,
              'A phone or camera, one object and available light.',
              'هاتف أو كاميرا، عنصر واحد والضوء المتاح.',
            ),
          ),
          const SizedBox(height: 22),
          StatusText(session: session),
          const SizedBox(height: 18),
          FilledButton(
            key: const ValueKey('enrol-or-continue'),
            onPressed: session.pending
                ? null
                : () async {
                    if (!session.enrolled) {
                      await session.enrol();
                    }
                    if (c.mounted && session.enrolled) {
                      push(
                        c,
                        LessonScreen(
                          session: session,
                          index: session.firstComplete ? 1 : 0,
                        ),
                      );
                    }
                  },
            child: Text(
              session.pending
                  ? tr(c, 'Enrolling…', 'جارٍ التسجيل…')
                  : session.enrolled
                  ? tr(c, 'Continue lesson', 'تابع الدرس')
                  : tr(c, 'Continue as demo learner', 'تابع كمتعلّم تجريبي'),
            ),
          ),
          if (session.error == 'enrol') ...[
            const SizedBox(height: 16),
            RecoveryBlock(
              message: tr(
                c,
                'We couldn’t enrol you. Try again when the demo service is available.',
                'تعذّر تسجيلك. حاول مجدداً عندما تتوفر الخدمة التجريبية.',
              ),
              action: tr(c, 'Try again', 'حاول مجدداً'),
              onPressed: session.enrol,
            ),
          ],
          const SizedBox(height: 28),
          heading(
            c,
            tr(c, 'One useful step at a time.', 'خطوة مفيدة في كل مرة.'),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            6,
            (index) => LessonRow(session: session, index: index),
          ),
          const SizedBox(height: 24),
          body(
            c,
            tr(
              c,
              'Lesson 01 has an authored 30-second video, captions and a transcript. The study times above describe the planned curriculum.',
              'يتضمن الدرس 01 فيديو مؤلّفاً مدته 30 ثانية، وترجمة نصية ونصاً مكتوباً. الأوقات أعلاه تخص المنهج المخطّط.',
            ),
          ),
        ],
      ),
    ),
  );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.text});
  final String label;
  final String text;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(c).textTheme.labelLarge?.copyWith(color: muted),
        ),
        const SizedBox(height: 4),
        Text(text, style: Theme.of(c).textTheme.bodyLarge),
      ],
    ),
  );
}

class LessonRow extends StatelessWidget {
  const LessonRow({super.key, required this.session, required this.index});
  final LearningSession session;
  final int index;
  @override
  Widget build(BuildContext c) => Column(
    children: [
      const Divider(height: 1, color: Color(0xFFCBD4E2)),
      ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 18,
        leading: SizedBox(
          width: 32,
          child: ltr(
            (index + 1).toString().padLeft(2, '0'),
            style: Theme.of(c).textTheme.titleMedium?.copyWith(
              color: index == 0 && session.firstComplete
                  ? const Color(0xFF225C47)
                  : blue,
            ),
          ),
        ),
        title: Text(title(c, index), style: Theme.of(c).textTheme.titleMedium),
        subtitle: Text(
          tr(
            c,
            '${lessonMinutes[index]} minutes · planned study',
            '${lessonMinutes[index]} دقائق · دراسة مخطّطة',
          ),
        ),
        trailing: Icon(
          index == 0 && session.firstComplete
              ? CupertinoIcons.check_mark_circled_solid
              : ar(c)
              ? CupertinoIcons.chevron_left
              : CupertinoIcons.chevron_right,
          color: index == 0 && session.firstComplete
              ? const Color(0xFF225C47)
              : muted,
          size: 22,
        ),
        onTap: () => push(c, LessonScreen(session: session, index: index)),
      ),
    ],
  );
}

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.session, required this.index});
  final LearningSession session;
  final int index;
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  VideoPlayerController? player;
  bool failed = false;
  bool captions = true;
  bool? currentArabic;
  String transcript = '';
  String captionFile = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentArabic != ar(context)) {
      currentArabic = ar(context);
      loadMedia();
    }
  }

  Future<void> loadMedia() async {
    final previous = player;
    player = null;
    previous?.dispose();
    if (widget.index != 0) return;
    failed = false;
    final suffix = currentArabic! ? '-ar' : '';
    final locale = currentArabic! ? 'ar' : 'en';
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(
        '$apiBase/assets/selected-work/frame/media/see-the-edges$suffix.mp4',
      ),
    );
    player = controller;
    try {
      await controller.initialize();
      final client = HttpClient();
      final transcriptResponse = await (await client.getUrl(
        Uri.parse(
          '$apiBase/assets/selected-work/frame/media/transcript-$locale.txt',
        ),
      )).close();
      transcript = await transcriptResponse
          .transform(const SystemEncoding().decoder)
          .join();
      final captionsResponse = await (await client.getUrl(
        Uri.parse(
          '$apiBase/assets/selected-work/frame/media/captions-$locale.vtt',
        ),
      )).close();
      captionFile = await captionsResponse
          .transform(const SystemEncoding().decoder)
          .join();
      client.close();
      controller.addListener(update);
    } catch (_) {
      failed = true;
    }
    if (mounted) setState(() {});
  }

  void update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    player?.removeListener(update);
    player?.dispose();
    super.dispose();
  }

  String activeCaption() {
    final seconds = player?.value.position.inMilliseconds ?? 0;
    for (final block in captionFile.split(RegExp(r'\n\s*\n'))) {
      final lines = block.trim().split('\n');
      final timeline = lines.indexWhere((line) => line.contains('-->'));
      if (timeline < 0) continue;
      final times = lines[timeline].split('-->');
      int millis(String value) {
        final nums = value.trim().split(':');
        final secs = double.tryParse(nums.last.split(' ').first) ?? 0;
        return ((nums.length > 2 ? int.parse(nums[0]) * 3600 : 0) +
                    int.parse(nums[nums.length - 2]) * 60) *
                1000 +
            (secs * 1000).round();
      }

      if (seconds >= millis(times.first) && seconds < millis(times.last)) {
        return lines.skip(timeline + 1).join(' ');
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext c) {
    final s = widget.session;
    final index = widget.index;
    final ready = player?.value.isInitialized == true;
    return Scaffold(
      appBar: TopBar(
        label: tr(
          c,
          'Lesson ${(index + 1).toString().padLeft(2, '0')} of 6',
          'الدرس ${(index + 1).toString().padLeft(2, '0')} من 6',
        ),
      ),
      body: PageBody(
        children: [
          heading(c, title(c, index)),
          const SizedBox(height: 12),
          Text(
            tr(c, 'Composition Essentials', 'أساسيات التكوين'),
            style: Theme.of(c).textTheme.bodyMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: 22),
          if (index == 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: ready ? player!.value.aspectRatio : 16 / 9,
                child: ready
                    ? VideoPlayer(player!)
                    : ColoredBox(
                        color: ink,
                        child: Center(
                          child: failed
                              ? const Icon(
                                  CupertinoIcons.exclamationmark_circle,
                                  color: Colors.white,
                                  size: 36,
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            if (ready) ...[
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    IconButton.filled(
                      key: const ValueKey('play-pause'),
                      tooltip: player!.value.isPlaying
                          ? tr(c, 'Pause lesson', 'أوقف الدرس مؤقتاً')
                          : tr(c, 'Play lesson', 'شغّل الدرس'),
                      onPressed: () {
                        player!.value.isPlaying
                            ? player!.pause()
                            : player!.play();
                      },
                      icon: Icon(
                        player!.value.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: VideoProgressIndicator(
                        player!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: blue,
                          bufferedColor: Color(0xFFCBD4E2),
                          backgroundColor: Color(0xFFE0E6F1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${player!.value.position.inSeconds.toString().padLeft(2, '0')} / ${player!.value.duration.inSeconds}s',
                      style: Theme.of(c).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Semantics(
                liveRegion: true,
                label: tr(c, 'Caption', 'الترجمة النصية'),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  color: captions ? mint : canvas,
                  child: Text(
                    captions
                        ? activeCaption().isEmpty
                              ? tr(
                                  c,
                                  'Captions on. Press play to begin.',
                                  'الترجمة النصية مفعّلة. شغّل الفيديو للبدء.',
                                )
                              : activeCaption()
                        : tr(c, 'Captions off.', 'الترجمة النصية متوقفة.'),
                    style: Theme.of(c).textTheme.bodyMedium,
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                key: const ValueKey('captions'),
                contentPadding: EdgeInsets.zero,
                title: Text(tr(c, 'Captions', 'الترجمة النصية')),
                value: captions,
                onChanged: (v) => setState(() {
                  captions = v;
                }),
              ),
              Text(
                tr(
                  c,
                  'Actual video: ${player!.value.duration.inSeconds} seconds · Planned study: 8 minutes',
                  'الفيديو الفعلي: ${player!.value.duration.inSeconds} ثانية · الدراسة المخطّطة: 8 دقائق',
                ),
                style: Theme.of(c).textTheme.bodySmall?.copyWith(color: muted),
              ),
            ] else if (failed)
              RecoveryBlock(
                message: tr(
                  c,
                  'This lesson video is unavailable. Your progress is unchanged. Reconnect to the local demo and retry.',
                  'فيديو الدرس غير متاح. تقدّمك محفوظ كما هو. اتصل بالخدمة التجريبية وحاول مجدداً.',
                ),
                action: tr(c, 'Retry video', 'أعد تحميل الفيديو'),
                onPressed: loadMedia,
              ),
            const SizedBox(height: 24),
            body(
              c,
              tr(
                c,
                'A composition begins at the edges. Look for what your frame includes, and what it leaves out.',
                'يبدأ التكوين عند الحواف. لاحظ ما يدخله إطارك وما يتركه خارجه.',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const ValueKey('exercise'),
              onPressed: () {
                player?.pause();
                push(c, ExerciseScreen(session: s));
              },
              icon: const Icon(CupertinoIcons.pencil),
              label: Text(tr(c, 'Try the exercise', 'جرّب التمرين')),
            ),
            const SizedBox(height: 24),
            ExpansionTile(
              key: const ValueKey('transcript'),
              tilePadding: EdgeInsets.zero,
              title: Text(
                tr(c, 'Read the transcript', 'اقرأ النص المكتوب'),
                style: Theme.of(c).textTheme.titleMedium,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SelectableText(
                    transcript.isNotEmpty
                        ? transcript
                        : tr(
                            c,
                            'Transcript loads with the authored video. Retry the lesson if it is unavailable.',
                            'يُحمّل النص مع الفيديو المؤلّف. أعد تحميل الدرس إذا تعذّر عرضه.',
                          ),
                    style: Theme.of(c).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(28),
              color: mint,
              child: const Center(child: FrameMark(size: 90, color: ink)),
            ),
            const SizedBox(height: 24),
            body(
              c,
              tr(
                c,
                'Your next useful step: decide what the photograph is about before you decide where to place it.',
                'خطوتك المفيدة التالية: حدّد موضوع الصورة قبل أن تقرّر أين تضعه.',
              ),
            ),
            const SizedBox(height: 18),
            Text(
              tr(
                c,
                'Planned study: ${lessonMinutes[index]} minutes',
                'الدراسة المخطّطة: ${lessonMinutes[index]} دقائق',
              ),
              style: Theme.of(c).textTheme.bodyMedium?.copyWith(color: muted),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: muted),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tr(
                  c,
                  'This lesson is part of the planned curriculum. Its video has not been produced. Lesson 01 is the playable demo.',
                  'هذا الدرس جزء من المنهج المخطّط. لم يُنتج الفيديو بعد. الدرس 01 هو الدرس التجريبي القابل للتشغيل.',
                ),
                style: Theme.of(c).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              key: const ValueKey('return-first'),
              onPressed: () => Navigator.of(c)
                  .pushReplacement(route(LessonScreen(session: s, index: 0))),
              child: Text(tr(c, 'Return to lesson 01', 'عد إلى الدرس 01')),
            ),
          ],
        ],
      ),
    );
  }
}

class RecoveryBlock extends StatelessWidget {
  const RecoveryBlock({
    super.key,
    required this.message,
    required this.action,
    required this.onPressed,
  });
  final String message;
  final String action;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext c) => Semantics(
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_circle,
                color: recovery,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(c).textTheme.bodyMedium
                      ?.copyWith(color: recovery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const ValueKey('retry-save'),
            onPressed: onPressed,
            child: Text(action),
          ),
        ],
      ),
    ),
  );
}

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key, required this.session});
  final LearningSession session;
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late final TextEditingController note;
  final noteFocus = FocusNode();
  bool failPrepared = false;
  @override
  void initState() {
    super.initState();
    note = TextEditingController(text: widget.session.localNote);
  }

  @override
  void dispose() {
    note.dispose();
    noteFocus.dispose();
    super.dispose();
  }

  Future<void> save({bool complete = false}) async {
    FocusScope.of(context).unfocus();
    final result = await widget.session.save(complete: complete);
    if (result && complete && mounted) {
      Navigator.of(context)
          .pushReplacement(route(CompletionScreen(session: widget.session)));
    }
  }

  @override
  Widget build(BuildContext c) => AnimatedBuilder(
    animation: widget.session,
    builder: (c, _) {
      final s = widget.session;
      return Scaffold(
        appBar: TopBar(label: tr(c, 'Exercise 01', 'التمرين 01')),
        body: PageBody(
          children: [
            heading(c, tr(c, 'Centre. Then edge.', 'المنتصف. ثم الحافة.')),
            const SizedBox(height: 18),
            body(c, ar(c) ? practiceAr : practiceEn),
            const SizedBox(height: 20),
            Text(
              tr(
                c,
                'You need a phone or camera, one object and available light.',
                'ستحتاج إلى هاتف أو كاميرا، عنصر واحد والضوء المتاح.',
              ),
              style: Theme.of(c).textTheme.bodyMedium?.copyWith(color: muted),
            ),
            const SizedBox(height: 26),
            TextField(
              key: const ValueKey('practice-note'),
              controller: note,
              focusNode: noteFocus,
              minLines: 4,
              maxLines: 10,
              maxLength: 2000,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => FocusScope.of(c).unfocus(),
              onChanged: s.edit,
              decoration: InputDecoration(
                labelText: tr(c, 'Practice note', 'ملاحظة التمرين'),
                hintText: tr(
                  c,
                  'What changed when you moved the object?',
                  'ما الذي تغيّر عندما حرّكت العنصر؟',
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile.adaptive(
              key: const ValueKey('sample-attachment'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                tr(
                  c,
                  'Attach the local sample image',
                  'أرفق الصورة التجريبية المحلية',
                ),
              ),
              subtitle: Text(
                tr(
                  c,
                  'An example for this demo; no instructor review.',
                  'مثال لهذه التجربة؛ لم يراجعه مدرّس.',
                ),
              ),
              value: s.localAttachment,
              onChanged: s.pending ? null : (v) => s.attach(v ?? false),
            ),
            if (s.localAttachment) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/sample-practice.png',
                  height: 130,
                  fit: BoxFit.cover,
                  semanticLabel: tr(
                    c,
                    'Local sample: object placed within a photographic frame',
                    'الصورة التجريبية المحلية: عنصر داخل إطار فوتوغرافي',
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: Text(
                s.pending
                    ? tr(c, 'Saving…', 'جارٍ الحفظ…')
                    : s.confirmed
                    ? tr(c, 'Exercise draft saved.', 'تم حفظ مسودة التمرين.')
                    : s.error != null
                    ? tr(
                        c,
                        'Your exercise is still here.',
                        'تمرينك ما زال هنا.',
                      )
                    : s.dirty
                    ? tr(c, 'Unsaved changes', 'تغييرات غير محفوظة')
                    : tr(
                        c,
                        'Your note stays here while you practise.',
                        'تبقى ملاحظتك هنا أثناء التدريب.',
                      ),
                key: const ValueKey('save-status'),
                style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                  color: s.confirmed ? const Color(0xFF225C47) : muted,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (s.error == 'save' || s.error == 'complete') ...[
              RecoveryBlock(
                message: tr(
                  c,
                  'We couldn’t save your progress. Your exercise is still here. Try again.',
                  'تعذّر حفظ تقدّمك. تمرينك ما زال هنا. حاول مجدداً.',
                ),
                action: tr(c, 'Retry save', 'أعد محاولة الحفظ'),
                onPressed: () => save(complete: s.error == 'complete'),
              ),
              const SizedBox(height: 20),
            ],
            OutlinedButton(
              key: const ValueKey('save-draft'),
              onPressed: s.pending || (!s.dirty && s.confirmed) ? null : save,
              child: Text(tr(c, 'Save draft', 'احفظ المسودة')),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const ValueKey('complete-exercise'),
              onPressed:
                  s.pending ||
                      (s.localNote.trim().isEmpty && !s.localAttachment)
                  ? null
                  : () => save(complete: true),
              child: Text(tr(c, 'Mark exercise complete', 'أكمل التمرين')),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                c,
                'Completion is your decision. Playing the video does not complete the lesson.',
                'إكمال التمرين قرارك. تشغيل الفيديو لا يُكمل الدرس.',
              ),
              style: Theme.of(c).textTheme.bodySmall?.copyWith(color: muted),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(tr(c, 'Demo save recovery', 'تجربة استعادة الحفظ')),
              children: [
                Text(
                  tr(
                    c,
                    'Make the next save fail once to see how your work is retained. Retry then saves to the shared demo session.',
                    'اجعل محاولة الحفظ التالية تفشل مرة واحدة لترى كيف يبقى عملك. ثم احفظ مجدداً في الجلسة التجريبية المشتركة.',
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  key: const ValueKey('fail-next'),
                  onPressed: () async {
                    await s.failNext();
                    if (mounted) {
                      setState(() {
                        failPrepared = true;
                      });
                    }
                  },
                  child: Text(
                    failPrepared
                        ? tr(
                            c,
                            'Next save will fail once',
                            'ستفشل محاولة الحفظ التالية مرة واحدة',
                          )
                        : tr(
                            c,
                            'Prepare controlled save failure',
                            'جهّز فشلاً مضبوطاً للحفظ',
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key, required this.session});
  final LearningSession session;
  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: TopBar(label: tr(c, 'Progress', 'التقدّم')),
    body: PageBody(
      children: [
        const SizedBox(height: 24),
        Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.all(28),
          color: mint,
          child: const Icon(
            CupertinoIcons.check_mark_circled,
            color: Color(0xFF225C47),
            size: 56,
          ),
        ),
        const SizedBox(height: 28),
        heading(c, tr(c, 'Progress saved.', 'تم حفظ تقدّمك.')),
        const SizedBox(height: 16),
        StatusText(session: session),
        const SizedBox(height: 22),
        body(c, tr(c, 'Your next lesson is ready.', 'درسك التالي جاهز.')),
        const SizedBox(height: 18),
        Text('02  ${title(c, 1)}', style: Theme.of(c).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          tr(c, '10 minutes · planned study', '10 دقائق · دراسة مخطّطة'),
          style: Theme.of(c).textTheme.bodyMedium?.copyWith(color: muted),
        ),
        const SizedBox(height: 28),
        FilledButton(
          key: const ValueKey('continue-next'),
          onPressed: () => Navigator.of(c)
              .pushReplacement(route(LessonScreen(session: session, index: 1))),
          child: Text(tr(c, 'Continue lesson', 'تابع الدرس')),
        ),
        const SizedBox(height: 14),
        TextButton(
          key: const ValueKey('back-learning'),
          onPressed: () => Navigator.of(c).popUntil((r) => r.isFirst),
          child: Text(tr(c, 'Back to My learning', 'عد إلى تعلّمي')),
        ),
      ],
    ),
  );
}

class ProgressBody extends StatelessWidget {
  const ProgressBody({super.key, required this.session});
  final LearningSession session;
  @override
  Widget build(BuildContext c) => PageBody(
    children: [
      const SizedBox(height: 12),
      Text(
        tr(c, 'Progress', 'التقدّم'),
        style: Theme.of(c).textTheme.headlineLarge,
      ),
      const SizedBox(height: 20),
      SessionLabel(session: session),
      const SizedBox(height: 28),
      heading(c, tr(c, 'Composition Essentials', 'أساسيات التكوين')),
      const SizedBox(height: 16),
      StatusText(session: session),
      const SizedBox(height: 16),
      LinearProgressIndicator(
        value: session.count / 6,
        minHeight: 4,
        color: blue,
        backgroundColor: const Color(0xFFE0E6F1),
      ),
      const SizedBox(height: 28),
      ...List.generate(6, (i) => LessonRow(session: session, index: i)),
      const SizedBox(height: 24),
      if (session.confirmed)
        Text(
          tr(
            c,
            'Your exercise draft is saved in this demo session.',
            'تم حفظ مسودة تمرينك في هذه الجلسة التجريبية.',
          ),
          style: Theme.of(c).textTheme.bodyMedium
              ?.copyWith(color: const Color(0xFF225C47)),
        ),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: () => push(
          c,
          LessonScreen(session: session, index: session.firstComplete ? 1 : 0),
        ),
        child: Text(tr(c, 'Continue lesson', 'تابع الدرس')),
      ),
    ],
  );
}
