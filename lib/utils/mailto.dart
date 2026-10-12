import '../l10n/site_content.dart';

String buildProjectMailto({
  required String name,
  required String email,
  required Iterable<String> selectedServices,
  required String message,
  String? timing,
  SiteLocale locale = SiteLocale.en,
}) {
  final content = siteContentFor(locale);
  final serviceLabels = selectedServices.map((service) {
    final index = int.tryParse(service);
    return index != null && index >= 0 && index < content.serviceNames.length ? content.serviceNames[index] : service;
  }).toList();
  final points = serviceLabels.isEmpty ? content.t(UiTextKey.mailtoUndecided) : serviceLabels.join(' + ');
  final normalizedTiming = timing?.trim();
  final timingLabel = normalizedTiming == null ? null : content.timingLabels[normalizedTiming] ?? normalizedTiming;
  final timingLine =
      timingLabel == null ||
          timingLabel.isEmpty ||
          normalizedTiming == 'unsure' ||
          normalizedTiming == 'Not sure yet' ||
          timingLabel == content.t(UiTextKey.mailtoUndecided)
      ? ''
      : '\n${content.t(UiTextKey.mailtoTiming)}: $timingLabel';
  final subject = Uri.encodeComponent(content.t(UiTextKey.mailtoSubject, values: {'name': name}));
  final body = Uri.encodeComponent(
    '${content.t(UiTextKey.mailtoName)}: $name\n'
    '${content.t(UiTextKey.mailtoEmail)}: $email\n'
    '${content.t(UiTextKey.mailtoPoints)}: $points$timingLine\n\n$message',
  );
  return 'mailto:hello@cr8.media?subject=$subject&body=$body';
}
