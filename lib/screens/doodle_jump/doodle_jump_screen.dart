import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'my_game.dart';
import 'ui/game_over_menu.dart';
import 'ui/pause_menu.dart';

class DoodleJumpGameScreen extends StatelessWidget {
  const DoodleJumpGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
      overlayBuilderMap: {
        'GameOverMenu': (context, MyGame game) {
          return GameOverMenu(game: game);
        },
        'PauseMenu': (context, MyGame game) {
          return PauseMenu(game: game);
        }
      },
    );
  }
}
