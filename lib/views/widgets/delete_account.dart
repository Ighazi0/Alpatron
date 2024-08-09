import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetDeleteAccount extends StatefulWidget {
  const BottomSheetDeleteAccount({super.key});

  @override
  State<BottomSheetDeleteAccount> createState() =>
      _BottomSheetDeleteAccountState();
}

class _BottomSheetDeleteAccountState extends State<BottomSheetDeleteAccount> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: staticWidgets.scrollController,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to delete your account?'.tr,
            style: const TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            height: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: 100,
              height: 40,
              onPressed: () async {
                Navigator.pop(context);
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              color: Colors.grey.shade400,
              child: Text(
                'cancel'.tr,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            MaterialButton(
              minWidth: 100,
              height: 40,
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                Get.find<AuthController>().logOut();
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              color: appConstant.primaryColor,
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'delete'.tr,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ],
        )
      ],
    );
  }
}
