class CategoryModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String url;
  final DateTime? timestamp;
  final String link;

  CategoryModel(
      {this.id = '',
      this.titleEn = '',
      this.titleAr = '',
      this.url = '',
      this.timestamp,
      this.link = ''});

  factory CategoryModel.fromJson(Map json) {
    return CategoryModel(
      titleEn: json['titleEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      link: json['link'] ?? '',
    );
  }
}
