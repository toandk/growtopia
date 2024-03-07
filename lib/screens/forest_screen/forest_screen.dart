import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/screens/forest_screen/forest_land_widget.dart';
import 'package:growtopia/screens/home/home_controller.dart';
import 'package:growtopia/widgets/app_bar.dart';
import 'package:growtopia/widgets/dot_indicator.dart';

import '../home/home_screen.dart';
import 'forest_screen_controller.dart';

class ForestScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForestController());
  }
}

class ForestScreen extends GetView<ForestController> {
  const ForestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 115, 167, 122)))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MJAppBar(
              isWhite: false,
              backgroundColor: Colors.transparent,
              titleString: 'Forests',
              rightViews: [
                Obx(() =>
                    WaterDropView(waterDrops: homeController.userWaters.value))
              ]),
          body: Column(
            children: [
              Expanded(
                child: Obx(() => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : PageView(
                        controller: controller.pageController,
                        onPageChanged: controller.onChangePage,
                        children: controller.listItem
                            .asMap()
                            .entries
                            .map((element) => ForestLandWidget(
                                trees: controller.listTrees[element.key],
                                donateWaterAction: controller.donateWaterAction,
                                userInfo: element.value))
                            .toList(),
                      )),
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Center(
                child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.listItem
                        .asMap()
                        .entries
                        .map((element) => DotIndicator(
                            onTap: () => controller.changePage(element.key),
                            isActive:
                                element.key == controller.currentPage.value))
                        .toList())))),
      ],
    );
  }
}
