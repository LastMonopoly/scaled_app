import "package:flutter/material.dart";
import "package:scaled_app_example/layout_block.dart";

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
              MediaQuery.of(context),
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
