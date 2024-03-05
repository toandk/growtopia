import 'package:flutter/material.dart';
import 'package:growtopia/theme/text_theme.dart';

class ErrorView extends StatelessWidget {
  const ErrorView(this.error, {Key? key}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    // TODO (toannm) order error image here.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          error,
          style: textStyle(GPTypography.bodyLarge),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
