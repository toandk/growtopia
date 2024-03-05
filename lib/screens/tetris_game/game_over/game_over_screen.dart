import 'package:confetti/confetti.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_controller.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'game_over_controller.dart';
import 'header_view.dart';
import 'rank_row.dart';

class TetrisGameOverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TetrisGameOverController(Get.arguments));
    final points = Get.arguments['result']['points'];
    Get.lazyPut(() => ClaimWaterController(points: points, gameType: 'tetris'));
  }
}

class TetrisGameOverScreen extends GetView<TetrisGameOverController> {
  const TetrisGameOverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Container(
        decoration: const BoxDecoration(gradient: GPColor.bgGradient4),
      )),
      Obx(() => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MJAppBar(
            titleString: controller.game.name ?? '',
            backgroundColor: Colors.transparent,
            isWhite: false,
            hasBack: controller.showClaimPopup.value,
          ),
          body: Column(
            children: [
              HeaderView(data: controller.gameResult),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      itemCount: controller.listItem.length,
                      itemBuilder: (context, index) {
                        return RankRow(
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
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Obx(() => controller.gameModel.value.id != null
                      ? RankRow(
                          gameModel: controller.gameModel.value,
                          index: controller.userRank.value - 1,
                          isMe: true,
                        )
                      : Container()),
                ),
              )
            ],
          ))),
      Positioned.fill(
          top: 110,
          left: Get.width / 2,
          child: ConfettiWidget(
            confettiController: controller.confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ))
    ]);
  }
}
