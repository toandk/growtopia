import 'dart:math';

import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AILoadingView extends StatelessWidget {
  const AILoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: GPColor.bgPrimary,
                borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/json/machine.json',
                    width: min(Get.width, Get.height) * 2 / 3),
                const SizedBox(
                  height: 20,
                ),
                Text(LocaleKeys.scan_waitText.tr,
                    textAlign: TextAlign.center,
                    style: textStyle(GPTypography.body)?.mergeFontSize(16.sp))
              ],
            ),
          ),
        )));
  }
}
