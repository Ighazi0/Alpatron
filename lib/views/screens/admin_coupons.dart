import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/coupon_model.dart';
import 'package:alnoor/views/screens/coupon_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ticket_widget/ticket_widget.dart';

class AdminCoupons extends StatefulWidget {
  const AdminCoupons({super.key});

  @override
  State<AdminCoupons> createState() => _AdminCouponsState();
}

class _AdminCouponsState extends State<AdminCoupons> {
  TextEditingController search = TextEditingController();
  Iterable<CouponModel> result = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Coupons', action: {
        'title': 'add',
        'function': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CouponDetails(coupon: CouponModel(code: 'New coupon')),
              ));
          setState(() {});
        }
      }),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore.collection('coupons').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CouponModel> data = snapshot.data!.docs
                  .map((e) => CouponModel.fromJson(e.data()))
                  .toList();
              result = data.where((a) =>
                  a.code.toLowerCase().contains(search.text.toLowerCase()));

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: result.isEmpty
                          ? Column(
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
                            )
                          : ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                CouponModel coupon = result.toList()[index];
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CouponDetails(
                                            coupon: coupon,
                                          ),
                                        ));
                                    setState(() {});
                                  },
                                  child: TicketWidget(
                                    width: Get.width,
                                    height: 150,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    color: appConstant.primaryColor,
                                    isCornerRounded: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          coupon.titleEn,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(BoxIcons.bxs_offer,
                                                color: Colors.white),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${coupon.discount}%',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              coupon.code,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: coupon.code));
                                              },
                                              icon: const Icon(Icons.copy,
                                                  size: 15,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
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
