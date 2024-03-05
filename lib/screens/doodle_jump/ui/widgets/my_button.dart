import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:growtopia/utils/sound_manager.dart';
import 'package:growtopia/widgets/image_button.dart';

import '../../assets.dart';
import 'my_text.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width, height;

  const MyButton(
    this.text, {
    super.key,
    this.width = 120,
    this.height = 50,
    required this.onPressed,
  });

  void _onTap() {
    SoundManager.playLocalSound('sounds/collect.mp3');
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ImageButton(
        title: text,
        background: 'assets/images/ok_button_bg.png',
        onTap: _onTap,
        width: width,
        height: height);
  }
}
