import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/user_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/payment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'paymentMethod'.tr,
        action: {
          'title': 'add',
          'function': () async {
            await staticWidgets.showBottom(
                context, const BottomSheetPayment(), 0.8, 0.9);
            setState(() {});
          }
        },
      ),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          await Get.find<AuthController>().getUserData();
          setState(() {});
        },
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Get.find<AuthController>().userData.wallet!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_data.png',
                          height: 150,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'noPayment'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        Get.find<AuthController>().userData.wallet!.length,
                    itemBuilder: (context, index) {
                      var e =
                          Get.find<AuthController>().userData.wallet![index];
                      return Column(
                        children: [
                          if (index == 0)
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                decoration: BoxDecoration(
                                    color: appConstant.primaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Text(
                                  'default'.tr,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                )),
                          Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              var d =
                                  Get.find<AuthController>().userData.wallet;
                              setState(() {
                                loading = true;
                              });
                              d!.removeAt(index);

                              await firestore
                                  .collection('users')
                                  .doc(firebaseAuth.currentUser!.uid)
                                  .update({
                                'wallet': d.map((e) => {
                                      'name': e.name,
                                      'number': e.number,
                                      'date': e.date
                                    })
                              });

                              await Get.find<AuthController>().getUserData();
                              setState(() {
                                loading = false;
                              });
                            },
                            background: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colors.red.shade200,
                              ),
                              child: const Icon(Icons.delete),
                            ),
                            child: Stack(
                              children: [
                                CreditCardWidget(
                                  padding: 10,
                                  height: 125,
                                  isSwipeGestureEnabled: false,
                                  isChipVisible: false,
                                  cardBgColor: appConstant.primaryColor,
                                  enableFloatingCard: true,
                                  cardNumber: e.number,
                                  expiryDate: e.date,
                                  cardHolderName: e.name,
                                  cvvCode: '',
                                  showBackView: false,
                                  obscureCardCvv: true,
                                  isHolderNameVisible: true,
                                  onCreditCardWidgetChange:
                                      (CreditCardBrand creditCardBrand) {},
                                ),
                                if (index != 0)
                                  Positioned(
                                    right: 15,
                                    top: 10,
                                    child: IconButton(
                                        onPressed: () async {
                                          var d = Get.find<AuthController>()
                                              .userData
                                              .wallet;
                                          setState(() {
                                            loading = true;
                                          });
                                          d!.removeAt(index);
                                          d.insert(
                                              0,
                                              WalletModel(
                                                name: e.name,
                                                date: e.date,
                                                number: e.number,
                                              ));

                                          await firestore
                                              .collection('users')
                                              .doc(
                                                  firebaseAuth.currentUser!.uid)
                                              .update({
                                            'wallet': d.map((e) => {
                                                  'name': e.name,
                                                  'number': e.number,
                                                  'date': e.date
                                                })
                                          });

                                          await Get.find<AuthController>()
                                              .getUserData();
                                          setState(() {
                                            loading = false;
                                          });
                                        },
                                        icon: const Icon(Icons.edit)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
      ),
    );
  }
}
