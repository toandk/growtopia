import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:lottie/lottie.dart';

class FruitsLayer extends StatelessWidget {
  final int fruitsCount;
  final Function() onTap;
  final double width, height;
  final bool animated;
  const FruitsLayer(
      {super.key,
      required this.fruitsCount,
      required this.onTap,
      required this.width,
      required this.height,
      required this.animated});

  @override
  Widget build(BuildContext context) {
    if (fruitsCount == 0) return Container();
    // final List<double> posx = [30, 160, 20, 180, 20, 150];
    // final List<double> posy = [0, 20, 160, 150, 80, 90];
    final List<double> posx = List.generate(
        fruitsCount, (index) => Random().nextDouble() * (160) + 20);
    final List<double> posy = List.generate(
        fruitsCount, (index) => Random().nextDouble() * (160) + 20);
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
          children: List.generate(
              fruitsCount,
              (index) => Positioned(
                    left: posx[index],
                    top: posy[index],
                    child: _FruitGroup(
                      onTap: onTap,
                      width: 60,
                      height: 60,
                      index: index,
                    ),
                  )
                      .animate(target: animated ? 1 : 0)
                      .scale(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInBack,
                          end: const Offset(0.1, 0.1))
                      .then()
                      .fadeOut())),
    );
  }
}

class _FruitGroup extends StatelessWidget {
  final Function() onTap;
  final int index;
  final double? width, height;
  const _FruitGroup(
      {required this.onTap, required this.index, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: Lottie.asset('assets/json/light.json')),
          Bounceable(
            onTap: onTap,
            child: Image.asset('assets/images/ic_fruit_small.png',
                width: 30, height: 30),
          ),
        ],
      ),
    );
  }
}
