import 'dart:async' show scheduleMicrotask, Timer;
import 'dart:collection' show Queue;
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart' show ViewConfiguration;
import 'package:flutter/gestures.dart' show PointerEventConverter;
import 'package:flutter/widgets.dart';

typedef Checker = bool Function(double deviceWidth);

const double _nullWidth = -1;

/// Replace [runApp] with [runAppScaled] in `main()`.
///
/// [baseWidth] is screen width used in your UI design, it could be 360, 375, 414, etc.
///
/// Scaling will be applied when [applyScaling] returns true.
///
void runAppScaled(Widget app, {double? baseWidth, Checker? applyScaling}) {
  WidgetsBinding binding = ScaledWidgetsFlutterBinding.ensureInitialized(
    baseWidth: baseWidth ?? _nullWidth,
    applyScaling: applyScaling,
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

  /// Apply scaling based on device screen width
  final Checker applyScaling;

  ScaledWidgetsFlutterBinding(
      {required this.baseWidth, required this.applyScaling});

  static WidgetsBinding? _binding;

  /// Adapted from [WidgetsFlutterBinding.ensureInitialized]
  ///
  /// [baseWidth] is screen width used in your UI design, it could be 360, 375, 414, etc.
  ///
  /// Scaling will be applied when [applyScaling] returns true.
  ///
  static WidgetsBinding ensureInitialized({
    required double baseWidth,
    Checker? applyScaling,
  }) {
    _binding ??= ScaledWidgetsFlutterBinding(
      baseWidth: baseWidth,
      applyScaling: applyScaling ?? (_) => true,
    );
    return _binding!;
  }

  bool get _applyScaling {
    if (baseWidth == _nullWidth) return false;
    return applyScaling(window.physicalSize.width / window.devicePixelRatio);
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
    if (!window.physicalSize.isEmpty && _applyScaling) {
      final double devicePixelRatio = window.physicalSize.width / baseWidth;
      return ViewConfiguration(
        size: window.physicalSize / devicePixelRatio,
        devicePixelRatio: devicePixelRatio,
      );
    } else {
      return super.createViewConfiguration();
    }
  }

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

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  /// When we scale UI using [ViewConfiguration], [ui.window] stays the same.
  ///
  /// [GestureBinding] uses [window.devicePixelRatio] for calculations,
  /// so we override corresponding methods.
  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
      packet.data,
      _applyScaling
          ? window.physicalSize.width / baseWidth
          : window.devicePixelRatio,
    ));
    if (!locked) {
      _flushPointerEventQueue();
    }
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

extension ScaledMediaQueryData on MediaQueryData {
  scale(double baseWidth) {
    var scale = baseWidth / size.width;
    return copyWith(
      devicePixelRatio: devicePixelRatio * scale,
      viewInsets: viewInsets * scale,
    );
  }
}
