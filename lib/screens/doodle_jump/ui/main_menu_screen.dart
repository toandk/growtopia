import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:growtopia/routes/router_name.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/stroke_text.dart';

import '../assets.dart';
import '../high_scores.dart';
import 'widgets/my_button.dart';
import 'widgets/my_text.dart';

class DoodleJumpMainMenuScreen extends StatelessWidget {
  const DoodleJumpMainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(builder: (context, constrains) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: constrains.maxHeight * .25,
                      child: Image.asset(
                        'assets/ui/heroJump.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .60,
                      child: Image.asset(
                        'assets/ui/LandPiece_DarkMulticolored.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                        left: 4,
                        top: 20,
                        child: IconButton(
                          icon: SpriteWidget(
                            sprite: Assets.buttonBack,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        )),
                    Positioned(
                      bottom: constrains.maxHeight * .05,
                      left: constrains.maxWidth * .2,
                      child: Image.asset(
                        'assets/ui/BrokenLandPiece_Beige.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        'assets/ui/LandPiece_DarkBlue.png',
                        scale: 1.5,
                      ),
                    ),
                    Positioned(
                      top: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        'assets/ui/HappyCloud.png',
                        scale: 1.75,
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 84),
                          StrokeText(
                            'Eco Jumper',
                            textAlign: TextAlign.center,
                            style: textStyle(GPTypography.body20)
                                ?.mergeColor(Colors.yellow)
                                .mergeFontSize(46),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StrokeText(
                            'Best Score: ${HighScores.highScores[0]}',
                            style: textStyle(GPTypography.body20)
                                ?.white()
                                .mergeFontSize(28),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyButton(
                                  'Play',
                                  width: 180,
                                  height: 60,
                                  onPressed: () =>
                                      Get.offNamed(RouterName.doodleJump),
                                ),
                                const SizedBox(height: 40),
                                MyButton(
                                  'Leaderboard',
                                  width: 180,
                                  height: 60,
                                  onPressed: () => Get.offNamed(
                                      RouterName.doodleJumpLeaderboard),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
