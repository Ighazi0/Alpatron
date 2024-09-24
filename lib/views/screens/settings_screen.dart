import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/delete_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        action: {},
        title: 'Settings',
      ),
      body: Column(
        children: [
          GetBuilder(
            init: AuthController(),
            builder: (auth) {
              return SwitchListTile(
                value: auth.notification,
                activeColor: appConstant.primaryColor,
                title: Text(
                  'notifications'.tr,
                ),
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  auth.changeNotification(value);
                },
                secondary: const Icon(Icons.notifications),
              );
            },
          ),
          ListTile(
            title: Text(
              'deleteAccount'.tr,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              staticWidgets.showBottom(
                  context, const BottomSheetDeleteAccount(), 0.4, 0.5);
            },
            leading: const Icon(
              Icons.person_remove,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
