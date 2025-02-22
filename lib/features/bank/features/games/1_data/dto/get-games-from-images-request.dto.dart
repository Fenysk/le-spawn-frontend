class GetGamesFromImagesRequest {
  final List<String> images;
  final String? barcode;

  GetGamesFromImagesRequest({
    required this.images,
    this.barcode,
  });

  Map<String, dynamic> toJson() => {
        'images': images,
        if (barcode != null) 'barcode': barcode,
      };
}
