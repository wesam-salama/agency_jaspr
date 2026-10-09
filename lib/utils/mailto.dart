String buildProjectMailto({
  required String name,
  required String email,
  required Iterable<String> selectedServices,
  required String message,
  String? timing,
}) {
  final points = selectedServices.isEmpty ? 'Not sure yet' : selectedServices.join(' + ');
  final normalizedTiming = timing?.trim();
  final timingLine = normalizedTiming == null || normalizedTiming.isEmpty || normalizedTiming == 'Not sure yet'
      ? ''
      : '\nTiming: $normalizedTiming';
  final subject = Uri.encodeComponent('New project enquiry, $name');
  final body = Uri.encodeComponent('Name: $name\nEmail: $email\nPoints: $points$timingLine\n\n$message');
  return 'mailto:hello@cr8.media?subject=$subject&body=$body';
}
