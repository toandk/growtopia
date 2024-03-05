import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/answer_button.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:lottie/lottie.dart';

class MaxLevelPopup extends StatelessWidget {
  final String imageUrl;
  final int level;
  final Function() hideAction;
  final Function() addToWalletAction;
  final ConfettiController confettiController;

  const MaxLevelPopup(
      {super.key,
      required this.imageUrl,
      required this.level,
      required this.hideAction,
      required this.confettiController,
      required this.addToWalletAction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
              color: Colors.black38,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/lv_up.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.home_maxLevelPopupMessage.tr,
                      textAlign: TextAlign.center,
                      style: textStyle(GPTypography.body20)
                          ?.mergeFontSize(18)
                          .bold()
                          .white(),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset('assets/json/light.json',
                            width: min(300, Get.width - 60),
                            height: min(300, Get.width - 60)),
                        GPNetworkImage(
                          url: imageUrl,
                          width: min(260, Get.width - 100),
                          height: min(260, Get.width - 100),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GoogleWalletButton(
                        style: GoogleWalletButtonStyle
                            .condensed, // or GoogleWalletButtonStyle.primary (default)
                        height: 60,
                        onPressed: addToWalletAction // callback function
                        ),
                    const SizedBox(
                      height: 20,
                    ),
                    ImageButton(
                        title: 'Dismiss',
                        width: 180,
                        height: 70,
                        fontSize: 24,
                        background: 'assets/images/ok_button_bg.png',
                        onTap: hideAction),
                  ],
                ),
              )),
        ),
        Positioned.fill(
            top: 110,
            left: Get.width / 2,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ))
      ],
    );
  }
}
