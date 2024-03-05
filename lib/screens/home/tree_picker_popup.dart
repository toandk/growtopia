import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/screens/home/tree_widget.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';

class TreePickerPopup extends StatelessWidget {
  final List trees;
  final Function(int index) onTap;
  const TreePickerPopup({Key? key, required this.trees, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: 44,
            child: Center(
                child: Text(
              LocaleKeys.home_chooseATreeToPlant.tr,
              style: textStyle(GPTypography.fontButton),
            ))),
        SizedBox(
            height: 260,
            child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: GridView.builder(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 20),
                    itemCount: trees.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12.h375,
                        crossAxisSpacing: 12.h375,
                        childAspectRatio: 5 / 6),
                    itemBuilder: (context, index) {
                      return _TreeCell(
                          tree: trees[index], onTap: (() => onTap(index)));
                    }))),
      ],
    );
  }
}

class _TreeCell extends StatelessWidget {
  final TreeModel tree;
  final Function() onTap;
  const _TreeCell({Key? key, required this.tree, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  spreadRadius: 0.0,
                  blurRadius: 4.0,
                )
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TreeWidget(tree: tree),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(tree.name ?? '',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle(GPTypography.bodySmallBold)
                                      ?.bold()
                                      .mergeFontSize(10.sp)),
                              const SizedBox(height: 2),
                            ],
                          )),
                    )
                  ],
                )),
          ),
        ));
  }
}
