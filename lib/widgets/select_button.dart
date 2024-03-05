import 'package:cached_network_image/cached_network_image.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class SelectButton extends StatelessWidget {
  final String? photo;
  final String? word;
  final bool isSelected;
  final Function()? onTap;
  final Color activeColor;
  final Color inactiveColor;
  final double height;
  final double? minWidth;
  final double borderRadius;
  final double borderWidth;
  const SelectButton(
      {Key? key,
      this.photo,
      required this.isSelected,
      this.onTap,
      this.height = 60,
      this.word,
      this.activeColor = Colors.white,
      this.inactiveColor = Colors.black,
      this.borderRadius = 16,
      this.minWidth,
      this.borderWidth = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        width: photo != null ? 100 : null,
        padding: const EdgeInsets.only(left: 12, right: 12),
        constraints:
            minWidth != null ? BoxConstraints(minWidth: minWidth!) : null,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
              color: isSelected ? activeColor : inactiveColor,
              width: borderWidth),
        ),
        child: photo != null
            ? Center(
                child: CachedNetworkImage(
                    width: 100,
                    imageUrl: photo!,
                    color: isSelected ? activeColor : inactiveColor))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(word ?? '',
                      style: textStyle(GPTypography.bodyMedium)
                          ?.mergeFontWeight(FontWeight.bold)
                          .mergeColor(
                              isSelected ? activeColor : inactiveColor)),
                ],
              ),
      ),
    );
  }
}
