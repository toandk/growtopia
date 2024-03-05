import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/models/quiz/quiz_collection_model.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';

import 'quiz_end_controller.dart';
import 'result_star.dart';

class HeaderView extends StatelessWidget {
  final List gameLog;
  final QuizCollectionModel quiz;
  const HeaderView({Key? key, required this.gameLog, required this.quiz})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuizEndController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            // height: 220.h375,
            color: Colors.blue,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Obx(() => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GameResultStar(
                            size: 60.h375,
                            type: controller.stars.value >= 2
                                ? StarType.win
                                : StarType.lose,
                            isAnimating: true),
                        const SizedBox(width: 20),
                        GameResultStar(
                                type: StarType.win,
                                size: 100.h375,
                                isAnimating: true)
                            .marginOnly(bottom: 40),
                        const SizedBox(width: 20),
                        GameResultStar(
                            size: 60.h375,
                            type: controller.stars.value >= 3
                                ? StarType.win
                                : StarType.lose,
                            isAnimating: true),
                      ],
                    )),
                // const SizedBox(height: 20),
                Obx(() => Text(
                      controller.starMessage.value,
                      textAlign: TextAlign.center,
                      style: textStyle(GPTypography.body20)
                          ?.bold()
                          .white()
                          .mergeFontSize(20.sp),
                    )),
                SizedBox(height: 12.h375),
              ],
            )),
        const SizedBox(height: 20),
        Center(
          child: Obx(() => Text(controller.correctCountMessage.value,
              style: textStyle(GPTypography.body16)
                  ?.medium()
                  .mergeFontSize(16.sp))),
        ),
        SizedBox(height: 12.h375),
      ],
    );
  }
}
