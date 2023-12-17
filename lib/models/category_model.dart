class CategoryModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String url;

  CategoryModel({
    this.id = '',
    this.titleEn = '',
    this.titleAr = '',
    this.url = '',
  });

  factory CategoryModel.fromJson(Map json) {
    return CategoryModel(
      titleEn: json['titleEn'] ?? '',
      titleAr: json['titleAr'] ?? '',
      id: json['id'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
