import "package:flutter/material.dart";

import "shared/media_query_data_text.dart";

class ScaledMediaQueryDataDemo extends StatefulWidget {
  const ScaledMediaQueryDataDemo({super.key});

  @override
  State<ScaledMediaQueryDataDemo> createState() =>
      _ScaledMediaQueryDataDemoState();
}

class _ScaledMediaQueryDataDemoState extends State<ScaledMediaQueryDataDemo> {
  FocusNode keyboardFocusNode = FocusNode();
  bool scaleMediaQueryData = true;

  @override
  void initState() {
    super.initState();
    keyboardFocusNode.requestFocus();
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Switch(
              value: scaleMediaQueryData,
              activeColor: Colors.purple.shade300,
              onChanged: (bool value) {
                setState(() {
                  scaleMediaQueryData = value;
                });
              },
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Offstage(child: TextField(focusNode: keyboardFocusNode)),
          if (scaleMediaQueryData)
            MediaQueryDataText(
              MediaQuery.of(context),
              title: "Scaled mediaQueryData",
            ),
        ],
      ),
      backgroundColor: Colors.purple.shade50,
      floatingActionButton: FloatingActionButton(
        tooltip: "Push/pop keyboard",
        child: const Icon(Icons.keyboard),
        onPressed: () {
          if (keyboardFocusNode.hasFocus) {
            keyboardFocusNode.unfocus();
          } else {
            keyboardFocusNode.requestFocus();
          }
        },
      ),
    );
  }
}
