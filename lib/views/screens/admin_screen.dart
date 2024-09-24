import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/order_model.dart';
import 'package:alnoor/views/widgets/admin_drawer.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(child: AdminDrawer()),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ));
          }),
          title: const Text(
            'Admin',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: RefreshIndicator(
            color: appConstant.primaryColor,
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              children: [
                StreamBuilder(
                    stream: firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Card(
                            child: ListTile(
                          title: Text(
                            'Total Users: ${snapshot.data!.size}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ));
                      }
                      return const Shimmers(
                        child: Card(
                            child: ListTile(
                          title: Text(
                            'Total Users:',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: firestore.collection('reviews').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Card(
                            child: ListTile(
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.pushNamed(context, 'adminReviews');
                          },
                          title: Text(
                            'Total reviews: ${snapshot.data!.size}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ));
                      }
                      return const Shimmers(
                        child: Card(
                            child: ListTile(
                          title: Text(
                            'Total reviews:',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: firestore.collection('orders').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<OrderModel> orders = snapshot.data!.docs
                            .map((e) => OrderModel.fromJson(e.data()))
                            .toList();
                        return Column(
                          children: [
                            Card(
                                child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, 'adminOrders');
                              },
                              title: Text(
                                'Total orders: ${orders.length}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                                child: ListTile(
                              title: Text(
                                'Total amount: ${orders.map((e) => e.total - e.discount).join()}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            )),
                          ],
                        );
                      }
                      return const Shimmers(
                        child: Card(
                            child: ListTile(
                          title: Text(
                            'Total orders:',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                      );
                    }),
                GetBuilder(
                  init: AuthController(),
                  builder: (auth) {
                    return Column(
                      children: [
                        SwitchListTile(
                          value: auth.appData!.orders,
                          onChanged: (e) {
                            auth.changeOrders();
                          },
                          title: const Text('Accept orders?'),
                        ),
                        Column(
                            children: auth.appData!.paymobs!
                                .map(
                                  (m) => SwitchListTile(
                                    value: auth.appData!.paymobs!
                                        .firstWhere((w) => w.id == m.id)
                                        .status,
                                    onChanged: (e) {
                                      auth.changePaymobs(m.id);
                                    },
                                    title: Text(m.name),
                                  ),
                                )
                                .toList()),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
