import '../../2_domain/entity/uploaded-file.entity.dart';

class UploadedFileModel {
  final String url;
  final String bucket;
  final String filename;
  final String etag;
  final int size;
  final String mimetype;
  final String path;

  UploadedFileModel({
    required this.url,
    required this.bucket,
    required this.filename,
    required this.etag,
    required this.size,
    required this.mimetype,
    required this.path,
  });

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    return UploadedFileModel(
      url: json['url'] as String,
      bucket: json['fileInfo']['bucket'] as String,
      filename: json['fileInfo']['filename'] as String,
      etag: json['fileInfo']['etag'] as String,
      size: json['fileInfo']['size'] as int,
      mimetype: json['fileInfo']['mimetype'] as String,
      path: json['fileInfo']['path'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'fileInfo': {
          'bucket': bucket,
          'filename': filename,
          'etag': etag,
          'size': size,
          'mimetype': mimetype,
          'path': path,
        },
      };

  UploadedFileEntity toEntity() {
    return UploadedFileEntity(
      url: url,
      bucket: bucket,
      filename: filename,
      etag: etag,
      size: size,
      mimetype: mimetype,
      path: path,
    );
  }
}
