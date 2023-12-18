import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        action: {},
        title: 'Notifications',
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                  future: firestore.collection('notifications').get(),
                  builder: (context, snapshot) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_notification.png',
                            height: 150,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'No notifications yet!',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
