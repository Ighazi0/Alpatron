import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Get.find<AuthController>().userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'myOrders'.tr,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: appConstant.primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'orders');
            },
            leading: Icon(
              Icons.shopping_bag,
              color: appConstant.primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (Get.find<AuthController>().userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'manageAdd'.tr,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: appConstant.primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'address');
            },
            leading: Icon(
              Icons.location_on,
              color: appConstant.primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (Get.find<AuthController>().userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'paymentMethod'.tr,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: appConstant.primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'payment');
            },
            leading: Icon(
              Icons.wallet_sharp,
              color: appConstant.primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (Get.find<AuthController>().userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'settings'.tr,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: appConstant.primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'settings');
            },
            leading: Icon(
              Icons.settings,
              color: appConstant.primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          tileColor: Colors.white,
          title: Text(
            'contactUs'.tr,
          ),
          onTap: () {
            staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: appConstant.primaryColor,
          ),
          leading: Icon(
            Icons.call,
            color: appConstant.primaryColor,
          ),
        ),
        const Spacer(),
        MaterialButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: Colors.white,
          textColor: Colors.red,
          onPressed: () {
            Get.find<AuthController>().logOut();
          },
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(
                  Get.find<AuthController>().userData.uid.isNotEmpty
                      ? EvaIcons.log_out
                      : EvaIcons.log_in,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(Get.find<AuthController>().userData.uid.isNotEmpty
                    ? 'logOut'.tr
                    : 'signIn'.tr),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
