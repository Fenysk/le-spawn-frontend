import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageUtil {
  static Future<File> optimizeImage(
    File imageFile, {
    int maxDimension = 2000,
    int quality = 100,
  }) async {
    try {
      final fileBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(Uint8List.fromList(fileBytes));

      if (image == null) {
        debugPrint('⚠️ Impossible de décoder l\'image');
        return imageFile;
      }

      if (image.width > maxDimension || image.height > maxDimension) {
        debugPrint('📏 Redimensionnement de l\'image: ${image.width}x${image.height} -> max ${maxDimension}px');

        if (image.width > image.height) {
          image = img.copyResize(
            image,
            width: maxDimension,
            height: (maxDimension * image.height ~/ image.width),
            interpolation: img.Interpolation.cubic,
          );
        } else {
          image = img.copyResize(
            image,
            width: (maxDimension * image.width ~/ image.height),
            height: maxDimension,
            interpolation: img.Interpolation.cubic,
          );
        }
        debugPrint('📏 Image redimensionnée à: ${image.width}x${image.height}');
      } else {
        debugPrint('📏 L\'image ne nécessite pas de redimensionnement: ${image.width}x${image.height}');
      }

      final compressedBytes = img.encodeJpg(image, quality: quality);
      final originalSize = fileBytes.length / 1024;
      final compressedSize = compressedBytes.length / 1024;
      debugPrint('📏 Compression: ${originalSize.toStringAsFixed(2)}KB -> ${compressedSize.toStringAsFixed(2)}KB (${(100 - (compressedSize / originalSize) * 100).toStringAsFixed(1)}% de réduction)');

      final tempDir = await Directory.systemTemp.createTemp('optimized_images');
      final tempFile = File('${tempDir.path}/optimized_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await tempFile.writeAsBytes(compressedBytes);
      return tempFile;
    } catch (e) {
      debugPrint('⚠️ Échec de l\'optimisation de l\'image: $e');
      return imageFile;
    }
  }
}
