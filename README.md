# CR8.Media agency website — Jaspr

Static Jaspr/Dart recreation of `../agency_website.html`. The original HTML file is the visual and behavioral reference and is not modified by this project.

## Requirements

- Dart 3.11 or newer
- Jaspr CLI 0.23.4

```sh
dart pub global activate jaspr_cli 0.23.4
dart pub get
```

## Develop

```sh
jaspr serve
```

Jaspr serves the site at `http://localhost:8080` by default. The app uses static prerendering and hydrates only the client runtime responsible for interactions and animation.

## Verify

```sh
dart format --output=none --set-exit-if-changed lib tool test
dart analyze
dart test
jaspr build
```

The deployable static output is generated in `build/jaspr/`.

## Reference-generated markup

`lib/generated/agency_markup.dart` and `web/assets/styles.css` are generated from the reference document. To regenerate them after an intentional reference change, run:

```sh
dart run tool/generate_markup.dart
dart format lib/generated/agency_markup.dart
```

All fonts and image responses used by the clone are vendored under `web/assets/` so builds remain deterministic.
