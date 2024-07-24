import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/coupon_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          width: Get.width,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'AED'} ${(Get.find<UserController>().totalCartPrice() + 25).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              makeOrder
                  ? const CircularProgressIndicator()
                  : MaterialButton(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      onPressed: () async {
                        if (Get.find<AuthController>()
                            .userData
                            .address!
                            .isNotEmpty) {
                          // if (auth.userData.wallet!.isNotEmpty) {

                          // } else {
                          //   staticWidgets.showBottom(
                          //       context, const BottomSheetPayment(), 0.85, 0.9);
                          // }
                        } else {
                          Fluttertoast.showToast(msg: 'pleaseAddress');
                        }
                      },
                      height: 45,
                      minWidth: 100,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      color: appConstant.primaryColor,
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
              child: Get.find<AuthController>().userData.address!.isEmpty
                  ? TextButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, 'address');
                        setState(() {});
                      },
                      child: Text(
                        'addNew',
                        style: TextStyle(
                            fontSize: 12, color: appConstant.primaryColor),
                      ),
                    )
                  : ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          'Delivery to: ${Get.find<AuthController>().userData.address!.first.name}'),
                      subtitle: Text(Get.find<AuthController>()
                          .userData
                          .address!
                          .first
                          .address),
                      trailing: TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, 'address');
                          setState(() {});
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 12, color: appConstant.primaryColor),
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
