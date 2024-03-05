import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/circular_button.dart';

class BuyNewTreePage extends StatelessWidget {
  final Function() onTap;
  const BuyNewTreePage({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularButton(
          size: 200,
          icon:
              Image.asset('assets/images/icon_buy.png', width: 40, height: 40),
          onTap: onTap,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          LocaleKeys.home_buyATreeToPlant.tr,
          style: textStyle(GPTypography.body16)?.mergeColor(Colors.white),
        )
      ]),
    );
  }
}
