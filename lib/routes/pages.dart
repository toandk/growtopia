import 'package:growtopia/screens/doodle_jump/doodle_jump_screen.dart';
import 'package:growtopia/screens/doodle_jump/ui/leaderboards_screen.dart';
import 'package:growtopia/screens/doodle_jump/ui/main_menu_screen.dart';
import 'package:growtopia/screens/forest_screen/forest_screen.dart';
import 'package:growtopia/screens/loading/loading_screen.dart';
import 'package:growtopia/screens/quiz/quiz_end/quiz_end_screen.dart';
import 'package:growtopia/screens/quiz/quiz_screen.dart';
import 'package:growtopia/screens/tabbar/tabbar_screen.dart';
import 'package:growtopia/screens/tetris_game/game_over/game_over_screen.dart';
import 'package:growtopia/screens/tetris_game/panel/page_portrait.dart';
import 'package:get/get.dart';
import 'router_name.dart';

class Pages {
  static List<GetPage> pages = [
    GetPage(
        name: RouterName.loading,
        transitionDuration: Duration.zero,
        page: () => LoadingScreen()),
    GetPage(
        name: RouterName.tabbar,
        page: () => const TabbarScreen(),
        binding: TabbarScreenBinding()),
    GetPage(
        name: RouterName.gameTetris,
        page: () => const TetrisGame(),
        binding: TetrisGameScreenBinding()),
    GetPage(
        name: RouterName.tetrisGameOver,
        page: () => const TetrisGameOverScreen(),
        binding: TetrisGameOverBinding()),
    GetPage(
        name: RouterName.quiz,
        page: () => const QuizScreen(),
        binding: QuizScreenBinding()),
    GetPage(
        name: RouterName.quizEnd,
        page: () => const QuizEndScreen(),
        binding: QuizEndScreenBinding()),
    GetPage(
        transition: Transition.noTransition,
        transitionDuration: Duration.zero,
        name: RouterName.doodleJump,
        page: () => const DoodleJumpGameScreen()),
    GetPage(
        name: RouterName.doodleJumpMenu,
        page: () => const DoodleJumpMainMenuScreen()),
    GetPage(
        name: RouterName.doodleJumpLeaderboard,
        binding: DoodleJumpLeaderboardScreenBinding(),
        page: () => const DoodleJumpLeaderboardScreen()),
    GetPage(
        name: RouterName.forestScreen,
        binding: ForestScreenBinding(),
        page: () => const ForestScreen()),
  ];
}
