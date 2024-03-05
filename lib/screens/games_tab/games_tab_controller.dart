import 'package:get/get.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/quiz/quiz_collection_model.dart';
import 'package:growtopia/models/spelling_game/spelling_game_model.dart';
import 'package:growtopia/routes/router_name.dart';

class GamesTabController extends BaseController {
  void onOpenGame(int index) async {
    // final String gameName = ['quiz', 'tetris', 'pacman', 'doodle_jump'][index];
    if (index == 0) {
      Get.toNamed(RouterName.quiz,
          arguments: QuizCollectionModel(
              id: 'b5b0f310-62e6-4933-a6e6-54bcc7347302', name: 'Quiz Game'));
    } else if (index == 1) {
      final game = SpellingGameModel(
          id: 'tetris', type: 'tetris', words: ['earth', 'water', 'green']);
      Get.toNamed(RouterName.gameTetris, arguments: game);
    } else if (index == 2) {
    } else if (index == 3) {
      Get.toNamed(RouterName.doodleJumpMenu);
    }
  }
}
