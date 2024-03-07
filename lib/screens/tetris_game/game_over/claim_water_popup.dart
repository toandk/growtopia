import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:growtopia/widgets/stroke_text.dart';

import 'claim_water_controller.dart';

class ClaimWaterPoup extends GetView<ClaimWaterController> {
  const ClaimWaterPoup({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: min(320, Get.width - 40),
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 10),
                spreadRadius: 0.0,
                blurRadius: 10.0,
              )
            ],
          ),
          // gradient: GPColor.bgGradient3),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(
                'assets/images/popup_vertical.png',
                fit: BoxFit.fill,
              )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/icon_drop.png',
                      color: Colors.white,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 12),
                    StrokeText(LocaleKeys.claimWater_title.tr,
                        style: textStyle(GPTypography.body20)
                            ?.white()
                            .mergeFontSize(30)),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '${LocaleKeys.claimWater_watchAdsMessage1.tr}: ',
                        style: textStyle(GPTypography.body20)?.white(),
                        children: <TextSpan>[
                          TextSpan(
                              text: LocaleKeys.claimWater_watchAdsMessage2.tr,
                              style: textStyle(GPTypography.body20)
                                  ?.mergeColor(Colors.yellow))
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    ImageButton(
                        title: LocaleKeys.claimWater_claimX2.tr,
                        width: 180,
                        height: 64,
                        background: 'assets/images/ok_button_bg.png',
                        onTap: () => controller.claimAction(true)),
                    const SizedBox(
                      height: 12,
                    ),
                    ImageButton(
                        title: LocaleKeys.claimWater_claimButton.tr,
                        width: 180,
                        height: 64,
                        background: 'assets/images/ok_button_bg.png',
                        onTap: () => controller.claimAction(false)),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  final String title;
  final Widget? image;
  final Function() onTap;
  const _ClaimButton({required this.title, this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: onTap,
        child: Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blueAccent),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textStyle(GPTypography.body16)?.bold().white(),
                  ),
                  image?.marginOnly(left: 8) ?? Container()
                ],
              ),
            )));
  }
}
