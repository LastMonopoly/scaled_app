import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'main.dart';
import 'shared/layout_block.dart';
import 'shared/media_query_data_text.dart';

class ScaledAppDemo extends StatefulWidget {
  final MediaQueryData mediaQueryData;
  const ScaledAppDemo({Key? key, required this.mediaQueryData})
      : super(key: key);

  @override
  State<ScaledAppDemo> createState() => _ScaledAppDemoState();
}

class _ScaledAppDemoState extends State<ScaledAppDemo> {
  final binding = ScaledWidgetsFlutterBinding.instance;
  late bool isScaling;

  @override
  void initState() {
    super.initState();
    isScaling = binding.isScaling;
  }

  @override
  void dispose() {
    super.dispose();
    Future(() {
      binding.scaleFactor = (deviceSize) {
        return deviceSize.width / baseWidth;
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scale the app",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Switch(
              value: isScaling,
              activeColor: Colors.purple.shade300,
              onChanged: (bool value) {
                setState(() {
                  isScaling = value;
                  if (isScaling) {
                    binding.scaleFactor = (deviceSize) {
                      return deviceSize.width / baseWidth;
                    };
                  } else {
                    binding.scaleFactor = null;
                  }
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
            widget.mediaQueryData,
            title: "Original mediaQueryData",
          ),
        ],
      ),
    );
  }
}
