import 'package:alnoor/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().checkUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Image.asset(
          'assets/images/brand.png',
          height: 200,
        )),
      ),
    );
  }
}
