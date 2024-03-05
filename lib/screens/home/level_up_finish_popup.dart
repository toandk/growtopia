import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/answer_button.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:growtopia/widgets/stroke_text.dart';
import 'package:lottie/lottie.dart';

class LevelUpFinishPopup extends StatelessWidget {
  final String imageUrl;
  final int level;
  final bool isPlanting;
  final Function() hideAction;
  final ConfettiController confettiController;

  const LevelUpFinishPopup(
      {super.key,
      required this.imageUrl,
      required this.level,
      required this.hideAction,
      this.isPlanting = false,
      required this.confettiController});

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    isPlanting
                        ? 'assets/images/growing.png'
                        : 'assets/images/lv_up.png',
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset('assets/json/light.json',
                          width: 200, height: 200),
                      GPNetworkImage(
                        url: imageUrl,
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isPlanting
                      ? StrokeText(
                          'You have planted this tree. Now you can water to make it grow.',
                          textAlign: TextAlign.center,
                          style: textStyle(GPTypography.body20)
                              ?.bold()
                              .mergeColor(Colors.white),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('LV $level',
                                style: textStyle(GPTypography.body20)
                                    ?.bold()
                                    .white()),
                            const SizedBox(width: 16),
                            const Icon(Icons.trending_flat,
                                color: Colors.orange, size: 24),
                            const SizedBox(width: 16),
                            Text('LV ${level + 1}',
                                style: textStyle(GPTypography.body20)
                                    ?.bold()
                                    .mergeColor(Colors.green)),
                          ],
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  ImageButton(
                      title: 'OK',
                      width: 180,
                      height: 70,
                      fontSize: 24,
                      background: 'assets/images/ok_button_bg.png',
                      onTap: hideAction),
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
