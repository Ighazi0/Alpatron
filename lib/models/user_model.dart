import 'package:cryptlib_2_0/cryptlib_2_0.dart';

class UserModel {
  final String name;
  final String pic;
  final String uid;
  final String email;
  final String phone;
  final String gender;
  final String token;
  final DateTime? birth;
  final DateTime? timestamp;
  final String link;
  final List<WalletModel>? wallet;
  final List<AddressModel>? address;
  bool verified;
  bool blocked;
  double coins;

  UserModel(
      {this.name = '',
      this.pic = '',
      this.uid = '',
      this.email = '',
      this.phone = '',
      this.birth,
      this.gender = '',
      this.token = '',
      this.timestamp,
      this.coins = 0.0,
      this.link = '',
      this.wallet,
      this.address,
      this.blocked = false,
      this.verified = false});

  factory UserModel.fromJson(Map json) {
    List a = json['address'];
    List w = json['wallet'];
    return UserModel(
      name: json['name'] ?? '',
      pic: json['pic'] ?? '',
      token: json['token'] ?? '',
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      birth: json['birth'].toDate() ?? DateTime.now(),
      timestamp: json['timestamp'].toDate() ?? DateTime.now(),
      verified: json['verified'] ?? false,
      blocked: json['blocked'] ?? false,
      coins: double.parse(json['coins'].toString()),
      link: json['link'] ?? '',
      wallet: w.map((e) => WalletModel.fromJson(e as Map)).toList(),
      address: a.map((e) => AddressModel.fromJson(e as Map)).toList(),
    );
  }
}

class AddressModel {
  final String name;
  final String label;
  final String address;
  final String phone;

  AddressModel({
    this.name = '',
    this.label = '',
    this.address = '',
    this.phone = '',
  });
  factory AddressModel.fromJson(Map json) {
    return AddressModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      label: json['label'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class WalletModel {
  final String name;
  final String number;
  final String date;
  final String cvv;

  WalletModel({
    this.name = '',
    this.number = '',
    this.date = '',
    this.cvv = '',
  });
  factory WalletModel.fromJson(Map json) {
    return WalletModel(
      date: json['date'] == null
          ? ''
          : CryptLib.instance
              .decryptCipherTextWithRandomIV(json['date'], "date"),
      name: json['name'] ?? '',
      number: CryptLib.instance
          .decryptCipherTextWithRandomIV(json['number'] ?? '', "number"),
      cvv: json['cvv'] == null
          ? ''
          : CryptLib.instance.decryptCipherTextWithRandomIV(json['cvv'], "cvv"),
    );
  }
}
