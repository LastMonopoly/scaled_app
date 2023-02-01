import 'dart:async' show scheduleMicrotask, Timer;
import 'dart:collection' show Queue;
import 'dart:ui' show PointerDataPacket;
import 'package:flutter/rendering.dart' show ViewConfiguration;
import 'package:flutter/gestures.dart' show PointerEventConverter;
import 'package:flutter/widgets.dart';

typedef ScaleFactorCallback = double Function(Size deviceSize);

/// Replace [runApp] with [runAppScaled] in `main()`.
///
/// Scaling will be applied based on [scaleFactor] function.
///
void runAppScaled(Widget app, {ScaleFactorCallback? scaleFactor}) {
  WidgetsBinding binding = ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: scaleFactor,
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
  /// Calculate the scale factor.
  ScaleFactorCallback? _scaleFactor;

  ScaledWidgetsFlutterBinding({ScaleFactorCallback? scaleFactor})
      : _scaleFactor = scaleFactor;

  static ScaledWidgetsFlutterBinding? _binding;

  ScaleFactorCallback get scaleFactor => _scaleFactor ?? (_) => 1.0;

  set scaleFactor(ScaleFactorCallback? callback) {
    _scaleFactor = callback;
    handleMetricsChanged();
  }

  double get scale =>
      scaleFactor(window.physicalSize / window.devicePixelRatio);

  double get devicePixelRatioScaled =>
      window.devicePixelRatio *
      scaleFactor(window.physicalSize / window.devicePixelRatio);

  bool get isScaling =>
      scaleFactor(window.physicalSize / window.devicePixelRatio) != 1.0;

  /// Adapted from [WidgetsFlutterBinding.ensureInitialized]
  ///
  /// Scaling will be applied based on [scaleFactor] function.
  ///
  static WidgetsBinding ensureInitialized({ScaleFactorCallback? scaleFactor}) {
    _binding ??= ScaledWidgetsFlutterBinding(scaleFactor: scaleFactor);
    return _binding!;
  }

  static ScaledWidgetsFlutterBinding get instance => _binding!;

  /// Override the method from [RendererBinding.createViewConfiguration] to
  /// change what size or device pixel ratio the [RenderView] will use.
  ///
  /// See more:
  ///
  /// * [RendererBinding.createViewConfiguration]
  /// * [TestWidgetsFlutterBinding.createViewConfiguration]
  @override
  ViewConfiguration createViewConfiguration() {
    if (!window.physicalSize.isEmpty) {
      return ViewConfiguration(
        size: window.physicalSize / devicePixelRatioScaled,
        devicePixelRatio: devicePixelRatioScaled,
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
      devicePixelRatioScaled,
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
  MediaQueryData scale() {
    final scale = (ScaledWidgetsFlutterBinding._binding?.scale ?? 1);
    return copyWith(
      size: size / scale,
      devicePixelRatio: devicePixelRatio * scale,
      viewInsets: viewInsets / scale,
      viewPadding: viewPadding / scale,
      padding: padding / scale,
    );
  }
}
