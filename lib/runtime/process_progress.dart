/// The reference timeline follows a point 70% down the viewport.
double processProgress({required double viewportHeight, required double timelineTop, required double timelineHeight}) =>
    (viewportHeight * .7 - timelineTop).clamp(0.0, timelineHeight);

bool processStepActive(double rowOffset, double progress) => rowOffset <= progress + 8;
