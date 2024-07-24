import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/views/screens/order_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  String filterx = '';
  TextEditingController controller = TextEditingController();

  filter(x) {
    setState(() {
      filterx = x;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'orders',
        action: {
          'title': 'filter',
          'function': () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Options'),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          filter('');
                        },
                        child: Text(
                          'All',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter('inProgress');
                        },
                        child: Text(
                          'inProgress'.tr,
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter('inDelivery');
                        },
                        child: Text(
                          'inDelivery'.tr,
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter('complete');
                        },
                        child: Text(
                          'complete'.tr,
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter('cancel');
                        },
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      body: RefreshIndicator(
          color: appConstant.primaryColor,
          onRefresh: () async {
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  controller: controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Expanded(
                  child: FutureBuilder(
                    future: filterx.isEmpty
                        ? firestore.collection('orders').get()
                        : firestore
                            .collection('orders')
                            .where('status', isEqualTo: filterx)
                            .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<OrderModel> data = snapshot.data!.docs
                            .map((e) => OrderModel.fromJson(e.data()))
                            .toList();

                        Iterable<OrderModel> result = data.where((element) =>
                            element.name
                                .toLowerCase()
                                .contains(controller.text.toLowerCase()) ||
                            element.number
                                .toString()
                                .toLowerCase()
                                .contains(controller.text.toLowerCase()));

                        if (result.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty_data.png',
                                height: 150,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('No data found')
                            ],
                          );
                        }
                        return ListView.builder(
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            OrderModel order = data[index];
                            return Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: ListTile(
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetails(order: order),
                                      ));
                                  setState(() {});
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('${'orderNo'.tr}. ${order.number}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('${'name'.tr}: ${order.name}'),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm a',
                                        Get.locale!.languageCode)
                                    .format(order.timestamp!)),
                                trailing: Icon(
                                  order.status == 'inProgress'
                                      ? Icons.update
                                      : order.status == 'cancel'
                                          ? Iconsax.box_remove_bold
                                          : order.status == 'inDelivery'
                                              ? Icons.delivery_dining_sharp
                                              : Bootstrap.box2_fill,
                                  color: order.status == 'inProgress'
                                      ? null
                                      : order.status == 'cancel'
                                          ? Colors.red
                                          : order.status == 'inDelivery'
                                              ? Colors.blue
                                              : Colors.green,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
