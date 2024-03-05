import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/answer_button.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:lottie/lottie.dart';

class TopRankColectiableCardPopup extends StatelessWidget {
  final int rank;
  final Function() hideAction;
  final Function() addToWalletAction;
  final ConfettiController confettiController;
  const TopRankColectiableCardPopup(
      {super.key,
      required this.rank,
      required this.hideAction,
      required this.addToWalletAction,
      required this.confettiController});

  @override
  Widget build(BuildContext context) {
    final message = rank < 2
        ? LocaleKeys.game_tetris_topRank1Message.tr
        : (rank < 4
            ? LocaleKeys.game_tetris_topRank30Message.tr
            : LocaleKeys.game_tetris_topRank10Message.tr);
    final img = rank < 2
        ? 'assets/images/tetris_top1.png'
        : (rank < 4
            ? 'assets/images/tetris_top3.png'
            : 'assets/images/tetris_top10.png');
    return Stack(
      children: [
        Container(
            color: Colors.black38,
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: textStyle(GPTypography.body20)?.bold().white(),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset('assets/json/light.json',
                          width: min(300, Get.width - 60),
                          height: min(300, Get.width - 60)),
                      Image.asset(
                        img,
                        width: min(260, Get.width - 100),
                        height: min(260, Get.width - 100),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
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
                      background: 'assets/images/ok_button_bg.png',
                      onTap: hideAction,
                      width: 200,
                      height: 70),
                ],
              ),
            )),
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
