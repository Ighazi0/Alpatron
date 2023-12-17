import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/bottom_sheet_status.dart';
import 'package:alnoor/views/widgets/review_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderModel order = OrderModel();

  fetch() async {
    await firestore
        .collection('orders')
        .doc(order.timestamp!.millisecondsSinceEpoch.toString())
        .get()
        .then((value) {
      order = OrderModel.fromJson(value.data() as Map);
      setState(() {});
    });
  }

  @override
  void initState() {
    order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        action: order.status != 'complete' &&
                firebaseAuth.currentUser!.uid == staticData.adminUID
            ? {
                'title': 'update',
                'function': () async {
                  await staticWidgets.showBottom(
                      context, BottomSheetStatus(order: order), 0.4, 0.5);
                  fetch();
                }
              }
            : {},
        title: 'orderDetails'.tr(context),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'subtotal'.tr(context)}:'),
                    Text(
                      '${'AED'.tr(context)} ${order.total.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'deliveryFee'.tr(context)}:'),
                    Text(
                      '${'AED'.tr(context)} ${order.delivery}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'discount'.tr(context)}:'),
                    Text('- ${'AED'.tr(context)} ${order.discount}',
                        style: const TextStyle()),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'total'.tr(context)}:'),
                    Text(
                      '${'AED'.tr(context)} ${(order.total - (order.total * (order.discount / 100)) + order.delivery).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ],
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
        ),
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            fetch();
          },
          child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'orderNumber'.tr(context),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  order.number.toString(),
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'name'.tr(context),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  order.name,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'shipping'.tr(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(order.addressData!.address),
            const SizedBox(
              height: 5,
            ),
            Text(order.addressData!.phone),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              order.status.tr(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              DateFormat('EE, dd/MM/yyyy hh:mm a', locale.locale)
                  .format(order.timestamp!),
            ),
            const Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 100,
              width: dWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: order.orderList!.length,
                itemBuilder: (context, index) {
                  ProductModel orderList = order.orderList![index];
                  return SizedBox(
                    width: 275,
                    child: ListTile(
                      onTap: () async {
                        await firestore
                            .collection('products')
                            .doc(orderList.id)
                            .get()
                            .then((value) {
                          if (value.exists) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      product: ProductModel.fromJson(
                                          value.data() as Map)),
                                ));
                          }
                        });
                      },
                      leading: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: orderList.media![0],
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        locale.locale == 'ar'
                            ? orderList.titleAr
                            : orderList.titleEn,
                        overflow: TextOverflow.ellipsis,
                      ),
                      visualDensity: const VisualDensity(vertical: 4),
                      subtitle: Text(
                        '${'AED'.tr(context)} ${orderList.price}  x${orderList.count}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!order.rated &&
                order.status == 'complete' &&
                firebaseAuth.currentUser!.uid != staticData.adminUID)
              MaterialButton(
                onPressed: () async {
                  await staticWidgets.showBottom(
                      context,
                      BottomSheetReview(
                        id: order.timestamp!.millisecondsSinceEpoch.toString(),
                      ),
                      0.5,
                      0.75);
                  fetch();
                },
                color: primaryColor,
                height: 45,
                textColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Text('reviewOrder'.tr(context)),
              )
          ]),
        ),
      ),
    );
  }
}
