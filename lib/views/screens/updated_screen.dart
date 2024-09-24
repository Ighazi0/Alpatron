import 'package:alnoor/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatedScreen extends StatelessWidget {
  final bool server;
  const UpdatedScreen({super.key, this.server = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'There are a new version for this app\n\nplease update your app to use the app'
                    .tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (GetPlatform.isAndroid) {
                  // staticFunctions.urlLauncher(
                  //   Uri.parse(
                  //       "https://play.google.com/store/apps/details?id=com.comma.believer"),
                  // );
                } else {
                  // staticFunctions.urlLauncher(
                  //   Uri.parse(
                  //       "https://apps.apple.com/us/app/believer/id6474021514"),
                  // );
                }
              },
              color: appConstant.primaryColor,
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
