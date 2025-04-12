import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../bloc/game-photos/game-photos.cubit.dart';
import '../bloc/game-photos/game-photos.state.dart';

class NewGameItemPage extends StatelessWidget {
  final String collectionId;

  const NewGameItemPage({
    super.key,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    if (collectionId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erreur'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Vous devez avoir une collection pour ajouter un jeu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Veuillez créer ou sélectionner une collection avant d\'ajouter un jeu',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => GamePhotosCubit(),
      child: _NewGameItemPageContent(collectionId: collectionId),
    );
  }
}

class _NewGameItemPageContent extends StatefulWidget {
  final String collectionId;

  const _NewGameItemPageContent({
    required this.collectionId,
  });

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
  bool _isScanningBarcodes = false;
  bool _backImageSkipped = false;

  File? _frontImage;
  File? _backImage;
  String? _detectedBarcode;

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
          _isScanningBarcodes = true;
        });

        await _scanBarcodes();
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      setState(() {
        _isTakingPicture = false;
        _showCaptureEffect = false;
        _isScanningBarcodes = false;
      });
    }
  }

  Future<void> _scanBarcodes() async {
    try {
      print('Scanning for barcodes...');

      final String? frontBarcode = await _scanBarcodeFromImage(_frontImage!);
      if (frontBarcode != null) {
        print('Barcode detected on front image: $frontBarcode');
        setState(() {
          _detectedBarcode = frontBarcode;
          _isScanningBarcodes = false;
        });
        return;
      }

      final String? backBarcode = await _scanBarcodeFromImage(_backImage!);
      if (backBarcode != null) {
        print('Barcode detected on back image: $backBarcode');
        setState(() {
          _detectedBarcode = backBarcode;
          _isScanningBarcodes = false;
        });
        return;
      }

      print('No barcodes detected on either image');
      setState(() {
        _isScanningBarcodes = false;
      });
    } catch (e) {
      print('Error scanning barcodes: $e');
      setState(() {
        _isScanningBarcodes = false;
      });
    }
  }

  Future<String?> _scanBarcodeFromImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final barcodeScanner = BarcodeScanner(formats: [
      BarcodeFormat.all
    ]);

    try {
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        for (final barcode in barcodes) {
          if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
            return barcode.rawValue;
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error scanning barcode from image: $e');
      return null;
    } finally {
      barcodeScanner.close();
    }
  }

  void _resetImages() {
    setState(() {
      _frontImage = null;
      _backImage = null;
      _detectedBarcode = null;
      _backImageSkipped = false;
    });
  }

  Future<void> _uploadImages() async {
    if (_frontImage != null) {
      context.read<GamePhotosCubit>().uploadGamePhotos(
            frontImage: _frontImage!,
            backImage: _backImage,
            context: context,
            barcode: _detectedBarcode,
            collectionId: widget.collectionId,
          );
    }
  }

  void _skipBackImage() async {
    setState(() {
      _isScanningBarcodes = true;
    });

    if (_frontImage != null) {
      try {
        final String? frontBarcode = await _scanBarcodeFromImage(_frontImage!);
        if (frontBarcode != null) {
          print('Barcode detected on front image: $frontBarcode');
          setState(() {
            _detectedBarcode = frontBarcode;
          });
        }
      } catch (e) {
        print('Error scanning barcodes: $e');
      }
    }

    setState(() {
      _isScanningBarcodes = false;
      _backImageSkipped = true;
    });
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
                  ? _isScanningBarcodes
                      ? 'Analyse du code-barres'
                      : 'Capture face arrière du jeu'
                  : 'Vérification des photos',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      body: Column(
        children: [
          if (_frontImage == null || (_frontImage != null && _backImage == null && !_isScanningBarcodes && !_backImageSkipped))
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
          else if (_isScanningBarcodes)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Analyse des photos pour détecter les codes-barres...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _backImage == null ? 'Photo capturée' : 'Photos capturées',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_detectedBarcode != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.qr_code),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Code-barres détecté:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(_detectedBarcode!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Expanded(
                      child: _backImage == null
                          ? Column(
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
                            )
                          : Row(
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
                      : _frontImage == null
                          ? ElevatedButton(
                              onPressed: (_isTakingPicture || _showTransition) ? null : _takePicture,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: _isTakingPicture
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Capturer la face avant',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            )
                          : _backImage == null && _isScanningBarcodes == false && _backImageSkipped == false
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: (_isTakingPicture || _showTransition) ? null : _skipBackImage,
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(50),
                                        ),
                                        child: const Text('Ignorer la face arrière'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: (_isTakingPicture || _showTransition) ? null : _takePicture,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(50),
                                        ),
                                        child: _isTakingPicture
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                'Capturer la face arrière',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                      ),
                                    ),
                                  ],
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
                                  : _isScanningBarcodes
                                      ? const SizedBox.shrink()
                                      : _backImageSkipped && _frontImage != null
                                          ? Row(
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
