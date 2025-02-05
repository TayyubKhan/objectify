// Color Palette Widget for selecting colors
import 'package:flutter/material.dart';

class ColorPaletteWidget extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPaletteWidget({super.key, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.brown,
      Colors.black,
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onColorSelected(colors[index]),
            child: Container(
              width: 50,
              height: 50,
              color: colors[index],
              margin: const EdgeInsets.symmetric(horizontal: 5),
            ),
          );
        },
      ),
    );
  }
}
