import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/app_data_model.dart';
import 'package:alnoor/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthController extends GetxController {
  GlobalKey<FormState> key = GlobalKey();
  AppDataModel? appData;

  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  UserModel userData = UserModel();
  bool agree = false, notification = false, signIn = true, loading = false;

  changeOrders() {
    appData!.orders = !appData!.orders;
    firestore
        .collection('appInfo')
        .doc('0')
        .update({'orders': appData!.orders});
    update();
  }

  changePaymobs(x) {
    appData!.paymobs!.firstWhere((w) => w.id == x).status =
        !appData!.paymobs!.firstWhere((w) => w.id == x).status;

    firestore.collection('appInfo').doc('0').update({
      'paymobs': appData!.paymobs!
          .map((m) => {
                'id': m.id,
                'username': m.username,
                'status': m.status,
                'name': m.name,
                'password': m.password
              })
          .toList()
    });
    update();
  }

  getAppInfo() async {
    await firestore.collection('appData').doc('0').get().then((value) async {
      appData = AppDataModel.fromJson(value.data() as Map);
    }).onError((e, e1) {
      Get.offNamed('updated');
      return;
    });
  }

  changeStatus() {
    signIn = !signIn;
    update();
  }

  changeNotification(x) async {
    notification = x;
    getStorage.write('notification', x);

    update();
  }

  agreeTerm() {
    agree = !agree;
    update();
  }

  logOut() async {
    Get.find<UserController>().selectedIndex = 0;

    userData = UserModel();
    await firebaseAuth.signOut();
    Get.offNamed('register');
  }

  getUserData() async {
    if (firebaseAuth.currentUser!.uid != appConstant.adminUid) {
      try {
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get()
            .then((value) {
          if (value.exists) {
            userData = UserModel.fromJson(value.data() as Map);
          } else {
            logOut();
          }
        });
      } catch (e) {
        logOut();
      }
    }
  }

  checkUser() async {
    String v = '0';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    v = packageInfo.version;
    await getAppInfo();
    if (!appData!.server) {
      Get.offNamed('updated');
      return;
    }

    if (GetPlatform.isIOS) {
      if (v != appData!.ios) {
        Get.offNamed('updated');
        return;
      }
    } else {
      if (v != appData!.android) {
        Get.offNamed('updated');
        return;
      }
    }
    if (firebaseAuth.currentUser != null) {
      if (firebaseAuth.currentUser!.uid == appConstant.adminUid) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        final stopwatch = Stopwatch()..start();
        await getUserData();
        stopwatch.stop();
        if (stopwatch.elapsed.inSeconds < 2) {
          await Future.delayed(
              Duration(seconds: 2 - stopwatch.elapsed.inSeconds));
        }
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
    navigator();
  }

  navigator() async {
    if (firebaseAuth.currentUser?.uid == appConstant.adminUid) {
      Get.offNamed('admin');
    } else {
      if (firebaseAuth.currentUser != null) {
        Get.offNamed('user');
      } else {
        Get.offNamed('register');
      }
    }
  }

  Future<void> createUser(
    String name,
    String photo,
    String email,
  ) async {
    Map<String, dynamic> data = {
      'uid': firebaseAuth.currentUser!.uid,
      'pic': photo,
      'verified': false,
      'blocked': false,
      'link': '',
      'timestamp': Timestamp.now(),
      'birth': Timestamp.now(),
      'phone': '',
      'coins': 0,
      'wallet': [],
      'email': email.trim(),
      'name': name.trim(),
      'address': [],
      'gender': '',
    };

    firestore.collection('users').doc(firebaseAuth.currentUser!.uid).set(data);
    userData = UserModel.fromJson(data);
  }

  auth() async {
    if (!key.currentState!.validate()) {
      return;
    }
    loading = true;
    update();
    try {
      if (signIn) {
        await signInAuth();
      } else {
        await signUp();
      }
    } on FirebaseAuthException catch (e) {
      Get.log(e.message.toString());
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: e.code.tr);
      }
      Fluttertoast.showToast(msg: 'invalidCredentials'.tr);
    }
    loading = false;
    update();
  }

  Future<void> signUp() async {
    if (agree) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
      await createUser(name.text, '', email.text.trim());
      navigator();
      email.clear();
      name.clear();
      password.clear();
    } else {
      Fluttertoast.showToast(
          msg: 'Please read the Terms & Conditions and agree with it');
    }
  }

  Future<void> signInAuth() async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);
    await getUserData();
    await navigator();
    email.clear();
    name.clear();
    password.clear();
  }
}
