import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/screens/home/home_controller.dart';
import 'package:growtopia/screens/home/home_screen.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/app_bar.dart';

import 'shop_controller.dart';
import 'shop_item_cell.dart';

class ShopScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopController());
  }
}

class ShopScreen extends GetView<ShopController> {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Scaffold(
      backgroundColor: const Color(0xffadb5bd),
      appBar: MJAppBar(
        hasBack: false,
        isWhite: false,
        backgroundColor: Colors.transparent,
        titleString: "Shop",
        rightViews: [
          Obx(() => WaterDropView(
              waterDrops: homeController.userWaters.value,
              fruits: homeController.userFruits.value))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 120),
          child: Obx(() => GridView.builder(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20),
              itemCount: controller.listItem.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.h375,
                  crossAxisSpacing: 12.h375,
                  childAspectRatio: 4 / 8),
              itemBuilder: (context, index) {
                return ShopItemCell(
                    item: controller.listItem[index],
                    index: index,
                    onTap: controller.onSelectAnItem);
              }))),
    );
  }
}
