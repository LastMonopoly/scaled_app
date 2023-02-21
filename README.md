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

Button, image, font, every widget is scaled simultaneously.

Before:
- 250x250 square is the same size across devices

![Screenshots of the same design before scaling](https://raw.githubusercontent.com/LastMonopoly/scaled_app/master/screenshots/Before.png "Screenshots before scaling")
  
After:
- 250x250 square is two thirds the screen width across devices

![Screenshots of the same design after scaling](https://raw.githubusercontent.com/LastMonopoly/scaled_app/master/screenshots/After.png "Screenshots after scaling")

- if we resize the screenshots above to be the same width
- then everything appears the same size as below

![Resized screenshots of the same design after scaling](https://raw.githubusercontent.com/LastMonopoly/scaled_app/master/screenshots/After_2.png "Resized screenshots after scaling")

## Live demo

https://lastmonopoly.github.io/flutter_web_app/scaled_app_demo/

## Features

Use this package in your Flutter app when:

- your UI design is fixed-width
- you want to scale the entire UI, not just part of it

## Usage

Firstly, replace `runApp` with `runAppScaled`
```dart
void main() {
  // 1st way to use this package
  runAppScaled(const MyApp(), scaleFactor: (deviceSize) {
    // screen width used in your UI design
    const double widthOfDesign = 375;
    return deviceSize.width / widthOfDesign;
  });
}
```
Or, replace `WidgetsFlutterBinding` with `ScaledWidgetsFlutterBinding`
```dart
void main() {
  // 2nd way to use this package
  // Scaling will be applied based on [scaleFactor] callback.
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      const double widthOfDesign = 375;
      return deviceSize.width / widthOfDesign;
    },
  );
  runApp(const MyApp());
}
```
Then, use `MediaQueryData.scale` to scale size, viewInsets, viewPadding, etc.
```dart
class PageRoute extends StatelessWidget {
  const PageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: const Scaffold(...),
    );
  }
}
```
Optionally, update `ScaledWidgetsFlutterBinding.instance.scaleFactor` to enable / disable scaling on demand.

## Reference

https://juejin.cn/post/7078816723666731021
