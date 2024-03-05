import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:growtopia/theme/text_theme.dart';

class ImageButton extends StatelessWidget {
  final String title;
  final String background;
  final Function() onTap;
  final double? width, height;
  final Color textColor;
  final double fontSize;
  const ImageButton(
      {super.key,
      required this.title,
      required this.background,
      required this.onTap,
      this.width,
      this.height,
      this.fontSize = 18,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(background, fit: BoxFit.fill)),
            SizedBox(
              width: width,
              height: height,
              child: Center(
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: textStyle(GPTypography.fontButton)
                        ?.mergeColor(textColor)
                        .mergeFontSize(fontSize)),
              ),
            )
          ],
        ));
  }
}
