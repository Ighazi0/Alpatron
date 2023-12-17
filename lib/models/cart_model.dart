import 'package:alnoor/models/product_model.dart';

class CartModel {
  final ProductModel? productData;
  final int count;

  CartModel({this.productData, this.count = 0});

  factory CartModel.fromJson(ProductModel product, int c) {
    return CartModel(productData: product, count: c);
  }
}
