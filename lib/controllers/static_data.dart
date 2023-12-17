import 'package:alnoor/controllers/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class StaticData {
  String adminUID = 'Ms4bgI9hdCUfLQF9Bf52lXAb0P43';

  String formatElapsedTime(time, context) {
    var currentTime = DateTime.now().toUtc();
    var convertTime = DateTime.parse(time).toUtc();

    if (currentTime.isBefore(convertTime)) {
      final temp = currentTime;
      currentTime = convertTime;
      convertTime = temp;
    }

    final elapsedDuration = currentTime.difference(convertTime);

    if (elapsedDuration.inDays >= 365) {
      final years = (elapsedDuration.inDays / 365).floor();
      return '$years${years > 1 ? ' ${'years'.tr(context)}' : ' ${'year'.tr(context)}'}';
    } else if (elapsedDuration.inDays >= 30) {
      final months = (elapsedDuration.inDays / 30.44).floor();
      return '$months${months > 1 ? ' ${'months'.tr(context)}' : ' ${'month'.tr(context)}'}';
    } else if (elapsedDuration.inDays >= 7) {
      final weeks = (elapsedDuration.inDays / 7).floor();
      return '$weeks${weeks > 1 ? ' ${'weekss'.tr(context)}' : ' ${'weeks'.tr(context)}'}';
    } else if (elapsedDuration.inDays > 0) {
      return '${elapsedDuration.inDays}${elapsedDuration.inDays > 1 ? ' ${'days'.tr(context)}' : ' ${'day'.tr(context)}'}';
    } else if (elapsedDuration.inHours > 0) {
      return '${elapsedDuration.inHours}${'h'.tr(context)}';
    } else if (elapsedDuration.inMinutes > 0) {
      return '${elapsedDuration.inMinutes}${'m'.tr(context)}';
    } else {
      return '${elapsedDuration.inSeconds}${'s'.tr(context)}';
    }
  }

  List<Map> bottomBar = [
    {'home': Iconsax.home_2},
    {'categories': Icons.category},
    {'cart': Icons.shopping_cart},
    {'profile': Icons.person_outline_outlined},
  ];
}
