import 'package:flutter/material.dart';

import 'gradient_painter.dart';

class CustomOutlineButton extends StatelessWidget {
  final GradientPainter _painter;
  final Widget _child;
  final EdgeInsetsGeometry _padding;
  final double _radius;
  final double _height;
  final double _width;

  CustomOutlineButton({
    required double strokeWidth,
    required double radius,
    required EdgeInsetsGeometry padding,
    required Gradient gradient,
    required Widget child,
    required double height,
    required double width,
  })  : this._painter = GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this._padding = padding,
        this._height = height,
        this._width = width,
        this._radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        height: _height,
        width: _width,
        padding: _padding,
        child: _child,
      ),
    );
  }
}
