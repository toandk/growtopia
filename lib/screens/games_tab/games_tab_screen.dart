import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:growtopia/screens/home/home_controller.dart';
import 'package:growtopia/screens/home/home_screen.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/app_bar.dart';
import 'package:growtopia/widgets/stroke_text.dart';

import 'games_tab_controller.dart';

class GamesTabScreen extends GetView<GamesTabController> {
  const GamesTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return Stack(children: [
      Positioned.fill(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFb8c0ff), Color(0xFFbbd0ff)])))),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MJAppBar(
              hasBack: false,
              isWhite: false,
              backgroundColor: Colors.transparent,
              titleString: 'Mini Games',
              rightViews: [
                Obx(() =>
                    WaterDropView(waterDrops: homeController.userWaters.value))
              ]),
          body: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: GridView.builder(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 4 / 5),
                  itemBuilder: (context, index) {
                    return GameCell(
                        index: index,
                        onTap: () => controller.onOpenGame(index));
                  })))
    ]);
  }
}

class GameCell extends StatelessWidget {
  final Function() onTap;
  final int index;
  const GameCell({Key? key, required this.onTap, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gameName = ['quiz', 'tetris', 'pacman', 'doodle_jump'][index];
    final String nameText = ['Quiz', 'Tetris', 'Pacman', 'Doodle Jump'][index];
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Column(children: [
        Expanded(
          flex: 4,
          child: Bounceable(
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          spreadRadius: 0.0,
                          blurRadius: 4.0,
                        )
                      ]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                              'assets/images/${gameName}_game.jpg',
                              fit: BoxFit.cover))))),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: StrokeText(
              nameText,
              style: textStyle(GPTypography.body20)?.merge(TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              )),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]),
    );
  }
}
