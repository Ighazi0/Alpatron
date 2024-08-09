import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/views/widgets/icon_badge.dart';
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
    return Container(
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12))),
      child: GetBuilder(
        init: UserController(),
        builder: (userCubit) {
          return SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(staticData.bottomBar.length, (index) {
                  var e = staticData.bottomBar[index].entries.toList().first;
                  return InkWell(
                    onTap: () {
                      userCubit.changeIndex(index);
                    },
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Icon(e.value,
                                color: userCubit.selectedIndex == index
                                    ? appConstant.primaryColor
                                    : Colors.black),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              e.key,
                              style: TextStyle(
                                  color: userCubit.selectedIndex == index
                                      ? appConstant.primaryColor
                                      : Colors.black),
                            )
                          ],
                        ),
                        if (userCubit.cartList.isNotEmpty && index == 2)
                          Positioned(
                              top: 0,
                              right: 0,
                              child: BadgeIcon(
                                  badgeText:
                                      userCubit.cartList.length.toString()))
                      ],
                    ),
                  );
                })),
          );
        },
      ),
    );
  }
}
