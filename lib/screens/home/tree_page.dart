import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/screens/home/level_up_time_view.dart';
import 'package:growtopia/screens/home/fruits_layer.dart';
import 'package:growtopia/screens/home/tree_widget.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'tree_page_controller.dart';

class TreePage extends StatelessWidget {
  final TreeModel tree;
  final int index;
  const TreePage(this.tree, {Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TreePageController controller = Get.find(tag: tree.id.toString());
    final double photoWidth = min(260, Get.width - 100);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Bounceable(
                      onTap: controller.showTreeInfo,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(() => controller.levelUpRemainTime.value > 0
                              ? CircularPercentIndicator(
                                  radius: photoWidth / 2,
                                  lineWidth: 10.0,
                                  percent: (controller.levelUpTotalTime.value -
                                          controller.levelUpRemainTime.value) /
                                      controller.levelUpTotalTime.value,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor: Colors.white12,
                                  progressColor: Colors.orange,
                                )
                              : Container()),
                          Obx(() => TreePhoto(
                                borderRadius:
                                    BorderRadius.circular(photoWidth / 2 - 10),
                                url: tree.health == -1
                                    ? ''
                                    : tree.getPhoto(controller.level.value),
                                index: index,
                                width: photoWidth - 20,
                                height: photoWidth - 20,
                              )),
                          Obx(() => FruitsLayer(
                              width: photoWidth - 20,
                              height: photoWidth - 20,
                              animated: controller.isAnimatingFruits.value,
                              fruitsCount: controller.fruitsCount.value,
                              onTap: controller.collectSeed)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => controller.levelUpRemainTime.value > 0
                        ? LevelUpTimeView(
                            timeRemain: controller.levelUpRemainTime.value,
                            totalTime: controller.levelUpTotalTime.value)
                        : Container(height: 24)),
                    Obx(() => controller.fruitsCount.value > 0
                        ? ImageButton(
                            width: 160,
                            height: 60,
                            title: 'Collect Fruits',
                            background: 'assets/images/ok_button_bg.png',
                            onTap: controller.collectSeed,
                          )
                        : Container(
                            height: 60,
                          ))
                  ],
                ),
              ),
            ),
            Obx(() => !controller.isPlanted.value
                ? ImageButton(
                    title: 'PLANT',
                    background: 'assets/images/plant_bt.png',
                    onTap: controller.plantAction,
                    width: 180,
                    height: 60,
                  )
                : SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Bounceable(
                                onTap: controller.waterTheTree,
                                child: Image.asset('assets/images/watering.png',
                                    fit: BoxFit.fill, width: 70, height: 70)),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Container(
                                  height: 30,
                                  width: 72,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset('assets/images/water.png',
                                            width: 16, height: 16),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                            controller.level.value - 1 <
                                                    controller
                                                        .tree.waterList!.length
                                                ? controller
                                                    .tree
                                                    .waterList![
                                                        controller.level.value -
                                                            1]
                                                    .toString()
                                                : '',
                                            style:
                                                textStyle(GPTypography.body16)
                                                    ?.mergeColor(
                                                        const Color(0xFF2664b9))
                                                    .merge(const TextStyle(
                                                        fontFamily:
                                                            'BoldenVan'))),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Bounceable(
                              onTap: controller.openGames,
                              child: Image.asset(
                                  'assets/images/icon_play_game.png',
                                  fit: BoxFit.fill,
                                  width: 70,
                                  height: 70),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                Container(
                                    height: 30,
                                    width: 72,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('+',
                                              style: textStyle(
                                                      GPTypography.body16)
                                                  ?.mergeColor(
                                                      const Color(0xFF2664b9))
                                                  .merge(const TextStyle(
                                                      fontFamily:
                                                          'BoldenVan'))),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Image.asset('assets/images/water.png',
                                              width: 16, height: 16),
                                        ],
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 30),
          ]),
        ),
      ],
    );
  }
}
