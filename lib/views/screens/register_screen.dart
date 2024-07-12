import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/auth_cubit.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:alnoor/views/widgets/forgot_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool signIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          signIn = auth.signIn;
          return Form(
            key: auth.key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 50, bottom: 15),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          signIn ? 'Welcome' : 'Register',
                          key: ValueKey<String>(signIn ? 'signIn' : 'signUp'),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    if (!signIn)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Create your account'.tr(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    if (!signIn)
                      EditText(
                          hint: 'Ex. Ahmad',
                          function: auth.auth,
                          controller: auth.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseName'.tr(context);
                            }
                            return null;
                          },
                          title: 'Name'),
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
                        hint: 'example@gmail.com',
                        function: auth.auth,
                        controller: auth.email,
                        validator: (value) {
                          if (!value!.contains('@') && !value.contains('.')) {
                            return 'pleaseEmail'.tr(context);
                          }
                          return null;
                        },
                        title: 'Email'),
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
                        hint: '',
                        secure: true,
                        function: auth.auth,
                        controller: auth.password,
                        validator: (value) {
                          if (value!.length < 8) {
                            return 'pleasePassword'.tr(context);
                          }
                          return null;
                        },
                        title: 'Password'),
                    Align(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        child: state is LoadingState
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                minWidth: dWidth,
                                height: 50,
                                onPressed: () async {
                                  auth.auth(context);
                                },
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                color: primaryColor,
                                child: Text(
                                  signIn
                                      ? 'signIn'.tr(context)
                                      : 'signUp'.tr(context),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                    signIn
                        ? TextButton(
                            style: ButtonStyle(
                                overlayColor: WidgetStateProperty.all(
                                    Colors.amber.shade50)),
                            onPressed: () {
                              staticWidgets.showBottom(
                                  context, const BottomSheetForgot(), 0.4, 0.5);
                            },
                            child: Text('forgot'.tr(context),
                                style: TextStyle(
                                  color: primaryColor,
                                )))
                        : Theme(
                            data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: CheckboxListTile(
                              value: auth.agree,
                              onChanged: (v) {
                                auth.agreeTerm();
                              },
                              activeColor: primaryColor,
                              title: Text(
                                'agree'.tr(context),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            signIn
                                ? 'dontHave'.tr(context)
                                : 'haveAcc'.tr(context),
                            key: ValueKey<String>(
                                signIn ? 'dontHave' : 'haveAcc'),
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            auth.changeStatus();
                          },
                          style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                  Colors.amber.shade50)),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                                signIn
                                    ? 'signUp'.tr(context)
                                    : 'signIn'.tr(context),
                                key: ValueKey<String>(
                                    signIn ? 'signUp' : 'signIn'),
                                style: TextStyle(
                                  color: primaryColor,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
