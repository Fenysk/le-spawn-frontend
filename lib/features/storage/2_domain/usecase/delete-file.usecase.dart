import 'package:dartz/dartz.dart';
import '../repository/storage.repository.dart';

class DeleteFileUseCase {
  final StorageRepository _repository;

  DeleteFileUseCase(this._repository);

  Future<Either<String, String>> call(
    String url, {
    String? bucket,
  }) {
    return _repository.deleteFileFromUrl(url, bucket: bucket);
  }
}
