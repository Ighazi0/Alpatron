import 'dart:async';
import 'dart:convert';

import 'package:alnoor/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewer extends StatefulWidget {
  final String url;
  const WebViewer({super.key, required this.url});

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late final WebViewController controller;
  bool loading = true;
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              loading = false;
            });
          },
          onUrlChange: (UrlChange change) async {
            timer = Timer.periodic(const Duration(seconds: 2), (e) {
              Future future = controller
                  .runJavaScriptReturningResult("document.body.innerText");
              future.then((data) {
                String text = GetPlatform.isIOS
                    ? data.toString()
                    : jsonDecode(data).toString();
                Get.log(text);
                if (text.removeAllWhitespace
                    .toLowerCase()
                    .contains('paymentaccepted')) {
                  Get.find<UserController>().changeDone(true);
                  Get.back();
                }
              });
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WebViewWidget(controller: controller),
      ),
    );
  }
}
