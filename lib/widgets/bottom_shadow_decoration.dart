import 'package:flutter/material.dart';
import 'package:growtopia/theme/colors.dart';

class BottomShadowDecoration extends BoxDecoration {
  final bool allBorder;
  BottomShadowDecoration({this.allBorder = false})
      : super(
            color: GPColor.bgPrimary,
            boxShadow: [
              const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(allBorder ? 16 : 0),
                topRight: Radius.circular(allBorder ? 16 : 0),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16)));
}
