// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

// void main() => runApp(const MyApp());

void main() {
  // 1st way to use this package
  runAppScaled(const MyApp(), baseWidth: 375);

  // 2nd way to use this package
  // ScaledWidgetsFlutterBinding.ensureInitialized(
  //   baseWidth: 375,
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
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: "Roboto"),
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.1,
        // devicePixelRatio: 10, // Provide your own value
        // size: Size(1000, 2000), // Provide your own value
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: false),
        body: const TestCase(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Pressed!'),
              duration: Duration(seconds: 1),
            ));
          },
          child: const Icon(Icons.abc),
        ),
      ),
    );
  }
}

class TestCase extends StatelessWidget {
  const TestCase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Huawei: Size(360.0, 800.0), devicePixelRatio: 3.0, w: 1080
    // Apple: Size(375.0, 667.0), devicePixelRatio: 2.0, w: 750
    // Pixel4: Size(411.4, 820.6), devicePixelRatio: 3.5, w: 1440
    MediaQueryData mediaQueryData = MediaQuery.of(context);

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
          'mediaQuery screen size is ${mediaQueryData.size.width.toStringAsFixed(0)} x ${mediaQueryData.size.height.toStringAsFixed(0)}\n'
          'mediaQuery devicePixelRatio is ${mediaQueryData.devicePixelRatio}\n'
          'mediaQuery data stays the same \n',
        ),
      ],
    );
  }
}
