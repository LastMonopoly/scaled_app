import 'dart:async' show scheduleMicrotask, Timer;
import 'dart:collection' show Queue;
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart' show ViewConfiguration;
import 'package:flutter/gestures.dart' show PointerEventConverter;
import 'package:flutter/widgets.dart';

/// Replace [runApp] with [runAppScaled] in `main()`.
///
/// [baseWidth] is screen width used in your UI design, it could be 360, 375, 414, etc.
///
/// Scaling will be applied to devices of screen width from [fromWidth] to [toWidth].
/// 
/// It's also possible to scale by height ratio, just replace `Width` with `Height`.
/// Note that the scaling can only be **either** width or height ratio. You can't supply
/// both `*Width` & `*Height` parameters.
///
void runAppScaled(
  Widget app, {
  double? baseWidth,
  double? fromWidth,
  double? toWidth,
  double? baseHeight,
  double? fromHeight,
  double? toHeight,
}) {
  WidgetsBinding binding = ScaledWidgetsFlutterBinding.ensureInitialized(
    baseWidth: baseWidth ?? -1,
    fromWidth: fromWidth,
    toWidth: toWidth,
    baseHeight: baseHeight ?? -1,
    fromHeight: fromHeight,
    toHeight: toHeight,
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
  /// Screen width used in your UI design
  final double baseWidth;

  /// Minimum screen width used for scaling
  final double fromWidth;

  /// Maximum screen width used for scaling
  final double toWidth;

  /// Screen height used in your UI design
  final double baseHeight;

  /// Minimum screen height used for scaling
  final double fromHeight;

  /// Maximum screen height used for scaling
  final double toHeight;

  ScaledWidgetsFlutterBinding(
    this.baseWidth,
    this.fromWidth,
    this.toWidth,
    this.baseHeight,
    this.fromHeight,
    this.toHeight,
  );

  /// Adapted from [WidgetsFlutterBinding.ensureInitialized]
  ///
  /// [baseWidth] is screen width used in your UI design, it could be 360, 375, 414, etc.
  ///
  /// Scaling will be applied to devices of screen width from [fromWidth] to [toWidth].
  ///
  /// It's also possible to scale by height ratio, just replace `Width` with `Height`.
  /// Note that the scaling can only be **either** width or height ratio. You can't supply
  /// both `*Width` & `*Height` parameters.
  ///
  static WidgetsBinding ensureInitialized({
    required double baseWidth,
    double? fromWidth,
    double? toWidth,
    required double baseHeight,
    double? fromHeight,
    double? toHeight,
  }) {
    double _fromWidth = fromWidth ?? -double.infinity;
    double _toWidth = toWidth ?? double.infinity;
    double _fromHeight = fromHeight ?? -double.infinity;
    double _toHeight = toHeight ?? double.infinity;

    assert(_fromWidth < _toWidth && _fromHeight < _toHeight);
    if (WidgetsBinding.instance == null) {
      ScaledWidgetsFlutterBinding(
        baseWidth,
        _fromWidth,
        _toWidth,
        baseHeight,
        _fromHeight,
        _toHeight,
      );
    }
    return WidgetsBinding.instance!;
  }

  bool get _isUsingWidth => baseWidth >= 0 && baseHeight < 0;

  bool get _inRange {
    if (baseWidth < 0 && baseHeight < 0) return false;
    if (baseWidth >= 0 && baseHeight >= 0) return false;
    if (_isUsingWidth) {
      double deviceWidth = window.physicalSize.width / window.devicePixelRatio;
      return deviceWidth >= fromWidth && deviceWidth <= toWidth;
    } else {
      double deviceHeight =
          window.physicalSize.height / window.devicePixelRatio;
      return deviceHeight >= fromHeight && deviceHeight <= toHeight;
    }
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
      double devicePixelRatio = _isUsingWidth
          ? window.physicalSize.width / baseWidth
          : window.physicalSize.height / baseHeight;
      return ViewConfiguration(
        size: _isUsingWidth
            ? Size(baseWidth, window.physicalSize.height / devicePixelRatio)
            : Size(window.physicalSize.width / devicePixelRatio, baseHeight),
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

  /// When we scale UI using [ViewConfiguration], [ui.window] stays the same.
  ///
  /// [GestureBinding] uses [window.devicePixelRatio] to do calculations,
  /// so we override corresponding methods.
  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
      packet.data,
      _inRange
          ? _isUsingWidth
              ? window.physicalSize.width / baseWidth
              : window.physicalSize.height / baseHeight
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
