import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

enum StarType { win, lose }

const _starSizeRate = (440 / 200);

class GameResultStar extends StatelessWidget {
  final StarType type;
  final bool isAnimating;
  final double size;
  const GameResultStar(
      {Key? key, required this.type, required this.isAnimating, this.size = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == StarType.lose) {
      return SvgPicture.asset(
        'assets/images/star-normal2.svg',
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: OverflowBox(
        maxWidth: size * _starSizeRate,
        maxHeight: size * _starSizeRate,
        alignment: Alignment.center,
        child: Lottie.asset('assets/json/win-sar3.json',
            width: size * _starSizeRate, height: size * _starSizeRate),
      ),
    );
  }
}
