import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum StarType { normal, correct, incorrect }

class AnimateStar extends StatelessWidget {
  final StarType type;
  final bool isAnimating;
  final double size;
  const AnimateStar(
      {Key? key, required this.type, required this.isAnimating, this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == StarType.normal) {
      return SvgPicture.asset('assets/images/star-normal.svg',
          width: size, height: size);
    }
    if (type == StarType.correct) {
      return SvgPicture.asset('assets/images/star-correct.svg',
              width: size,
              height: size,
              colorFilter:
                  const ColorFilter.mode(Colors.yellow, BlendMode.srcIn))
          .animate(target: isAnimating ? 1 : 0)
          .scaleXY(end: 2.0, duration: 100.ms, curve: Curves.easeOut)
          .then()
          .slide(duration: 100.ms, end: const Offset(0, -1))
          .then()
          .scaleXY(end: 1.0, duration: 100.ms, curve: Curves.easeInBack);
    }
    return SvgPicture.asset('assets/images/star-incorrect.svg',
            width: size,
            height: size,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn))
        .animate(target: isAnimating ? 1 : 0)
        .scaleXY(end: 2.0, duration: 100.ms, curve: Curves.easeOut)
        .then()
        .slide(duration: 100.ms, end: const Offset(0, -1))
        .then()
        .scaleXY(end: 1.0, duration: 100.ms, curve: Curves.easeInBack);
  }
}
