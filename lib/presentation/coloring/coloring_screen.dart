import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:learnito/app/theme.dart';
import 'package:learnito/application/coloring/coloring_state.dart';
import 'package:learnito/presentation/coloring/widgets/coloring_painters.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

import '../../domain/coloring/coloring_entity.dart';
import '../../domain/coloring/coloring_enums.dart';
import '../../shared/utils/audioplayer_manager.dart';

class ColoringScreen extends ConsumerStatefulWidget {
  const ColoringScreen({super.key});

  @override
  ConsumerState<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends ConsumerState<ColoringScreen> {
  File? _image;
  ui.Image? _cachedImage;
  final picker = ImagePicker();
  List<ColoringPoints?> points = [];
  List<List<ColoringPoints?>> undoHistory = [];
  List<List<ColoringPoints?>> redoHistory = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isImageLoading = false;
  ColoringMode currentMode = ColoringMode.freeform;
  final screenshotController = ScreenshotController();
  double opacity = 1.0;
  bool showGrid = false;
  Offset? startPoint;
  bool isDrawing = false;
  double zoom = 1.0;
  Offset pan = Offset.zero;
  String currentText = '';
  TextStyle currentTextStyle = const TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
  BrushStyle currentBrushStyle = BrushStyle.solid;
  bool isErasing = false;
  double gridSize = 20.0;
  bool showRulers = false;
  bool mirrorMode = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioManager.playMusic("assets/bgm/bg1.mp3"); // Replace with your file
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processArguments();
    });
  }

  void _processArguments() {
    final image = ref.watch(imageProvider);
    _loadImageFromAssets(image);
  }

  final AudioManager _audioManager = AudioManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildQuickControls(), // Your existing drawing canvas
          Expanded(
            child: Stack(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: GestureDetector(
                    onScaleStart: handleScaleStart,
                    onScaleUpdate: handleScaleUpdate,
                    onScaleEnd: handleScaleEnd,
                    child: CustomPaint(
                      painter: ColoringPainter(
                        pointsList: points,
                        cachedImage: _cachedImage,
                        showGrid: showGrid,
                        gridSize: gridSize,
                        showRulers: showRulers,
                        zoom: zoom,
                        pan: pan,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),
                if (isImageLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          // Your existing controls panel
          buildControlsPanel(),
        ],
      ),
      endDrawer: buildSettingsDrawer(),
    );
  }

// Add this method inside your _ColoringScreenState class
  Widget buildControlsPanel() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stroke Width Control
          Row(
            children: [
              const SizedBox(width: 10),
              const Text('Stroke Width:'),
              Expanded(
                child: Slider(
                  min: 1,
                  max: 20,
                  value: strokeWidth,
                  onChanged: (val) {
                    setState(() {
                      strokeWidth = val;
                    });
                  },
                ),
              ),
              Text(strokeWidth.toStringAsFixed(1)),
              const SizedBox(width: 10),
            ],
          ),

          // Opacity Control
          Row(
            children: [
              const SizedBox(width: 10),
              const Text('Opacity:'),
              Expanded(
                child: Slider(
                  min: 0.1,
                  max: 1.0,
                  value: opacity,
                  onChanged: (val) {
                    setState(() {
                      opacity = val;
                    });
                  },
                ),
              ),
              Text('${(opacity * 100).toStringAsFixed(0)}%'),
              const SizedBox(width: 10),
            ],
          ),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Color Picker Button
              ElevatedButton.icon(
                onPressed: () => _showColorPicker(),
                icon: Icon(
                  Icons.color_lens,
                  color: selectedColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
                label: const Text('Color'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedColor,
                  foregroundColor: selectedColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              // Clear Button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    points.clear();
                    redoHistory.clear();
                    undoHistory.clear();
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              // Save Button
              ElevatedButton.icon(
                onPressed: _showSaveOptions,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

// Helper method for building mode chips
  Widget _buildModeChip(ColoringMode mode, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        avatar: Icon(
          icon,
          size: 18,
          color: currentMode == mode ? Colors.white : Colors.grey,
        ),
        label: Text(label),
        selected: currentMode == mode,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              currentMode = mode;
            });
          }
        },
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: currentMode == mode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.primary,
      title: const Text(
        'Coloring',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.undo,
            color: canUndo ? AppColors.secondary : Colors.grey.shade300,
          ),
          onPressed: canUndo ? undo : null,
        ),
        IconButton(
          icon: Icon(
            Icons.redo,
            color: canRedo ? AppColors.secondary : Colors.grey.shade300,
          ),
          onPressed: canRedo ? redo : null,
        ),
        IconButton(
          icon: const Icon(
            Icons.save,
            color: AppColors.secondary,
          ),
          onPressed: _showSaveOptions,
        ),
        IconButton(
          icon: Icon(
            showGrid ? Icons.grid_on : Icons.grid_off,
            color: AppColors.secondary,
          ),
          onPressed: toggleGrid,
        ),
        IconButton(
          color: AppColors.secondary,
          icon: const Icon(Icons.settings),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ],
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        Screenshot(
          controller: screenshotController,
          child: GestureDetector(
            onScaleStart: handleScaleStart,
            onScaleUpdate: handleScaleUpdate,
            onScaleEnd: handleScaleEnd,
            child: CustomPaint(
              painter: ColoringPainter(
                pointsList: points,
                cachedImage: _cachedImage,
                showGrid: showGrid,
                gridSize: gridSize,
                showRulers: showRulers,
                zoom: zoom,
                pan: pan,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
        ),
        if (isImageLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget buildQuickControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          mini: true,
          onPressed: () => setState(() => zoom *= 1.2),
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          mini: true,
          onPressed: () => setState(() => zoom /= 1.2),
          child: const Icon(Icons.zoom_out),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          mini: true,
          onPressed: resetView,
          child: const Icon(Icons.refresh),
        ), // You can also add a floating action button for quick access:
      ],
    );
  }

  Widget buildSettingsDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Drawing Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Brush Style'),
            trailing: DropdownButton<BrushStyle>(
              value: currentBrushStyle,
              items: BrushStyle.values.map((style) {
                return DropdownMenuItem(
                  value: style,
                  child: Text(style.toString().split('.').last),
                );
              }).toList(),
              onChanged: (style) {
                if (style != null) {
                  setState(() => currentBrushStyle = style);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Grid Size'),
            trailing: SizedBox(
              width: 100,
              child: Slider(
                value: gridSize,
                min: 10,
                max: 50,
                divisions: 8,
                label: gridSize.round().toString(),
                onChanged: (value) {
                  setState(() => gridSize = value);
                },
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Show Rulers'),
            value: showRulers,
            onChanged: (value) {
              setState(() => showRulers = value);
            },
          ),
          SwitchListTile(
            title: const Text('Mirror Mode'),
            value: mirrorMode,
            onChanged: (value) {
              setState(() => mirrorMode = value);
            },
          ),
          ListTile(
            title: const Text('Background Color'),
            trailing: Container(
              width: 24,
              height: 24,
              color: selectedColor,
            ),
            onTap: _showColorPicker,
          ),
        ],
      ),
    );
  }

  void handleScaleStart(ScaleStartDetails details) {
    if (currentMode != ColoringMode.text) {
      setState(() {
        startPoint = details.localFocalPoint;
        isDrawing = true;
      });
    }
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    if (!isDrawing) return;

    setState(() {
      if (currentMode == ColoringMode.freeform ||
          currentMode == ColoringMode.eraser) {
        points.add(
          ColoringPoints(
            points: details.localFocalPoint,
            paint: createPaint(),
            brushStyle: currentBrushStyle,
          ),
        );
      }
    });
  }

  // Update the handleScaleEnd method in your _ColoringScreenState class
  void handleScaleEnd(ScaleEndDetails details) {
    if (!isDrawing) return;

    setState(() {
      isDrawing = false;
      if (startPoint != null) {
        // Use the last known point instead of details.localPosition
        final lastPoint = points.isNotEmpty && points.last != null
            ? points.last!.points
            : startPoint!;

        switch (currentMode) {
          case ColoringMode.line:
          case ColoringMode.rectangle:
          case ColoringMode.circle:
          case ColoringMode.arrow:
            points.add(
              ColoringPoints(
                points: startPoint!,
                paint: createPaint(),
                endPoints: lastPoint,
                mode: currentMode,
                brushStyle: currentBrushStyle,
              ),
            );
            break;
          default:
            break;
        }
        points.add(null); // Add separator
        saveToHistory();
      }
      startPoint = null;
    });
  }

  Paint createPaint() {
    return Paint()
      ..color = currentMode == ColoringMode.eraser
          ? Colors.white
          : selectedColor.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
  }

  void addTextToCanvas() {
    if (currentText.isEmpty) return;

    setState(() {
      points.add(
        ColoringPoints(
          points: Offset(100, 100), // Default position
          paint: Paint(),
          mode: ColoringMode.text,
          text: currentText,
          textStyle: currentTextStyle.copyWith(
            color: selectedColor,
          ),
        ),
      );
      points.add(null);
      saveToHistory();
    });
  }

  void saveToHistory() {
    undoHistory.add(List.from(points));
    redoHistory.clear();
  }

  bool get canUndo => undoHistory.isNotEmpty;
  bool get canRedo => redoHistory.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    setState(() {
      redoHistory.add(List.from(points));
      points = List.from(undoHistory.last);
      undoHistory.removeLast();
    });
  }

  void redo() {
    if (!canRedo) return;
    setState(() {
      undoHistory.add(List.from(points));
      points = List.from(redoHistory.last);
      redoHistory.removeLast();
    });
  }

  void resetView() {
    setState(() {
      zoom = 1.0;
      pan = Offset.zero;
    });
  }

  void toggleGrid() {
    setState(() {
      showGrid = !showGrid;
    });
  }

  void _showSaveOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save to Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final image = await screenshotController.capture();
              if (image != null) {
                final tempDir = await getTemporaryDirectory();
                final file = File('${tempDir.path}/drawing.png');
                await file.writeAsBytes(image);
                await GallerySaver.saveImage(file.path);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to gallery')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () async {
              Navigator.pop(context);
              final image = await screenshotController.capture();
              if (image != null) {
                final tempDir = await getTemporaryDirectory();
                final file = File('${tempDir.path}/drawing.png');
                await file.writeAsBytes(image);
                await Share.shareXFiles([XFile(file.path)]);
              }
            },
          ),
        ],
      ),
    );
  }
