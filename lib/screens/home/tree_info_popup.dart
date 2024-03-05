import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/screens/home/tree_widget.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:growtopia/widgets/stroke_text.dart';

class TreeInfoPopup extends StatelessWidget {
  final TreeModel tree;
  const TreeInfoPopup({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: Get.width - 40,
        // height: Get.height - 240,
        padding: const EdgeInsets.all(20),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.asset('assets/images/popup_vertical.png',
                    // centerSlice: const Rect.fromLTRB(30, 30, 30, 30),
                    fit: BoxFit.contain)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StrokeText(tree.name ?? '',
                      style: textStyle(GPTypography.headingLarge)
                          ?.mergeFontSize(40)
                          .merge(const TextStyle(fontFamily: 'BoldenVan'))
                          .white()),
                  const SizedBox(height: 16),
                  StrokeText(tree.rarity?.toUpperCase() ?? 'Common',
                      strokeColor: Colors.white,
                      style: textStyle(GPTypography.body20)
                          ?.mergeColor(Colors.green)
                          .bold()),
                  const SizedBox(height: 20),
                  TreePhoto(
                    url: tree.getPhoto(tree.getActualLevel()),
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(height: 12),
                  Text('Tree level: ${tree.getActualLevel()}',
                      style: textStyle(GPTypography.body16)?.white().bold()),
                  const SizedBox(height: 20),
                  ImageButton(
                      title: 'OK',
                      width: 180,
                      height: 70,
                      fontSize: 24,
                      background: 'assets/images/ok_button_bg.png',
                      onTap: () => Get.back()),
                ],
              ),
            )
          ],
        ));
  }
}
