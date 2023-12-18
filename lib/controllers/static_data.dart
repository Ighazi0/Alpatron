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
    {'id': '1', 'titleAr': 'ثلاجات', 'titleEn': 'Refrigerators'},
    {'id': '2', 'titleAr': 'غسالات', 'titleEn': 'Washing Machines'},
    {'id': '3', 'titleAr': 'قلايات هوائية', 'titleEn': 'Air fryers'},
    {'id': '4', 'titleAr': 'أفران وحماصات', 'titleEn': 'Ovens & toasters'},
    {'id': '5', 'titleAr': 'الكوايات', 'titleEn': 'Irons & steamers'},
    {'id': '6', 'titleAr': 'آلات القهوة', 'titleEn': 'Coffee Makers'},
    {'id': '7', 'titleAr': 'مكانس كهربائية', 'titleEn': 'Vacuum Cleaners'},
    {'id': '8', 'titleAr': 'فرن غاز', 'titleEn': 'Cooking Ranges'},
    {'id': '9', 'titleAr': 'خلاطات', 'titleEn': 'Blenders'},
    {'id': '10', 'titleAr': 'الدفايات', 'titleEn': 'Heaters'},
    {'id': '11', 'titleAr': 'غلايات كهربائية', 'titleEn': 'Electric kettles'},
    {'id': '12', 'titleAr': 'عجانات', 'titleEn': 'Mixers'},
    {'id': '13', 'titleAr': 'غسالات الصحون', 'titleEn': 'Dishwashers'},
    {'id': '14', 'titleAr': 'موزعات الماء', 'titleEn': 'Water dispensers'},
    {'id': '15', 'titleAr': 'عصارات', 'titleEn': 'Juicers'},
    {'id': '16', 'titleAr': 'منقيات الهواء', 'titleEn': 'Air purifiers'},
    {'id': '17', 'titleAr': 'آفران المايكرويف', 'titleEn': 'Microwave ovens'},
    {'id': '18', 'titleAr': 'صانعات ساندويش', 'titleEn': 'Sandwich Makers'},
    {'id': '19', 'titleAr': 'محضرات طعام', 'titleEn': 'Food Processors'},
    {'id': '20', 'titleAr': 'مكيفات', 'titleEn': 'Air Conditioners'},
    {'id': '21', 'titleAr': 'المراوح', 'titleEn': 'Fans'},
    {'id': '22', 'titleAr': 'قطاعات', 'titleEn': 'Choppers'},
    {'id': '23', 'titleAr': 'آلات الأرز', 'titleEn': 'Rice Cookers'},
  ];
}
