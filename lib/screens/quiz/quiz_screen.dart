import 'dart:math';

import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/screens/quiz/quiz_question_view.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'quiz_controller.dart';

class QuizScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController(Get.arguments));
  }
}

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({Key? key}) : super(key: key);

  void _back() async {
    if (controller.currentPage.value > 0) {
      final result = await Popup.instance.showAlert(
          title: LocaleKeys.quiz_quitWarning.tr,
          message: LocaleKeys.quiz_quitWarningMessage.tr,
          cancelTitle: LocaleKeys.alert_cancel.tr);
      if (result != null && result == true) {
        Get.back();
      }
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Container(
        decoration: const BoxDecoration(gradient: GPColor.bgGradient1),
      )),
      Scaffold(
          backgroundColor: GPColor.transparent,
          appBar: AppBar(
            leading: BackButton(color: Colors.white, onPressed: _back),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.quizCollection.name ?? '',
                  maxLines: 1,
                  style: textStyle(GPTypography.fontButton)?.white().bold(),
                ),
                Obx(() => Text(
                    '${controller.currentPage.value + 1}/${max(controller.listItem.length, controller.quizCollection.numberOfQuestions ?? 0)}',
                    style: textStyle(GPTypography.bodySmall)
                        ?.mergeFontSize(14)
                        .bold()
                        .mergeColor(Colors.yellow)))
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(8),
                child: Obx(() => LinearProgressIndicator(
                    backgroundColor: Colors.blue.withAlpha(204),
                    minHeight: 8,
                    borderRadius: controller.currentPage.value + 1 ==
                            controller.listItem.length
                        ? BorderRadius.zero
                        : const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                    color: Colors.white,
                    value: controller.listItem.isEmpty
                        ? 0
                        : (controller.currentPage.value + 1) /
                            controller.listItem.length))),
          ),
          body: Obx(
            () => PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: controller.onChangePage,
                children: controller.listItem
                    .map((quiz) => QuizQuestionView(
                          quiz: quiz,
                        ))
                    .toList()),
          )),
      // Obx(() => controller.isAnimatingResult.value
      //     ? Positioned.fill(
      //         child: CorrectView(
      //             isCorrect: controller.answerLog.last['isCorrect'] == true))
      //     : Container())
    ]);
  }
}
