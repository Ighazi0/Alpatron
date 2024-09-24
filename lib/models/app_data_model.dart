class AppDataModel {
  String android, ios;
  bool server, orders;
  List<Paymob>? paymobs;

  AppDataModel(
      {this.android = '',
      this.ios = '',
      this.server = true,
      this.orders = true,
      this.paymobs});

  factory AppDataModel.fromJson(Map json) {
    List p = json['paymobs'] ?? [];
    return AppDataModel(
        android: json['android'] ?? '',
        ios: json['ios'] ?? '',
        server: json['server'] ?? true,
        orders: json['orders'] ?? true,
        paymobs: p.map((e) => Paymob.fromJson(e)).toList());
  }
}

class Paymob {
  String id;
  String username;
  String password;
  String name;
  bool status;

  Paymob(
      {this.id = '',
      this.username = '',
      this.name = '',
      this.status = true,
      this.password = ''});

  factory Paymob.fromJson(Map json) {
    return Paymob(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        password: json['password'] ?? '',
        username: json['username'] ?? '',
        status: json['status'] ?? false);
  }
}
