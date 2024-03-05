import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:growtopia/widgets/stroke_text.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LevelUpTimeView extends StatelessWidget {
  final int timeRemain;
  final int totalTime;
  const LevelUpTimeView(
      {super.key, required this.timeRemain, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/clock.png', width: 24, height: 24)
            .marginOnly(top: 12),
        const SizedBox(width: 4),
        Column(
          children: [
            SizedBox(
              width: 160,
              child: StrokeText(Utils.secondsToTimeString(timeRemain),
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          .white()),
            ),
            LinearPercentIndicator(
              width: 160,
              lineHeight: 10,
              percent: (totalTime - timeRemain) / totalTime,
              backgroundColor: Colors.white12,
              progressColor: Colors.orange,
              barRadius: const Radius.circular(2),
            ),
          ],
        )
      ],
    );
  }
}
