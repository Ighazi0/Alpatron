class CouponModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionEn;
  final String descriptionAr;
  final String code;
  final double discount;
  final double max;
  final DateTime? timestamp;
  final DateTime? endTime;
  final String link;

  CouponModel(
      {this.id = '',
      this.descriptionEn = '',
      this.descriptionAr = '',
      this.titleAr = '',
      this.titleEn = '',
      this.code = '',
      this.timestamp,
      this.endTime,
      this.discount = 0.0,
      this.max = 0.0,
      this.link = ''});

  factory CouponModel.fromJson(Map json) {
    return CouponModel(
        descriptionEn: json['descriptionEn'] ?? '',
        descriptionAr: json['descriptionAr'] ?? '',
        titleAr: json['titleAr'] ?? '',
        titleEn: json['titleEn'] ?? '',
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        timestamp: DateTime.parse(
            json['timestamp'] ?? DateTime.now().toIso8601String()),
        endTime:
            DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
        link: json['link'] ?? '',
        max: double.parse(json['max']),
        discount: double.parse(json['discount']));
  }
}
