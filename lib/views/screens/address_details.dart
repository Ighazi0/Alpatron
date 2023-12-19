// ignore_for_file: use_build_context_synchronously
import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/user_model.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  submit(delete) async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    if (delete) {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'address': FieldValue.arrayRemove([
          {
            'name': widget.address.name,
            'phone': widget.address.phone,
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
                phone: phone.text));

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
              'phone': phone.text,
            }
          ])
        });
      }
    }
    await auth.getUserData();
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.address.label.isNotEmpty) {
      label = widget.address.label;
      address.text = widget.address.address;
      phone.text = widget.address.phone;
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
                    return 'pleaseAddressName'.tr(context);
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
                    return 'pleaseYourAddress'.tr(context);
                  }
                  return null;
                },
                hint: '',
                title: 'Address'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                number: true,
                controller: phone,
                validator: (p) {
                  if (p!.isEmpty) {
                    return 'pleasephone'.tr(context);
                  }
                  return null;
                },
                hint: '009',
                title: 'Phone'),
            const SizedBox(
              height: 20,
            ),
            Text('label'.tr(context)),
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
                      'homes'.tr(context),
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
                    label: Text('work'.tr(context)),
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
                          var e = auth.userData.address;

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
                          await auth.getUserData();

                          Navigator.pop(context);
                        },
                        child: Text(
                          'makeDefualt'.tr(context),
                          style: const TextStyle(color: Colors.black),
                        )),
                  TextButton(
                      onPressed: () {
                        submit(true);
                      },
                      child: Text(
                        'deleteAddress'.tr(context),
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
