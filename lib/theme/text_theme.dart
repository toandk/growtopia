import 'package:growtopia/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:growtopia/theme/themes.dart';

enum GPTypography {
  h1,
  h2,
  h3,
  fontButton,
  fontLink,
  body,
  body16,
  body20,

  displayXXLarge,
  displayXLarge,
  displayLarge,
  displayMedium,
  displaySmall,
  headingXLarge,
  headingLarge,
  headingMedium,
  headingSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  bodySmallBold
}

extension TextTheme on TextStyle {
  TextStyle mergeFontSize(double size) {
    return merge(TextStyle(fontSize: size));
  }

  TextStyle mergeColor(Color color) {
    return merge(TextStyle(color: color));
  }

  TextStyle mergeFontWeight(FontWeight weight) {
    return merge(TextStyle(fontWeight: weight));
  }

  TextStyle bold() {
    return merge(const TextStyle(fontWeight: FontWeight.normal));
  }

  TextStyle medium() {
    return merge(const TextStyle(fontWeight: FontWeight.w500));
  }

  TextStyle white() {
    return merge(const TextStyle(color: GPColor.contentInversePrimary));
  }

  TextStyle black() {
    return merge(const TextStyle(color: GPColor.contentPrimary));
  }
}

TextStyle? textStyle(GPTypography typo) {
  switch (typo) {
    case GPTypography.displayXXLarge:
      return AppThemes.instance.textTheme.displayLarge;
    case GPTypography.displayXLarge:
      return AppThemes.instance.textTheme.displayMedium;
    case GPTypography.displayLarge:
      return AppThemes.instance.textTheme.displaySmall;
    case GPTypography.displayMedium:
      return AppThemes.instance.textTheme.headlineMedium;
    case GPTypography.displaySmall:
      return AppThemes.instance.textTheme.headlineSmall?.merge(
          const TextStyle(leadingDistribution: TextLeadingDistribution.even));

    case GPTypography.headingXLarge:
      return AppThemes.instance.textTheme.titleLarge;
    case GPTypography.headingMedium:
      return AppThemes.instance.textTheme.titleSmall;
    case GPTypography.headingLarge:
      return AppThemes.instance.textTheme.titleMedium;
    case GPTypography.headingSmall:
      return AppThemes.instance.textTheme.bodySmall;

    case GPTypography.bodyLarge:
      return AppThemes.instance.textTheme.bodyLarge;
    case GPTypography.bodyMedium:
      return AppThemes.instance.textTheme.bodyMedium;
    case GPTypography.bodySmall:
      return AppThemes.instance.textTheme.labelSmall;
    case GPTypography.bodySmallBold:
      return AppThemes.instance.textTheme.labelSmall
          ?.mergeFontWeight(FontWeight.bold);

    case GPTypography.h1:
      return AppThemes.instance.textTheme.displayLarge;
    case GPTypography.h2:
      return AppThemes.instance.textTheme.displayMedium;
    case GPTypography.h3:
      return AppThemes.instance.textTheme.displaySmall;
    case GPTypography.body:
      return AppThemes.instance.textTheme.bodyLarge;
    case GPTypography.fontButton:
      return AppThemes.instance.textTheme.labelLarge?.merge(const TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          fontWeight: FontWeight.bold));
    case GPTypography.fontLink:
      return AppThemes.instance.textTheme.titleMedium;
    case GPTypography.body16:
      return AppThemes.instance.textTheme.bodyLarge?.merge(const TextStyle(
          fontSize: 16,
          height: 26 / 16,
          leadingDistribution: TextLeadingDistribution.even));
    case GPTypography.body20:
      return AppThemes.instance.textTheme.bodyLarge?.merge(const TextStyle(
          fontSize: 20,
          height: 32 / 20,
          leadingDistribution: TextLeadingDistribution.even));
    default:
      return AppThemes.instance.textTheme.bodyLarge;
  }
}
