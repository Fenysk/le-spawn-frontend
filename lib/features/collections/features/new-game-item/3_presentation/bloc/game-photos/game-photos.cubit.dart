import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image/image.dart' as img;
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/features/storage/2_domain/repository/storage.repository.dart';
import 'game-photos.state.dart';

class GamePhotosCubit extends Cubit<GamePhotosState> {
  final StorageRepository _storageRepository;

  GamePhotosCubit({StorageRepository? storageRepository})
      : _storageRepository = storageRepository ?? serviceLocator<StorageRepository>(),
        super(GamePhotosInitialState());

  Future<void> uploadGamePhotos({
    required File frontImage,
    required File backImage,
  }) async {
    emit(GamePhotosUploadingState(
      frontImage: frontImage,
      backImage: backImage,
    ));

    try {
      final optimizedFrontImage = await _optimizeImage(frontImage);
      final optimizedBackImage = await _optimizeImage(backImage);

      debugPrint('📤 Uploading front image...');
      final frontImageResult = await _storageRepository.uploadFile(optimizedFrontImage);

      final frontImageFile = frontImageResult.fold(
        (error) {
          debugPrint('❌ Error uploading front image: $error');
          throw Exception(error);
        },
        (file) => file,
      );

      debugPrint('✅ Front image uploaded successfully: ${frontImageFile.url}');

      debugPrint('📤 Uploading back image...');
      final backImageResult = await _storageRepository.uploadFile(optimizedBackImage);

      final backImageFile = backImageResult.fold(
        (error) {
          debugPrint('❌ Error uploading back image: $error');
          throw Exception(error);
        },
        (file) => file,
      );

      debugPrint('✅ Back image uploaded successfully: ${backImageFile.url}');

      emit(GamePhotosProcessingBarcodesState(
        frontImage: frontImage,
        backImage: backImage,
        frontImageUrl: frontImageFile.url,
        backImageUrl: backImageFile.url,
      ));

      await _processGameBarcodes(
        frontImage: frontImage,
        backImage: backImage,
        frontImageUrl: frontImageFile.url,
        backImageUrl: backImageFile.url,
      );
    } catch (e) {
      debugPrint('❌ Error during photo upload: $e');
      emit(GamePhotosErrorState(
        errorMessage: 'Erreur lors du téléchargement des photos: $e',
      ));
    }
  }

  Future<File> _optimizeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        return imageFile;
      }

      if (bytes.length < 1024 * 1024) {
        return imageFile;
      }

      final int maxWidth = 1200;
      final int maxHeight = 1800;

      img.Image resizedImage = originalImage;
      if (originalImage.width > maxWidth || originalImage.height > maxHeight) {
        double ratio = originalImage.width / originalImage.height;
        int newWidth, newHeight;

        if (ratio > 2 / 3) {
          newWidth = maxWidth;
          newHeight = (maxWidth / ratio).round();
        } else {
          newHeight = maxHeight;
          newWidth = (maxHeight * ratio).round();
        }

        resizedImage = img.copyResize(
          originalImage,
          width: newWidth,
          height: newHeight,
        );
      }

      final Uint8List optimizedBytes = img.encodeJpg(resizedImage, quality: 80);

      final optimizedFile = File('${imageFile.path}_optimized.jpg');
      await optimizedFile.writeAsBytes(optimizedBytes);

      debugPrint('📸 Image optimized: original size: ${bytes.length / 1024}KB, new size: ${optimizedBytes.length / 1024}KB');

      return optimizedFile;
    } catch (e) {
      debugPrint('⚠️ Failed to optimize image: $e');
      return imageFile;
    }
  }

  Future<void> _processGameBarcodes({
    required File frontImage,
    required File backImage,
    required String frontImageUrl,
    required String backImageUrl,
  }) async {
    try {
      debugPrint('🔍 Scanning front image for barcodes...');
      final String? frontBarcodeValue = await _scanBarcodeFromImage(frontImage);

      debugPrint('🔍 Scanning back image for barcodes...');
      final String? backBarcodeValue = await _scanBarcodeFromImage(backImage);

      if (frontBarcodeValue != null) {
        debugPrint('✅ Front barcode detected: $frontBarcodeValue');
      } else {
        debugPrint('⚠️ No barcode detected in front image');
      }

      if (backBarcodeValue != null) {
        debugPrint('✅ Back barcode detected: $backBarcodeValue');
      } else {
        debugPrint('⚠️ No barcode detected in back image');
      }

      emit(GamePhotosUploadedState(
        frontImage: frontImage,
        backImage: backImage,
        frontImageUrl: frontImageUrl,
        backImageUrl: backImageUrl,
        frontBarcodeValue: frontBarcodeValue,
        backBarcodeValue: backBarcodeValue,
      ));
    } catch (e) {
      debugPrint('❌ Error scanning barcodes: $e');

      emit(GamePhotosUploadedState(
        frontImage: frontImage,
        backImage: backImage,
        frontImageUrl: frontImageUrl,
        backImageUrl: backImageUrl,
      ));
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

  void resetState() {
    emit(GamePhotosInitialState());
  }
}
