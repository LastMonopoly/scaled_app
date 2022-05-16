<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Scale the entire UI design proportionally.

Button, image, font, everything is scaled automatically.

Before:
- 250x250 square is the same size across devices

![Screenshots of the same design before scaling](https://raw.githubusercontent.com/LastMonopoly/scaled_app/master/doc/Before.png "Screenshots before scaling")
  
After:
- 250x250 square is two thirds the screen width across devices

![Screenshots of the same design after scaling](https://raw.githubusercontent.com/LastMonopoly/scaled_app/master/doc/After.png "Screenshots after scaling")

- if we resize the screenshots above to be the same width
- then everything appears the same size across devices (see below)

![Resized screenshots of the same design after scaling](https://raw.githubusercontent.com/LastMonopoly/scaled_app/master/doc/After_2.png "Resized screenshots after scaling")


## Features

Use this package in your Flutter app when:

- the UI design is fixed-width
- you want to scale the entire UI, not just part of it

## Getting Started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  scaled_app: ^0.1.8
```

For projects using Flutter 3.0, add the following dependency:

```yaml
dependencies:
  ...
  scaled_app:
    git:
      url: https://github.com/LastMonopoly/scaled_app.git
      ref: master
```

Import it:

```dart
import 'package:scaled_app/scaled_app.dart';
```

## Usage

Replace `runApp` with `runAppScaled`
```dart
void main() {
  // 1st way to use this package
  // baseWidth is the screen width used for your UI design
  runAppScaled(const MyApp(), baseWidth: 375);
}
```
Or, replace `WidgetsFlutterBinding` with `ScaledWidgetsFlutterBinding`
```dart
void main() {
  // 2nd way to use this package
  // Scaling will be applied when [applyScaling] returns true.
  ScaledWidgetsFlutterBinding.ensureInitialized(
    baseWidth: 375,
    applyScaling: (deviceWidth) => deviceWidth > 300 && deviceWidth < 400,
  );
  runAppScaled(const MyApp());
}
```

<!-- ## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more. -->
