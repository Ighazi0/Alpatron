import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            title: Text(
              'myOrders'.tr(context),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'orders');
            },
            leading: const Icon(OctIcons.paste_16),
          ),
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            title: Text(
              'manageAdd'.tr(context),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'address');
            },
            leading: const Icon(FontAwesome.map_location),
          ),
        if (auth.userData.uid.isNotEmpty)
          ListTile(
            title: Text(
              'paymentMethod'.tr(context),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'payment');
            },
            leading: const Icon(FontAwesome.wallet),
          ),
        ListTile(
          title: Text(
            'settings'.tr(context),
          ),
          onTap: () {
            Navigator.pushNamed(context, 'settings');
          },
          leading: const Icon(EvaIcons.settings),
        ),
        ListTile(
          title: Text(
            'help'.tr(context),
          ),
          onTap: () {
            HapticFeedback.lightImpact();
            var url = Uri(
              scheme: 'mailto',
              path: 'comma0tech@gmail.com',
              query: 'subject=Help',
            );
            staticFunctions.urlLauncher(url);
          },
          leading: const Icon(
            EvaIcons.question_mark_circle,
          ),
        ),
        ListTile(
          title: Text(
            'contactUs'.tr(context),
          ),
          onTap: () {
            staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
          },
          leading: const Icon(
            Icons.quick_contacts_mail,
          ),
        ),
        ListTile(
          leading: Icon(
            auth.userData.uid.isNotEmpty ? EvaIcons.log_out : EvaIcons.log_in,
            color: Colors.red,
          ),
          title: Text(
            auth.userData.uid.isNotEmpty
                ? 'logOut'.tr(context)
                : 'signIn'.tr(context),
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () {
            auth.logOut();
          },
        ),
      ],
    );
  }
}
