import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../2_domain/repository/storage.repository.dart';
import '../../2_domain/entity/uploaded-file.entity.dart';
import '../model/uploaded-file.model.dart';

class StorageRepositoryImpl implements StorageRepository {
  final Dio _dio;

  StorageRepositoryImpl(this._dio);

  @override
  Future<Either<String, UploadedFileEntity>> uploadFile(
    File file, {
    String? bucket,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        if (bucket != null) 'bucket': bucket,
      });

      final response = await _dio.post(
        '/storage/upload',
        data: formData,
      );

      final model = UploadedFileModel.fromJson(response.data);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Failed to upload file: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteFileFromUrl(
    String url, {
    String? bucket,
  }) async {
    try {
      final response = await _dio.delete(
        '/storage/url',
        data: {
          'url': url,
          if (bucket != null) 'bucket': bucket,
        },
      );

      return Right(response.data as String);
    } catch (e) {
      return Left('Failed to delete file: $e');
    }
  }
}
