import 'dart:math';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/screens/games_tab/games_tab_controller.dart';
import 'package:growtopia/screens/games_tab/games_tab_screen.dart';
import 'package:growtopia/screens/shop/shop_controller.dart';
import 'package:growtopia/screens/shop/shop_screen.dart';
import 'package:growtopia/screens/tabbar/tabbar_controller.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../home/home_screen.dart';

class TabbarScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabbarController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => GamesTabController());
    Get.lazyPut(() => ShopController());
  }
}

class TabbarScreen extends GetView<TabbarController> {
  const TabbarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: GPColor.transparent,
      body: Obx(() => IndexedStack(
          index: controller.selectedTabIndex.value,
          children: const [HomeScreen(), ShopScreen(), GamesTabScreen()])),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() => DotNavigationBar(
                currentIndex: controller.selectedTabIndex.value,
                onTap: controller.changeIndex,
                dotIndicatorColor: Colors.transparent,
                unselectedItemColor: Colors.black12,
                enablePaddingAnimation: false,
                backgroundColor: Colors.white54,
                itemPadding:
                    const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                marginR:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 0),
                paddingR:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                items: [
                  DotNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/tree_tab.png',
                      width: 40,
                      height: 40,
                    ),
                    // icon: const Icon(
                    //   Icons.forest,
                    // ),
                    selectedColor: const Color.fromRGBO(102, 161, 137, 1.0),
                  ),

                  /// Likes
                  DotNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/shop_tab.png',
                      width: 40,
                      height: 40,
                    ),
                    // icon: const Icon(
                    //   Icons.shopping_cart,
                    // ),
                    selectedColor: Colors.blueAccent,
                  ),

                  /// Search
                  DotNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/game_tab.png',
                      width: 40,
                      height: 40,
                    ),
                    // icon: const Icon(
                    //   Icons.gamepad,
                    // ),
                    selectedColor: const Color(0xFF7579ff),
                  ),
                ],
              )),
        ],
      ),
      // bottomNavigationBar: Obx(() => SalomonBottomBar(
      //       backgroundColor: const Color(0x00ffffff),
      //       currentIndex: controller.selectedTabIndex.value,
      //       items: [
      //         SalomonBottomBarItem(
      //           icon: const Icon(Icons.home),
      //           title: Text(LocaleKeys.tabbar_home.tr,
      //               style: textStyle(GPTypography.bodySmallBold)
      //                   ?.mergeColor(Colors.purple)),
      //           unselectedColor: GPColor.contentTertiary,
      //           selectedColor: Colors.purple,
      //         ),
      //         SalomonBottomBarItem(
      //           icon: const Icon(Icons.shop),
      //           title: Text(LocaleKeys.tabbar_shop.tr,
      //               style: textStyle(GPTypography.bodySmallBold)
      //                   ?.mergeColor(Colors.pink)),
      //           unselectedColor: GPColor.contentTertiary,
      //           selectedColor: Colors.pink,
      //         ),
      //         SalomonBottomBarItem(
      //           icon: const Icon(Icons.sports_esports),
      //           title: Text(LocaleKeys.tabbar_games.tr,
      //               style: textStyle(GPTypography.bodySmallBold)
      //                   ?.mergeColor(Colors.teal)),
      //           unselectedColor: GPColor.contentTertiary,
      //           selectedColor: Colors.teal,
      //         ),
      //         SalomonBottomBarItem(
      //           icon: const Icon(Icons.account_circle),
      //           title: Text(LocaleKeys.tabbar_profile.tr,
      //               style: textStyle(GPTypography.bodySmallBold)
      //                   ?.mergeColor(Colors.blueGrey)),
      //           unselectedColor: GPColor.contentTertiary,
      //           selectedColor: Colors.blueGrey,
      //         ),
      //       ],
      //       onTap: controller.changeIndex,
      //     ))
    );
  }
}
