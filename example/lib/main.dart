// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

const double baseWidth = 375;

void main() {
  // 1st way to use this package
  runAppScaled(const MyApp(), baseWidth: baseWidth);

  // 2nd way to use this package
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
    const _title = 'Scaled app demo';
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "Roboto",
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 15)),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const ScaledMediaQueryDataTest();
              }));
            },
          )
        ],
      ),
      body: const ScaledAppLayoutTest(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Tapped ...'),
            duration: Duration(seconds: 1),
          ));
        },
        child: const Icon(Icons.abc),
      ),
    );
  }
}

class ScaledAppLayoutTest extends StatelessWidget {
  const ScaledAppLayoutTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Huawei: Size(360.0, 800.0), devicePixelRatio: 3.0, w: 1080
    // Apple: Size(375.0, 667.0), devicePixelRatio: 2.0, w: 750
    // Pixel4: Size(411.4, 820.6), devicePixelRatio: 3.5, w: 1440
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return ListView(
      children: [
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
        Text(
          'mediaQuery screen size is ${mediaQuery.size.width.toStringAsFixed(0)} x ${mediaQuery.size.height.toStringAsFixed(0)}\n'
          'mediaQuery devicePixelRatio is ${mediaQuery.devicePixelRatio}\n'
          'mediaQuery data stays the same',
        ),
      ],
    );
  }
}

class ScaledMediaQueryDataTest extends StatefulWidget {
  const ScaledMediaQueryDataTest({Key? key}) : super(key: key);

  @override
  State<ScaledMediaQueryDataTest> createState() =>
      _ScaledMediaQueryDataTestState();
}

class _ScaledMediaQueryDataTestState extends State<ScaledMediaQueryDataTest> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).scale(baseWidth),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MediaQueryData.scale'),
        ),
        body: Stack(
          children: [
            Container(color: Colors.purple.shade50),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                focusNode: focusNode,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
          },
          child: const Icon(Icons.keyboard),
        ),
      ),
    );
  }
}
