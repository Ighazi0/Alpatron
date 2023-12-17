import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/views/screens/order_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
// ignore: depend_on_referenced_packages
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
        title: 'myOrders'.tr(context),
      ),
      body: RefreshIndicator(
        color: primaryColor,
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
                        'noOrders'.tr(context),
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
                  return Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListTile(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetails(order: order),
                            ));
                        setState(() {});
                      },
                      title: Text('${'orderNo'.tr(context)}. ${order.number}'),
                      subtitle: Text(
                          DateFormat('dd/MM/yyyy hh:mm a', locale.locale)
                              .format(order.timestamp!)),
                      trailing: Icon(
                        order.status == 'inProgress'
                            ? Icons.update
                            : order.status == 'cancel'
                                ? Iconsax.box_remove
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
      ),
    );
  }
}
