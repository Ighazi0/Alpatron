import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/user_model.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  GlobalKey<FormState> key = GlobalKey();

  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  UserModel userData = UserModel();
  bool agree = false, notification = false, signIn = true;

  changeStatus() {
    signIn = !signIn;
    emit(AuthInitial());
  }

  changeNotification(x) async {
    final prefs = await SharedPreferences.getInstance();
    notification = x;
    prefs.setBool('notification', x);
    if (x) {
      requestPermission();
    } else {
      firebaseMessaging.deleteToken();
    }
    emit(AuthInitial());
  }

  requestPermission() async {
    SharedPreferences.getInstance().then((value) {
      notification = value.getBool('notification') ?? true;
    });
    await firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (notification) {
      firebaseMessaging.getToken().then((value) {
        firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'token': value,
        });
      });
    }
  }

  agreeTerm() {
    agree = !agree;
    emit(AuthInitial());
  }

  logOut() async {
    userCubit.selectedIndex = 0;

    userData = UserModel();
    await firebaseAuth.signOut();
    navigatorKey.currentState?.pushReplacementNamed('register');
  }

  checkUser() async {
    if (firebaseAuth.currentUser != null) {
      if (firebaseAuth.currentUser!.uid == staticData.adminUID) {
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

  getUserData() async {
    if (firebaseAuth.currentUser!.uid != staticData.adminUID) {
      try {
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get()
            .then((value) {
          userData = UserModel.fromJson(value.data() as Map);
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'error');
      }
    }
  }

  deleteAccount() async {
    logOut();
    await firebaseAuth.currentUser!.delete();
  }

  navigator() async {
    if (firebaseAuth.currentUser?.uid == staticData.adminUID) {
      navigatorKey.currentState?.pushReplacementNamed('admin');
    } else {
      if (firebaseAuth.currentUser != null) {
        requestPermission();
      }
      navigatorKey.currentState?.pushReplacementNamed('user');
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

    var link = await staticFunctions.generateLink(
        firebaseAuth.currentUser!.uid, 'profile');
    data.update(
      'link',
      (v) => link,
    );
    firestore.collection('users').doc(firebaseAuth.currentUser!.uid).set(data);
    userData = UserModel.fromJson(data);
  }

  auth(context) async {
    if (!key.currentState!.validate()) {
      return;
    }
    emit(LoadingState());
    try {
      if (signIn) {
        await signInAuth();
      } else {
        await signUp();
      }
      email.clear();
      name.clear();
      password.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: e.code.tr(context));
      }
      Fluttertoast.showToast(msg: 'invalidCredentials'.tr(context));
    }
    emit(AuthInitial());
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
      snackbarKey.currentState?.showSnackBar(const SnackBar(
        width: 300,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        content: Center(
            child: Text(
          'Please read the Terms & Conditions and agree with it',
          style: TextStyle(fontSize: 18),
        )),
        behavior: SnackBarBehavior.floating,
      ));
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
