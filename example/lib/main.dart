import "package:flutter/material.dart";
import "package:scaled_app/scaled_app.dart";

// screen width used in your UI design
const double baseWidth = 375;

void main() {
  // 1st way to use runAppScaled
  runAppScaled(const MyApp(), baseWidth: baseWidth);

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
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(color: Colors.purple.shade200),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(color: Colors.purple.shade100),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(color: Colors.purple.shade50),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.purple.shade50,
                width: 250,
                child: const AspectRatio(
                  aspectRatio: 1,
                  child: Center(child: Text("250 x 250")),
                ),
              ),
            ),
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
        floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}

class MediaQueryDataText extends StatelessWidget {
  final String title;
  final MediaQueryData data;
  const MediaQueryDataText(this.data, {Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + "",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            "screen size is ${doubleStr(data.size.width)} x ${doubleStr(data.size.height)}\n"
            "devicePixelRatio is ${doubleStr(data.devicePixelRatio, 1)}\n"
            "viewInsets is ${paddingStr(data.viewInsets)}\n"
            // 'viewPadding is ${paddingStr(data.viewPadding)} \n'
            "padding is ${paddingStr(data.padding)}",
          ),
        ],
      ),
    );
  }

  String doubleStr(double d, [int precision = 0]) {
    return d.toStringAsFixed(precision);
  }

  String paddingStr(EdgeInsets pad) {
    var l = doubleStr(pad.left);
    var r = doubleStr(pad.right);
    var t = doubleStr(pad.top);
    var b = doubleStr(pad.bottom);
    return "($l, $t, $r, $b)";
  }
}
