import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';

import '../../app/theme.dart';

late List<CameraDescription> cameras;

class ObjectDetection extends StatefulWidget {
  const ObjectDetection({super.key});

  @override
  State<ObjectDetection> createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: YoloVideo(),
    );
  }
}

class YoloVideo extends StatefulWidget {
  const YoloVideo({super.key});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          title: const Text(
            'Object Detection',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          color: Colors.black,
          child: const Center(
            child: SpinKitFadingCircle(color: Colors.white, size: 50.0),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Object Detection',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8n.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    List<Uint8List> bytesList =
        cameraImage.planes.map((plane) => plane.bytes).toList();

    final result = await vision.yoloOnFrame(
        bytesList: bytesList,
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.4);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    return yoloResults.map((result) {
      double boxLeft = result["box"][0] * factorX;
      double boxTop = result["box"][1] * factorY;
      double boxWidth = (result["box"][2] - result["box"][0]) * factorX;
      double boxHeight = (result["box"][3] - result["box"][1]) * factorY;

      double objectWidth;
      double realObjectWidth;
      double realObjectDistance;
      double perceivedObjectWidthInPixels;

      switch (result['tag']) {
        case 'bottle':
          realObjectWidth = 8.0;
          realObjectDistance = 60.0;
          perceivedObjectWidthInPixels = 67.99305;

          break;
        case 'cup':
          objectWidth = 8.0;
          realObjectWidth = objectWidth;
          realObjectDistance = objectWidth;
          perceivedObjectWidthInPixels = screen.width;

          break;
        case 'tv':
          objectWidth = 52.0;
          realObjectWidth = objectWidth;
          realObjectDistance = objectWidth;
          perceivedObjectWidthInPixels = screen.width;

          break;
        case 'keyboard':
          objectWidth = 44.0;
          realObjectWidth = objectWidth;
          realObjectDistance = objectWidth;
          perceivedObjectWidthInPixels = screen.width;

          break;
        case 'person':
          realObjectWidth = 46;
          realObjectDistance = 150;
          perceivedObjectWidthInPixels = 179.37023;

          break;
        case 'book':
          realObjectWidth = 16;
          realObjectDistance = 40;
          perceivedObjectWidthInPixels = 180.96644;

          break;
        default:
          objectWidth = (boxWidth * boxHeight) / (screen.width);
          realObjectWidth = objectWidth;
          realObjectDistance = objectWidth / 2.5;
          perceivedObjectWidthInPixels = screen.width;
      }

      double focalLength =
          (perceivedObjectWidthInPixels * realObjectDistance) / realObjectWidth;
      double distanceToObject = (realObjectWidth * focalLength) / boxWidth;

      return Stack(
        children: [
          Positioned(
            left: boxLeft,
            top: boxTop,
            width: boxWidth,
            height: boxHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Colors.pink, width: 2.0),
              ),
            ),
          ),
          Positioned(
            left: boxLeft,
            top: boxTop - 35,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 135, 0, 45).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                "${result['tag']} D: ${distanceToObject.toStringAsFixed(2)} cm",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
