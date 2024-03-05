import 'package:flutter/material.dart';

import 'block.dart';

class ClearData {
  int clearCount;
  List map;

  ClearData(this.clearCount, this.map);
}

///state of [GameControl]
enum GameStates {
  /// You can start an exciting and thrilling game of Tetris at any time.
  none,

  /// The game is currently paused, and the falling of the blocks will stop.
  paused,

  /// The game is in progress, and the blocks are falling.
  /// Keys are interactive.
  running,

  /// The game is resetting.
  /// After the reset is complete, the [GameController] state will transition to [none].
  reset,

  /// The falling block has reached the bottom, and it is currently being locked in the game matrix.
  /// After locking is complete, the next block's falling task will immediately begin.
  mixing,

  /// Rows are being cleared.
  /// After the clearing is complete, the next block's falling task will start immediately.
  clear,

  /// The block is rapidly falling to the bottom.
  drop,

  // /// After mixing, the floating cells should be drop
  // afterScoring,
}

class GameState extends InheritedWidget {
  const GameState(
    this.data,
    this.states,
    this.level,
    this.muted,
    this.points,
    this.cleared,
    this.next, {
    Key? key,
    required this.child,
  }) : super(key: key, child: child);

  @override
  final Widget child;

  ///Screen display data
  ///0: Empty brick
  ///1-26: Ordinary bricks
  ///>26: Highlight bricks
  final List<List<int>> data;

  final GameStates states;

  final int level;

  final bool muted;

  final int points;

  final int cleared;

  final Block next;

  static GameState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameState>()!;
  }

  @override
  bool updateShouldNotify(GameState oldWidget) {
    return true;
  }
}
