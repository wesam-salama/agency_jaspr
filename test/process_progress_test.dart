import 'package:agency_jaspr/runtime/process_progress.dart';
import 'package:test/test.dart';

void main() {
  double progress(double top, {double viewport = 1000, double height = 1800}) => processProgress(
    viewportHeight: viewport,
    timelineTop: top,
    timelineHeight: height,
  );

  test('clamps before the section, after its end, and for an empty timeline', () {
    expect(progress(900), 0);
    expect(progress(-2000), 1800);
    expect(progress(0, height: 0), 0);
    // The original first dot is active even when clamped to zero.
    expect(processStepActive(0, progress(900)), isTrue);
    expect(processStepActive(300, progress(900)), isFalse);
  });

  test('tracks the 70% viewport reference and the exact eight-pixel threshold', () {
    expect(progress(200), 500);
    expect(processStepActive(508, 500), isTrue);
    expect(processStepActive(509, 500), isFalse);
  });

  test('scrolling back retracts the line and deactivates previously passed dots', () {
    final offsets = [0.0, 300.0, 600.0, 900.0, 1200.0, 1500.0];
    final down = offsets.map((offset) => processStepActive(offset, progress(-250))).toList();
    final up = offsets.map((offset) => processStepActive(offset, progress(500))).toList();
    expect(down, [true, true, true, true, false, false]);
    expect(up, [true, false, false, false, false, false]);
  });

  test('recalculates from current viewport and timeline dimensions after layout changes', () {
    expect(progress(200), 500);
    expect(progress(200, viewport: 600), 220);
    expect(progress(-250, height: 800), 800);
    expect(progress(-250, height: 2000), 950);
  });
}
