import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:learnito/app/theme.dart';
import 'package:learnito/presentation/drawing/widgets/drawing_painter.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

import '../../application/drawing/drawing_notifier.dart';
import '../../shared/utils/audioplayer_manager.dart';

class DrawingScreen extends ConsumerStatefulWidget {
  const DrawingScreen({super.key});

  @override
  ConsumerState<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends ConsumerState<DrawingScreen> {
  final GlobalKey repaintBoundaryKey = GlobalKey();
  final AudioManager _audioManager = AudioManager();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioManager.playMusic("assets/bgm/bg1.mp3"); // Replace with your file

}
  @override
  Widget build(BuildContext context) {
    final drawingState = ref.watch(drawingStateProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Drawing Screen',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange.shade50,
      body: Stack(
        children: [
          RepaintBoundary(
            key: repaintBoundaryKey,
            child: GestureDetector(
              onPanStart: (details) => ref
                  .read(drawingStateProvider.notifier)
                  .startPath(details.localPosition),
              onPanUpdate: (details) => ref
                  .read(drawingStateProvider.notifier)
                  .updatePath(details.localPosition),
              child: CustomPaint(
                painter: DrawingPainter(
                    paths: drawingState.paths,
                    scale: drawingState.scale,
                    offset: drawingState.offset),
                size: Size.infinite,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                _buildControlButton(context,
                    icon: Icons.undo,
                    onPressed: ref.read(drawingStateProvider.notifier).undo,
                    isEnabled: drawingState.paths.isNotEmpty),
                const SizedBox(width: 10),
                _buildControlButton(context,
                    icon: Icons.redo,
                    onPressed: ref.read(drawingStateProvider.notifier).redo,
                    isEnabled: drawingState.redoPaths.isNotEmpty),
                const SizedBox(width: 10),
                _buildControlButton(context,
                    icon: Icons.clear,
                    onPressed: ref.read(drawingStateProvider.notifier).clear),
                const SizedBox(width: 10),
                _buildControlButton(context,
                    icon: Icons.zoom_out,
                    onPressed: ref.read(drawingStateProvider.notifier).zoomOut),
                const SizedBox(width: 10),
                _buildControlButton(context,
                    icon: Icons.zoom_in,
                    onPressed: ref.read(drawingStateProvider.notifier).zoomIn),
                const SizedBox(width: 10),
                _buildControlButton(context,
                    icon: Icons.restore,
                    onPressed:
                        ref.read(drawingStateProvider.notifier).resetZoom),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildColorPalette(ref),
      ),
      floatingActionButton: _buildControlButton(
        context,
        icon: Icons.save,
        onPressed: () async {
          await saveDrawing(context);
        },
      ),
    );
  }

  Future<void> saveDrawing(context) async {
    try {
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final directory = await getApplicationDocumentsDirectory();
        String filePath =
            '${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png';

        File file = File(filePath);
        await file.writeAsBytes(pngBytes);

        await GallerySaver.saveImage(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Drawing Saved Successfully!")),
        );
      }
    } catch (e) {
      print("Error saving drawing: $e");
    }
  }

  Widget _buildControlButton(BuildContext context,
      {required IconData icon,
      required VoidCallback onPressed,
      bool isEnabled = true}) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      elevation: 2,
      child: IconButton(
        icon: Icon(icon),
        onPressed: isEnabled ? onPressed : null,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildColorPalette(WidgetRef ref) {
    final colors = [
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () =>
              ref.read(drawingStateProvider.notifier).selectColor(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ==================== DRAWING CANVAS ====================
