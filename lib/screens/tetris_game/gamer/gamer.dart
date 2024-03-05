import 'dart:async';
import 'dart:math';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/routes/routes.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/utils/sound_manager.dart';
import 'package:growtopia/widgets/stroke_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../gamer/block.dart';
import '../gamer/constants.dart';
import '../gamer/utils.dart';
import 'game_state.dart';

class Game extends StatefulWidget {
  final Widget child;

  const Game({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GameControl();
  }

  static GameControl of(BuildContext context) {
    final state = context.findAncestorStateOfType<GameControl>();
    assert(state != null, "must wrap this context with [Game]");
    return state!;
  }
}

class GameControl extends State<Game> with RouteAware {
  GameControl() {
    //inflate game pad data
    for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
      _data.add(List.filled(GameConstants.GAME_PAD_MATRIX_W, 0));
      _mask.add(List.filled(GameConstants.GAME_PAD_MATRIX_W, 0));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _autoFallTimer?.cancel();
    _autoFallTimer = null;
  }

  @override
  void didPushNext() {
    //pause when screen is at background
    pause();
  }

  ///the gamer data
  final List<List<int>> _data = [];

  ///Mix with [_data] in the [build] method to form a new matrix
  ///The width and height of the [_mask] matrix are consistent with [_data]
  ///For any _mask[x,y]:
  /// If the value is 0, it has no effect on [_data]
  /// If the value is -1, it means that the row in [_data] is not displayed
  /// If the value is 1, it means that the row in [_data] is highlighted
  final List<List<int>> _mask = [];

  List<List<int>> _highlightClearables = [];

  double _lastMoveDx = 0;
  double _lastMoveDy = 0;

  bool _isMuted = false;

  ///from 1-6
  int _level = 1;

  int _points = 0;
  int _addedPoints = 0;

  int _cleared = 0;

  Block? _current;

  Block _next = Block.getRandomFromWord();

  GameStates _states = GameStates.none;

  Block _getNext() {
    final next = _next;
    _next = Block.getRandomFromWord();
    return next;
  }

  void rotate() {
    if (_states == GameStates.running) {
      final next = _current?.rotate();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        _highlightClearables = Utils.findClearableCells(
            GameConstants.LIST_WORDS, _current!, _data);
        SoundManager.playTetrisRotate(_isMuted);
      }
    }
    setState(() {});
  }

