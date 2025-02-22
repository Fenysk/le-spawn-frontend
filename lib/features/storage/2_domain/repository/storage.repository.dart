import 'dart:io';
import 'package:dartz/dartz.dart';
import '../entity/uploaded-file.entity.dart';

abstract class StorageRepository {
  Future<Either<String, UploadedFileEntity>> uploadFile(
    File file, {
    String? bucket,
  });

  Future<Either<String, String>> deleteFileFromUrl(
    String url, {
    String? bucket,
  });
}
