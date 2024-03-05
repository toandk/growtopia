import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neon_widgets/neon_widgets.dart';
import '../gamer/constants.dart';

const _COLOR_NORMAL = Colors.black87;

const _COLOR_NULL = Colors.black12;

const _COLOR_HIGHLIGHT = Color(0xFF560000);

class BrikSize extends InheritedWidget {
  const BrikSize({
    Key? key,
    required this.size,
    required Widget child,
  }) : super(key: key, child: child);

  final Size size;

  static BrikSize of(BuildContext context) {
    final brikSize = context.dependOnInheritedWidgetOfExactType<BrikSize>();
    assert(brikSize != null, "....");
    return brikSize!;
  }

  @override
  bool updateShouldNotify(BrikSize oldWidget) {
    return oldWidget.size != size;
  }
}

///the basic brik for game panel
class Brik extends StatelessWidget {
  final Color color;
  final int number;
  final double sizeRatio;

  const Brik._(
      {Key? key,
      required this.color,
      required this.number,
      this.sizeRatio = 1.0})
      : super(key: key);

  const Brik.normal(int number, {Key? key, sizeRatio = 1.0})
      : this._(
            key: key,
            color: _COLOR_NORMAL,
            number: number,
            sizeRatio: sizeRatio);

  const Brik.empty({Key? key, sizeRatio = 1.0})
      : this._(key: key, color: _COLOR_NULL, number: 0, sizeRatio: sizeRatio);

  const Brik.highlight(int number, {Key? key})
      : this._(key: key, color: _COLOR_HIGHLIGHT, number: number);

  @override
  Widget build(BuildContext context) {
    final width = BrikSize.of(context).size.width * sizeRatio;
    final isHighlightClearable = number >= 100;
    String character =
        number != 0 && number <= 26 ? String.fromCharCode(number + 96) : '';
    if (isHighlightClearable) {
      character = String.fromCharCode(number - 100 + 96);
    }
    final fontSize = max(16 * (width / 35) * sizeRatio, 9.0);

    return SizedBox.fromSize(
        size: BrikSize.of(context).size * sizeRatio,
        child: Container(
            margin: EdgeInsets.all(0.05 * width),
            padding:
                number == 0 ? EdgeInsets.all(0.1 * width) : EdgeInsets.zero,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: number != 0
                    ? null
                    : Border.all(width: 2, color: Colors.white10)),
            child: number == GameConstants.CLEAR_VALUE
                ? _ClearBrik(sizeRatio: sizeRatio)
                : number == 0
                    ? Container()
                    : NeonContainer(
                        borderWidth: 2 * sizeRatio,
                        lightSpreadRadius: 4,
                        lightBlurRadius: 2,
                        borderRadius: BorderRadius.circular(4 * sizeRatio),
                        child: number != 0
                            ? Center(
                                child: NeonText(
                                  text: character.toUpperCase(),
                                  textColor: isHighlightClearable
                                      ? Colors.red
                                      : Colors.white,
                                  spreadColor: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GetPlatform.isAndroid
                                      ? 'NotoSans'
                                      : 'GoogleSans',
                                  blurRadius: 8,
                                  textSize: fontSize,
                                ),
                              )
                            : Container()))
        // : Container(
        //     decoration: BoxDecoration(
        //         color: number == 0 ? null : color,
        //         borderRadius: BorderRadius.circular(4),
        //         gradient: number != 0
        //             ? LinearGradient(
        //                 colors: isHighlightClearable
        //                     ? [
        //                         const Color(0xFF00cdac),
        //                         const Color(0xFF8ddad5)
        //                       ]
        //                     : [
        //                         const Color(0xFFfa709a),
        //                         const Color(0xFFfee140)
        //                       ],
        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight)
        //             : null),
        //     child: number != 0
        //         ? Center(
        //             child: Text(
        //               character.toUpperCase(),
        //               style: textStyle(GPTypography.body16)?.merge(
        //                   TextStyle(
        //                       color: Colors.white,
        //                       fontSize: fontSize,
        //                       fontWeight: FontWeight.bold)),
        //             ),
        //           )
        //         : null),
        // ),
        );
  }
}

class _ClearBrik extends StatelessWidget {
  final double sizeRatio;
  const _ClearBrik({Key? key, this.sizeRatio = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = BrikSize.of(context).size.width * sizeRatio;
    return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                    colors: [Color(0xFFff758c), Color(0xFFff7eb3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Center(
                child: Icon(Icons.star_border,
                    color: Colors.white, size: width * sizeRatio * 0.7)))
        .animate(onPlay: (controller) => controller.loop(reverse: true))
        .fadeIn(duration: 200.ms)
        .then()
        .fadeOut(duration: 200.ms, delay: 100.ms);
  }
}
