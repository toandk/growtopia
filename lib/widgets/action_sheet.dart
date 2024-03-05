import 'dart:math';

import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _rowHeight = 44;

class ActionSheetPicker extends StatelessWidget {
  final List<String> data;
  final List<Widget>? leftWidgets;
  final List? icons;
  final List? righWidgets;
  final int selectedIndex;
  final String title;
  const ActionSheetPicker(
      {Key? key,
      required this.data,
      this.icons,
      required this.selectedIndex,
      required this.title,
      this.righWidgets,
      this.leftWidgets})
      : super(key: key);

  void onTap(int index) {
    Get.back(result: index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: GPColor.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 50,
                child: Center(
                  child: Text(title, style: textStyle(GPTypography.fontButton)),
                )),
            SizedBox(
              height: (_rowHeight + 10) * min(data.length, 5) + _rowHeight / 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => _ItemRow(
                          title: data[index],
                          leftWidget:
                              leftWidgets != null ? leftWidgets![index] : null,
                          index: index,
                          rightWidget:
                              righWidgets != null ? righWidgets![index] : null,
                          onTap: onTap,
                          icon: icons != null ? icons![index] : null,
                          selected: selectedIndex == index,
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final Widget? leftWidget;
  final Icon? icon;
  final Widget? rightWidget;
  final int index;
  final bool selected;
  final void Function(int index) onTap;
  const _ItemRow(
      {Key? key,
      required this.title,
      this.icon,
      required this.index,
      required this.selected,
      required this.onTap,
      this.rightWidget,
      this.leftWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(index),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: GPColor.linePrimary),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(_rowHeight / 2))),
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              height: _rowHeight,
              child: Row(
                children: [
                  leftWidget != null
                      ? leftWidget!.marginOnly(right: 8)
                      : Container(),
                  icon != null ? icon!.marginOnly(right: 8) : Container(),
                  Text(
                    title,
                    style: textStyle(GPTypography.body16),
                  ),
                  const Spacer(),
                  rightWidget != null ? rightWidget! : Container(),
                  selected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : Container()
                ],
              )),
        ),
      ],
    );
  }
}
