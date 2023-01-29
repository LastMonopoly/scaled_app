import "package:flutter/material.dart";

class MediaQueryDataText extends StatelessWidget {
  final String title;
  final MediaQueryData data;
  const MediaQueryDataText(this.data, {Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            "screen size is ${doubleStr(data.size.width)} x ${doubleStr(data.size.height)}\n"
            "devicePixelRatio is ${doubleStr(data.devicePixelRatio, 1)}\n"
            "viewInsets is ${paddingStr(data.viewInsets)}\n"
            // 'viewPadding is ${paddingStr(data.viewPadding)} \n'
            "padding is ${paddingStr(data.padding)}",
          ),
        ],
      ),
    );
  }

  String doubleStr(double d, [int precision = 0]) {
    return d.toStringAsFixed(precision);
  }

  String paddingStr(EdgeInsets pad) {
    var l = doubleStr(pad.left);
    var r = doubleStr(pad.right);
    var t = doubleStr(pad.top);
    var b = doubleStr(pad.bottom);
    return "($l, $t, $r, $b)";
  }
}
