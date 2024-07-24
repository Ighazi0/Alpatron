import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/views/screens/cart_screen.dart';
import 'package:alnoor/views/screens/categories_screen.dart';
import 'package:alnoor/views/screens/orders_screen.dart';
import 'package:alnoor/views/widgets/home.dart';
import 'package:alnoor/views/widgets/user_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: false,
              title: Text(
                'Hi, ${Get.find<AuthController>().userData.name}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.toNamed('wish');
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      Get.to(() => const OrdersScreen());
                    },
                    icon: const Icon(
                      Icons.paste,
                      color: Colors.black,
                    )),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            bottomNavigationBar: const UserBottomBar(),
            body: SafeArea(
              child: IndexedStack(
                index: userCubit.selectedIndex,
                children: const [
                  Home(),
                  CategoriesScreen(),
                  CartScreen(),
                ],
              ),
            ));
      },
    );
  }
}
