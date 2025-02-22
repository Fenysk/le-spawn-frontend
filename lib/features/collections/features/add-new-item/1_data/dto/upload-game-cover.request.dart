import 'dart:io';

class UploadGameCoverRequest {
  final File file;
  final String barcode;
  final String? bucket;

  const UploadGameCoverRequest({
    required this.file,
    required this.barcode,
    this.bucket = 'game-covers',
  });

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'bucket': bucket,
      };
}
