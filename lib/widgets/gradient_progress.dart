import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';

class GradientProgressView extends StatelessWidget {
  final int value;
  final int maxValue;
  final String text;
  const GradientProgressView(
      {Key? key, required this.value, this.maxValue = 7, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = [for (var i = 0; i < maxValue * 2 - 1; i += 1) i];
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(21)),
        child: Container(
            color: const Color(0xFFF8F8F8),
            child: Stack(
              children: [
                Row(
                    children: list
                        .map((index) => index % 2 == 0
                            ? Brick(isEmpty: index / 2 >= value)
                            : const SizedBox(width: 2))
                        .toList()),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      LocaleKeys.alert_ok.tr.replaceFirst("%s", '$value/7'),
                      style: textStyle(GPTypography.body16)
                          ?.mergeFontWeight(FontWeight.bold),
                    ),
                  ),
                )
              ],
            )));
  }
}

class Brick extends StatelessWidget {
  final bool isEmpty;
  const Brick({Key? key, this.isEmpty = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = ((Get.width - 64) - 6 * 2) / 7 - 0.3;
    return Container(
      height: 42,
      width: width,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          gradient: isEmpty
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFFFDA9A), Color(0xFFFF8574)])),
    );
  }
}
