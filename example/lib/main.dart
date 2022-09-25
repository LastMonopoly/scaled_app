import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

// screen width used in your UI design
const double baseWidth = 375;

void main() {
  // 1st way to use runAppScaled
  runAppScaled(const MyApp(), baseWidth: baseWidth);

  // 2nd way to use runAppScaled
  // Scaling will be applied when [applyScaling] returns true
  // ScaledWidgetsFlutterBinding.ensureInitialized(
  //   baseWidth: baseWidth,
  //   applyScaling: (deviceWidth) => deviceWidth > 300 && deviceWidth < 400,
  // );
  // runAppScaled(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Scaled app demo';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "Roboto",
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 15)),
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
  bool scaleMediaQuery = true;

  @override
  Widget build(BuildContext context) {
    var scaledData = MediaQuery.of(context);

    // use mediaQueryData.scale to properly display keyboard
    if (scaleMediaQuery) scaledData = scaledData.scale(baseWidth);

    return MediaQuery(
      data: scaledData,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Switch(
              value: scaleMediaQuery,
              activeColor: Colors.purple.shade300,
              onChanged: (bool toScale) {
                setState(() {
                  scaleMediaQuery = toScale;
                });
              },
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
                  child: Center(child: Text('250 x 250')),
                ),
              ),
            ),
            MediaQueryDataText(scaledData),
          ],
        ),
        floatingActionButton: FloatingActionButton(
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
  final MediaQueryData data;
  const MediaQueryDataText(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _data = MediaQuery.of(context);
    return Text(
      'mediaQuery screen size is ${doubleStr(_data.size.width)} x ${doubleStr(_data.size.height)}\n'
      'mediaQuery devicePixelRatio is ${doubleStr(_data.devicePixelRatio, 1)}\n'
      'mediaQuery viewInsets is ${paddingStr(data.viewInsets)} \n'
      'mediaQuery viewPadding is ${paddingStr(data.viewPadding)} \n'
      'mediaQuery padding is ${paddingStr(data.padding)} \n',
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
    return '($l, $t, $r, $b)';
  }
}
