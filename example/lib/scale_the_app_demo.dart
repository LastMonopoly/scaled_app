import 'package:flutter/material.dart';

import 'layout_block.dart';
import 'main.dart';
import 'media_query_data_text.dart';

class ScaleTheAppDemo extends StatefulWidget {
  const ScaleTheAppDemo({Key? key}) : super(key: key);

  @override
  State<ScaleTheAppDemo> createState() => _ScaleTheAppDemoState();
}

class _ScaleTheAppDemoState extends State<ScaleTheAppDemo> {
  bool scaleTheApp = applyScaling;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scale the app",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Tooltip(
            message: "Scale mediaQueryData",
            child: Switch(
              value: scaleTheApp,
              activeColor: Colors.purple.shade300,
              onChanged: (bool value) {
                setState(() {
                  scaleTheApp = value;
                  applyScaling = scaleTheApp;
                });
              },
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const LayoutBlock(),
          MediaQueryDataText(
            MediaQuery.of(context),
            title: "Original mediaQueryData",
          ),
        ],
      ),
    );
  }
}
