import 'dart:convert';

import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/app_data_model.dart';
import 'package:alnoor/models/cart_model.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/models/payment_model.dart';
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
  Paymob? paymob;
  bool makeOrder = false, loading = false;
  TextEditingController code = TextEditingController();
  var auth = Get.find<AuthController>(),
      userController = Get.find<UserController>();

  ordering() async {
    var id = DateTime.now(), numbers = 0, done = false;

    QuerySnapshot querySnapshot = await firestore
        .collection('orders')
        .orderBy('number', descending: true)
        .limit(1)
        .get();

    numbers = querySnapshot.docs.first.get('number') + 1;

    await makePayment();

    numbers = querySnapshot.docs.first.get('number') + 1;

    done = userController.done;

    if (done) {
      for (int i = 0; i < userController.cartList.entries.length; i++) {
        await firestore
            .collection('products')
            .doc(userController.cartList.entries.toList()[i].key)
            .update({
          'stock': FieldValue.increment(
              -userController.cartList.entries.toList()[i].value.count),
          'seller': FieldValue.increment(1)
        });
      }

      var data = {
        'number': numbers,
        'uid': firebaseAuth.currentUser!.uid,
        'total': userController.totalCartPrice(),
        'discount': 0,
        'delivery': 25,
        'rated': false,
        'status': 'inProgress',
        'name': Get.find<AuthController>().userData.name,
        'timestamp': id.toIso8601String(),
        'orderList': userController.cartList.entries
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
      userController.changeDone(false);
      userController.clearCart();
    } else {
      Fluttertoast.showToast(msg: 'Payment failed');
      setState(() {
        makeOrder = false;
      });
    }
  }

  makePayment() async {
    try {
      var response = await http.post(
          Uri.parse('https://uae.paymob.com/api/auth/tokens'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {"username": paymob?.username, "password": paymob?.password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = PaymentModel.fromMap(jsonDecode(response.body));
        try {
          var request = await http.post(
              Uri.parse('https://uae.paymob.com/api/ecommerce/payment-links'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${data.token}',
              },
              body: {
                'amount_cents':
                    (Get.find<UserController>().totalCartPrice() * 100)
                        .toStringAsFixed(2),
                'full_name': auth.userData.name,
                'email': auth.userData.email,
                'phone_number': auth.userData.address!.first.phone,
                'payment_methods': paymob!.id,
                'payment_link_image': '',
                'save_selection': 'false',
                'is_live': 'true'
              });

          if (request.statusCode == 200 || request.statusCode == 201) {
            var data2 = PaymentLink.fromJson(jsonDecode(request.body));
            await Get.to(
              () => WebViewer(
                url: data2.clientUrl,
              ),
            );
          } else {
            Get.log(request.body);
          }
        } catch (e) {
          Get.log(e.toString());
        }
      } else {
        Get.log(response.body);
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  @override
  void initState() {
    paymob = auth.appData!.paymobs!
        .firstWhere((w) => w.status, orElse: () => Paymob());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            bottomNavigationBar: userCubit.cartList.isEmpty ||
                    !auth.appData!.orders
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
                                    if (paymob!.id.isNotEmpty) {
                                      if (auth.userData.address!.isNotEmpty) {
                                        setState(() {
                                          makeOrder = true;
                                        });

                                        await ordering();

                                        setState(() {
                                          makeOrder = false;
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Please pick your address'.tr);
                                      }
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
                          margin: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Payment methods'.tr,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (paymob!.id.isNotEmpty)
                          Column(
                            children: auth.appData!.paymobs!
                                .where((w) => w.status)
                                .map((m) => RadioListTile(
                                      activeColor: appConstant.primaryColor,
                                      contentPadding: EdgeInsets.zero,
                                      value: m,
                                      onChanged: (value) {
                                        setState(() {
                                          paymob = m;
                                        });
                                      },
                                      groupValue: paymob,
                                      title: Text(m.name),
                                    ))
                                .toList(),
                          ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        auth.userData.address!.isEmpty
                            ? MaterialButton(
                                minWidth: 0,
                                height: 25,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                onPressed: () async {
                                  await Navigator.pushNamed(context, 'address');
                                  setState(() {});
                                },
                                color: appConstant.primaryColor,
                                shape: const RoundedRectangleBorder(
                                    side: BorderSide(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  'addNew'.tr,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              )
                            : ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: appConstant.primaryColor,
                                ),
                                title: Text(auth.userData.address!.first.name),
                                subtitle:
                                    Text(auth.userData.address!.first.address),
                                trailing: MaterialButton(
                                  minWidth: 0,
                                  height: 25,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, 'address');
                                    setState(() {});
                                  },
                                  color: appConstant.primaryColor,
                                  child: Text(
                                    'change'.tr,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        // Container(
                        //   width: Get.width,
                        //   margin: const EdgeInsets.all(10),
                        //   padding: const EdgeInsets.all(10),
                        //   decoration: BoxDecoration(
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.5),
                        //           spreadRadius: 0.5,
                        //           blurRadius: 0.5,
                        //         ),
                        //       ],
                        //       color: Colors.white,
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(10))),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Text(
                        //         'Price details:',
                        //         style: TextStyle(
                        //             fontSize: 16, fontWeight: FontWeight.bold),
                        //       ),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //               'Products (${userCubit.totalCartCount()} ${'items'.tr})'),
                        //           Text(
                        //               '${'AED'.tr} ${userCubit.totalCartPrice().toStringAsFixed(2)}'),
                        //         ],
                        //       ),
                        //       const Divider(),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           const Text('Total amount'),
                        //           Text(
                        //               '${'AED'.tr} ${(userCubit.totalCartPrice()).toStringAsFixed(2)}'),
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
            ));
      },
    );
  }
}
