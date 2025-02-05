import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/application/drawing/drawing_state.dart';
import 'dart:ui' as ui;

import '../../domain/drawing/drawing_entity.dart';

class DrawingController extends StateNotifier<DrawingState> {
  DrawingController()
      : super(
    const DrawingState(
      paths: [],
      redoPaths: [],
      scale: 1.0,
      offset: ui.Offset.zero,
      selectedColor: Colors.black,
      strokeWidth: 3.0,
    ),
  );

  void startPath(Offset offset) {
    final path = DrawingPath(color: state.selectedColor, width: state.strokeWidth);
    path.path.moveTo(
      (offset.dx - state.offset.dx) / state.scale,
      (offset.dy - state.offset.dy) / state.scale,
    );

    state = state.copyWith(
      paths: [...state.paths, path],
      redoPaths: [],
    );
  }

  void updatePath(Offset offset) {
    if (state.paths.isEmpty) return;
    final currentPath = state.paths.last;

    final dx = (offset.dx - state.offset.dx) / state.scale;
    final dy = (offset.dy - state.offset.dy) / state.scale;

    currentPath.path.lineTo(dx, dy);
    state = state.copyWith(paths: List.from(state.paths)); // Trigger update
  }

  void undo() {
    if (state.paths.isNotEmpty) {
      final updatedPaths = List<DrawingPath>.from(state.paths);
      final lastPath = updatedPaths.removeLast();
      state = state.copyWith(paths: updatedPaths, redoPaths: [...state.redoPaths, lastPath]);
    }
  }

  void redo() {
    if (state.redoPaths.isNotEmpty) {
      final updatedRedoPaths = List<DrawingPath>.from(state.redoPaths);
      final restoredPath = updatedRedoPaths.removeLast();
      state = state.copyWith(paths: [...state.paths, restoredPath], redoPaths: updatedRedoPaths);
    }
  }

  void clear() {
    state = state.copyWith(paths: [], redoPaths: []);
  }

  void zoomIn() {
    state = state.copyWith(scale: (state.scale * 1.2).clamp(1.0, 5.0));
  }

  void zoomOut() {
    state = state.copyWith(scale: (state.scale / 1.2).clamp(1.0, 5.0));
  }

  void resetZoom() {
    state = state.copyWith(scale: 1.0, offset: ui.Offset.zero);
  }

  void selectColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }
}