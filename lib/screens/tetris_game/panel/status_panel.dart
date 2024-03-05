import 'dart:async';

import 'package:growtopia/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../gamer/game_state.dart';
import '../material/briks.dart';
import '../material/images.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(LocaleKeys.game_tetris_points.tr,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Number(number: GameState.of(context).points),
          const SizedBox(height: 10),
          Text(LocaleKeys.game_tetris_cleans.tr,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Number(number: GameState.of(context).cleared),
          const SizedBox(height: 10),
          Text(LocaleKeys.game_tetris_level.tr,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Number(number: GameState.of(context).level),
          const SizedBox(height: 10),
          Text(LocaleKeys.game_tetris_next.tr,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _NextBlock(),
          const Spacer(),
          _GameStatus(),
        ],
      ),
    );
  }
}

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
                ? Brik.normal(b, sizeRatio: 1.0)
                : const Brik.empty(sizeRatio: 1.0);
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer? _timer;

  bool _colonEnable = true;

  int _minute = 0;

  int _hour = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconSound(enable: GameState.of(context).muted),
        const SizedBox(width: 4),
        IconPause(enable: GameState.of(context).states == GameStates.paused),
        const Spacer(),
        Number(number: _hour, length: 2, padWithZero: true),
        IconColon(enable: _colonEnable),
        Number(number: _minute, length: 2, padWithZero: true),
      ],
    );
  }
}
