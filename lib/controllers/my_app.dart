import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/static_data.dart';
import 'package:alnoor/controllers/static_functions.dart';
import 'package:alnoor/controllers/static_widgets.dart';
import 'package:alnoor/cubit/auth_cubit.dart';
import 'package:alnoor/cubit/locale_cubit.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/views/screens/address_screen.dart';
import 'package:alnoor/views/screens/admin_banners.dart';
import 'package:alnoor/views/screens/admin_coupons.dart';
import 'package:alnoor/views/screens/admin_orders.dart';
import 'package:alnoor/views/screens/admin_products.dart';
import 'package:alnoor/views/screens/admin_reviews.dart';
import 'package:alnoor/views/screens/admin_screen.dart';
import 'package:alnoor/views/screens/cart_screen.dart';
import 'package:alnoor/views/screens/categories_screen.dart';
import 'package:alnoor/views/screens/checkout_screen.dart';
import 'package:alnoor/views/screens/notification_screen.dart';
import 'package:alnoor/views/screens/orders_screen.dart';
import 'package:alnoor/views/screens/payment_screen.dart';
import 'package:alnoor/views/screens/register_screen.dart';
import 'package:alnoor/views/screens/settings_screen.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

LocaleCubit locale = LocaleCubit();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final physical =
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
final devicePixelRatio =
    WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
final double dHeight = physical.height / devicePixelRatio;
final double dWidth = physical.width / devicePixelRatio;

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();
StaticFunctions staticFunctions = StaticFunctions();

Color primaryColor = const Color(0xff33367E);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          locale = BlocProvider.of<LocaleCubit>(context);
          return MaterialApp(
            locale: state.locale,
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: snackbarKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                useMaterial3: false,
                progressIndicatorTheme:
                    ProgressIndicatorThemeData(color: primaryColor),
                // scaffoldBackgroundColor: Colors.white,
                primaryColor: primaryColor,
                appBarTheme: AppBarTheme(backgroundColor: primaryColor)),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }

              return supportedLocales.first;
            },
            routes: {
              'register': (context) => const RegisterScreen(),
              'user': (context) => const UserScreen(),
              'payment': (context) => const PaymentScreen(),
              'orders': (context) => const OrdersScreen(),
              'categories': (context) => const CategoriesScreen(),
              'cart': (context) => const CartScreen(),
              'settings': (context) => const SettingsScreen(),
              'admin': (context) => const AdminScreen(),
              'adminOrders': (context) => const AdminOrders(),
              'adminReviews': (context) => const AdminReviews(),
              'adminP': (context) => const AdminProducts(),
              'adminB': (context) => const AdminBanners(),
              'address': (context) => const AddressScreen(),
              'coupons': (context) => const AdminCoupons(),
              'checkout': (context) => const CheckoutScreen(),
              'notification': (context) => const NotificationScreen(),
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
