import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/quiz/quiz_model.dart';
import 'package:growtopia/screens/quiz/quiz_question_controller.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/answer_button.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizQuestionView extends StatelessWidget {
  final QuizModel quiz;
  const QuizQuestionView({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final answers = quiz.answers ?? [];
    final controller =
        Get.find<QuizQuestionController>(tag: quiz.id.toString());
    return Column(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  quiz.photo != null
                      ? GPNetworkImage(
                          url: quiz.photo ?? '',
                          width: 120,
                          height: 120,
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    quiz.question ?? '',
                    textAlign: TextAlign.center,
                    style: textStyle(GPTypography.body20)?.bold().white(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.quiz_pick.tr.toUpperCase(),
                        style: textStyle(GPTypography.body)?.bold().white(),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            '${quiz.correctAnswers?.length ?? 0}',
                            style: textStyle(GPTypography.bodySmall)
                                ?.white()
                                .bold()
                                .mergeFontSize(12),
                          ))).marginOnly(top: 2)
                    ],
                  ),
                  const Spacer(),
                  Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      children: answers
                          .asMap()
                          .entries
                          .map((e) => Obx(() => AnswerButton(
                              width: quiz.isLongAnswer
                                  ? MediaQuery.of(context).size.width - 40
                                  : null,
                              text: e.value,
                              state: controller.getAnswerButtonState(e.key),
                              onTap: () => controller.onTapAnswer(e.key))))
                          .toList()),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              )),
        ),
        Material(
          child: Obx(() => controller.answerStatus.value ==
                  AnswerStatus.notAnwser
              ? _BottomView(
                  onTap: controller.onCheckAnswer,
                  text: LocaleKeys.quiz_checkAnswerButton.tr.toUpperCase(),
                  isActive: controller.isCheckEnabled.value,
                  backgroundColor: Colors.blue)
              : _BottomView(
                  text: (controller.answerStatus.value == AnswerStatus.correct
                          ? LocaleKeys.quiz_correct.tr
                          : LocaleKeys.quiz_incorrect.tr)
                      .toUpperCase(),
                  isActive: true,
                  backgroundColor:
                      controller.answerStatus.value == AnswerStatus.correct
                          ? Colors.green
                          : Colors.red)),
        ),
      ],
    );
  }
}

class _BottomView extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isActive;
  final Color backgroundColor;
  const _BottomView(
      {Key? key,
      this.onTap,
      required this.text,
      required this.isActive,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            color: backgroundColor,
            child: Column(children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    text,
                    style: textStyle(GPTypography.body20)
                        ?.bold()
                        .mergeColor(isActive ? Colors.white : Colors.white60),
                  ),
                ),
              ),
              SafeArea(
                bottom: true,
                child: Container(),
              )
            ])));
  }
}
