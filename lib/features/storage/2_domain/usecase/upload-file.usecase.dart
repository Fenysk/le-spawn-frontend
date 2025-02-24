import 'dart:io';

import 'package:dartz/dartz.dart';
import '../repository/storage.repository.dart';
import '../entity/uploaded-file.entity.dart';

class UploadFileUseCase {
  final StorageRepository _repository;

  UploadFileUseCase(this._repository);

  Future<Either<String, UploadedFileEntity>> call(
    File file, {
    String? bucket,
  }) {
    return _repository.uploadFile(file, bucket: bucket);
  }
}
