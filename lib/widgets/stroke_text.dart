import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color strokeColor;
  final double strokeWidth;
  final Color color;
  final TextAlign textAlign;
  const StrokeText(this.text,
      {Key? key,
      required this.style,
      this.strokeWidth = 1,
      this.color = Colors.white,
      this.strokeColor = const Color(0xFF212121),
      this.textAlign = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: style?.merge(TextStyle(shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-strokeWidth, -strokeWidth),
              color: strokeColor),
          Shadow(
              // bottomRight
              offset: Offset(strokeWidth, -strokeWidth),
              color: strokeColor),
          Shadow(
              // topRight
              offset: Offset(strokeWidth, strokeWidth),
              color: strokeColor),
          Shadow(
              // topLeft
              offset: Offset(-strokeWidth, strokeWidth),
              color: strokeColor),
        ])));
  }
}
