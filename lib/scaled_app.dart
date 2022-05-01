import 'dart:collection';
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

void runAppScaled(Widget app, {double? baseWidth, double? fromWidth, double? toWidth}) {
  ScaledWidgetsFlutterBinding.ensureInitialized(
      baseWidth: baseWidth ?? -1, fromWidth: fromWidth, toWidth: toWidth)
    ..attachRootWidget(app)
    ..scheduleWarmUpFrame();
}

class ScaledWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final double baseWidth;
  final double toWidth;
  final double fromWidth;

  ScaledWidgetsFlutterBinding(this.baseWidth, this.fromWidth, this.toWidth);

  static WidgetsBinding ensureInitialized(
      {required double baseWidth, double? fromWidth, double? toWidth}) {
    double _fromWidth = fromWidth ?? -double.infinity;
    double _toWidth = toWidth ?? double.infinity;

    assert(_fromWidth < _toWidth);
    if (WidgetsBinding.instance == null) {
      ScaledWidgetsFlutterBinding(baseWidth, _fromWidth, _toWidth);
    }
    return WidgetsBinding.instance!;
  }

  bool get _inRange => baseWidth > 0 && baseWidth >= fromWidth && baseWidth <= toWidth;

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
