import 'package:flutter/material.dart';

/// [NoSplashFactory] disables splash animations in Material components
class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    bool containedInkWell = false,
    ShapeBorder customBorder,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    double radius,
    VoidCallback onRemoved,
    TextDirection textDirection,
  }) {
    return _NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class _NoSplash extends InteractiveInkFeature {
  _NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
  })  : assert(controller != null),
        assert(referenceBox != null),
        super(
          controller: controller,
          referenceBox: referenceBox,
        );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}
