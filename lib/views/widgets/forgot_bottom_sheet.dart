// ignore_for_file: use_build_context_synchronously

import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      await firebaseAuth.sendPasswordResetEmail(email: auth.email.text);
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'passwordSent'.tr(context));
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
              'resetPassword'.tr(context),
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 40, left: 20, right: 20),
            child: EditText(
                hint: 'example@gmail.com',
                function: auth.auth,
                controller: auth.email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'pleaseEmail'.tr(context);
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
              color: primaryColor,
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'submit'.tr(context),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
