import 'package:alnoor/views/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: NImage(
        url: url,
        w: Get.width,
        h: Get.height,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
