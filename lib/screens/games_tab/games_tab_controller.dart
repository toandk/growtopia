import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/quiz/quiz_collection_model.dart';
import 'package:growtopia/models/spelling_game/spelling_game_model.dart';
import 'package:growtopia/routes/router_name.dart';
import 'package:growtopia/utils/local_service.dart';
import 'package:growtopia/utils/popup.dart';

class GamesTabController extends BaseController {
  void onOpenGame(int index) async {
    // final String gameName = ['quiz', 'tetris', 'pacman', 'doodle_jump'][index];
    if (index == 0) {
      final quiz = await _getRandomQuiz();
      if (quiz != null) {
        Get.toNamed(RouterName.quiz, arguments: quiz);
        _savePlayedQuiz(quiz.id ?? '');
      } else {
        Popup.instance.showSnackBar(
            message: 'You played all the quizzes. Please come back later.');
      }
    } else if (index == 1) {
      final game = SpellingGameModel(
          id: 'tetris', type: 'tetris', words: ['earth', 'water', 'green']);
      Get.toNamed(RouterName.gameTetris, arguments: game);
    } else if (index == 2) {
    } else if (index == 3) {
      Get.toNamed(RouterName.doodleJumpMenu);
    }
  }

  Future<QuizCollectionModel?> _getRandomQuiz() async {
    try {
      final res = await SupabaseAPI.get(table: 'quizz_collection', body: {});
      if (res.isNotEmpty) {
        final quizzes =
            res.map((value) => QuizCollectionModel.fromJson(value)).toList();
        for (final quiz in quizzes) {
          if (!_isPlayedQuiz(quiz.id)) {
            return quiz;
          }
        }
        return quizzes[Random().nextInt(quizzes.length)];
      }
    } catch (error) {
      debugPrint('error $error');
    }
    return QuizCollectionModel(
        id: 'b5b0f310-62e6-4933-a6e6-54bcc7347302', name: 'Quiz Game');
  }

  void _savePlayedQuiz(String quizId) {
    final playedQuizzes = LocalService.get('played_quiz', false) ?? '';
    LocalService.save('played_quiz', playedQuizzes + ',' + quizId, false);
  }

  bool _isPlayedQuiz(String quizId) {
    final String playedQuizzes = LocalService.get('played_quiz', false) ?? '';
    return playedQuizzes.split(',').contains(quizId);
  }
}
