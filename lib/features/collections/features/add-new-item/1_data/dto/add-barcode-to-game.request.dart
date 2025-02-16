import 'dart:convert';

class AddBarcodeToGameRequest {
  final String gameId;
  final String barcode;

  const AddBarcodeToGameRequest({
    required this.gameId,
    required this.barcode,
  });

  String toJson() => jsonEncode({
        'gameId': gameId,
        'barcode': barcode,
      });
}
