import 'dart:io';
import 'dart:typed_data';

import 'package:agency_jaspr/data/site_data.dart';
import 'package:agency_jaspr/utils/image_assets.dart';
import 'package:test/test.dart';

void main() {
  test('every case image resolves to valid WebP sources and intrinsic dimensions', () {
    final sources = <String>{
      for (final project in workProjects) project.cardImage,
      for (final study in caseStudies) ...[
        study.heroImage,
        for (final figure in study.figures) figure.image,
        for (final chapter in study.chapters) chapter.image,
      ],
    };

    for (final source in sources) {
      final asset = imageAssetFor(source);
      expect(asset, isNotNull, reason: source);
      final fullSize = _dimensions(File('web/${asset!.src}'));
      expect(fullSize, (width: asset.width, height: asset.height), reason: source);

      var previousWidth = 0;
      for (final candidate in asset.srcSet.split(', ')) {
        final parts = candidate.split(' ');
        final width = int.parse(parts.last.replaceFirst('w', ''));
        final size = _dimensions(File('web/${parts.first}'));
        expect(size.width, width, reason: candidate);
        expect(width, greaterThan(previousWidth), reason: candidate);
        expect(width, lessThanOrEqualTo(asset.width), reason: candidate);
        expect(size.height, lessThanOrEqualTo(asset.height), reason: candidate);
        expect(
          size.height,
          closeTo(asset.height * width / asset.width, 1),
          reason: 'The responsive candidate preserves its source aspect ratio: $candidate',
        );
        previousWidth = width;
      }
      expect(previousWidth, asset.width, reason: source);
    }
  });

  test('broken legacy phone source uses the existing onboarding photo', () {
    final phone = imageAssetFor('assets/images/loop-phone.jpg');
    final onboarding = imageAssetFor('assets/images/loop-onboarding.jpg');

    expect(phone!.src, onboarding!.src);
    expect(phone.srcSet, onboarding.srcSet);
    expect((width: phone.width, height: phone.height), (width: onboarding.width, height: onboarding.height));
  });

  test('unknown image sources retain a nullable fallback', () {
    expect(imageAssetFor('assets/images/unknown.jpg'), isNull);
  });
}

({int width, int height}) _dimensions(File file) {
  expect(file.existsSync(), isTrue, reason: file.path);
  final bytes = file.readAsBytesSync();
  final data = ByteData.sublistView(bytes);
  expect(String.fromCharCodes(bytes.sublist(0, 4)), 'RIFF', reason: file.path);
  expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WEBP', reason: file.path);

  for (var offset = 12; offset + 8 <= bytes.length;) {
    final type = String.fromCharCodes(bytes.sublist(offset, offset + 4));
    final length = data.getUint32(offset + 4, Endian.little);
    final start = offset + 8;
    if (type == 'VP8 ') {
      return (
        width: data.getUint16(start + 6, Endian.little) & 0x3fff,
        height: data.getUint16(start + 8, Endian.little) & 0x3fff,
      );
    }
    offset = start + length + (length % 2);
  }
  throw FormatException('No lossy WebP image frame in ${file.path}');
}
