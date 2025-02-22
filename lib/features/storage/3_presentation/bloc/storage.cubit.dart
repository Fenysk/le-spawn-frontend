import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../2_domain/usecase/upload-file.usecase.dart';
import '../../2_domain/usecase/delete-file.usecase.dart';
import 'storage.state.dart';

class StorageCubit extends Cubit<StorageState> {
  final UploadFileUseCase _uploadFileUseCase;
  final DeleteFileUseCase _deleteFileUseCase;

  StorageCubit(
    this._uploadFileUseCase,
    this._deleteFileUseCase,
  ) : super(const StorageInitial());

  Future<void> uploadFile(File file, {String? bucket}) async {
    emit(const StorageLoading());

    final result = await _uploadFileUseCase(file, bucket: bucket);

    result.fold(
      (failure) => emit(StorageError(failure.toString())),
      (response) => emit(FileUploaded(response)),
    );
  }

  Future<void> deleteFile(String url, {String? bucket}) async {
    emit(const StorageLoading());

    final result = await _deleteFileUseCase(url, bucket: bucket);

    result.fold(
      (failure) => emit(StorageError(failure.toString())),
      (message) => emit(FileDeleted(message)),
    );
  }
}
