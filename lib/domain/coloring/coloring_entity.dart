// lib/presentation/coloring/models/drawing_models.dart
import 'package:flutter/material.dart';

import 'coloring_enums.dart';

class ColoringPoints {
  final Offset points;
  final Paint paint;
  final Offset? endPoints;
  final ColoringMode mode;
  final String? text;
  final TextStyle? textStyle;
  final BrushStyle brushStyle;

  ColoringPoints({
    required this.points,
    required this.paint,
    this.endPoints,
    this.mode = ColoringMode.freeform,
    this.text,
    this.textStyle,
    this.brushStyle = BrushStyle.solid,
  });
}


class ColoringLines {
  final List<ColoringPoints> points;
  final Color color;
  final double strokeWidth;
  final double opacity;

  ColoringLines({
    required this.points,
    required this.color,
    required this.strokeWidth,
    required this.opacity,
  });
}