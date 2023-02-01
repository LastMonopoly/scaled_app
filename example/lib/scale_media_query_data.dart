import "package:flutter/material.dart";
import "shared/media_query_data_text.dart";

class ScaledMediaQueryDataDemo extends StatefulWidget {
  final bool scaleMediaQueryData;
  final MediaQueryData mediaQueryData;
  final void Function(bool value) onToggleScaleMediaQueryData;

  const ScaledMediaQueryDataDemo({
    super.key,
    required this.scaleMediaQueryData,
    required this.mediaQueryData,
    required this.onToggleScaleMediaQueryData,
  });

  @override
  State<ScaledMediaQueryDataDemo> createState() =>
      _ScaledMediaQueryDataDemoState();
}

class _ScaledMediaQueryDataDemoState extends State<ScaledMediaQueryDataDemo> {
  FocusNode keyboardFocusNode = FocusNode();
  late bool scaleMediaQueryData;

  @override
  void initState() {
    super.initState();
    scaleMediaQueryData = widget.scaleMediaQueryData;
    keyboardFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                widget.onToggleScaleMediaQueryData(scaleMediaQueryData);
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 70, 20),
              child: Text("Scale mediaQueryData to properly display keyboard"),
            ),
          ),
          ListView(
            children: [
              Offstage(child: TextField(focusNode: keyboardFocusNode)),
              MediaQueryDataText(
                widget.mediaQueryData,
                title: "Scaled mediaQueryData",
              ),
            ],
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