  void right() {
    if (_states == GameStates.none && _level < GameConstants.LEVEL_MAX) {
      _level++;
    } else if (_states == GameStates.running) {
      final next = _current?.right();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        _highlightClearables = Utils.findClearableCells(
            GameConstants.LIST_WORDS, _current!, _data);
        SoundManager.playTetrisMove(_isMuted);
      }
    }
    setState(() {});
  }

  void left() {
    if (_states == GameStates.none && _level > GameConstants.LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.running) {
      final next = _current?.left();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        _highlightClearables = Utils.findClearableCells(
            GameConstants.LIST_WORDS, _current!, _data);
        SoundManager.playTetrisMove(_isMuted);
      }
    }
    setState(() {});
  }

  void drop() async {
    if (_states == GameStates.running) {
      for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
        final fall = _current?.fall(step: i + 1);
        if (fall != null && !fall.isValidInMatrix(_data)) {
          _current = _current?.fall(step: i);
          _states = GameStates.drop;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          _mixCurrentIntoData(
              mixSound: () => SoundManager.playTetrisFall(_isMuted));
          break;
        }
      }
      setState(() {});
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    }
  }

  void down({bool enableSounds = true}) {
    if (_states == GameStates.running) {
      _lastMoveDy = 0;
      final next = _current?.fall();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          SoundManager.playTetrisMove(_isMuted);
        }
        _highlightClearables = Utils.findClearableCells(
            GameConstants.LIST_WORDS, _current!, _data);
      } else {
        Utils.clearArray(_highlightClearables);
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  Timer? _autoFallTimer;

  Future _doClearAnimation(ClearData clearData) async {
    for (int count = 0; count < 5; count++) {
      for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
        for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
          if (clearData.map[i][j] == 1) {
            _mask[i][j] = count % 2 == 0 ? -1 : 1;
          }
        }
      }
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 100));
    }
    for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
        if (clearData.map[i][j] == 1) {
          _mask[i][j] = 0;
        }
      }
    }
  }

  // Clear the line that _current block landed
  Future _mixFromSpecialClearBlock() async {
    if (_current == null) {
      return;
    }
    //cancel the auto falling task
    _autoFall(false);
    setState(() => _states = GameStates.clear);
    List<List<int>> map = List.generate(GameConstants.GAME_PAD_MATRIX_H,
        (i) => List.filled(GameConstants.GAME_PAD_MATRIX_W, 0));
    final i = min(_current!.xy[1] + 1, GameConstants.GAME_PAD_MATRIX_H - 1);
    map[i] = _data[i].map((e) => e != 0 ? 1 : 0).toList();
    SoundManager.playTetrisClear(_isMuted);

    /// Clear animation
    await _doClearAnimation(ClearData(1, map));
    Utils.clearArray(_highlightClearables);

    // Remove clearData cells
    int clearCellCount = 0;
    for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
      if (map[i][j] == 1) {
        clearCellCount++;
        _changeData(i, j, 0);
      }
    }
    for (int row = i; row >= 1; row--) {
      for (int col = 0; col < _data[row].length; col++) {
        _changeData(row, col, _data[row - 1][col]);
      }
    }
    for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
      _changeData(0, j, 0);
    }
    _calculateLevel(1, clearCellCount);
    _current = null;
    _startGame();
    // }
  }

  void _changeData(int i, int j, int value) {
    _data[i][j] = value;
  }

  ///mix current into [_data]
  Future<void> _mixCurrentIntoData({VoidCallback? mixSound}) async {
    if (_current == null) {
      return;
    }
    if (_current!.type == BlockType.CLEAR) {
      _mixFromSpecialClearBlock();
      return;
    }
    //cancel the auto falling task
    _autoFall(false);

    List<List<int>> backupData =
        Utils.copyList(_data); // _data before mixxing with _current block

    for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
        _changeData(i, j, _current?.get(j, i) ?? _data[i][j]);
        if (_data[i][j] != 0) {
          debugPrint(
              'data $i $j ${_current!.get(j, i)} ${_data[i][j]} ${backupData[i][j]}');
        }
      }
    }

    final clearData = Utils.findClearCells(GameConstants.LIST_WORDS, _data);

    if (clearData.clearCount > 0) {
      setState(() => _states = GameStates.clear);

      SoundManager.playTetrisClear(_isMuted);

      /// Clear animation
      await _doClearAnimation(clearData);
      Utils.clearArray(_highlightClearables);

      // Remove clearData cells
      int clearCellCount = 0;
      for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
        for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
          if (clearData.map[i][j] == 1) {
            clearCellCount++;
            _changeData(i, j, 0);
            backupData[i][j] = 0;
            _current?.clearShapeAt(j, i);
          }
        }
      }

      _calculateLevel(clearData.clearCount, clearCellCount);

      if (_current!.isValidInMatrix(backupData)) {
        debugPrint('current is still valid.');
        Utils.forTable((i, j) => _changeData(i, j, backupData[i][j]));

        _states = GameStates.running;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));
        drop();
      } else {
        _current = null;
        _nextGameState();
      }
    } else {
      mixSound?.call();
      await _doNextBlockAfterMixing();
    }
  }

  void _calculateLevel(int clearCount, int clearCellCount) {
    _cleared += clearCount;
    _addedPoints = clearCellCount * _level * 5;
    Future.delayed(800.ms, () {
      _addedPoints = 0;
    });
    _points += _addedPoints;
    setState(() {});

    //up level possible when cleared
    int level =
        (_cleared ~/ GameConstants.POINT_PER_LEVEL) + GameConstants.LEVEL_MIN;
    _level =
        level <= GameConstants.LEVEL_MAX && level > _level ? level : _level;
  }

  Future _doNextBlockAfterMixing() async {
    _states = GameStates.mixing;
    Utils.forTable((i, j) => _mask[i][j] = _current?.get(j, i) ?? _mask[i][j]);
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 200));
    Utils.forTable((i, j) => _mask[i][j] = 0);
    //_current has been integrated into _data, so it is no longer needed
    _current = null;
    _nextGameState();
  }

  void _gameOver() async {
    try {
      await SupabaseAPI.querySql(functionName: 'update_played_game', params: {
        'points': _points,
        'gtype': 'tetris',
        'gid': GameConstants.currentGame?.id ?? ''
      });
    } catch (error) {
      debugPrint('update score error $error');
    }
    final map = {
      'result': {'points': _points, 'level': _level, 'cleans': _cleared},
      'game': GameConstants.currentGame
    };
    Get.offNamed(RouterName.tetrisGameOver, arguments: map);
  }

  void _nextGameState() {
    //Check whether the game is over, there is an element in the first row that is != 0
    if (_data[0].any((element) => element != 0)) {
      _gameOver();
      return;
    } else {
      // The game is not over yet, start the next round of block falling
      _startGame();
    }
  }

  void _autoFall(bool enable) {
    if (!enable) {
      _autoFallTimer?.cancel();
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel();
      _current = _current ?? _getNext();
      _highlightClearables =
          Utils.findClearableCells(GameConstants.LIST_WORDS, _current!, _data);
      _autoFallTimer = Timer.periodic(GameConstants.SPEED[_level - 1], (t) {
        down(enableSounds: false);
      });
    }
  }

  void pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    }
    setState(() {});
  }

  void pauseOrResume() {
    if (_states == GameStates.running) {
      pause();
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      _startGame();
    }
  }

  void reset() {
    if (_states == GameStates.none) {
      _startGame();
      return;
    }
    if (_states == GameStates.reset) {
      return;
    }
    SoundManager.playTetrisStart(_isMuted);
    _states = GameStates.reset;
    () async {
      int line = GameConstants.GAME_PAD_MATRIX_H;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_W; i++) {
          _changeData(line, i, 1);
        }
        setState(() {});
        await Future.delayed(GameConstants.REST_LINE_DURATION);
        return line != 0;
      });
      _lastMoveDx = 0;
      _lastMoveDy = 0;
      _current = null;
      _getNext();
      _level = 1;
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_W; i++) {
          _changeData(line, i, 0);
          _highlightClearables[line][i] = 0;
        }
        setState(() {});
        line++;
        await Future.delayed(GameConstants.REST_LINE_DURATION);
        return line != GameConstants.GAME_PAD_MATRIX_H;
      });
      setState(() {
        _states = GameStates.none;
      });
    }();
  }

  void _startGame() {
    if (_states == GameStates.running && _autoFallTimer?.isActive == false) {
      return;
    }
    _states = GameStates.running;
    _autoFall(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> mixed = [];
    Block? fall;
    int fallStep = 0;
    if (_current != null) {
      for (int step = 0; step < GameConstants.GAME_PAD_MATRIX_H; step++) {
        fall = _current!.fall(step: step + 1);
        if (!fall.isValidInMatrix(_data)) {
          fall = _current!.fall(step: step);
          fallStep = step;
          break;
        }
      }
    }
    for (var i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
      mixed.add(List.filled(GameConstants.GAME_PAD_MATRIX_W, 0));
      for (var j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
        int value = _current?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1 && value < 26) {
          // Highlight cell
          value = value + 26;
        }
        if (_states == GameStates.running &&
            _highlightClearables.isNotEmpty &&
            value != 0) {
          if (_highlightClearables[i][j] == 1 && value < 100) {
            value = value + 100;
          }
          if (fall != null &&
              _current?.get(j, i) != 0 &&
              _current?.get(j, i) != null) {
            if (_highlightClearables[i + fallStep][j] != 0 && value < 100) {
              value = value + 100;
            }
          }
        }
        mixed[i][j] = value;
      }
    }
    debugPrint("game states : $_states");
    return GestureDetector(
      onTap: rotate,
      onPanUpdate: (details) {
        _lastMoveDx += details.delta.dx;
        _lastMoveDy += details.delta.dy;
        if (_states != GameStates.running && _states != GameStates.drop) return;
        if (_lastMoveDy > GameConstants.SWIPE_DOWN_THRESHOLD) {
          drop();
          _lastMoveDx = 0;
          _lastMoveDy = 0;
        } else if (_lastMoveDx > GameConstants.getGameCellWidth(context)) {
          right();
          _lastMoveDx = 0;
          _lastMoveDy = 0;
        } else if (_lastMoveDx < -GameConstants.getGameCellWidth(context)) {
          left();
          _lastMoveDx = 0;
          _lastMoveDy = 0;
        }
      },
      child: Stack(
        children: [
          GameState(mixed, _states, _level, _isMuted, _points, _cleared, _next,
              child: widget.child),
          _addedPoints > 0
              ? Center(
                      child: StrokeText("+$_addedPoints",
                          strokeWidth: 2,
                          strokeColor: Colors.black26,
                          style: textStyle(GPTypography.body20)
                              ?.mergeFontWeight(FontWeight.w900)
                              .mergeColor(const Color(0xFFE59A18))
                              .mergeFontSize(50)))
                  .animate()
                  .moveY(end: -50, duration: 800.ms)
                  .fadeOut(delay: 100.ms, duration: 700.ms)
              : Container()
        ],
      ),
    );
  }

  void soundSwitch() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }
}
