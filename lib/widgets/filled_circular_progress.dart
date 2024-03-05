import 'dart:math';

import 'package:flutter/material.dart';

class CirclePaint extends CustomPainter {
  final double value;
  final Color fillColor;

  CirclePaint(this.value, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2);

    canvas.drawArc(
        area, -pi / 2, -2 * pi * value, true, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FilledCircularProgress extends StatelessWidget {
  final double value;
  final Color fillColor;
  final Color backgroundColor;
  final double size;
  const FilledCircularProgress(
      {Key? key,
      required this.value,
      required this.fillColor,
      this.backgroundColor = Colors.white,
      this.size = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * 0.8,
          height: size * 0.8,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(size * 0.8 / 2)),
        ),
        SizedBox(
          width: size,
          height: size,
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(size / 2),
          //     color: backgroundColor),
          child: CustomPaint(painter: CirclePaint(value, fillColor)),
        ),
      ],
    );
  }
}
