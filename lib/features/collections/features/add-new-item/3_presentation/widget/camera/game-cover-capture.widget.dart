import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.cubit.dart';

class GameCoverCaptureWidget extends StatefulWidget {
  final String? barcode;

  const GameCoverCaptureWidget({
    super.key,
    this.barcode,
  });

  @override
  State<GameCoverCaptureWidget> createState() => _GameCoverCaptureWidgetState();
}

class _GameCoverCaptureWidgetState extends State<GameCoverCaptureWidget> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller?.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller?.takePicture();
      if (image == null) return;

      if (mounted) {
        context.read<GameSearchCubit>().searchGamesFromImage(
              File(image.path),
              widget.barcode,
            );
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        SizedBox.expand(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: RotatedBox(
              quarterTurns: 1,
              child: CameraPreview(_controller!),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: _captureImage,
              child: const Icon(Icons.camera),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
