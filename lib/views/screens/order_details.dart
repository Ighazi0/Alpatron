import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/bottom_sheet_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                firebaseAuth.currentUser!.uid == appConstant.adminUid
            ? {
                'title': 'update',
                'function': () async {
                  await staticWidgets.showBottom(
                      context, BottomSheetStatus(order: order), 0.4, 0.5);
                  fetch();
                }
              }
            : {},
        title: '',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            color: appConstant.primaryColor,
            onRefresh: () async {
              fetch();
            },
            child: ListView(children: [
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
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order id:' ' ${order.number.toString()}',
                        style: const TextStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Order date:'
                        ' ${DateFormat(
                          'dd/MM/yyyy',
                        ).format(order.timestamp!)}',
                        style: const TextStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Order details:'
                        ' ${order.orderList!.length} items',
                        style: const TextStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Order status:'
                        ' ${order.status.tr}s',
                        style: const TextStyle(),
                      ),
                    ]),
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
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'name'.tr}:' ' ${order.name}',
                        style: const TextStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   'Deliver to:'
                      //   ' ${order.addressData!.address}',
                      //   style: const TextStyle(),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // Text(order.addressData!.phone),
                    ]),
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
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${'total'.tr}: '
                          '${'AED'.tr} ${(order.total + order.delivery).toStringAsFixed(2)}'),
                    ]),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                            Get.to(() => ProductDetails(
                                product: ProductModel.fromJson(
                                    value.data() as Map)));
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
                        Get.locale!.languageCode == 'ar'
                            ? orderList.titleAr
                            : orderList.titleEn,
                        overflow: TextOverflow.ellipsis,
                      ),
                      visualDensity: const VisualDensity(vertical: 4),
                      subtitle: Text(
                        '${'AED'.tr} ${orderList.price}  x${orderList.count}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
