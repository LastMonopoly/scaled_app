import "package:flutter/material.dart";

class LayoutBlock extends StatelessWidget {
  const LayoutBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: Center(child: Text("250 x 250")),
            ),
          ),
        ),
      ],
    );
  }
}
