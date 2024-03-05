import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:get/get.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_controller.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_popup.dart';
import 'high_scores.dart';
import 'objects/background.dart';
import 'objects/bullet.dart';
import 'objects/cloud_enemy.dart';
import 'objects/coin.dart';
import 'objects/floor.dart';
import 'objects/hearth_enemy.dart';
import 'objects/hero.dart';
import 'objects/platform.dart';
import 'objects/platform_pieces.dart';
import 'objects/power_up.dart';
import 'ui/game_ui.dart';
import 'dart:async' as DASYNC;

final screenSize = Vector2(428, 926);
final worldSize = Vector2(4.28, 9.26);

final random = Random();

enum GameState {
  running,
  gameOver,
}

class MyGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapCallbacks {
  late final MyHero hero;
  DASYNC.Timer? _timer;

  int score = 0;
  int coins = 0;
  int bullets = 0;
  double generatedWorldHeight = 6.7;

  var state = GameState.running;

  // Scale the screenSize by 100 and set the gravity of 15
  MyGame()
      : super(
            zoom: 100,
            cameraComponent: CameraComponent.withFixedResolution(
              width: screenSize.x,
              height: screenSize.y,
            ),
            gravity: Vector2(0, 9.8));

  @override
  Future<void> onLoad() async {
    // Adds a black background to the viewport
    camera.backdrop.add(Background());
    camera.viewport.add(GameUI());
    // camera.viewfinder.anchor = Anchor.center;

    world.add(Floor());
    hero = MyHero();

    // generateNextSectionOfWorld();

    world.add(hero);

    final worldBounds = Rectangle.fromLTRB(
      worldSize.x / 2,
      -double.infinity,
      worldSize.x / 2,
      worldSize.y / 2,
    );
    camera.follow(hero);
    camera.setBounds(worldBounds);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == GameState.running) {
      if (generatedWorldHeight > hero.body.position.y - worldSize.y / 2) {
        generateNextSectionOfWorld();
      }
      final heroY = (hero.body.position.y - worldSize.y) * -1;

      if (score < heroY) {
        score = heroY.toInt();
      }

      if (score - 7 > heroY) {
        hero.hit();
      }

      if (hero.state == HeroState.dead && (score - worldSize.y) > heroY) {
        state = GameState.gameOver;
        HighScores.saveNewScore(score);
        overlays.add('GameOverMenu');
        _showClaimPopup();
      }
    }
  }

  void _showClaimPopup() {
    if (score < 20) return;
    _timer = DASYNC.Timer(const Duration(seconds: 3), () {
      Get.lazyPut(
          () => ClaimWaterController(points: score, gameType: 'doodle_jump'));
      Get.dialog(const ClaimWaterPoup(), barrierDismissible: true);
      _timer?.cancel();
    });
  }

  bool isOutOfScreen(Vector2 position) {
    final heroY = (hero.body.position.y - worldSize.y) * -1;
    final otherY = (position.y - worldSize.y) * -1;

    return otherY < heroY - worldSize.y / 2;

    // final heroPosY = (hero.body.position.y - worldSize.y).abs();
    // final otherPosY = (position.y - worldSize.y).abs();
    // return otherPosY < heroPosY - worldSize.y / 2;
  }

  void generateNextSectionOfWorld() {
    for (int i = 0; i < 10; i++) {
      world.add(Platform(
        x: worldSize.x * random.nextDouble(),
        y: generatedWorldHeight,
      ));
      if (random.nextDouble() < .8) {
        world.add(Platform(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 3 + (random.nextDouble() * 6),
        ));
      }

      if (random.nextBool()) {
        world.add(HearthEnemy(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
      } else if (random.nextDouble() < .2) {
        world.add(CloudEnemy(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
      }
      if (random.nextDouble() < .3) {
        world.add(PowerUp(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight - 1.5,
        ));
        if (random.nextDouble() < 21.2) {
          addCoins();
        }
      }

      generatedWorldHeight -= 2.7;
    }
  }

  void addBrokenPlatformPieces(Platform platform) {
    final x = platform.body.position.x;
    final y = platform.body.position.y;

    final leftSide = PlatformPieces(
      x: x - (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: true,
      type: platform.type,
    );

    final rightSide = PlatformPieces(
      x: x + (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: false,
      type: platform.type,
    );

    world.add(leftSide);
    world.add(rightSide);
  }

  void addCoins() {
    final rows = random.nextInt(15) + 1;
    final cols = random.nextInt(5) + 1;

    final x = (worldSize.x - (Coin.size.x * cols)) * random.nextDouble() +
        Coin.size.x / 2;

    for (int col = 0; col < cols; col++) {
      for (int row = 0; row <= rows; row++) {
        world.add(Coin(
          x: x + (col * Coin.size.x),
          y: generatedWorldHeight + (row * Coin.size.y) - 2,
        ));
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    hero.fireBullet();
  }

  void addBullets() {
    bullets -= 3;
    if (bullets < 0) bullets = 0;
    if (bullets == 0) return;
    final x = hero.body.position.x;
    final y = hero.body.position.y;

    world.add(Bullet(x: x, y: y, accelX: -1.5));
    world.add(Bullet(x: x, y: y, accelX: 0));
    world.add(Bullet(x: x, y: y, accelX: 1.5));
  }

  @override
  void onRemove() {
    super.onRemove();
    hero.cancelSensor();
    _timer?.cancel();
  }

  void reset() {
    state = GameState.running;
    score = 0;
    coins = 0;
    bullets = 0;
    generatedWorldHeight = 6.7;
    hero.reset();

    overlays.remove('GameOverMenu');
  }
}
