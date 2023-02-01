import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:scaled_app_example/main.dart';
import 'package:scaled_app_example/shared/layout_block.dart';
import 'package:scaled_app_example/shared/media_query_data_text.dart';

class ScaledAppDemo extends StatefulWidget {
  const ScaledAppDemo({Key? key}) : super(key: key);

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
            MediaQuery.of(context),
            title: "Original mediaQueryData",
          ),
        ],
      ),
    );
  }
}
