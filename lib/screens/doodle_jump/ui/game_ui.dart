import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../assets.dart';
import '../my_game.dart';
import '../utils.dart';
import 'tap_sprite_button.dart';

final textPaint = TextPaint(
  style: const TextStyle(
    color: Colors.white,
    fontSize: 35,
    // fontWeight: FontWeight.w500,
    fontFamily: 'BoldenVan',
  ),
);

class GameUI extends PositionComponent with HasGameRef<MyGame> {
  // Keep track of the number of bodies in the world.
  final totalBodies =
      TextComponent(position: Vector2(5, 895), textRenderer: textPaint);

  final totalScore = TextComponent(textRenderer: textPaint);

  final totalCoins = TextComponent(textRenderer: textPaint);

  final totalBullets = TextComponent(textRenderer: textPaint);

  final coin = SpriteComponent(sprite: Assets.coin, size: Vector2.all(25));
  final gun = SpriteComponent(sprite: Assets.gun, size: Vector2.all(35));

  // Keep track of the frames per second
  final fps =
      FpsTextComponent(position: Vector2(5, 850), textRenderer: textPaint);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position.y = isIOS ? 25 : 0;
    final btPause = SpriteButtonComponent(
      button: Assets.buttonPause,
      buttonDown: Assets.buttonBack,
      size: Vector2(35, 35),
      position: Vector2(390, 50),
      priority: 10,
      onPressed: () {
        gameRef.overlays.add('PauseMenu');
        gameRef.paused = true;
      },
    );
    final leftButton = TapSpriteButton(
        button: Assets.leftButton,
        buttonDown: Assets.leftButton,
        size: Vector2(45, 45),
        position: Vector2(10, gameRef.size.y - 120),
        priority: 10,
        onPressedDown: () {
          gameRef.hero.moveLeft();
        },
        onPressedUp: () {
          gameRef.hero.stopMoving();
        });

    final rightButton = TapSpriteButton(
        button: Assets.rightButton,
        buttonDown: Assets.rightButton,
        size: Vector2(45, 45),
        position: Vector2(gameRef.size.x - 60, gameRef.size.y - 120),
        priority: 10,
        onPressedDown: () {
          gameRef.hero.moveRight();
        },
        onPressedUp: () {
          gameRef.hero.stopMoving();
        });

    add(btPause);
    add(coin);
    add(gun);
    // add(fps);
    add(totalBodies);
    add(totalScore);
    add(totalCoins);
    add(totalBullets);
    add(leftButton);
    add(rightButton);
  }

  @override
  void update(double dt) {
    super.update(dt);
    totalBodies.text = 'Bodies: ${game.world.physicsWorld.bodies.length}';
    totalScore.text = 'Score ${gameRef.score}';
    totalCoins.text = 'x${gameRef.coins}';
    totalBullets.text = 'x${gameRef.bullets}';

    final posX = screenSize.x - totalCoins.size.x;
    totalCoins.position
      ..x = posX - 5
      ..y = 5;
    coin.position
      ..x = posX - 35
      ..y = 12;

    gun.position
      ..x = 5
      ..y = 12;
    totalBullets.position
      ..x = 40
      ..y = 8;

    totalScore.position
      ..x = screenSize.x / 2 - totalScore.size.x / 2
      ..y = 5;
  }

// @override
// void render(Canvas canvas) {
//   canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
//       BasicPalette.blue.paint());
// }
}
