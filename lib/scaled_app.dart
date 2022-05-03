import 'dart:async' show scheduleMicrotask, Timer;
import 'dart:collection' show Queue;
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart' show ViewConfiguration;
import 'package:flutter/gestures.dart' show PointerEventConverter;
import 'package:flutter/widgets.dart';

/// Replace [runApp] with [runAppScaled] in `main()`.
///
/// [baseWidth] is screen width used in your UI design.
///
/// It could be 360, 375, 414, etc, works for portrait & landscape mode.
///
/// Scaling will be applied to devices of screen width from [fromWidth] to [toWidth].
///
void runAppScaled(Widget app,
    {double? baseWidth, double? fromWidth, double? toWidth}) {
  WidgetsBinding binding = ScaledWidgetsFlutterBinding.ensureInitialized(
    baseWidth: baseWidth ?? -1,
    fromWidth: fromWidth,
    toWidth: toWidth,
  );
  Timer.run(() {
    binding.attachRootWidget(app);
  });
  binding.scheduleWarmUpFrame();
}

/// A concrete binding for applications based on the Widgets framework.
///
/// This is the glue that binds the framework to the Flutter engine.
///
/// Inherit from [WidgetsFlutterBinding].
class ScaledWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final double baseWidth;
  final double toWidth;
  final double fromWidth;

  ScaledWidgetsFlutterBinding(this.baseWidth, this.fromWidth, this.toWidth);

  /// Adapted from [WidgetsFlutterBinding.ensureInitialized]
  ///
  /// [baseWidth] is screen width used in your UI design.
  ///
  /// It could be 360, 375, 414, etc, works for portrait & landscape mode.
  ///
  /// Scaling will be applied to devices of screen width from [fromWidth] to [toWidth].
  ///
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

  bool get _inRange {
    if (baseWidth < 0) return false;
    double deviceWidth = window.physicalSize.width / window.devicePixelRatio;
    return deviceWidth >= fromWidth && deviceWidth <= toWidth;
  }

  /// Override the method from [RendererBinding.createViewConfiguration] to
  /// change what size or device pixel ratio the [RenderView] will use.
  ///
  /// See more:
  ///
  /// * [RendererBinding.createViewConfiguration]
  /// * [TestWidgetsFlutterBinding.createViewConfiguration]
  @override
  ViewConfiguration createViewConfiguration() {
    if (_inRange) {
      double devicePixelRatio = window.physicalSize.width / baseWidth;
      return ViewConfiguration(
        size: Size(baseWidth, window.physicalSize.height / devicePixelRatio),
        devicePixelRatio: devicePixelRatio,
      );
    } else {
      return super.createViewConfiguration();
    }
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  /// Adapted from [GestureBinding.initInstances]
  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  /// When we scale UI using [ViewConfiguration], [ui.window] remains unchanged.
  ///
  /// [GestureBinding] uses [window.devicePixelRatio] to do calculations,
  /// so we override corresponding methods.
  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
      packet.data,
      _inRange
          ? window.physicalSize.width / baseWidth
          : window.devicePixelRatio,
    ));
    if (!locked) _flushPointerEventQueue();
  }

  /// Dispatch a [PointerCancelEvent] for the given pointer soon.
  ///
  /// The pointer event will be dispatched before the next pointer event and
  /// before the end of the microtask but not within this function call.
  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked) {
      scheduleMicrotask(_flushPointerEventQueue);
    }
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }
}
