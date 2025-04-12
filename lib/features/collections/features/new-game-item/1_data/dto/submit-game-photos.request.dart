import 'dart:convert';

class SubmitGamePhotosRequest {
  final String frontGameImageUrl;
  final String? backGameImageUrl;
  final String? barcode;
  final String collectionId;

  const SubmitGamePhotosRequest({
    required this.frontGameImageUrl,
    this.backGameImageUrl,
    this.barcode,
    required this.collectionId,
  });

  String toJson() => jsonEncode({
        'frontGameImageUrl': frontGameImageUrl,
        'backGameImageUrl': backGameImageUrl,
        'barcode': barcode,
        'collectionId': collectionId,
      });
}
