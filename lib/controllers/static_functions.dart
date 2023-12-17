import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class StaticFunctions {
  Map<String, dynamic>? paymentIntent;

  // Future<void> makePayment() async {
  //   String price =
  //       userCubit.totalCartPrice().toStringAsFixed(2).replaceAll('.', '');

  //   paymentIntent = await createPaymentIntent(price, 'AED');

  //   await Stripe.instance
  //       .initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //               paymentIntentClientSecret: paymentIntent!['client_secret'],
  //               merchantDisplayName: auth.userData.name,
  //               customerId: firebaseAuth.currentUser!.uid))
  //       .then((value) {});

  //   displayPaymentSheet();
  // }

  // displayPaymentSheet() async {
  //   await Stripe.instance.presentPaymentSheet().then((value) {
  //     Fluttertoast.showToast(msg: 'succsess');
  //   });
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   var response = await Dio().post(
  //     'https://api.stripe.com/v1/payment_intents',
  //     options: Options(
  //       headers: {
  //         'Authorization':
  //             'Bearer sk_test_51OGoUUBkldohVpSKF8txUSH6VX0iMnSYIqiU48iSVRgLG66CaNlcRqAGxIp9hr4xmYKq4wmPGrBIa8nZzIqaD0UK00DEmyhBys',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //     ),
  //     data: {
  //       'amount': amount,
  //       'currency': currency,
  //     },
  //   );

  //   return response.data;
  // }

  shareData(link) {
    Share.share(link);
  }

  Future<String> generateLink(String id, String route) async {
    const apiUrl =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyB5_vY9MWglILO4MsgggWwv14AAS_gS6Ps';

    final dynamicLinkData = {
      'dynamicLinkInfo': {
        'domainUriPrefix': 'https://believergoods.page.link',
        'link': 'https://www.believer.com?screen=/$route/$id',
        'androidInfo': {
          'androidPackageName': 'com.comma.believergoods',
        },
        'iosInfo': {
          'iosBundleId': 'com.comma.believergoods',
        },
      },
      'suffix': {
        'option': 'SHORT',
      },
    };

    final respo = await Dio().post(
      apiUrl,
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: json.encode(dynamicLinkData),
    );

    var shortUrl = respo.data['shortLink'];

    return shortUrl;
  }

  urlLauncher(Uri uri) async {
    await launchUrl(uri);
  }
}
