import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/shop_item/shop_item_model.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:growtopia/widgets/network_image.dart';

class ShopItemCell extends StatelessWidget {
  final ShopItemModel item;
  final Function(int index) onTap;
  final int index;
  const ShopItemCell(
      {Key? key, required this.item, required this.onTap, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
        onTap: () => onTap(index),
        child: Container(
          decoration: BoxDecoration(
              gradient: const RadialGradient(colors: [
                Color(0xFFfff3b0),
                Color(0xFFeff6e0),
              ], radius: 0.8),
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
            child: Stack(
              children: [
                // Positioned.fill(
                //     child: Image.asset(
                //   'assets/images/popup_vertical.png',
                //   fit: BoxFit.fill,
                // )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: GPNetworkImage(
                            url: item.photos?.last ?? '',
                            placeholder: Image.asset(
                                'assets/images/tree_placeholder.png'),
                            fit: BoxFit.contain),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(item.name ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle(GPTypography.bodySmall)
                                      ?.mergeColor(Colors.orange)
                                      .mergeFontSize(12.sp)),
                              const SizedBox(height: 8),
                              Center(
                                child: ImageButton(
                                    title: item.priceString(),
                                    width: 70,
                                    height: 36,
                                    fontSize: 14,
                                    background:
                                        'assets/images/ok_button_bg.png',
                                    onTap: () => onTap(index)),
                              ),
                              const SizedBox(height: 8),
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
