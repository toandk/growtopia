import 'dart:math';

import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/screens/tetris_game/panel/word_button.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neon_widgets/neon_widgets.dart';
import '../gamer/constants.dart';
import '../gamer/game_state.dart';
import '../gamer/gamer.dart';
import '../gamer/keyboard.dart';
import 'controller.dart';
import 'screen.dart';

part 'page_land.dart';

class TetrisGameScreenBinding extends Bindings {
  @override
  void dependencies() {
    GameConstants.genWordParts(Get.arguments);
  }
}

class TetrisGame extends StatelessWidget {
  const TetrisGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Game(child: KeyboardController(child: PagePortrait())),
    );
  }
}

class PagePortrait extends StatelessWidget {
  const PagePortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenW = GameConstants.getGameScreenWidth(context);

    return Stack(
      children: [
        // Positioned.fill(
        //     child: Container(
        //   decoration: const BoxDecoration(gradient: GPColor.bgGradient4),
        // )),
        Positioned.fill(
            child: Image.asset(
          'assets/images/tetris_bg2.jpg',
          fit: BoxFit.cover,
        )),
        SizedBox.expand(
          child: Padding(
            padding: MediaQuery.of(context).padding,
            child: Column(
              children: <Widget>[
                Screen(width: screenW),
                Expanded(
                    child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () => Game.of(context).pauseOrResume(),
                      child: Container(
                        width: min(50.h375, 70),
                        height: min(50.h375, 70),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Icon(
                            GameState.of(context).states == GameStates.running
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 30.h375,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeonText(
                              text: LocaleKeys.game_tetris_listWords.tr
                                  .toUpperCase(),
                              fontWeight: FontWeight.w700,
                              textSize: 14.sp,
                              spreadColor: Colors.pink,
                              blurRadius: 8,
                              textColor: Colors.white),
                          const SizedBox(
                            height: 4,
                          ),
                          Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: GameConstants.LIST_WORDS
                                  .map(
                                      (e) => WordButton(title: e.toUpperCase()))
                                  .toList()),
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
