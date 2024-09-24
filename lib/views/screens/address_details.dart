import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/user_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({super.key, required this.address, required this.index});
  final AddressModel address;
  final int index;
  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  String label = 'home';
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController name = TextEditingController(),
      phone = TextEditingController(),
      address = TextEditingController();
  var auth = Get.find<AuthController>();

  submit(delete) async {
    if (!delete) {
      if (!key.currentState!.validate()) {
        return;
      }
    }
    setState(() {
      loading = true;
    });
    String phonex = '+971${phone.text}';
    if (delete) {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'address': FieldValue.arrayRemove([
          {
            'name': widget.address.name,
            'phone': phonex,
            'address': widget.address.address,
            'label': widget.address.label
          }
        ])
      });
    } else {
      var e = auth.userData.address;
      if (widget.address.label.isNotEmpty) {
        e!.removeAt(widget.index);
        e.insert(
            widget.index,
            AddressModel(
                name: name.text,
                address: address.text,
                label: label,
                phone: phonex));

        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'address': e.map((e) => {
                'name': e.name,
                'address': e.address,
                'label': e.label,
                'phone': e.phone,
              })
        });
      } else {
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'address': FieldValue.arrayUnion([
            {
              'name': name.text,
              'address': address.text,
              'label': label,
              'phone': phonex
            }
          ])
        });
      }
    }
    await auth.getUserData();
    setState(() {
      loading = false;
    });
    Get.back();
  }

  @override
  void initState() {
    if (widget.address.label.isNotEmpty) {
      label = widget.address.label;
      address.text = widget.address.address;
      phone.text = widget.address.phone.replaceFirst('+971', '');
      name.text = widget.address.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
          title: widget.address.name,
          action: {
            'title': widget.address.label.isEmpty ? 'Add' : 'Update',
            'function': () {
              submit(false);
            },
          },
          loading: loading),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: key,
          child: Column(children: [
            EditText(
                function: () {},
                controller: name,
                validator: (p) {
                  if (p!.isEmpty) {
                    return 'pleaseAddressName'.tr;
                  }
                  return null;
                },
                hint: 'My home',
                title: 'Address name'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                controller: address,
                validator: (p) {
                  if (p!.isEmpty) {
                    return 'pleaseYourAddress'.tr;
                  }
                  return null;
                },
                hint: '',
                title: 'Address'),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('+971'),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: EditText(
                      function: () {},
                      number: true,
                      controller: phone,
                      validator: (p) {
                        if (p!.length < 9) {
                          return 'pleasephone'.tr;
                        }
                        return null;
                      },
                      length: 9,
                      hint: '123456789',
                      title: 'phone'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text('label'.tr),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      label = 'home';
                    });
                  },
                  child: Chip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    side: const BorderSide(color: Colors.grey),
                    label: Text(
                      'homes'.tr,
                    ),
                    backgroundColor:
                        label == 'home' ? Colors.red.shade100 : Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      label = 'work';
                    });
                  },
                  child: Chip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    side: const BorderSide(color: Colors.grey),
                    label: Text('work'.tr),
                    backgroundColor:
                        label == 'work' ? Colors.red.shade100 : Colors.white,
                  ),
                ),
              ],
            ),
            if (widget.address.label.isNotEmpty && !loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.index != 0)
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          var e = Get.find<AuthController>().userData.address;

                          e!.removeAt(widget.index);
                          e.insert(
                              0,
                              AddressModel(
                                  name: widget.address.name,
                                  address: widget.address.address,
                                  label: widget.address.label,
                                  phone: widget.address.phone));

                          await firestore
                              .collection('users')
                              .doc(firebaseAuth.currentUser!.uid)
                              .update({
                            'address': e.map((e) => {
                                  'name': e.name,
                                  'address': e.address,
                                  'label': e.label,
                                  'phone': e.phone,
                                })
                          });
                          await Get.find<AuthController>().getUserData();

                          Get.back();
                        },
                        child: Text(
                          'makeDefualt'.tr,
                          style: const TextStyle(color: Colors.black),
                        )),
                  TextButton(
                      onPressed: () {
                        submit(true);
                      },
                      child: Text(
                        'deleteAddress'.tr,
                        style: const TextStyle(color: Colors.red),
                      )),
                ],
              ),
          ]),
        ),
      ),
    );
  }
}
