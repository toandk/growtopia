import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/models/quiz/quiz_model.dart';
import 'package:growtopia/utils/sound_manager.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/answer_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'quiz_controller.dart';

enum AnswerStatus { notAnwser, correct, incorrect }

class QuizQuestionController extends BaseController {
  final QuizModel quiz;
  String get tag => quiz.id!.toString();
  final Rx<AnswerStatus> answerStatus = (AnswerStatus.notAnwser).obs;
  final RxList selectedIndexes = [].obs;
  final RxBool isCheckEnabled = false.obs;

  QuizQuestionController({required this.quiz});

  void onTapAnswer(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      if (quiz.correctAnswers?.length == 1) {
        selectedIndexes.clear();
      }
      selectedIndexes.add(index);
    }
    isCheckEnabled.value =
        selectedIndexes.length == quiz.correctAnswers?.length;
  }

  void onCheckAnswer() {
    QuizController parentController = Get.find();
    if (parentController.isAnimatingResult.value ||
        parentController.answerLog.length - 1 ==
            parentController.currentPage.value) return;

    selectedIndexes.sort(((a, b) => a.compareTo(b)));
    quiz.correctAnswers?.sort(((a, b) => a.compareTo(b)));
    final isCorrect = selectedIndexes.map((e) => e.toString()).join(',') ==
        quiz.correctAnswers?.map((e) => e.toString()).join(',');

    answerStatus.value =
        isCorrect ? AnswerStatus.correct : AnswerStatus.incorrect;
    parentController.logPickingAnswer(isCorrect, selectedIndexes);

    Future.delayed(100.ms, () {
      if (!isCorrect) {
        handleWrongAnswer();
      } else {
        SoundManager.playCorrectSound();
      }
      parentController.nextQuestion();
    });
  }

  void handleWrongAnswer() {
    Utils.vibrateDevice();
    SoundManager.playWrongSound();
  }

  ButtonState getAnswerButtonState(int index) {
    if (answerStatus.value == AnswerStatus.notAnwser) {
      return selectedIndexes.contains(index)
          ? ButtonState.selected
          : ButtonState.normal;
    }
    return quiz.correctAnswers?.contains(index) == true
        ? ButtonState.correct
        : ButtonState.normal;
  }
}
