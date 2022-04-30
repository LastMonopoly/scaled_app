import 'dart:collection';
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

void runAppScaled(Widget app, {required double baseWidth}) {
  ScaledWidgetsFlutterBinding.ensureInitialized(baseWidth)
    ..attachRootWidget(app)
    ..scheduleWarmUpFrame();
}

class ScaledWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final double baseWidth;

  ScaledWidgetsFlutterBinding(this.baseWidth);

  static WidgetsBinding ensureInitialized(double baseWidth) {
    if (WidgetsBinding.instance == null) ScaledWidgetsFlutterBinding(baseWidth);
    return WidgetsBinding.instance!;
  }

  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    return ViewConfiguration(
      size: Size(baseWidth, window.physicalSize.height / (window.physicalSize.width / baseWidth)),
      devicePixelRatio: window.physicalSize.width / baseWidth,
    );
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents
        .addAll(PointerEventConverter.expand(packet.data, window.physicalSize.width / baseWidth));
    if (!locked) _flushPointerEventQueue();
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }
}
