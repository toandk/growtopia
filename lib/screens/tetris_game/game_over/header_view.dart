import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/screens/tetris_game/game_over/game_over_controller.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/line_button.dart';
import 'package:growtopia/widgets/stroke_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class HeaderView extends StatelessWidget {
  final Map<String, dynamic> data;
  const HeaderView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TetrisGameOverController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${LocaleKeys.game_tetris_points.tr}:',
                              style: textStyle(GPTypography.body16)
                                  ?.bold()
                                  .white(),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(data['points'].toString(),
                                style: textStyle(GPTypography.body16)
                                    ?.bold()
                                    .white())
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${LocaleKeys.game_tetris_level.tr}:',
                              style: textStyle(GPTypography.body16)
                                  ?.bold()
                                  .white(),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(data['level'].toString(),
                                style: textStyle(GPTypography.body16)
                                    ?.bold()
                                    .white())
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${LocaleKeys.game_tetris_cleans.tr}:',
                              style: textStyle(GPTypography.body16)
                                  ?.bold()
                                  .white(),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(data['cleans'].toString(),
                                style: textStyle(GPTypography.body16)
                                    ?.bold()
                                    .white())
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            Obx(() => controller.gameModel.value.score != null &&
                    controller.gameModel.value.score! == data['points']!
                ? Positioned(
                    right: 12,
                    top: 40,
                    child: Image.asset(
                      'assets/images/new-hscore.png',
                      color: Colors.yellow,
                    ))
                : Container()),
            Align(
                alignment: Alignment.topCenter,
                child: StrokeText(LocaleKeys.game_tetris_youWon.tr,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                    style: textStyle(GPTypography.h3)
                        ?.mergeFontWeight(FontWeight.w900)
                        .mergeFontSize(30)
                        .mergeColor(Colors.purple)))
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LineBorderButton(
                text: LocaleKeys.game_tetris_retry.tr,
                height: 50,
                width: Get.width / 2 - 35,
                onTap: Get.find<TetrisGameOverController>().playAgain,
              ),
              LineBorderButton(
                text: LocaleKeys.game_tetris_exit.tr,
                height: 50,
                width: Get.width / 2 - 35,
                onTap: Utils.back,
              ),
            ],
          )
        ],
      ),
    );
  }
}
