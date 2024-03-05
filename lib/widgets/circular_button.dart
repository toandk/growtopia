import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CircularButton extends StatelessWidget {
  final double size;
  final String? text;
  final Widget icon;
  final Function()? onTap;
  final Color color;
  final Color backgroundColor;
  const CircularButton(
      {Key? key,
      required this.size,
      this.text,
      required this.icon,
      this.onTap,
      this.backgroundColor = Colors.white,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2.0,
            ),
          ),
          child: Center(child: icon),
        ));
  }
}

// create a curcular button widget with a border and an icon inside