// Add these methods inside the _ColoringScreenState class

  void _showColorPicker({bool forText = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                if (forText) {
                  currentTextStyle = currentTextStyle.copyWith(color: color);
                } else {
                  selectedColor = color;
                }
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showTextStyleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Style'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: currentTextStyle.fontSize ?? 20,
              min: 10,
              max: 50,
              divisions: 40,
              label: '${currentTextStyle.fontSize?.round() ?? 20}',
              onChanged: (value) {
                setState(() {
                  currentTextStyle = currentTextStyle.copyWith(fontSize: value);
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Bold'),
              value: currentTextStyle.fontWeight == FontWeight.bold,
              onChanged: (value) {
                setState(() {
                  currentTextStyle = currentTextStyle.copyWith(
                    fontWeight:
                        value ?? false ? FontWeight.bold : FontWeight.normal,
                  );
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Italic'),
              value: currentTextStyle.fontStyle == FontStyle.italic,
              onChanged: (value) {
                setState(() {
                  currentTextStyle = currentTextStyle.copyWith(
                    fontStyle:
                        value ?? false ? FontStyle.italic : FontStyle.normal,
                  );
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget buildImageLoadingButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        isImageLoading = true;
      });

      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final data = await file.readAsBytes();
        final completer = Completer<ui.Image>();

        ui.decodeImageFromList(data, (ui.Image img) {
          completer.complete(img);
        });

        setState(() {
          _image = file;
          points.clear();
        });

        _cachedImage = await completer.future;
        setState(() {
          isImageLoading = false;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image loaded successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          isImageLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      setState(() {
        isImageLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadImageFromAssets(String assetPath) async {
    try {
      setState(() {
        isImageLoading = true;
      });

      // Load the asset image
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final completer = Completer<ui.Image>();

      // Decode the image
      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(img);
      });

      // Clear previous points and update the cached image
      setState(() {
        points.clear();
      });

      _cachedImage = await completer.future;
      setState(() {
        isImageLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image loaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error loading asset image: $e');
      setState(() {
        isImageLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
// Add remaining helper methods and UI components here...
}
