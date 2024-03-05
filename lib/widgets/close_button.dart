import 'package:flutter/material.dart';
import 'package:growtopia/theme/colors.dart';

class GPCloseButton extends StatelessWidget {
  const GPCloseButton({Key? key}) : super(key: key);

  void _onBack(BuildContext context) {
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onBack(context),
        icon: Image.asset(
          "assets/images/ic-close.png",
          width: 16,
          height: 16,
          color: GPColor.contentPrimary,
        ));
  }
}
