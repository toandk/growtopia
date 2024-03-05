import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:neon_widgets/neon_widgets.dart';

class WordButton extends StatelessWidget {
  final String title;

  const WordButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeonContainer(
      borderWidth: 2,
      lightSpreadRadius: 4,
      lightBlurRadius: 2,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      borderRadius: BorderRadius.circular(4),
      child: NeonText(
          text: title,
          fontWeight: FontWeight.w900,
          textSize: 10.sp,
          spreadColor: Colors.pink,
          textColor: Colors.white),
    );
  }
}
