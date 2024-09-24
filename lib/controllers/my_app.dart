import 'package:alnoor/controllers/language_controller.dart';
import 'package:alnoor/controllers/static_data.dart';
import 'package:alnoor/controllers/static_widgets.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/languages.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale(Get.find<LanguageController>().getSavedLanguage()),
      translations: Languages(),
      theme: appConstant.theme,
      routes: appConstant.routes,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
