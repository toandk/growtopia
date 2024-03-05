import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';

class LineBorderButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String? leftIcon;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Color? borderColor;
  const LineBorderButton(
      {Key? key,
      this.text = "",
      this.onTap,
      this.leftIcon,
      this.height = 64,
      this.width,
      this.backgroundColor,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Bounceable(
            onTap: onTap,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: backgroundColor ?? GPColor.transparent,
                  border: Border.all(color: borderColor ?? GPColor.bgPrimary),
                  borderRadius: BorderRadius.circular(height / 2)),
              child: Center(
                      child: leftIcon != null
                          ? Row(children: [
                              Image.asset(leftIcon!),
                              const SizedBox(width: 4),
                              Text(
                                text,
                                style: textStyle(GPTypography.fontButton)
                                    ?.mergeColor(GPColor.bgPrimary),
                              )
                            ]).paddingOnly(left: 16, right: 16)
                          : Text(
                              text,
                              style: textStyle(GPTypography.fontButton)
                                  ?.mergeColor(GPColor.bgPrimary),
                            ))
                  .paddingOnly(left: 16, right: 16),
            )));
  }
}
