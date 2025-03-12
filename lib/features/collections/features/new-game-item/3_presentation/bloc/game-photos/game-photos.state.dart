import 'dart:io';

import 'package:equatable/equatable.dart';

sealed class GamePhotosState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GamePhotosInitialState extends GamePhotosState {}

class GamePhotosCapturingState extends GamePhotosState {}

class GamePhotosUploadingState extends GamePhotosState {
  final File? frontImage;
  final File? backImage;

  GamePhotosUploadingState({this.frontImage, this.backImage});

  @override
  List<Object?> get props => [
        frontImage,
        backImage
      ];
}

class GamePhotosProcessingBarcodesState extends GamePhotosState {
  final File frontImage;
  final File backImage;
  final String frontImageUrl;
  final String backImageUrl;

  GamePhotosProcessingBarcodesState({
    required this.frontImage,
    required this.backImage,
    required this.frontImageUrl,
    required this.backImageUrl,
  });

  @override
  List<Object?> get props => [
        frontImage,
        backImage,
        frontImageUrl,
        backImageUrl
      ];
}

class GamePhotosUploadedState extends GamePhotosState {
  final File frontImage;
  final File backImage;
  final String frontImageUrl;
  final String backImageUrl;
  final String? frontBarcodeValue;
  final String? backBarcodeValue;

  GamePhotosUploadedState({
    required this.frontImage,
    required this.backImage,
    required this.frontImageUrl,
    required this.backImageUrl,
    this.frontBarcodeValue,
    this.backBarcodeValue,
  });

  @override
  List<Object?> get props => [
        frontImage,
        backImage,
        frontImageUrl,
        backImageUrl,
        frontBarcodeValue,
        backBarcodeValue
      ];
}

class GamePhotosErrorState extends GamePhotosState {
  final String errorMessage;

  GamePhotosErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [
        errorMessage
      ];
}
