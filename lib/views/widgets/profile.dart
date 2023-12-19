import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'myOrders'.tr(context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'orders');
            },
            leading: Icon(
              Icons.shopping_bag,
              color: primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'manageAdd'.tr(context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'address');
            },
            leading: Icon(
              Icons.location_on,
              color: primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'paymentMethod'.tr(context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'payment');
            },
            leading: Icon(
              Icons.wallet_sharp,
              color: primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            tileColor: Colors.white,
            title: Text(
              'settings'.tr(context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, 'settings');
            },
            leading: Icon(
              Icons.settings,
              color: primaryColor,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          tileColor: Colors.white,
          title: Text(
            'contactUs'.tr(context),
          ),
          onTap: () {
            staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: primaryColor,
          ),
          leading: Icon(
            Icons.call,
            color: primaryColor,
          ),
        ),
        const Spacer(),
        MaterialButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: Colors.white,
          textColor: Colors.red,
          onPressed: () {
            auth.logOut();
          },
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(
                  auth.userData.uid.isNotEmpty
                      ? EvaIcons.log_out
                      : EvaIcons.log_in,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(auth.userData.uid.isNotEmpty
                    ? 'logOut'.tr(context)
                    : 'signIn'.tr(context)),
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
