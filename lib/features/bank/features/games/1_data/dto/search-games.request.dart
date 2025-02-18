import 'dart:convert';

class SearchGamesRequest {
  final String? query;
  final String? barcode;
  final String? id;

  const SearchGamesRequest({
    this.query,
    this.barcode,
    this.id,
  });

  String toJson() => jsonEncode({
        'query': query,
        'barcode': barcode,
        'id': id,
      });
}
