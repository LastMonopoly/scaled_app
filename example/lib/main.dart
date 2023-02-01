import "package:flutter/material.dart";
import "package:scaled_app/scaled_app.dart";

import 'scale_media_query_data.dart';
import 'scale_the_app.dart';

// screen width used in your UI design
const double baseWidth = 375;

void main() {
  // 1st way to use runAppScaled
  runAppScaled(
    const MyApp(),
    scaleFactor: (deviceSize) => deviceSize.width / baseWidth,
  );

  // 2nd way to use runAppScaled
  // Scaling will be applied based on [scaleFactor] function.
  // ScaledWidgetsFlutterBinding.ensureInitialized(
  //   scaleFactor: (deviceSize) => deviceSize.width / baseWidth,
  // );
  // runAppScaled(const MyApp());
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

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Scale mediaQueryData to properly display keyboard
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
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
          const ScaledAppDemo(),
          const ScaledMediaQueryDataDemo(),
        ][currentPageIndex],
      ),
    );
  }
}
