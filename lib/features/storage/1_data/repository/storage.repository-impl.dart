import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/features/storage/1_data/model/uploaded-file.model.dart';
import 'package:le_spawn_fr/features/storage/1_data/source/storage-api.service.dart';
import 'package:le_spawn_fr/features/storage/2_domain/entity/uploaded-file.entity.dart';
import 'package:le_spawn_fr/features/storage/2_domain/repository/storage.repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  @override
  Future<Either<String, UploadedFileEntity>> uploadFile(
    File file, {
    String? bucket,
  }) async {
    final result = await serviceLocator<StorageApiService>().uploadFile(
      file,
      bucket: bucket,
    );

    return result.fold(
      (error) => Left(error),
      (data) {
        final model = UploadedFileModel.fromJson(data);
        return Right(model.toEntity());
      },
    );
  }

  @override
  Future<Either<String, String>> deleteFileFromUrl(
    String url, {
    String? bucket,
  }) async {
    final result = await serviceLocator<StorageApiService>().deleteFileFromUrl(
      url,
      bucket: bucket,
    );

    return result.fold(
      (error) => Left(error),
      (data) => Right(data as String),
    );
  }
}
