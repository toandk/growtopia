import 'dart:math';

import 'package:flutter/material.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';

import 'package:get/get.dart';
import 'package:growtopia/utils/utils.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({this.emptyText, Key? key, this.imageName, this.actionWidget})
      : super(key: key);

  final String? emptyText;
  final String? imageName;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Column(children: [
        imageName != null
            ? Image.asset(imageName!, width: min(185 / 375 * Get.width, 185))
                .marginOnly(bottom: Utils.isSmallDevice() ? 16 : 30)
            : Container(),
        Text(
          emptyText ?? LocaleKeys.error_empty.tr,
          style: textStyle(GPTypography.bodyLarge),
          textAlign: TextAlign.center,
        ),
        actionWidget != null ? actionWidget!.marginOnly(top: 16) : Container()
      ])),
    );
  }
}
