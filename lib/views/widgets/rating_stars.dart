import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({
    super.key,
    this.size = 20,
    this.rate = 0,
    this.show = false,
  });
  final double size;
  final int rate;
  final bool show;

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < widget.rate ? Icons.star : Icons.star_border,
              color: Colors.orange,
              size: widget.size,
            );
          }),
        ),
        if (widget.show) Text('  ${widget.rate.toString()}')
      ],
    );
  }
}
