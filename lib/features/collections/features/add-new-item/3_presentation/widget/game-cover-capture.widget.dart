import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:permission_handler/permission_handler.dart';

class GameCoverCaptureWidget extends StatefulWidget {
  final String barcode;

  const GameCoverCaptureWidget({
    super.key,
    required this.barcode,
  });

  @override
  State<GameCoverCaptureWidget> createState() => _GameCoverCaptureWidgetState();
}

class _GameCoverCaptureWidgetState extends State<GameCoverCaptureWidget> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    setState(() => _isPermissionGranted = status.isGranted);

    if (!_isPermissionGranted) return;

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller?.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    debugPrint('📸 Starting image capture...');
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('❌ Camera not initialized');
      return;
    }

    try {
      debugPrint('📸 Taking picture...');
      final image = await _controller?.takePicture();

      if (image == null) {
        debugPrint('❌ No image captured');
        return;
      }

      debugPrint('✅ Picture taken: ${image.path}');

      if (!mounted) {
        debugPrint('❌ Widget not mounted');
        return;
      }

      debugPrint('📤 Starting upload for barcode: ${widget.barcode}');

      context.read<AddNewGameCubit>().searchGamesFromImage(
            File(image.path),
            widget.barcode,
          );
    } catch (e, stackTrace) {
      debugPrint('❌ Error capturing image: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la capture de l\'image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_photography_outlined,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Permission de caméra refusée',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final status = await Permission.camera.request();
              setState(() => _isPermissionGranted = status.isGranted);
              if (status.isGranted) {
                _initializeCamera();
              }
            },
            child: const Text('Autoriser l\'accès à la caméra'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.read<AddNewGameCubit>().resetGame(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isPermissionGranted) {
      return _buildPermissionDenied();
    }

    if (!_isCameraInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CameraPreview(_controller!),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Column(
            children: [
              const Text(
                'Prenez en photo la couverture du jeu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () => context.read<AddNewGameCubit>().resetGame(),
                  ),
                  FloatingActionButton(
                    onPressed: _captureImage,
                    child: const Icon(Icons.camera),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Vérifions que le BLoC est accessible
    final cubit = context.read<AddNewGameCubit>();
    debugPrint('🔄 Building GameCoverCapture with barcode: ${widget.barcode}');

    return BlocConsumer<AddNewGameCubit, AddNewGameState>(
      listener: (context, state) {
        debugPrint('📸 GameCoverCapture state: ${state.runtimeType}');
        if (state is AddNewGameLoadedGamesState) {
          debugPrint('✅ Games found, disposing camera and navigating back');
          _controller?.dispose();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else if (state is AddNewGameFailureState) {
          debugPrint('❌ Error: ${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AddNewGameUploadingPhotoState) {
          debugPrint('📤 Uploading photo...');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Photographier la couverture'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              _buildCameraPreview(),
              if (state is AddNewGameUploadingPhotoState)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Analyse de la couverture pour le jeu\navec le code-barre ${widget.barcode}...',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              if (state is AddNewGameFailureState)
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => cubit.resetGame(),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
