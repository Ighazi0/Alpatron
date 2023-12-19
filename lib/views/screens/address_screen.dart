import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/user_model.dart';
import 'package:alnoor/views/screens/address_details.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'address'.tr(context),
        action: {
          'title': 'Add',
          'function': () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressDetails(
                    address: AddressModel(name: 'newAddress'.tr(context)),
                    index: 0,
                  ),
                ));
            setState(() {});
          }
        },
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await auth.getUserData();
          setState(() {});
        },
        child: auth.userData.address!.isEmpty
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
                      'noAddress'.tr(context),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount: auth.userData.address!.length,
                itemBuilder: (context, index) {
                  var e = auth.userData.address![index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressDetails(
                              address: e,
                              index: index,
                            ),
                          ));
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(e.label == 'home' ? Icons.home : Icons.work),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(e.name),
                              const SizedBox(
                                width: 10,
                              ),
                              if (index == 0)
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      'default'.tr(context),
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ))
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('address'.tr(context)),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  e.address,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('phone'.tr(context)),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  e.phone,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
