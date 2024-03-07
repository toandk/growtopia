import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:growtopia/widgets/image_button.dart';

import 'header_view.dart';
import 'quiz_end_controller.dart';

class QuizEndScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizEndController(
        quiz: Get.arguments['quiz'], gameLog: Get.arguments['gameLog']));
  }
}

class QuizEndScreen extends GetView<QuizEndController> {
  const QuizEndScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPColor.bgTertiary,
      appBar: MJAppBar(
        titleString: LocaleKeys.quiz_endTitle.tr,
        isWhite: false,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Obx(() => ListView.builder(
                    itemCount: controller.listItem.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return HeaderView(
                            gameLog: controller.gameLog, quiz: controller.quiz);
                      }
                      return Obx(() => _QuestionItem(
                          question: controller.listItem[index - 1],
                          isSelected: controller.selectedList[index - 1],
                          onTap: () => controller.onTapQuestion(index - 1)));
                    })),
              ),
              const _BottomView()
            ],
          ),
          Positioned.fill(
              top: 110,
              left: Get.width / 2,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
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
      ),
    );
  }
}

class _QuestionItem extends StatelessWidget {
  final Map<String, dynamic> question;
  final bool isSelected;
  final Function() onTap;
  const _QuestionItem(
      {Key? key,
      required this.question,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: GPColor.bgTertiary,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
              color: GPColor.bgPrimary, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(children: [
                  question['isCorrect']
                      ? Icon(Icons.check, color: GPColor.green, size: 24.sp)
                      : Icon(Icons.close, color: GPColor.red, size: 24.sp),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      (question['question'] as String).capitalizeFirst ?? '',
                      style:
                          textStyle(GPTypography.body16)?.mergeFontSize(16.sp),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: GPColor.contentPrimary,
                    size: 20.h375,
                  ),
                ]),
              ),
              isSelected
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const SizedBox(height: 0),
                          Container(height: 1, color: GPColor.linePrimary),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: RichText(
                                text: TextSpan(
                                  text: '${LocaleKeys.quiz_yourAnswer.tr}: ',
                                  style: textStyle(GPTypography.body16)
                                      ?.bold()
                                      .mergeFontSize(16.sp),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: question['answer'].join(', '),
                                        style: textStyle(GPTypography.body16)
                                            ?.mergeFontSize(16.sp))
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: RichText(
                                text: TextSpan(
                                  text: '${LocaleKeys.quiz_correctAnswer.tr}: ',
                                  style: textStyle(GPTypography.body16)
                                      ?.bold()
                                      .mergeFontSize(16.sp),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: question['correctAnswer']
                                            .join(', '),
                                        style: textStyle(GPTypography.body16)
                                            ?.mergeFontSize(16.sp))
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                        ])
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomView extends StatelessWidget {
  const _BottomView({Key? key}) : super(key: key);

  void _continueAction() async {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GPColor.bgPrimary,
      child: SafeArea(
        top: false,
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
            child: ImageButton(
                title: LocaleKeys.quiz_continueButton.tr,
                width: 180,
                height: 70,
                fontSize: 24,
                background: 'assets/images/ok_button_bg.png',
                onTap: _continueAction)),
      ),
    );
  }
}
