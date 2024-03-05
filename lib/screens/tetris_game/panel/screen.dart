import 'dart:math';

import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/widgets/image_button.dart';
import '../gamer/constants.dart';
import '../gamer/game_state.dart';
import '../gamer/gamer.dart';
import '../material/briks.dart';
import '../material/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import 'player_panel.dart';

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = GameState.of(context).next.shape;
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          children: list.map((b) {
            return b != 0
                ? Brik.normal(b, sizeRatio: 0.6)
                : const Brik.empty(sizeRatio: 0.6);
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final points = GameState.of(context).points;
    final level = GameState.of(context).level;
    String pointsText = points.toString();
    while (pointsText.length < 5) {
      pointsText = '0$pointsText';
    }
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageButton(
              title: '',
              width: 40,
              height: 44,
              background: 'assets/images/back_button.png',
              onTap: Get.back),
          _NextBlock(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${LocaleKeys.game_tetris_points.tr}: $pointsText',
                  style: textStyle(GPTypography.body16)
                      ?.mergeFontSize(12.h375)
                      .bold()
                      .white()),
              const SizedBox(height: 4),
              Text('${LocaleKeys.game_tetris_level.tr}: $level',
                  style: textStyle(GPTypography.body16)
                      ?.mergeFontSize(12.h375)
                      .bold()
                      .white()),
            ],
          )
        ],
      ),
    );
  }
}

/// screen H : W;
class Screen extends StatelessWidget {
  ///the with of screen
  final double width;

  const Screen({
    Key? key,
    required this.width,
  }) : super(key: key);

  const Screen.fromHeight(double height, {Key? key})
      : this(key: key, width: ((height - 6) / 2 + 6) / 0.6);

  @override
  Widget build(BuildContext context) {
    //play panel need 60%
    // final playerPanelWidth = width * 0.6;
    final playerPanelWidth = GameConstants.getGamePadWidth(context);
    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: SizedBox(
        width: width,
        child: GameMaterial(
          child: BrikSize(
            size: getBrikSizeForScreenWidth(playerPanelWidth),
            child: Column(
              children: [
                const _Header(),
                const SizedBox(height: 20),
                PlayerPanel(width: playerPanelWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Shake extends StatefulWidget {
  final Widget child;

  ///true to shake screen vertically
  final bool shake;

  const Shake({
    Key? key,
    required this.child,
    required this.shake,
  }) : super(key: key);

  @override
  ShakeState createState() => ShakeState();
}

///摇晃屏幕
class ShakeState extends State<Shake> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  v.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}
