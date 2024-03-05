import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../gamer/game_state.dart';
import '../gamer/gamer.dart';
import '../material/briks.dart';
import '../gamer/constants.dart';

const _kPlayerPannelPadding = 6;

Size getBrikSizeForScreenWidth(double width) {
  return Size.square(
      (width - _kPlayerPannelPadding) / GameConstants.GAME_PAD_MATRIX_W);
}

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;

  PlayerPanel({
    Key? key,
    required double width,
  })  : assert(width != 0),
        size = Size(
            width,
            width *
                    GameConstants.GAME_PAD_MATRIX_H /
                    GameConstants.GAME_PAD_MATRIX_W -
                _kPlayerPannelPadding),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("size : $size");
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(4)),
      child: SizedBox.fromSize(
        size: size,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
              // border: Border.all(color: Colors.black),
              ),
          child: Stack(
            children: <Widget>[
              _PlayerPad(),
              _GameUninitialized(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: GameState.of(context).data.map((list) {
        return Row(
          children: list.map((b) {
            return b != 0
                ? Brik.normal(b, sizeRatio: 1.0)
                : b > 26
                    ? Brik.highlight(b)
                    : const Brik.empty(sizeRatio: 1.0);
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GameState.of(context).states == GameStates.none ||
        GameState.of(context).states == GameStates.paused) {
      return GestureDetector(
        onTap: Game.of(context).pauseOrResume,
        child: Container(
          color: Colors.black54,
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/json/play.json'),
              const SizedBox(
                height: 16,
              ),
              Text(LocaleKeys.game_tetris_tapToPlay.tr,
                  style: textStyle(GPTypography.body20)
                      ?.mergeFontSize(30)
                      .bold()
                      .white())
            ],
          )),
        ),
      );
    } else {
      return Container();
    }
  }
}
