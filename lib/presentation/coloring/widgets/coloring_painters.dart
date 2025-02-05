import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../domain/coloring/coloring_entity.dart';

class ColoringPainter extends CustomPainter {
  final List<ColoringPoints?> pointsList;
  final ui.Image? cachedImage;
  final bool showGrid;
  final double gridSize;
  final bool showRulers;
  final double zoom;
  final Offset pan;

  ColoringPainter({
    required this.pointsList,
    this.cachedImage,
    this.showGrid = false,
    this.gridSize = 20.0,
    this.showRulers = false,
    this.zoom = 1.0,
    this.pan = Offset.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(pan.dx, pan.dy);
    canvas.scale(zoom);

    if (cachedImage != null) {
      final double scaleX = size.width / cachedImage!.width;
      final double scaleY = size.height / cachedImage!.height;
      final double scale = scaleX < scaleY ? scaleX : scaleY;

      final double left = (size.width - cachedImage!.width * scale) / 2;
      final double top = (size.height - cachedImage!.height * scale) / 2;

      final src = Rect.fromLTWH(
        0,
        0,
        cachedImage!.width.toDouble(),
        cachedImage!.height.toDouble(),
      );
      final dst = Rect.fromLTWH(
        left,
        top,
        cachedImage!.width * scale,
        cachedImage!.height * scale,
      );

      canvas.drawImageRect(cachedImage!, src, dst, Paint());
    }

    if (showGrid) {
      _drawGrid(canvas, size);
    }

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
          pointsList[i]!.points,
          pointsList[i + 1]!.points,
          pointsList[i]!.paint,
        );
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [pointsList[i]!.points],
          pointsList[i]!.paint,
        );
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}