import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/core/utils/image.util.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/dto/submit-game-photos.request.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/2_domain/usecase/submit-game-photos.usecase.dart';
import 'package:le_spawn_fr/features/storage/2_domain/repository/storage.repository.dart';
import 'game-photos.state.dart';

class GamePhotosCubit extends Cubit<GamePhotosState> {
  final StorageRepository _storageRepository;
  final SubmitGamePhotosUsecase _submitGamePhotosUsecase;

  GamePhotosCubit({
    StorageRepository? storageRepository,
    SubmitGamePhotosUsecase? submitGamePhotosUsecase,
  })  : _storageRepository = storageRepository ?? serviceLocator<StorageRepository>(),
        _submitGamePhotosUsecase = submitGamePhotosUsecase ?? serviceLocator<SubmitGamePhotosUsecase>(),
        super(GamePhotosInitialState());

  Future<void> uploadGamePhotos({
    required File frontImage,
    File? backImage,
    required BuildContext context,
    required String collectionId,
    String? barcode,
  }) async {
    emit(GamePhotosUploadingState(
      frontImage: frontImage,
      backImage: backImage,
    ));

    try {
      final optimizedFrontImage = await ImageUtil.optimizeImage(frontImage);
      File? optimizedBackImage;
      String? backImageUrl;

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

      if (backImage != null) {
        optimizedBackImage = await ImageUtil.optimizeImage(backImage);

        debugPrint('📤 Uploading back image...');
        final backImageResult = await _storageRepository.uploadFile(optimizedBackImage);

        final backImageFile = backImageResult.fold(
          (error) {
            debugPrint('❌ Error uploading back image: $error');
            throw Exception(error);
          },
          (file) => file,
        );

        backImageUrl = backImageFile.url;
        debugPrint('✅ Back image uploaded successfully: $backImageUrl');
      } else {
        debugPrint('ℹ️ No back image provided, skipping back image upload');
      }

      if (barcode != null) {
        debugPrint('ℹ️ Using pre-detected barcode: $barcode');
        await _submitGamePhotosToBackend(
          frontImageUrl: frontImageFile.url,
          backImageUrl: backImageUrl,
          barcode: barcode,
          collectionId: collectionId,
          context: context,
        );
      } else {
        emit(GamePhotosProcessingBarcodesState(
          frontImage: frontImage,
          backImage: backImage,
          frontImageUrl: frontImageFile.url,
          backImageUrl: backImageUrl,
        ));

        final String? detectedBarcode = await _processGameBarcodes(
          frontImage: frontImage,
          backImage: backImage,
          frontImageUrl: frontImageFile.url,
          backImageUrl: backImageUrl,
        );

        await _submitGamePhotosToBackend(
          frontImageUrl: frontImageFile.url,
          backImageUrl: backImageUrl,
          barcode: detectedBarcode,
          collectionId: collectionId,
          context: context,
        );
      }
    } catch (e) {
      debugPrint('❌ Error during photo upload: $e');
      emit(GamePhotosErrorState(
        errorMessage: 'Erreur lors du téléchargement des photos: $e',
      ));
    }
  }

  Future<void> _submitGamePhotosToBackend({
    required String frontImageUrl,
    String? backImageUrl,
    required String collectionId,
    String? barcode,
    required BuildContext context,
  }) async {
    try {
      debugPrint('📤 Submitting game photos to backend...');
      final request = SubmitGamePhotosRequest(
        frontGameImageUrl: frontImageUrl,
        backGameImageUrl: backImageUrl,
        barcode: barcode,
        collectionId: collectionId,
      );

      final result = await _submitGamePhotosUsecase.execute(request: request);

      result.fold(
        (error) {
          debugPrint('❌ Error submitting game photos: $error');
          emit(GamePhotosErrorState(
            errorMessage: 'Erreur lors de l\'envoi des photos au serveur: $error',
          ));
        },
        (_) {
          debugPrint('✅ Game photos submitted successfully');
          emit(GamePhotosUploadedState(
            frontImage: state is GamePhotosProcessingBarcodesState ? (state as GamePhotosProcessingBarcodesState).frontImage : File(''),
            backImage: state is GamePhotosProcessingBarcodesState ? (state as GamePhotosProcessingBarcodesState).backImage : null,
            frontImageUrl: frontImageUrl,
            backImageUrl: backImageUrl,
            frontBarcodeValue: barcode,
            backBarcodeValue: null,
          ));

          context.go('/collections');
        },
      );
    } catch (e) {
      debugPrint('❌ Error submitting game photos: $e');
      emit(GamePhotosErrorState(
        errorMessage: 'Erreur lors de l\'envoi des photos au serveur: $e',
      ));
    }
  }

  Future<String?> _processGameBarcodes({
    required File frontImage,
    File? backImage,
    required String frontImageUrl,
    String? backImageUrl,
  }) async {
    try {
      debugPrint('🔍 Scanning front image for barcodes...');
      final String? frontBarcodeValue = await _scanBarcodeFromImage(frontImage);

      if (frontBarcodeValue != null) {
        debugPrint('✅ Front barcode detected: $frontBarcodeValue');
        return frontBarcodeValue;
      }

      if (backImage != null) {
        debugPrint('🔍 Scanning back image for barcodes...');
        final String? backBarcodeValue = await _scanBarcodeFromImage(backImage);

        if (backBarcodeValue != null) {
          debugPrint('✅ Back barcode detected: $backBarcodeValue');
          return backBarcodeValue;
        }
      }

      debugPrint('⚠️ No barcodes detected in any image');
      return null;
    } catch (e) {
      debugPrint('❌ Error scanning barcodes: $e');
      return null;
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
