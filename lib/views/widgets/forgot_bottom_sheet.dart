import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BottomSheetForgot extends StatefulWidget {
  const BottomSheetForgot({super.key});

  @override
  State<BottomSheetForgot> createState() => _BottomSheetForgotState();
}

class _BottomSheetForgotState extends State<BottomSheetForgot> {
  final GlobalKey<FormState> key = GlobalKey();
  var loading = false;

  resetPass() async {
    if (!key.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        loading = true;
      });
      await firebaseAuth.sendPasswordResetEmail(
          email: Get.find<AuthController>().email.text);
      Get.back();
      Fluttertoast.showToast(msg: 'passwordSent'.tr);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: ListView(
        controller: staticWidgets.scrollController,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'resetPassword'.tr,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 40, left: 20, right: 20),
            child: EditText(
                hint: 'example@gmail.com',
                function: Get.find<AuthController>().auth,
                controller: Get.find<AuthController>().email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'pleaseEmail'.tr;
                  }
                  return null;
                },
                title: 'email'),
          ),
          Center(
            child: MaterialButton(
              minWidth: 150,
              height: 50,
              onPressed: () async {
                resetPass();
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: appConstant.primaryColor,
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'submit'.tr,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
