import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/cart_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  int selectedIndex = 0;
  Map<String, CartModel> cartList = {};

  clearCart() {
    cartList.clear();
    emit(UserLoaded());
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
    emit(UserLoaded());
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

    emit(UserLoaded());
  }

  changeIndex(x) {
    selectedIndex = x;
    emit(UserLoaded());
  }

  favoriteStatus(ProductModel product) async {
    if (auth.userData.uid.isEmpty) {
      navigatorKey.currentState?.pushReplacementNamed('register');
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
