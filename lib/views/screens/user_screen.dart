import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/widgets/home.dart';
import 'package:alnoor/views/widgets/profile.dart';
import 'package:alnoor/views/widgets/search.dart';
import 'package:alnoor/views/widgets/user_bottom_bar.dart';
import 'package:alnoor/views/widgets/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

UserCubit userCubit = UserCubit();

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        userCubit = BlocProvider.of<UserCubit>(context);
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              title: Text(
                'Hi, ${auth.userData.name}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, 'categories');
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      // Navigator.pushNamed(context, 'cart');
                    },
                    icon: const Icon(
                      Icons.notifications,
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
                children: const [Home(), Search(), WishList(), Profile()],
              ),
            ));
      },
    );
  }
}
