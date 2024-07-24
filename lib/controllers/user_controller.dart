import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/cart_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  int selectedIndex = 0;
  Map<String, CartModel> cartList = {};
  bool done = false;

  clearCart() {
    cartList.clear();
    update();
  }

  changeDone(x, {updating = true}) {
    done = x;
    if (updating) {
      update();
    }
  }

  double totalCartPrice() {
    double t = 0;
    cartList.values
        .map((e) => e.productData!.price * e.count)
        .forEach((element) {
      t = element + t;
    });
    return t;
  }

  int totalCartCount() {
    int c = 0;
    cartList.values.map((e) => e.count).forEach((element) {
      c = element + c;
    });
    return c;
  }

  removeFromCart(id) {
    cartList.remove(id);
    update();
  }

  addToCart(ProductModel p, int c) {
    if (cartList.containsKey(p.id)) {
      cartList.update(
          p.id,
          (value) => CartModel(
              productData: value.productData, count: value.count + c));
    } else {
      cartList.putIfAbsent(p.id, () => CartModel(productData: p, count: c));
    }

    update();
  }

  changeIndex(x) {
    selectedIndex = x;
    update();
  }

  favoriteStatus(ProductModel product) async {
    if (Get.find<AuthController>().userData.uid.isEmpty) {
      Get.offNamed('register');
      Fluttertoast.showToast(msg: 'Please sign in first');
    } else {
      await firestore.collection('products').doc(product.id).update({
        'favorites': product.favorites!.contains(firebaseAuth.currentUser!.uid)
            ? FieldValue.arrayRemove([firebaseAuth.currentUser!.uid])
            : FieldValue.arrayUnion([firebaseAuth.currentUser!.uid])
      });
    }
  }
}
