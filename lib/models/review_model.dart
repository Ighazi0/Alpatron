class ReviewModel {
  final String id;
  final String name;
  final String uid;
  final String message;
  final String orderId;
  final DateTime? timestamp;
  final double rate;

  ReviewModel({
    this.id = '',
    this.name = '',
    this.message = '',
    this.orderId = '',
    this.rate = 0.0,
    this.timestamp,
    this.uid = '',
  });

  factory ReviewModel.fromJson(Map data) {
    return ReviewModel(
      id: data['id'],
      name: data['name'],
      message: data['message'],
      orderId: data['orderId'],
      rate: double.parse(data['rate'].toString()),
      uid: data['uid'] ?? '',
      timestamp:
          DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
