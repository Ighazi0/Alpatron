import 'package:alnoor/controllers/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class StaticData {
  String adminUID = 'IyCnrdBdowaVW5ZDLN53dlpYeD63';

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

  List<Map> categories = [
    {'id': '1', 'ar': 'ثلاجات', 'en': 'Refrigerators'},
    {'id': '2', 'ar': 'غسالات', 'en': 'Washing Machines'},
    {'id': '3', 'ar': 'قلايات هوائية', 'en': 'Air fryers'},
    {'id': '4', 'ar': 'أفران وحماصات', 'en': 'Ovens & toasters'},
    {'id': '5', 'ar': 'الكوايات', 'en': 'Irons & steamers'},
    {'id': '6', 'ar': 'آلات القهوة', 'en': 'Coffee Makers'},
    {'id': '7', 'ar': 'مكانس كهربائية', 'en': 'Vacuum Cleaners'},
    {'id': '8', 'ar': 'فرن غاز', 'en': 'Cooking Ranges'},
    {'id': '9', 'ar': 'خلاطات', 'en': 'Blenders'},
    {'id': '10', 'ar': 'الدفايات', 'en': 'Heaters'},
    {'id': '11', 'ar': 'غلايات كهربائية', 'en': 'Electric kettles'},
    {'id': '12', 'ar': 'عجانات', 'en': 'Mixers'},
    {'id': '13', 'ar': 'غسالات الصحون', 'en': 'Dishwashers'},
    {'id': '14', 'ar': 'موزعات الماء', 'en': 'Water dispensers'},
    {'id': '15', 'ar': 'عصارات', 'en': 'Juicers'},
    {'id': '16', 'ar': 'منقيات الهواء', 'en': 'Air purifiers'},
    {'id': '17', 'ar': 'آفران المايكرويف', 'en': 'Microwave ovens'},
    {'id': '18', 'ar': 'صانعات ساندويش', 'en': 'Sandwich Makers'},
    {'id': '19', 'ar': 'محضرات طعام', 'en': 'Food Processors'},
    {'id': '20', 'ar': 'مكيفات', 'en': 'Air Conditioners'},
    {'id': '21', 'ar': 'المراوح', 'en': 'Fans'},
    {'id': '22', 'ar': 'قطاعات', 'en': 'Choppers'},
    {'id': '23', 'ar': 'آلات الأرز', 'en': 'Rice Cookers'},
  ];
}
