// ignore_for_file: use_build_context_synchronously

import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/coupon_model.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/views/screens/order_details.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/payment_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  TextEditingController code = TextEditingController();

  ordering() async {
    var id = DateTime.now(), numbbers = 0;
    await firestore.collection('orders').get().then((value) {
      numbbers = value.size;
    });

    for (int i = 0; i < userCubit.cartList.entries.length; i++) {
      await firestore
          .collection('products')
          .doc(userCubit.cartList.entries.toList()[i].key)
          .update({
        'stock': FieldValue.increment(
            -userCubit.cartList.entries.toList()[i].value.count),
        'seller': FieldValue.increment(1)
      });
    }
    Fluttertoast.showToast(msg: 'orderPlaced'.tr(context));

    var data = {
      'number': numbbers + 1,
      'uid': firebaseAuth.currentUser!.uid,
      'total': userCubit.totalCartPrice(),
      'discount': couponData.discount,
      'delivery': 25,
      'rated': false,
      'status': 'inProgress',
      'name': auth.userData.name,
      'timestamp': id.toIso8601String(),
      'addressData': {
        'address': auth.userData.address!.first.address,
        'phone': auth.userData.address!.first.phone,
        'label': auth.userData.address!.first.label,
        'name': auth.userData.address!.first.name,
      },
      'walletData': {
        'number': CryptLib.instance.encryptPlainTextWithRandomIV(
            auth.userData.wallet!.first.number, "number"),
      },
      'orderList': userCubit.cartList.entries
          .map((e) => {
                'id': e.key,
                'titleEn': e.value.productData!.titleEn,
                'titleAr': e.value.productData!.titleAr,
                'price': e.value.productData!.price,
                'discount': e.value.productData!.discount,
                'media': [e.value.productData!.media!.first],
                'count': e.value.count,
              })
          .toList()
    };
    firestore
        .collection('orders')
        .doc(id.millisecondsSinceEpoch.toString())
        .set(data);
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
      builder: (context) => OrderDetails(order: OrderModel.fromJson(data)),
    ));
    userCubit.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          width: dWidth,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'AED'.tr(context)} ${(userCubit.totalCartPrice() + 25).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                onPressed: () async {
                  if (auth.userData.address!.isNotEmpty) {
                    if (auth.userData.wallet!.isNotEmpty) {
                      setState(() {
                        makeOrder = true;
                      });

                      await ordering();
                    } else {
                      staticWidgets.showBottom(
                          context, const BottomSheetPayment(), 0.85, 0.9);
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'pleaseAddress'.tr(context));
                  }
                },
                height: 45,
                minWidth: 100,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                color: primaryColor,
                child: const Text(
                  'Pay & order',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: const AppBarCustom(
        title: 'Place order',
        action: {},
      ),
      body: Column(
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: auth.userData.address!.isEmpty
                  ? TextButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, 'address');
                        setState(() {});
                      },
                      child: Text(
                        'addNew'.tr(context),
                        style: TextStyle(fontSize: 12, color: primaryColor),
                      ),
                    )
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          'Delivery to: ${auth.userData.address!.first.name}'),
                      subtitle: Text(auth.userData.address!.first.address),
                      trailing: TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, 'address');
                          setState(() {});
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(fontSize: 12, color: primaryColor),
                        ),
                      )),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: const Center(),
          ),
        ],
      ),
    );
  }
}
