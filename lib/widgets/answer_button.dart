import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

enum ButtonState { normal, incorrect, selected, correct }

class AnswerButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color color;
  final double? width;
  final ButtonState state;
  final double height;
  final double cornerRadius;
  final int maxLines;
  const AnswerButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color = GPColor.blue,
      this.state = ButtonState.normal,
      this.width,
      this.cornerRadius = 12,
      this.height = 60,
      this.maxLines = 1})
      : super(key: key);

  Color getStateBottomColor() {
    return state == ButtonState.selected
        ? GPColor.orange
        : (state == ButtonState.incorrect
            ? GPColor.red
            : (state == ButtonState.correct
                ? const Color.fromRGBO(56, 120, 79, 1.0)
                : GPColor.teal));
  }

  LinearGradient? getStateBGGradient() {
    return state == ButtonState.selected
        ? GPColor.buttonGradient
        : (state == ButtonState.incorrect
            ? GPColor.buttonIncorrectGradient
            : state == ButtonState.correct
                ? GPColor.buttonCorrectGradient
                : null);
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      spreadRadius: 0.0,
                      blurRadius: 4.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(cornerRadius),
                  color: getStateBottomColor()),
            ),
          ),
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornerRadius),
                gradient: getStateBGGradient(),
                color: state == ButtonState.normal ? GPColor.bgPrimary : null),
          ),
          Container(
            width: width,
            height: height - 4,
            padding: const EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
                color: state == ButtonState.normal ? GPColor.bgPrimary : null,
                gradient: getStateBGGradient(),
                borderRadius: BorderRadius.circular(cornerRadius),
                boxShadow: state == ButtonState.normal
                    ? const [
                        BoxShadow(
                          color: Color(0x334688F9),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(-4, 0),
                        ),
                        BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(4, 0),
                        )
                      ]
                    : []),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                maxLines: maxLines,
                textAlign: TextAlign.center,
                style: textStyle(GPTypography.body20)
                    ?.mergeColor(state == ButtonState.normal
                        ? color
                        : GPColor.contentInversePrimary)
                    .merge(const TextStyle(height: 1.2))
                    .bold(),
              ),
            )),
          )
        ],
      ),
    );
  }
}
