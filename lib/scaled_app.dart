import 'dart:collection';
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

void runAppScaled(Widget app, {required double baseWidth, double? toWidth, double? fromWidth}) {
  ScaledWidgetsFlutterBinding.ensureInitialized(
      baseWidth: baseWidth, toWidth: toWidth, fromWidth: fromWidth)
    ..attachRootWidget(app)
    ..scheduleWarmUpFrame();
}

class ScaledWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final double baseWidth;
  final double toWidth;
  final double fromWidth;

  ScaledWidgetsFlutterBinding(this.baseWidth, this.toWidth, this.fromWidth);

  static WidgetsBinding ensureInitialized(
      {required double baseWidth, double? toWidth, double? fromWidth}) {
    double _toWidth = toWidth ?? -double.infinity;
    double _fromWidth = fromWidth ?? double.infinity;

    assert(_toWidth < _fromWidth);
    if (WidgetsBinding.instance == null) {
      ScaledWidgetsFlutterBinding(baseWidth, _toWidth, _fromWidth);
    }
    return WidgetsBinding.instance!;
  }

  bool get _inRange => baseWidth >= toWidth && baseWidth <= fromWidth;

  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    if (_inRange) {
      return ViewConfiguration(
        size: Size(baseWidth, window.physicalSize.height / (window.physicalSize.width / baseWidth)),
        devicePixelRatio: window.physicalSize.width / baseWidth,
      );
    } else {
      return super.createViewConfiguration();
    }
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data, _inRange ? window.physicalSize.width / baseWidth : window.devicePixelRatio));
    if (!locked) _flushPointerEventQueue();
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }
}
