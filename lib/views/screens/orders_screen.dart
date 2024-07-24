import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/views/screens/order_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        action: const {},
        title: 'myOrders'.tr,
      ),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore
              .collection('orders')
              .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModel> data = snapshot.data!.docs
                  .map((e) => OrderModel.fromJson(e.data()))
                  .toList();

              if (data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty_pro.png'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'noOrders'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  OrderModel order = data[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetails(order: order),
                          ));
                      setState(() {});
                    },
                    child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${'orderNo'.tr}. ${order.number}'),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('${'Order status'}: ${order.status.tr}'),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(DateFormat('dd/MM/yyyy hh:mm a',
                                          Get.locale!.languageCode)
                                      .format(order.timestamp!))
                                ],
                              ),
                              if (!order.rated &&
                                  order.status == 'complete' &&
                                  firebaseAuth.currentUser!.uid !=
                                      appConstant.adminUid)
                                IconButton(
                                    onPressed: () async {
                                      await staticWidgets.showBottom(
                                          context,
                                          BottomSheetReview(
                                            id: order.timestamp!
                                                .millisecondsSinceEpoch
                                                .toString(),
                                          ),
                                          0.5,
                                          0.75);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ))
                            ],
                          ),
                        )),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
