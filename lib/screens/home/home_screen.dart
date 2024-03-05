import 'package:growtopia/screens/home/buy_new_tree_page.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/widgets/dot_indicator.dart';

import 'home_controller.dart';
import 'tree_page.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 115, 167,
                        122)))), // Color.fromRGBO(102, 161, 137, 1.0)))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MJAppBar(
              hasBack: false,
              isWhite: false,
              backgroundColor: Colors.transparent,
              titleString: 'Growtopia',
              rightViews: [
                Obx(() =>
                    WaterDropView(waterDrops: controller.userWaters.value))
              ]),
          body: Column(
            children: [
              Expanded(
                child: Obx(() => PageView(
                        controller: controller.pageController,
                        onPageChanged: controller.onChangePage,
                        children: [
                          ...controller.listItem
                              .map((tree) => TreePage(tree))
                              .toList(),
                          BuyNewTreePage(
                            onTap: controller.openShop,
                          )
                        ])),
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
        Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Center(
                child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [...controller.listItem, 1]
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

class WaterDropView extends StatelessWidget {
  final int waterDrops;
  const WaterDropView({super.key, required this.waterDrops});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Image.asset('assets/images/water.png', width: 24, height: 24),
          const SizedBox(width: 8),
          Text(
            waterDrops.toString(),
            style: textStyle(GPTypography.body16)
                ?.mergeColor(Colors.yellow)
                .mergeFontSize(14)
                .merge(const TextStyle(fontFamily: 'BoldenVan')),
          ).marginOnly(top: 2),
        ],
      ),
    );
  }
}
