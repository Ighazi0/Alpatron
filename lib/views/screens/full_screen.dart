import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/views/widgets/network_image.dart';
import 'package:flutter/material.dart';

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
        w: dWidth,
        h: dHeight,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
