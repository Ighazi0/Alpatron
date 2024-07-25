import 'dart:convert';

import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/cart_model.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/views/screens/order_details.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:http/http.dart' as http;
import 'package:alnoor/views/widgets/counter.dart';
import 'package:alnoor/views/widgets/remove_cart.dart';
import 'package:alnoor/views/widgets/web_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool makeOrder = false;
  ordering() async {
    var id = DateTime.now(), numbbers = 0;
    await firestore.collection('orders').get().then((value) {
      numbbers = value.size;
    });

    for (int i = 0;
        i < Get.find<UserController>().cartList.entries.length;
        i++) {
      await firestore
          .collection('products')
          .doc(Get.find<UserController>().cartList.entries.toList()[i].key)
          .update({
        'stock': FieldValue.increment(-Get.find<UserController>()
            .cartList
            .entries
            .toList()[i]
            .value
            .count),
        'seller': FieldValue.increment(1)
      });
    }

    var data = {
      'number': numbbers + 1,
      'uid': firebaseAuth.currentUser!.uid,
      'total': Get.find<UserController>().totalCartPrice(),
      'discount': 0,
      'delivery': 25,
      'rated': false,
      'status': 'inProgress',
      'name': Get.find<AuthController>().userData.name,
      'timestamp': id.toIso8601String(),
      'orderList': Get.find<UserController>()
          .cartList
          .entries
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
    Fluttertoast.showToast(msg: 'orderPlaced'.tr);
    Get.to(() => OrderDetails(order: OrderModel.fromJson(data)));
    firestore
        .collection('orders')
        .doc(id.millisecondsSinceEpoch.toString())
        .set(data);
    Get.find<UserController>().changeDone(false);
    Get.find<UserController>().clearCart();
  }

  makePayment() async {
    var response = await http.post(
        Uri.parse(
            'https://api-gateway.ngenius-payments.com/identity/auth/access-token'),
        headers: {
          'Content-Type': 'application/vnd.ni-identity.v1+json',
          'Authorization':
              'Basic Yzc5MGM0YjUtYTA0NC00ZmU5LWE4ODItYmVhZWY0MDdjOGY1OmFlZjNkNWYzLTAxZjEtNGY4Zi04Mjk1LWRlMTAwN2MyODAyYQ==',
        });

    if (response.statusCode == 200) {
      String token = json.decode(response.body)['access_token'];

      var response2 = await http.post(
          Uri.parse(
              'https://api-gateway.ngenius-payments.com/transactions/outlets/639a438c-1232-4674-a01f-d95d0c331116/orders'),
          body: json.encode({
            "action": "PURCHASE",
            "amount": {
              "currencyCode": "AED",
              "value":
                  (Get.find<UserController>().totalCartPrice() * 100).toInt()
            },
            "emailAddress": Get.find<AuthController>().userData.email,
          }),
          headers: {
            'Content-Type': 'application/vnd.ni-payment.v2+json',
            'Authorization': 'Bearer $token'
          });

      if (response2.statusCode == 200 || response2.statusCode == 201) {
        var data = jsonDecode(response2.body)['_links']['payment'];
        await Get.to(() => WebViewer(url: data['href'].toString()));
        if (Get.find<UserController>().done) {
          await ordering();
        } else {
          Fluttertoast.showToast(msg: 'paymentFailed'.tr);
        }
      } else {
        Fluttertoast.showToast(msg: 'paymentFailed'.tr);
      }
    } else {
      Fluttertoast.showToast(msg: 'paymentFailed'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            bottomNavigationBar: userCubit.cartList.isEmpty
                ? null
                : SafeArea(
                    child: Container(
                      width: Get.width,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 60,
                      child: makeOrder
                          ? const Align(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${'AED'.tr} ${(userCubit.totalCartPrice()).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  onPressed: () async {
                                    if (Get.find<AuthController>()
                                        .userData
                                        .uid
                                        .isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'pleaseFirst'.tr);
                                      Get.find<AuthController>().logOut();
                                    } else {
                                      setState(() {
                                        makeOrder = true;
                                      });

                                      await makePayment();
                                      setState(() {
                                        makeOrder = false;
                                      });
                                    }
                                  },
                                  height: 45,
                                  minWidth: 100,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  color: appConstant.primaryColor,
                                  child: const Text(
                                    'Proced to pay',
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
            body: Center(
              child: userCubit.cartList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_cart.png',
                          height: 150,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'emptyCart'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              itemCount: userCubit.cartList.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    height: 0,
                                  ),
                              itemBuilder: (context, index) {
                                CartModel cart =
                                    userCubit.cartList.values.toList()[index];
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    product: cart.productData!),
                                          ));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: cart.productData!.media![0],
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            Get.locale!.languageCode == 'ar'
                                                ? cart.productData!.titleAr
                                                : cart.productData!.titleEn,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              staticWidgets.showBottom(
                                                  context,
                                                  BottomSheetRemoveCart(
                                                    index: index,
                                                  ),
                                                  0.4,
                                                  0.5);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                    visualDensity:
                                        const VisualDensity(vertical: 4),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${'AED'.tr} ${cart.productData!.price}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Counter(
                                          remove: () {
                                            userCubit.addToCart(
                                                cart.productData!, -1);
                                          },
                                          add: () {
                                            userCubit.addToCart(
                                                cart.productData!, 1);
                                          },
                                          other: () {
                                            staticWidgets.showBottom(
                                                context,
                                                BottomSheetRemoveCart(
                                                  index: index,
                                                ),
                                                0.4,
                                                0.5);
                                          },
                                          count: cart.count,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          width: Get.width,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.5,
                                  blurRadius: 0.5,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price details:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Products (${userCubit.totalCartCount()} ${'items'.tr})'),
                                  Text(
                                      '${'AED'.tr} ${userCubit.totalCartPrice().toStringAsFixed(2)}'),
                                ],
                              ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     const Text('Delivery charges'),
                              //     Text('${'AED'.tr} 25'),
                              //   ],
                              // ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total amount'),
                                  Text(
                                      '${'AED'.tr} ${(userCubit.totalCartPrice()).toStringAsFixed(2)}'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
            ));
      },
    );
  }
}
