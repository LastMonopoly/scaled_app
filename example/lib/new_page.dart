import "package:flutter/material.dart";
import "package:scaled_app_example/layout_block.dart";

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Route")),
        body: ListView(
          children: const [LayoutBlock()],
        ));
  }
}
