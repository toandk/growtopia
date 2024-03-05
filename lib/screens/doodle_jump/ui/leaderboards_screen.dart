import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/played_game/played_game_model.dart';
import 'package:growtopia/models/spelling_game/spelling_game_model.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/screens/doodle_jump/ui/leaderboards_controller.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:growtopia/widgets/stroke_text.dart';

import '../assets.dart';
import 'widgets/my_text.dart';

class DoodleJumpLeaderboardScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DJLeaderboardsController({
          'game': SpellingGameModel(id: 'doodle_jump', type: 'doodle_jump'),
          'result': {'score': 0}
        }));
  }
}

class DoodleJumpLeaderboardScreen extends GetView<DJLeaderboardsController> {
  const DoodleJumpLeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/ui/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              top: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SpriteWidget(
                          sprite: Assets.buttonBack,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      StrokeText(
                        'Best Scores',
                        style: textStyle(GPTypography.body20)
                            ?.mergeFontSize(30)
                            .white(),
                      ),
                      Container()
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          itemCount: controller.listItem.length,
                          itemBuilder: (context, index) {
                            return _RankRow(
                              gameModel: controller.listItem[index],
                              index: index,
                            );
                          }),
                    ),
                  ),
                  SafeArea(
                    bottom: true,
                    child: Container(
                      height: 90,
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Obx(() => controller.gameModel.value.id != null
                          ? _RankRow(
                              gameModel: controller.gameModel.value,
                              index: controller.userRank.value - 1,
                              isMe: true,
                            )
                          : Container()),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final PlayedGameModel gameModel;
  final int index;
  final bool isMe;
  const _RankRow(
      {Key? key,
      required this.gameModel,
      required this.index,
      this.isMe = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isMe
        ? Colors.deepOrange
        : (index == 0
            ? Colors.deepOrange
            : (index == 1
                ? Colors.orange
                : index == 2
                    ? Colors.blue
                    : Colors.black));
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 12),
      // decoration:
      //     BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 20),
            MyText(
              '${index + 1}.',
              color: color,
              fontSize: 20,
            ),
            const SizedBox(width: 12),
            GPNetworkImage(
              url: gameModel.user?.avatarUrl ?? '',
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(20),
              placeholder: Constants.defaultAvatar,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MyText(
                gameModel.user?.id == TokenManager.userInfo.value.id
                    ? LocaleKeys.game_tetris_you.tr
                    : gameModel.user?.name ?? '',
                fontSize: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            MyText(
              gameModel.score?.toString() ?? '',
              color: color,
              fontSize: 20,
            ),
            const SizedBox(width: 4),
            MyText(
              LocaleKeys.game_tetris_pointShort.tr,
              color: color,
              fontSize: 20,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
