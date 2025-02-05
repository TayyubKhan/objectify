
import 'dart:ui';

class DrawingPath {
  final Paint paint;
  final Path path;

  DrawingPath({required Color color, required double width})
      : path = Path(),
        paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;
}

