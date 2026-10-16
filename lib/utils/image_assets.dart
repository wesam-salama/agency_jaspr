/// Responsive WebP sources and the intrinsic dimensions of their full-size image.
class ImageAsset {
  const ImageAsset({required this.src, required this.srcSet, required this.width, required this.height});

  final String src;
  final String srcSet;
  final int width;
  final int height;
}

/// Looks up optimized metadata by its local source path.
///
/// Unknown sources return null so callers can retain their existing source.
ImageAsset? imageAssetFor(String source) => _imageAssets[source];

const Map<String, ImageAsset> _imageAssets = {
  'assets/selected-work/fold/card.webp': ImageAsset(
    src: 'assets/selected-work/fold/card.webp',
    srcSet:
        'assets/selected-work/fold/card-480.webp 480w, assets/selected-work/fold/card-960.webp 960w, assets/selected-work/fold/card.webp 1600w',
    width: 1600,
    height: 1000,
  ),
  'assets/selected-work/fold/hero.webp': ImageAsset(
    src: 'assets/selected-work/fold/hero.webp',
    srcSet:
        'assets/selected-work/fold/hero-480.webp 480w, assets/selected-work/fold/hero-960.webp 960w, assets/selected-work/fold/hero.webp 2560w',
    width: 2560,
    height: 1600,
  ),
  'assets/selected-work/fold/case/identity.webp': ImageAsset(
    src: 'assets/selected-work/fold/case/identity.webp',
    srcSet: 'assets/selected-work/fold/case/identity-960.webp 960w, assets/selected-work/fold/case/identity.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/fold/case/continuity.webp': ImageAsset(
    src: 'assets/selected-work/fold/case/continuity.webp',
    srcSet:
        'assets/selected-work/fold/case/continuity-960.webp 960w, assets/selected-work/fold/case/continuity.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/fold/case/measurements.webp': ImageAsset(
    src: 'assets/selected-work/fold/case/measurements.webp',
    srcSet:
        'assets/selected-work/fold/case/measurements-960.webp 960w, assets/selected-work/fold/case/measurements.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/fold/case/shopping.webp': ImageAsset(
    src: 'assets/selected-work/fold/case/shopping.webp',
    srcSet: 'assets/selected-work/fold/case/shopping-960.webp 960w, assets/selected-work/fold/case/shopping.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/fold/case/maintenance.webp': ImageAsset(
    src: 'assets/selected-work/fold/case/maintenance.webp',
    srcSet:
        'assets/selected-work/fold/case/maintenance-960.webp 960w, assets/selected-work/fold/case/maintenance.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/frame/card.webp': ImageAsset(
    src: 'assets/selected-work/frame/card.webp',
    srcSet:
        'assets/selected-work/frame/card-480.webp 480w, assets/selected-work/frame/card-960.webp 960w, assets/selected-work/frame/card.webp 1600w',
    width: 1600,
    height: 1000,
  ),
  'assets/selected-work/frame/hero.webp': ImageAsset(
    src: 'assets/selected-work/frame/hero.webp',
    srcSet:
        'assets/selected-work/frame/hero-480.webp 480w, assets/selected-work/frame/hero-960.webp 960w, assets/selected-work/frame/hero.webp 2560w',
    width: 2560,
    height: 1600,
  ),
  'assets/selected-work/frame/identity.webp': ImageAsset(
    src: 'assets/selected-work/frame/identity.webp',
    srcSet: 'assets/selected-work/frame/identity-960.webp 960w, assets/selected-work/frame/identity.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/frame/course-discovery.webp': ImageAsset(
    src: 'assets/selected-work/frame/course-discovery.webp',
    srcSet:
        'assets/selected-work/frame/course-discovery-960.webp 960w, assets/selected-work/frame/course-discovery.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/frame/lesson-continuation.webp': ImageAsset(
    src: 'assets/selected-work/frame/lesson-continuation.webp',
    srcSet:
        'assets/selected-work/frame/lesson-continuation-960.webp 960w, assets/selected-work/frame/lesson-continuation.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/frame/exercise-recovery.webp': ImageAsset(
    src: 'assets/selected-work/frame/exercise-recovery.webp',
    srcSet:
        'assets/selected-work/frame/exercise-recovery-960.webp 960w, assets/selected-work/frame/exercise-recovery.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/frame/arabic-journey.webp': ImageAsset(
    src: 'assets/selected-work/frame/arabic-journey.webp',
    srcSet:
        'assets/selected-work/frame/arabic-journey-960.webp 960w, assets/selected-work/frame/arabic-journey.webp 2400w',
    width: 2400,
    height: 1600,
  ),
  'assets/selected-work/form/card.webp': ImageAsset(
    src: 'assets/selected-work/form/card.webp',
    srcSet:
        'assets/selected-work/form/card-480.webp 480w, assets/selected-work/form/card-960.webp 960w, assets/selected-work/form/card.webp 1600w',
    width: 1600,
    height: 1000,
  ),
  'assets/selected-work/form/hero.webp': ImageAsset(
    src: 'assets/selected-work/form/hero.webp',
    srcSet:
        'assets/selected-work/form/hero-480.webp 480w, assets/selected-work/form/hero-960.webp 960w, assets/selected-work/form/hero.webp 2560w',
    width: 2560,
    height: 1600,
  ),
  'assets/selected-work/form/identity-system.webp': ImageAsset(
    src: 'assets/selected-work/form/identity-system.webp',
    srcSet:
        'assets/selected-work/form/identity-system-960.webp 960w, assets/selected-work/form/identity-system.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/baseline.webp': ImageAsset(
    src: 'assets/selected-work/form/baseline.webp',
    srcSet: 'assets/selected-work/form/baseline-960.webp 960w, assets/selected-work/form/baseline.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/redesign.webp': ImageAsset(
    src: 'assets/selected-work/form/redesign.webp',
    srcSet: 'assets/selected-work/form/redesign-960.webp 960w, assets/selected-work/form/redesign.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/project-desktop.webp': ImageAsset(
    src: 'assets/selected-work/form/project-desktop.webp',
    srcSet:
        'assets/selected-work/form/project-desktop-960.webp 960w, assets/selected-work/form/project-desktop.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/project-mobile.webp': ImageAsset(
    src: 'assets/selected-work/form/project-mobile.webp',
    srcSet:
        'assets/selected-work/form/project-mobile-960.webp 960w, assets/selected-work/form/project-mobile.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/enquiry-states.webp': ImageAsset(
    src: 'assets/selected-work/form/enquiry-states.webp',
    srcSet:
        'assets/selected-work/form/enquiry-states-960.webp 960w, assets/selected-work/form/enquiry-states.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/cms-edit.webp': ImageAsset(
    src: 'assets/selected-work/form/cms-edit.webp',
    srcSet: 'assets/selected-work/form/cms-edit-960.webp 960w, assets/selected-work/form/cms-edit.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/details/wordmark.webp': ImageAsset(
    src: 'assets/selected-work/form/details/wordmark.webp',
    srcSet:
        'assets/selected-work/form/details/wordmark-960.webp 960w, assets/selected-work/form/details/wordmark.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/details/image-crop.webp': ImageAsset(
    src: 'assets/selected-work/form/details/image-crop.webp',
    srcSet:
        'assets/selected-work/form/details/image-crop-960.webp 960w, assets/selected-work/form/details/image-crop.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/form/details/project-facts.webp': ImageAsset(
    src: 'assets/selected-work/form/details/project-facts.webp',
    srcSet:
        'assets/selected-work/form/details/project-facts-960.webp 960w, assets/selected-work/form/details/project-facts.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/sift/card.webp': ImageAsset(
    src: 'assets/selected-work/sift/card.webp',
    srcSet:
        'assets/selected-work/sift/card-480.webp 480w, assets/selected-work/sift/card-960.webp 960w, assets/selected-work/sift/card.webp 1586w',
    width: 1586,
    height: 992,
  ),
  'assets/selected-work/sift/hero.webp': ImageAsset(
    src: 'assets/selected-work/sift/hero.webp',
    srcSet:
        'assets/selected-work/sift/hero-480.webp 480w, assets/selected-work/sift/hero-960.webp 960w, assets/selected-work/sift/hero.webp 1586w',
    width: 1586,
    height: 992,
  ),
  'assets/selected-work/sift/identity.webp': ImageAsset(
    src: 'assets/selected-work/sift/identity.webp',
    srcSet: 'assets/selected-work/sift/identity-960.webp 960w, assets/selected-work/sift/identity.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/sift/range.webp': ImageAsset(
    src: 'assets/selected-work/sift/range.webp',
    srcSet: 'assets/selected-work/sift/range-960.webp 960w, assets/selected-work/sift/range.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/sift/bilingual.webp': ImageAsset(
    src: 'assets/selected-work/sift/bilingual.webp',
    srcSet: 'assets/selected-work/sift/bilingual-960.webp 960w, assets/selected-work/sift/bilingual.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/selected-work/sift/applications.webp': ImageAsset(
    src: 'assets/selected-work/sift/applications.webp',
    srcSet: 'assets/selected-work/sift/applications-960.webp 960w, assets/selected-work/sift/applications.webp 2000w',
    width: 2000,
    height: 1500,
  ),
  'assets/images/fenwick-card.jpg': ImageAsset(
    src: 'assets/images/fenwick-card.webp',
    srcSet:
        'assets/images/fenwick-card-480.webp 480w, assets/images/fenwick-card-960.webp 960w, assets/images/fenwick-card.webp 1600w',
    width: 1600,
    height: 1067,
  ),
  'assets/images/fenwick-chair.jpg': ImageAsset(
    src: 'assets/images/fenwick-chair.webp',
    srcSet:
        'assets/images/fenwick-chair-480.webp 480w, assets/images/fenwick-chair-960.webp 960w, assets/images/fenwick-chair.webp 1400w',
    width: 1400,
    height: 2099,
  ),
  'assets/images/fenwick-hero.jpg': ImageAsset(
    src: 'assets/images/fenwick-hero.webp',
    srcSet:
        'assets/images/fenwick-hero-480.webp 480w, assets/images/fenwick-hero-960.webp 960w, assets/images/fenwick-hero.webp 2000w',
    width: 2000,
    height: 1333,
  ),
  'assets/images/fenwick-room.jpg': ImageAsset(
    src: 'assets/images/fenwick-room.webp',
    srcSet:
        'assets/images/fenwick-room-480.webp 480w, assets/images/fenwick-room-960.webp 960w, assets/images/fenwick-room.webp 1400w',
    width: 1400,
    height: 1235,
  ),
  'assets/images/loop-card.jpg': ImageAsset(
    src: 'assets/images/loop-card.webp',
    srcSet:
        'assets/images/loop-card-480.webp 480w, assets/images/loop-card-960.webp 960w, assets/images/loop-card.webp 1600w',
    width: 1600,
    height: 1067,
  ),
  'assets/images/loop-hero.jpg': ImageAsset(
    src: 'assets/images/loop-hero.webp',
    srcSet:
        'assets/images/loop-hero-480.webp 480w, assets/images/loop-hero-960.webp 960w, assets/images/loop-hero.webp 2000w',
    width: 2000,
    height: 1333,
  ),
  'assets/images/loop-onboarding.jpg': ImageAsset(
    src: 'assets/images/loop-onboarding.webp',
    srcSet: 'assets/images/loop-onboarding-480.webp 480w, assets/images/loop-onboarding.webp 900w',
    width: 900,
    height: 600,
  ),
  // The legacy phone JPEG contains a 404 page. Reuse the valid onboarding photo.
  'assets/images/loop-phone.jpg': ImageAsset(
    src: 'assets/images/loop-onboarding.webp',
    srcSet: 'assets/images/loop-onboarding-480.webp 480w, assets/images/loop-onboarding.webp 900w',
    width: 900,
    height: 600,
  ),
  'assets/images/loop-review.jpg': ImageAsset(
    src: 'assets/images/loop-review.webp',
    srcSet: 'assets/images/loop-review-480.webp 480w, assets/images/loop-review.webp 900w',
    width: 900,
    height: 1125,
  ),
  'assets/images/loop-widgets.jpg': ImageAsset(
    src: 'assets/images/loop-widgets.webp',
    srcSet: 'assets/images/loop-widgets-480.webp 480w, assets/images/loop-widgets.webp 900w',
    width: 900,
    height: 1125,
  ),
  'assets/images/marrow-card.jpg': ImageAsset(
    src: 'assets/images/marrow-card.webp',
    srcSet:
        'assets/images/marrow-card-480.webp 480w, assets/images/marrow-card-960.webp 960w, assets/images/marrow-card.webp 1600w',
    width: 1600,
    height: 1067,
  ),
  'assets/images/marrow-food.jpg': ImageAsset(
    src: 'assets/images/marrow-food.webp',
    srcSet:
        'assets/images/marrow-food-480.webp 480w, assets/images/marrow-food-960.webp 960w, assets/images/marrow-food.webp 1400w',
    width: 1400,
    height: 933,
  ),
  'assets/images/marrow-hero.jpg': ImageAsset(
    src: 'assets/images/marrow-hero.webp',
    srcSet:
        'assets/images/marrow-hero-480.webp 480w, assets/images/marrow-hero-960.webp 960w, assets/images/marrow-hero.webp 2000w',
    width: 2000,
    height: 1333,
  ),
  'assets/images/marrow-pack.jpg': ImageAsset(
    src: 'assets/images/marrow-pack.webp',
    srcSet:
        'assets/images/marrow-pack-480.webp 480w, assets/images/marrow-pack-960.webp 960w, assets/images/marrow-pack.webp 1400w',
    width: 1400,
    height: 875,
  ),
  'assets/images/marrow-salad.jpg': ImageAsset(
    src: 'assets/images/marrow-salad.webp',
    srcSet:
        'assets/images/marrow-salad-480.webp 480w, assets/images/marrow-salad-960.webp 960w, assets/images/marrow-salad.webp 1400w',
    width: 1400,
    height: 1400,
  ),
  'assets/images/northline-card.jpg': ImageAsset(
    src: 'assets/images/northline-card.webp',
    srcSet:
        'assets/images/northline-card-480.webp 480w, assets/images/northline-card-960.webp 960w, assets/images/northline-card.webp 1600w',
    width: 1600,
    height: 1067,
  ),
  'assets/images/northline-city.jpg': ImageAsset(
    src: 'assets/images/northline-city.webp',
    srcSet:
        'assets/images/northline-city-480.webp 480w, assets/images/northline-city-960.webp 960w, assets/images/northline-city.webp 1400w',
    width: 1400,
    height: 861,
  ),
  'assets/images/northline-field.jpg': ImageAsset(
    src: 'assets/images/northline-field.webp',
    srcSet:
        'assets/images/northline-field-480.webp 480w, assets/images/northline-field-960.webp 960w, assets/images/northline-field.webp 1400w',
    width: 1400,
    height: 788,
  ),
  'assets/images/northline-hero.jpg': ImageAsset(
    src: 'assets/images/northline-hero.webp',
    srcSet:
        'assets/images/northline-hero-480.webp 480w, assets/images/northline-hero-960.webp 960w, assets/images/northline-hero.webp 2000w',
    width: 2000,
    height: 1333,
  ),
};
