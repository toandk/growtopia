import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/quiz/quiz_collection_model.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_controller.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_popup.dart';
import 'package:growtopia/utils/sound_manager.dart';

class QuizEndController extends BaseListController {
  final QuizCollectionModel quiz;
  final List gameLog;
  Timer? _timer;

  QuizEndController({required this.quiz, required this.gameLog});

  final RxInt stars = 0.obs;
  final RxString starMessage = ''.obs;
  final RxString correctCountMessage = ''.obs;
  final RxList selectedList = [].obs;
  final RxBool showClaimPopup = false.obs;
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
    _timer?.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    _calculateStars();
    listItem.value = gameLog;
    correctCountMessage.value = LocaleKeys.spellingGame_resultTitle.tr
        .replaceAll('%1', numberOfCorrectAnswers().toString())
        .replaceAll('%2', gameLog.length.toString());
    confettiController.play();
    SoundManager.playFinishGameSound();

    _timer = Timer(const Duration(seconds: 3), () {
      Get.lazyPut(
          () => ClaimWaterController(points: stars.value, gameType: 'quiz'));

      showClaimPopup.value = true;
      Get.dialog(const ClaimWaterPoup(), barrierDismissible: true);
      _timer?.cancel();
    });
  }

  void _calculateStars() {
    int totalCorrect = 0;
    for (int i = 0; i < gameLog.length; i++) {
      totalCorrect += gameLog[i]['isCorrect'] ? 1 : 0;
      selectedList.add(false);
    }
    stars.value = totalCorrect / gameLog.length >= 0.8
        ? 3
        : totalCorrect / gameLog.length >= 0.5
            ? 2
            : 1;
    starMessage.value = [
      LocaleKeys.quiz_oneStarMessage.tr,
      LocaleKeys.quiz_twoStarMessage.tr,
      LocaleKeys.quiz_threeStarMessage.tr
    ][stars.value - 1];
  }

  void onTapQuestion(int index) {
    selectedList[index] = !selectedList[index];
  }

  int numberOfCorrectAnswers() {
    return gameLog.where((element) => element['isCorrect']).length;
  }
}
