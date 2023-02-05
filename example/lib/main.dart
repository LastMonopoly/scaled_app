import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:scaled_app/scaled_app.dart";

import 'scale_media_query_data.dart';
import 'scale_the_app.dart';

ScaleFactorCallback scaleFactorCallback = (deviceSize) {
  // screen width used in your UI design
  const double widthOfDesign = 375;
  return deviceSize.width / widthOfDesign;
};

void main() {
  // 1st way to use this package
  runAppScaled(const MyApp(), scaleFactor: scaleFactorCallback);

  // 2nd way to use this package
  // Scaling will be applied based on [scaleFactor] callback.
  // ScaledWidgetsFlutterBinding.ensureInitialized(
  //   scaleFactor: scaleFactorCallback,
  // );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = "Scaled app demo";
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
        fontFamily: "Roboto",
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  bool scaleMediaQueryData = true;

  @override
  Widget build(BuildContext context) {
    final originalMediaQueryData = MediaQuery.of(context);
    final scaledMediaQueryData = originalMediaQueryData.scale();

    return MediaQuery(
      // Don't forget to scale mediaQueryData in order to properly display keyboard
      data: scaleMediaQueryData ? scaledMediaQueryData : originalMediaQueryData,
      child: Scaffold(
        bottomNavigationBar: kIsWeb
            ? null
            : NavigationBar(
                onDestinationSelected: (int index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                selectedIndex: currentPageIndex,
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: Icon(Icons.toggle_on_outlined),
                    label: 'Enable / disable',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.keyboard_capslock),
                    label: 'MediaQueryData',
                  ),
                ],
              ),
        body: <Widget>[
          ScaledAppDemo(mediaQueryData: originalMediaQueryData),
          ScaledMediaQueryDataDemo(
            scaleMediaQueryData: scaleMediaQueryData,
            mediaQueryData: scaleMediaQueryData
                ? scaledMediaQueryData
                : originalMediaQueryData,
            onToggleScaleMediaQueryData: (value) {
              setState(() {
                scaleMediaQueryData = value;
              });
            },
          ),
        ][currentPageIndex],
      ),
    );
  }
}
