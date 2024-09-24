import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return SafeArea(
          child: BottomNavigationBar(
            items: staticData.bottomBar
                .map(
                  (m) => BottomNavigationBarItem(
                    icon: Icon(m.values.first),
                    label: m.keys.first.toString().tr,
                  ),
                )
                .toList(),
            showUnselectedLabels: true,
            unselectedItemColor: Colors.black,
            currentIndex: userCubit.selectedIndex,
            selectedItemColor: appConstant.primaryColor,
            onTap: (index) {
              userCubit.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}
