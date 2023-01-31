import "package:flutter/material.dart";
import "package:scaled_app/scaled_app.dart";
import "package:scaled_app_example/layout_block.dart";

import "main.dart";
import "media_query_data_text.dart";

class ScaledMediaQueryDataDemo extends StatefulWidget {
  const ScaledMediaQueryDataDemo({super.key});

  @override
  State<ScaledMediaQueryDataDemo> createState() =>
      _ScaledMediaQueryDataDemoState();
}

class _ScaledMediaQueryDataDemoState extends State<ScaledMediaQueryDataDemo> {
  FocusNode focusNode = FocusNode();
  bool scaleMediaQueryData = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final originalMediaQueryData = MediaQuery.of(context);
    late final MediaQueryData scaledMediaQueryData;

    // Scale mediaQueryData to properly display keyboard
    if (scaleMediaQueryData) {
      scaledMediaQueryData = originalMediaQueryData.scale(baseWidth);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scale mediaQueryData",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          Offstage(child: TextField(focusNode: focusNode)),
          const LayoutBlock(),
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
    );
  }
}
