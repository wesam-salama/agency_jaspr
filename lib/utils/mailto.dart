String buildProjectMailto({
  required String name,
  required String email,
  required Iterable<String> selectedServices,
  required String message,
}) {
  final points = selectedServices.isEmpty ? 'Not sure yet' : selectedServices.join(' + ');
  final subject = Uri.encodeComponent('New project enquiry, $name');
  final body = Uri.encodeComponent('Name: $name\nEmail: $email\nPoints: $points\n\n$message');
  return 'mailto:hello@cr8.media?subject=$subject&body=$body';
}
