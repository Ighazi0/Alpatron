import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetDeleteAccount extends StatefulWidget {
  const BottomSheetDeleteAccount({super.key});

  @override
  State<BottomSheetDeleteAccount> createState() =>
      _BottomSheetDeleteAccountState();
}

class _BottomSheetDeleteAccountState extends State<BottomSheetDeleteAccount> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ListView(
          controller: staticWidgets.scrollController,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'sureDelete'.tr(context),
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  minWidth: 100,
                  height: 40,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  color: Colors.grey.shade400,
                  child: Text(
                    'cancelx'.tr(context),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  minWidth: 100,
                  height: 40,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    auth.deleteAccount();
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  color: primaryColor,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'delete'.tr(context),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
