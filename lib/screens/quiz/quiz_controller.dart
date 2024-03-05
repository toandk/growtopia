import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/quiz/quiz_collection_model.dart';
import 'package:growtopia/models/quiz/quiz_model.dart';
import 'package:growtopia/routes/router_name.dart';
import 'package:growtopia/screens/quiz/quiz_question_controller.dart';
import 'package:growtopia/utils/sound_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class QuizController extends BaseListController {
  final QuizCollectionModel quizCollection;
  late final PageController pageController;
  final RxInt currentPage = 0.obs;
  final List<int> incorrectList = [];
  // final RxList<int> selectedIndexes = <int>[].obs;
  final RxBool isShowTip = false.obs;
  final RxString tipString = ''.obs;
  final RxList answerLog = [].obs;
  final RxBool isAnimatingResult = false.obs;

  QuizController(this.quizCollection);

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (pageController.hasClients && lesson.lastExerciseIndex != 0) {
      //   pageController.jumpToPage(lesson.lastExerciseIndex);
      //   playCurrentExerciseVoice();
      // }
    });
    getListItems();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  Future getListItems() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final hasCached = await _getCachedItems();
      if (!hasCached) {
        final response = await SupabaseAPI.get(
            table: 'quizzes',
            body: {'quiz_collection_id': quizCollection.id ?? ''},
            shouldCache: true);
        _buildQuizzes(response);
      }
    } catch (error) {
      handleError(error);
    }
  }

  Future<bool> _getCachedItems() async {
    final response = await SupabaseAPI.getFromCache(
        table: 'quizzes',
        body: {'quiz_collection_id': quizCollection.id ?? ''});
    if (response != null && response.isNotEmpty) {
      _buildQuizzes(response);
      return true;
    }
    return false;
  }

  void _buildQuizzes(List data) {
    final quizzes = data.map((e) => QuizModel.fromJson(e)).toList();
    quizCollection.quizzes = [...quizzes];
    for (int i = 0; i < quizzes.length; i++) {
      Get.lazyPut(() => QuizQuestionController(quiz: quizzes[i]),
          tag: quizzes[i].id!.toString());
    }
    handleResponse(quizzes, true);
  }

  void onChangePage(int page) {
    currentPage.value = page;
  }

  void playCurrentQuizVoice({int? page}) async {
    final QuizModel quiz = listItem[page ?? currentPage.value];
    if (quiz.voice != null) {
      SoundManager.playAVoice(quiz.voice!);
    }
  }

  void nextQuestion() {
    debugPrint('next question ${currentPage.value} ${pageController.page}');
    if (currentPage.value == listItem.length - 1) {
      _finishGame();
      return;
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      pageController.nextPage(
          duration: const Duration(milliseconds: 1), curve: Curves.linear);
    });
  }

  void _finishGame() {
    debugPrint('finish game');
    Future.delayed(2000.ms, () {
      Get.offNamed(RouterName.quizEnd,
          arguments: {'quiz': quizCollection, 'gameLog': answerLog});
    });
  }

  void logPickingAnswer(bool isCorrect, selectedIndexes) {
    final QuizModel quiz = listItem[currentPage.value];
    answerLog.add({
      'page': currentPage.value,
      'answer':
          selectedIndexes.map((element) => quiz.answers?[element]).toList(),
      'question': quiz.question,
      'isCorrect': isCorrect,
      'correctAnswer':
          quiz.correctAnswers?.map((e) => quiz.answers?[e]).toList(),
    });
    isAnimatingResult.value = true;
    Future.delayed(500.ms, () {
      isAnimatingResult.value = false;
    });
  }
}
