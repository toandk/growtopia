import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/routes/routes.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/stroke_text.dart';

import '../high_scores.dart';
import '../my_game.dart';
import 'widgets/my_button.dart';
import 'widgets/my_text.dart';

class GameOverMenu extends StatelessWidget {
  final MyGame game;

  const GameOverMenu({Key? key, required this.game}) : super(key: key);

  void _resetGame() {
    debugPrint('reset game');
    // game.reset();
    // Get.back();
    Get.offAndToNamed(RouterName.doodleJump);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.black38,
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(height: height * .15),
                StrokeText(
                  'Game Over!',
                  style:
                      textStyle(GPTypography.body20)?.mergeFontSize(50).white(),
                ),
                Table(
                  // border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(.2),
                    1: FlexColumnWidth(.5),
                    2: FlexColumnWidth(.2),
                    3: FlexColumnWidth(.1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const SizedBox(),
                        const MyText('Score', color: Colors.white),
                        MyText(
                          game.score.toString(),
                          color: Colors.white,
                        ),
                        const SizedBox(),
                      ],
                    ),
                    TableRow(
                      children: [
                        const SizedBox(),
                        const MyText('Best Score', color: Colors.white),
                        MyText(
                          '${HighScores.highScores[0]}',
                          color: Colors.white,
                        ),
                        const SizedBox(),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),
                MyButton(
                  'Try Again',
                  onPressed: _resetGame,
                ),
                const SizedBox(height: 40),
                MyButton(
                  'Menu',
                  onPressed: () => Get.offNamed(RouterName.doodleJumpMenu),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
