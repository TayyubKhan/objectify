import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

import '../../../domain/drawing/drawing_entity.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final double scale;
  final ui.Offset offset;

  const DrawingPainter({required this.paths, required this.scale, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);

    for (final path in paths) {
      canvas.drawPath(path.path, path.paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => paths != oldDelegate.paths || scale != oldDelegate.scale || offset != oldDelegate.offset;
}