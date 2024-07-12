// ignore_for_file: use_build_context_synchronously
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/coupon_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:alnoor/views/widgets/pick_date.dart';
import 'package:flutter/material.dart';

class CouponDetails extends StatefulWidget {
  const CouponDetails({super.key, required this.coupon});
  final CouponModel coupon;

  @override
  State<CouponDetails> createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController titleEn = TextEditingController(),
      titleAr = TextEditingController(),
      descriptionAr = TextEditingController(),
      descriptionEn = TextEditingController(),
      max = TextEditingController(),
      code = TextEditingController(),
      discount = TextEditingController();
  DateTime endDate = DateTime.now();

  update() async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    var id = DateTime.now().millisecondsSinceEpoch.toString();

    if (widget.coupon.id.isEmpty) {
      await firestore.collection('coupons').doc(id).set({
        'id': id,
        'timestamp': DateTime.now().toIso8601String(),
        'titleAr': titleAr.text,
        'titleEn': titleEn.text,
        'descriptionAr': descriptionAr.text,
        'descriptionEn': descriptionEn.text,
        'code': code.text,
        'endTime': endDate.toIso8601String(),
        'discount': discount.text,
        'max': max.text,
      });
    } else {
      await firestore.collection('coupons').doc(widget.coupon.id).update({
        'titleAr': titleAr.text,
        'titleEn': titleEn.text,
        'descriptionAr': descriptionAr.text,
        'descriptionEn': descriptionEn.text,
        'code': code.text,
        'endTime': endDate.toIso8601String(),
        'discount': discount.text,
        'max': max.text,
      });
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.coupon.id.isNotEmpty) {
      titleAr.text = widget.coupon.titleAr;
      titleEn.text = widget.coupon.titleEn;
      descriptionAr.text = widget.coupon.descriptionAr;
      descriptionEn.text = widget.coupon.descriptionEn;
      code.text = widget.coupon.code;
      max.text = widget.coupon.max.toString();
      discount.text = widget.coupon.discount.toString();
      endDate = widget.coupon.endTime!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.coupon.code,
        action: {
          'function': update,
          'title': widget.coupon.id.isEmpty ? 'add' : 'update'
        },
        loading: loading,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: key,
          child: ListView(children: [
            EditText(
                function: () {},
                controller: titleEn,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter coupon title in English';
                  }
                  return null;
                },
                hint: 'New year discount',
                title: 'titleEn'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                controller: titleAr,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter coupon title in Arabic';
                  }
                  return null;
                },
                hint: 'خصم بمناسبة السنة الجديدة',
                title: 'titleAr'),
            const SizedBox(
              height: 10,
            ),
            PickDate(
              function: (c) {
                setState(() {
                  endDate = c;
                });
              },
              date: endDate,
            ),
            const SizedBox(
              height: 10,
            ),
            EditText(
                function: () {},
                controller: discount,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter coupon discount percent';
                  }
                  return null;
                },
                hint: '50',
                title: 'discountP'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                controller: max,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter max dicount';
                  }
                  return null;
                },
                hint: '100',
                title: 'max'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                controller: code,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter coupon code';
                  }
                  return null;
                },
                hint: 'NEWYEAR',
                title: 'code'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                controller: descriptionEn,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter coupon description in English';
                  }
                  return null;
                },
                hint: '',
                title: 'descriptionEn'),
            const SizedBox(
              height: 20,
            ),
            EditText(
                function: () {},
                controller: descriptionAr,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Please enter coupon description in Arabic';
                  }
                  return null;
                },
                hint: '',
                title: 'descriptionAr'),
            if (widget.coupon.id.isNotEmpty && !loading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: IconButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await firestore
                            .collection('coupons')
                            .doc(widget.coupon.id)
                            .delete();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ),
              )
          ]),
        ),
      ),
    );
  }
}
