import 'package:flutter/material.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';

class GapoButton extends StatelessWidget {
  final double? width;

  final double height;

  final String text;

  final double borderRadius;

  final Color? backgroundColor;

  final bool disabled;

  final bool loading;

  final bool wrapContent;

  final TextStyle? titleStyle;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const GapoButton(
      {Key? key,
      this.width,
      this.height = 40,
      this.borderRadius = 0,
      this.backgroundColor = GPColor.bgPrimary,
      this.text = "",
      this.disabled = false,
      this.loading = false,
      this.wrapContent = false,
      required this.titleStyle,
      this.onPressed,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final disableTextStyle = textStyle(GPTypography.headingMedium)
        ?.mergeColor(GPColor.contentTertiary);
    double width = this.width ??
        (wrapContent
            ? _wrapContentWidth(text, titleStyle!)
            : MediaQuery.of(context).size.width);

    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: disabled ? GPColor.bgTertiary : backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                  onPressed: onPressed,
                  onLongPress: onLongPress,
                  child: Text(text,
                      style: disabled ? disableTextStyle : titleStyle)),
            ),
            if (loading)
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                child: CircularProgressIndicator(
                  color: titleStyle?.color,
                  strokeWidth: 2,
                ),
              )
          ],
        ));
  }

  double _wrapContentWidth(String text, TextStyle style) {
    //calculate size of text
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);

    //plus 24 pixel for padding left + right
    return textPainter.size.width + 24 + (loading ? 24 : 0);
  }
}

class AccentPrimaryButton extends GapoButton {
  AccentPrimaryButton(
    String text,
    VoidCallback? onPressed, {
    Key? key,
    double? width,
    VoidCallback? onLongPress,
    bool disabled = false,
    bool loading = false,
    double borderRadius = 0,
    double height = 40,
  }) : super(
            key: key,
            height: height,
            disabled: disabled,
            loading: loading,
            borderRadius: borderRadius,
            backgroundColor: GPColor.functionAccentPrimary,
            text: text,
            titleStyle: textStyle(GPTypography.headingMedium)
                ?.mergeColor(GPColor.contentInversePrimary),
            onPressed: onPressed,
            onLongPress: onLongPress);
}

class AccentSecondaryButton extends GapoButton {
  AccentSecondaryButton(
    String text,
    VoidCallback? onPressed, {
    Key? key,
    double? width,
    VoidCallback? onLongPress,
    bool disabled = false,
    bool loading = false,
    double borderRadius = 8,
    double height = 40,
  }) : super(
            key: key,
            height: height,
            disabled: disabled,
            loading: loading,
            width: width,
            borderRadius: borderRadius,
            backgroundColor: GPColor.functionAccentSecondary,
            text: text,
            titleStyle: textStyle(GPTypography.headingMedium)
                ?.mergeColor(GPColor.functionAccentPrimary),
            onPressed: onPressed,
            onLongPress: onLongPress);
}

class AccentWorkPrimaryButton extends GapoButton {
  AccentWorkPrimaryButton(
    String text,
    VoidCallback? onPressed, {
    Key? key,
    double? width,
    VoidCallback? onLongPress,
    bool disabled = false,
    bool loading = false,
    bool wrapContent = false,
    double borderRadius = 8,
    double height = 40,
  }) : super(
            key: key,
            height: height,
            width: width,
            disabled: disabled,
            loading: loading,
            wrapContent: wrapContent,
            borderRadius: borderRadius,
            backgroundColor: GPColor.functionAccentWorkPrimary,
            text: text,
            titleStyle: textStyle(GPTypography.headingMedium)
                ?.mergeColor(GPColor.contentInversePrimary),
            onPressed: onPressed,
            onLongPress: onLongPress);
}

class BgPrimaryButton extends GapoButton {
  BgPrimaryButton(
    String text,
    VoidCallback? onPressed, {
    Key? key,
    double? width,
    VoidCallback? onLongPress,
    bool disabled = false,
    bool loading = false,
    double borderRadius = 8,
    double height = 40,
  }) : super(
            key: key,
            height: height,
            disabled: disabled,
            loading: loading,
            width: width,
            borderRadius: borderRadius,
            backgroundColor: GPColor.bgPrimary,
            text: text,
            titleStyle: textStyle(GPTypography.headingMedium)
                ?.mergeColor(GPColor.contentPrimary),
            onPressed: onPressed,
            onLongPress: onLongPress);
}

class BgSecondaryButton extends GapoButton {
  BgSecondaryButton(
    String text,
    VoidCallback? onPressed, {
    Key? key,
    double? width,
    VoidCallback? onLongPress,
    bool disabled = false,
    bool loading = false,
    double borderRadius = 8,
    double height = 40,
  }) : super(
            key: key,
            height: height,
            disabled: disabled,
            loading: loading,
            width: width,
            borderRadius: borderRadius,
            backgroundColor: GPColor.bgSecondary,
            text: text,
            titleStyle: textStyle(GPTypography.headingMedium)
                ?.mergeColor(GPColor.contentPrimary),
            onPressed: onPressed,
            onLongPress: onLongPress);
}

class NegativeSecondaryButton extends GapoButton {
  NegativeSecondaryButton(
    String text,
    VoidCallback? onPressed, {
    Key? key,
    double? width,
    VoidCallback? onLongPress,
    bool disabled = false,
    bool loading = false,
    double borderRadius = 8,
    double height = 40,
  }) : super(
            key: key,
            height: height,
            disabled: disabled,
            loading: loading,
            borderRadius: borderRadius,
            backgroundColor: GPColor.functionNegativeSecondary,
            text: text,
            titleStyle: textStyle(GPTypography.headingMedium)
                ?.mergeColor(GPColor.functionNegativePrimary),
            onPressed: onPressed,
            onLongPress: onLongPress);
}
