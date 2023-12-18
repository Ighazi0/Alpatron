import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:alnoor/views/widgets/icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Colors.white,
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  var e = staticData.bottomBar[index].entries.toList().first;
                  return GestureDetector(
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
                                    ? primaryColor
                                    : Colors.black),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              e.key,
                              style: TextStyle(
                                  color: userCubit.selectedIndex == index
                                      ? primaryColor
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
