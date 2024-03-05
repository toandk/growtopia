import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';

class MJDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? cancelTitle;
  final String? confirmTitle;
  final void Function()? onCancel;
  final void Function()? onConfirm;
  const MJDialog(
      {Key? key,
      this.title = "",
      this.content = "",
      this.cancelTitle,
      this.confirmTitle,
      this.onCancel,
      this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.0)),
        child: Center(
            child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: GPColor.bgPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 7),
              Text(title, style: textStyle(GPTypography.h2)),
              const SizedBox(height: 47),
              Text(
                content,
                style: textStyle(GPTypography.body)?.mergeFontSize(20),
              ),
              const SizedBox(height: 40),
              Row(
                children: confirmTitle != null && confirmTitle!.isNotEmpty
                    ? [
                        Expanded(
                            child: CancelButton(
                                text: cancelTitle?.toUpperCase() ??
                                    LocaleKeys.alert_ok.tr.toUpperCase(),
                                onCancel: onCancel)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: ConfirmButton(
                                text: confirmTitle?.toUpperCase() ?? "",
                                onConfirm: onConfirm))
                      ]
                    : [
                        Expanded(
                            child: CancelButton(
                                text: cancelTitle?.toUpperCase() ?? "",
                                onCancel: onCancel))
                      ],
              )
            ],
          ),
        )));
  }
}

class ConfirmButton extends StatelessWidget {
  final String text;
  final void Function()? onConfirm;
  const ConfirmButton({Key? key, this.text = "", this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onConfirm,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE59A18), Color(0xFFE55618)]),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
              child: Text(
            text,
            style: textStyle(GPTypography.fontButton)
                ?.mergeColor(GPColor.contentInversePrimary),
          ).marginOnly(bottom: 4)),
        ));
  }
}

class CancelButton extends StatelessWidget {
  final String text;
  final void Function()? onCancel;
  const CancelButton({Key? key, this.text = "", this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onCancel,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
              color: GPColor.buttonDisabled,
              border: Border.all(color: GPColor.functionAccentWorkPrimary),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
              child: Text(
            text,
            style: textStyle(GPTypography.fontButton)
                ?.mergeColor(GPColor.functionAccentWorkPrimary),
          ).marginOnly(bottom: 4)),
        ));
  }
}
