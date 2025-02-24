import 'package:equatable/equatable.dart';

class UploadedFileEntity extends Equatable {
  final String url;
  final String bucket;
  final String filename;
  final String etag;
  final int size;
  final String mimetype;
  final String path;

  const UploadedFileEntity({
    required this.url,
    required this.bucket,
    required this.filename,
    required this.etag,
    required this.size,
    required this.mimetype,
    required this.path,
  });

  @override
  List<Object?> get props => [
        url,
        bucket,
        filename,
        etag,
        size,
        mimetype,
        path,
      ];
}
