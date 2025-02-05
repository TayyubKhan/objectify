// lib/features/object_detection/data/repositories/camera_repository_impl.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

import 'object_detection_repository.dart';



class CameraRepositoryImpl implements CameraRepository {
  late CameraController _controller;

  @override
  CameraController get controller => _controller;

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      throw CameraException('Failed to get cameras', e.toString());
    }
  }

  @override
  Future<void> initializeCamera(CameraDescription camera) async {
    try {
      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await _controller.initialize();
      await _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    } catch (e) {
      throw CameraException('Failed to initialize camera', e.toString());
    }
  }

  @override
  Future<void> startImageStream(Function(CameraImage) onImage) async {
    if (!_controller.value.isInitialized) {
      throw CameraException('Camera not initialized', 'Call initialize() first');
    }

    try {
      await _controller.startImageStream(onImage);
    } catch (e) {
      throw CameraException('Failed to start image stream', e.toString());
    }
  }

  @override
  Future<void> stopImageStream() async {
    try {
      await _controller.stopImageStream();
    } catch (e) {
      throw CameraException('Failed to stop image stream', e.toString());
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _controller.dispose();
    } catch (e) {
      throw CameraException('Failed to dispose camera', e.toString());
    }
  }
}