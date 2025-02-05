import 'package:flutter/material.dart';

class ObjectDetectionOverlay extends StatelessWidget {
  final List<Map<String, dynamic>> detections;

  const ObjectDetectionOverlay({
    Key? key,
    required this.detections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: detections.map((detection) {
            final rect = detection['rect'];
            final label = detection['label'] ?? 'Unknown';
            final confidence = detection['confidence']?.toStringAsFixed(2) ?? '0.00';

            if (rect == null) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: rect['x'] * constraints.maxWidth,
              top: rect['y'] * constraints.maxHeight,
              width: rect['width'] * constraints.maxWidth,
              height: rect['height'] * constraints.maxHeight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.green.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      '$label (${confidence}%)',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
