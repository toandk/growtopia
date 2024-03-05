import 'package:flutter/material.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';

class TagButton extends StatelessWidget {
  final String title;
  final Color borderColor;
  final Color selectedColor;
  final Color normalColor;
  final bool selected;
  final VoidCallback onPressed;
  final double height;
  final TextStyle? selectedStyle;
  final double borderWidth;

  const TagButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height = 32,
    this.borderColor = GPColor.workPrimary,
    this.selectedColor = GPColor.functionPositiveSecondary,
    this.selected = false,
    this.normalColor = GPColor.bgSecondary,
    this.selectedStyle,
    this.borderWidth = 1.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      labelPadding: const EdgeInsets.all(0),
      label: Text(
        title,
        style: selected
            ? selectedStyle
            : textStyle(GPTypography.bodyMedium)
                ?.mergeColor(GPColor.contentPrimary)
                .bold(),
      ),
      backgroundColor: selected ? selectedColor : normalColor,
      side: selected
          ? BorderSide(color: selectedColor, width: borderWidth)
          : BorderSide(
              color: GPColor.bgSecondary,
              width: borderWidth,
              style: BorderStyle.none),
      onPressed: onPressed,
    );
  }
}
