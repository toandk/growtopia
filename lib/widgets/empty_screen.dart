import 'package:flutter/material.dart';
import 'package:growtopia/theme/buttons.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';

import 'package:get/get.dart';

class EmptyScreen extends StatelessWidget {
  final String imageName;
  final String? title;
  final String? subTitle;
  final String? actionTitle;
  final Widget? actionWidget;
  final VoidCallback? action;

  const EmptyScreen(
      {Key? key,
      this.imageName = "assets/images/img-empty-content.png",
      this.title,
      this.subTitle,
      this.actionTitle,
      this.actionWidget,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final contentHeight = 144 +
    //     16 +
    //     (title != null ? 28 : 0) +
    //     (subTitle != null ? 28 : 0) +
    //     (actionWidget != null ? 72 : 0);
    // const navHeight = 84;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Image.asset(imageName)),
          title != null
              ? Text(title!, style: textStyle(GPTypography.headingXLarge))
                  .paddingOnly(bottom: 8)
              : const SizedBox(),
          subTitle != null
              ? Text(
                  subTitle!,
                  style: textStyle(GPTypography.bodyLarge)
                      ?.mergeColor(GPColor.contentSecondary),
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
          actionTitle != null
              ? AccentWorkPrimaryButton(actionTitle!, action,
                      height: 48, wrapContent: true, borderRadius: 8)
                  .paddingOnly(top: 24)
              : actionWidget ?? const SizedBox(),
        ],
      ),
    );
    // .paddingOnly(top: Get.height / 2 - contentHeight / 2 - navHeight - 20);
  }
}
