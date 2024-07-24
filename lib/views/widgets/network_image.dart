import 'package:alnoor/get_initial.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NImage extends StatelessWidget {
  const NImage(
      {super.key,
      required this.url,
      required this.h,
      required this.w,
      this.fit = BoxFit.cover});
  final String url;
  final double h, w;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url,
        height: h,
        width: w,
        fit: fit,
        errorWidget: (context, url, progress) => const Center(
              child: Icon(Icons.error),
            ),
        progressIndicatorBuilder: (context, url, progress) => Shimmers(
              child: Container(
                height: h,
                color: appConstant.primaryColor,
              ),
            ));
  }
}
