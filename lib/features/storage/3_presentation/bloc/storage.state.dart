import 'package:equatable/equatable.dart';
import '../../2_domain/entity/uploaded-file.entity.dart';

abstract class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object?> get props => [];
}

class StorageInitial extends StorageState {
  const StorageInitial();
}

class StorageLoading extends StorageState {
  const StorageLoading();
}

class StorageError extends StorageState {
  final String errorMessage;

  const StorageError(this.errorMessage);

  @override
  List<Object?> get props => [
        errorMessage
      ];
}

class FileUploaded extends StorageState {
  final UploadedFileEntity file;

  const FileUploaded(this.file);

  @override
  List<Object?> get props => [
        file
      ];
}

class FileDeleted extends StorageState {
  final String message;

  const FileDeleted(this.message);

  @override
  List<Object?> get props => [
        message
      ];
}
