import "package:flutter/material.dart";
import "package:scaled_app/scaled_app.dart";
import "package:scaled_app_example/layout_block.dart";

import "media_query_data_text.dart";
import "new_page.dart";

// screen width used in your UI design
const double baseWidth = 375;
bool applyScaling = true;

void main() {
  // 1st way to use runAppScaled
  runAppScaled(
    const MyApp(),
    baseWidth: baseWidth,
    applyScaling: (deviceWidth) {
      debugPrint("Scaling: $applyScaling");
      return applyScaling;
    },
  );

  // 2nd way to use runAppScaled
  // Scaling will be applied when [applyScaling] returns true
  // ScaledWidgetsFlutterBinding.ensureInitialized(
  //   baseWidth: baseWidth,
  //   applyScaling: (deviceWidth) => deviceWidth > 300 && deviceWidth < 450,
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
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FocusNode focusNode = FocusNode();
  bool scaleMediaQueryData = true;

  @override
  Widget build(BuildContext context) {
    final originalMediaQueryData = MediaQuery.of(context);
    late final MediaQueryData scaledMediaQueryData;

    // Scale mediaQueryData to properly display keyboard
    if (scaleMediaQueryData) {
      scaledMediaQueryData = originalMediaQueryData.scale(baseWidth);
    }

    return MediaQuery(
      data: scaleMediaQueryData ? scaledMediaQueryData : originalMediaQueryData,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            Tooltip(
              message: "Scale mediaQueryData",
              child: Switch(
                value: scaleMediaQueryData,
                activeColor: Colors.purple.shade300,
                onChanged: (bool toScale) {
                  setState(() {
                    scaleMediaQueryData = toScale;
                  });
                },
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            Offstage(
              child: TextField(focusNode: focusNode),
            ),
            const LayoutBlock(),
            MediaQueryDataText(
              originalMediaQueryData,
              title: "Original mediaQueryData",
            ),
            if (scaleMediaQueryData)
              MediaQueryDataText(
                scaledMediaQueryData,
                title: "Scaled mediaQueryData",
              ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: applyScaling
                  ? const Icon(Icons.toggle_on)
                  : const Icon(Icons.toggle_off),
              onPressed: () {
                setState(() {
                  applyScaling = !applyScaling;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              heroTag: "btn2",
              tooltip: "Push/pop keyboard",
              child: const Icon(Icons.keyboard),
              onPressed: () {
                if (focusNode.hasFocus) {
                  focusNode.unfocus();
                } else {
                  focusNode.requestFocus();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
