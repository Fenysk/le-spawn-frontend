import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:io';

import '../bloc/game-photos/game-photos.cubit.dart';
import '../bloc/game-photos/game-photos.state.dart';

class NewGameItemPage extends StatelessWidget {
  const NewGameItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamePhotosCubit(),
      child: const _NewGameItemPageContent(),
    );
  }
}

class _NewGameItemPageContent extends StatefulWidget {
  const _NewGameItemPageContent();

  @override
  State<_NewGameItemPageContent> createState() => _NewGameItemPageContentState();
}

class _NewGameItemPageContentState extends State<_NewGameItemPageContent> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isTakingPicture = false;
  bool _showCaptureEffect = false;
  bool _showTransition = false;
  String _transitionMessage = '';

  File? _frontImage;
  File? _backImage;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimation();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } on CameraException catch (e) {
      debugPrint('Camera error: ${e.description}');
    }
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _showTransition = false;
        });
      }
    });
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_isCameraInitialized || _isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
      _showCaptureEffect = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();

      await Future.delayed(const Duration(milliseconds: 50));

      setState(() {
        _showCaptureEffect = false;
      });

      if (_frontImage == null) {
        _frontImage = File(photo.path);
        print('Front image captured: ${photo.path}');

        setState(() {
          _showTransition = true;
          _transitionMessage = 'Photo de face avant capturée ! Préparez la face arrière...';
          _isTakingPicture = false;
        });

        _animationController.forward(from: 0.0);
      } else {
        _backImage = File(photo.path);
        print('Back image captured: ${photo.path}');
        setState(() {
          _isTakingPicture = false;
        });
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      setState(() {
        _isTakingPicture = false;
        _showCaptureEffect = false;
      });
    }
  }

  void _resetImages() {
    setState(() {
      _frontImage = null;
      _backImage = null;
    });
  }

  Future<void> _uploadImages() async {
    if (_frontImage != null && _backImage != null) {
      context.read<GamePhotosCubit>().uploadGamePhotos(
            frontImage: _frontImage!,
            backImage: _backImage!,
          );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamePhotosCubit, GamePhotosState>(
      listener: (context, state) {
        if (state is GamePhotosUploadedState) {
          print('Images téléchargées:');
          print('Front image URL: ${state.frontImageUrl}');
          print('Back image URL: ${state.backImageUrl}');

          print('Résultats de la détection de codes-barres:');
          if (state.frontBarcodeValue != null) {
            print('Code-barres sur la face avant: ${state.frontBarcodeValue}');
          } else {
            print('Aucun code-barres détecté sur la face avant');
          }

          if (state.backBarcodeValue != null) {
            print('Code-barres sur la face arrière: ${state.backBarcodeValue}');
          } else {
            print('Aucun code-barres détecté sur la face arrière');
          }
        } else if (state is GamePhotosErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return _buildScaffold(state);
      },
    );
  }

  Widget _buildScaffold(GamePhotosState state) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _frontImage == null
              ? 'Capture face avant du jeu'
              : _backImage == null
                  ? 'Capture face arrière du jeu'
                  : 'Vérification des photos',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      body: Column(
        children: [
          if (_frontImage == null || _backImage == null)
            Expanded(
              child: Stack(
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
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8 * (3 / 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.0),
                        ),
                        child: Center(
                          child: Text(
                            _frontImage == null ? 'Alignez la face avant du jeu' : 'Alignez la face arrière du jeu',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_showCaptureEffect)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withAlpha(178),
                      ),
                    ),
                  if (_showTransition)
                    Positioned.fill(
                      child: FadeTransition(
                        opacity: _animation,
                        child: Container(
                          color: Theme.of(context).colorScheme.primary.withAlpha(204),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _transitionMessage,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Photos capturées',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Face avant',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _frontImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Face arrière',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _backImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is GamePhotosUploadingState
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Téléchargement des photos...'),
                        ],
                      ),
                    )
                  : state is GamePhotosProcessingBarcodesState
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text('Analyse des codes-barres...'),
                            ],
                          ),
                        )
                      : _frontImage == null || _backImage == null
                          ? ElevatedButton(
                              onPressed: (_isTakingPicture || _showTransition) ? null : _takePicture,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: _isTakingPicture
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      _frontImage == null ? 'Capturer la face avant' : 'Capturer la face arrière',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                            )
                          : state is GamePhotosUploadedState
                              ? Column(
                                  children: [
                                    if (state.frontBarcodeValue != null || state.backBarcodeValue != null)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Codes-barres détectés:',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            if (state.frontBarcodeValue != null) Text('Face avant: ${state.frontBarcodeValue}'),
                                            if (state.backBarcodeValue != null) Text('Face arrière: ${state.backBarcodeValue}'),
                                          ],
                                        ),
                                      ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _resetImages();
                                        context.read<GamePhotosCubit>().resetState();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      child: const Text('Nouvelles photos'),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _resetImages,
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(50),
                                        ),
                                        child: const Text('Reprendre les photos'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _uploadImages,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(50),
                                        ),
                                        child: const Text('Confirmer'),
                                      ),
                                    ),
                                  ],
                                ),
            ),
          ),
        ],
      ),
    );
  }
}
