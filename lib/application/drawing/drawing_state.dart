
import 'package:flutter/material.dart';

import '../../domain/drawing/drawing_entity.dart';
import 'dart:ui' as ui;

class DrawingState {
  final List<DrawingPath> paths;
  final List<DrawingPath> redoPaths;
  final double scale;
  final ui.Offset offset;
  final Color selectedColor;
  final double strokeWidth;

  const DrawingState({
    required this.paths,
    required this.redoPaths,
    required this.scale,
    required this.offset,
    required this.selectedColor,
    required this.strokeWidth,
  });

  DrawingState copyWith({
    List<DrawingPath>? paths,
    List<DrawingPath>? redoPaths,
    double? scale,
    ui.Offset? offset,
    Color? selectedColor,
    double? strokeWidth,
  }) {
    return DrawingState(
      paths: paths ?? this.paths,
      redoPaths: redoPaths ?? this.redoPaths,
      scale: scale ?? this.scale,
      offset: offset ?? this.offset,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}