import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/models/cart_model.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:alnoor/views/widgets/counter.dart';
import 'package:alnoor/views/widgets/remove_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            bottomNavigationBar: userCubit.cartList.isEmpty
                ? null
                : SafeArea(
                    child: Container(
                      width: dWidth,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'AED'.tr(context)} ${(userCubit.totalCartPrice() + 25).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          MaterialButton(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            onPressed: () {
                              if (auth.userData.uid.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'pleaseFirst'.tr(context));
                                auth.logOut();
                              } else {
                                Navigator.pushNamed(context, 'checkout');
                              }
                            },
                            height: 45,
                            minWidth: 100,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            color: primaryColor,
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
                          'emptyCart'.tr(context),
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
                                            locale.locale == 'ar'
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
                                          '${'AED'.tr(context)} ${cart.productData!.price}',
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
                          width: dWidth,
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
                                      'Products (${userCubit.totalCartCount()} ${'items'.tr(context)})'),
                                  Text(
                                      '${'AED'.tr(context)} ${userCubit.totalCartPrice().toStringAsFixed(2)}'),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Delivery charges'),
                                  Text('${'AED'.tr(context)} 25'),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total amount'),
                                  Text(
                                      '${'AED'.tr(context)} ${(userCubit.totalCartPrice() + 25).toStringAsFixed(2)}'),
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
