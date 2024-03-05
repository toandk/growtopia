import 'constants.dart';
import 'dart:math' as math;

import 'utils.dart';

const BLOCK_SHAPES = {
  BlockType.I: [
    [1, 1, 1, 1]
  ],
  BlockType.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  BlockType.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  BlockType.I2: [
    [1, 1]
  ],
  BlockType.I3: [
    [1, 1, 1]
  ],
  // BlockType.Z: [
  //   [1, 1, 0],
  //   [0, 1, 1],
  // ],
  // BlockType.S: [
  //   [0, 1, 1],
  //   [1, 1, 0],
  // ],
  BlockType.O: [
    [1, 1],
    [1, 1]
  ],
  // BlockType.T: [
  //   [0, 1, 0],
  //   [1, 1, 1]
  // ],
  BlockType.D: [
    [1]
  ],
  BlockType.CLEAR: [
    [1]
  ]
};

///The initial position of the block
const START_XY = {
  BlockType.I: [3, 0],
  BlockType.L: [3, -1],
  BlockType.J: [3, -1],
  BlockType.I2: [3, -1],
  BlockType.I3: [3, -1],
  // BlockType.S: [4, -1],
  BlockType.O: [3, -1],
  // BlockType.T: [4, -1],
  BlockType.D: [3, 0],
  BlockType.CLEAR: [3, 0]
};

///The center point of the block rotation
const ORIGIN = {
  BlockType.I: [
    [1, -1],
    [-1, 1],
  ],
  BlockType.L: [
    [0, 0]
  ],
  BlockType.J: [
    [0, 0]
  ],
  BlockType.I2: [
    [0, 0]
  ],
  BlockType.I3: [
    [1, -1],
    [-1, 1],
  ],
  // BlockType.S: [
  //   [0, 0]
  // ],
  BlockType.O: [
    [0, 0]
  ],
  // BlockType.T: [
  //   [0, 0],
  //   [0, 1],
  //   [1, -1],
  //   [-1, 0]
  // ],
  BlockType.D: [
    [0, 0]
  ],
  BlockType.CLEAR: [
    [0, 0]
  ]
};

enum BlockType { I, L, J, I2, I3, O, D, CLEAR }

class Block {
  final BlockType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  Block(this.type, this.shape, this.xy, this.rotateIndex);

  Block clone() {
    return Block(type, shape, [xy[0], xy[1]], rotateIndex);
  }

  Block fall({int step = 1}) {
    return Block(type, shape, [xy[0], xy[1] + step], rotateIndex);
  }

  Block right() {
    return Block(type, shape, [xy[0] + 1, xy[1]], rotateIndex);
  }

  Block left() {
    return Block(type, shape, [xy[0] - 1, xy[1]], rotateIndex);
  }

  Block rotate() {
    List<List<int>> result =
        List.filled(shape[0].length, const [], growable: false);
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (result[col].isEmpty) {
          result[col] = List.filled(shape.length, 0, growable: false);
        }
        result[col][row] = shape[shape.length - 1 - row][col];
      }
    }
    final nextXy = [
      xy[0] + ORIGIN[type]![rotateIndex][0],
      xy[1] + ORIGIN[type]![rotateIndex][1]
    ];
    final nextRotateIndex =
        rotateIndex + 1 >= ORIGIN[type]!.length ? 0 : rotateIndex + 1;

    return Block(type, result, nextXy, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (xy[1] + shape.length > GameConstants.GAME_PAD_MATRIX_H ||
        xy[0] < 0 ||
        xy[0] + shape[0].length > GameConstants.GAME_PAD_MATRIX_W) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] != 0 && (get(j, i) != null && get(j, i) != 0)) {
          return false;
        }
      }
    }
    return true;
  }

  ///return null if do not show at [x][y]
  ///return 1 if show at [x,y]
  int? get(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return null;
    }
    return shape[y][x] != 0 ? shape[y][x] : null;
  }

  void clearShapeAt(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return;
    }
    shape[y][x] = 0;
  }

  static Block fromType(BlockType type) {
    var shape = [...BLOCK_SHAPES[type]!];
    for (int i = 0; i < shape.length; i++) {
      var row = [...shape[i]];
      for (int j = 0; j < row.length; j++) {
        if (row[j] == 1) {
          row[j] = math.Random().nextInt(10) + 1;
        }
      }
      shape[i] = row;
    }
    return Block(type, shape, START_XY[type]!, 0);
  }

  static Block getRandomFromWord() {
    int i = math.Random().nextInt(GameConstants.kSingleBlockRate) == 0
        ? BlockType.values.indexOf(BlockType.D)
        : math.Random().nextInt(BlockType.values.length);
    final type = BlockType.values[i];
    String word = GameConstants.getRandomWordPart();

    var shape = Utils.copyList(BLOCK_SHAPES[type]!);
    switch (type) {
      case BlockType.I:
        bool isFour = math.Random().nextBool();
        if (isFour) {
          word = GameConstants.getRandomWordPart(length: 4);
          shape[0][0] = Utils.getCharCode(word.substring(0, 1));
          shape[0][1] = Utils.getCharCode(word.substring(1, 2));
          shape[0][2] = Utils.getCharCode(word.substring(2, 3));
          shape[0][3] = Utils.getCharCode(word.substring(3, 4));
        } else {
          word = GameConstants.getRandomWordPart(length: 2);
          shape[0][0] = Utils.getCharCode(word.substring(0, 1));
          shape[0][1] = Utils.getCharCode(word.substring(1, 2));

          word = GameConstants.getRandomWordPart(length: 2);
          shape[0][2] = Utils.getCharCode(word.substring(0, 1));
          shape[0][3] = Utils.getCharCode(word.substring(1, 2));
        }
        break;
      case BlockType.L:
        word = GameConstants.getRandomWordPart(length: 3);
        shape[0][2] = GameConstants.getRandomCharacterCode();
        shape[1][0] = Utils.getCharCode(word.substring(0, 1));
        shape[1][1] = Utils.getCharCode(word.substring(1, 2));
        shape[1][2] = Utils.getCharCode(word.substring(2, 3));
        break;
      case BlockType.J:
        word = GameConstants.getRandomWordPart(length: 3);
        shape[0][0] = GameConstants.getRandomCharacterCode();
        shape[1][0] = Utils.getCharCode(word.substring(0, 1));
        shape[1][1] = Utils.getCharCode(word.substring(1, 2));
        shape[1][2] = Utils.getCharCode(word.substring(2, 3));
        break;
      case BlockType.I2:
        word = GameConstants.getRandomWordPart(length: 2);
        shape[0][0] = Utils.getCharCode(word.substring(0, 1));
        shape[0][1] = Utils.getCharCode(word.substring(1, 2));
        break;
      case BlockType.I3:
        word = GameConstants.getRandomWordPart(length: 3);
        shape[0][0] = Utils.getCharCode(word.substring(0, 1));
        shape[0][1] = Utils.getCharCode(word.substring(1, 2));
        shape[0][2] = Utils.getCharCode(word.substring(2, 3));
        break;
      // case BlockType.Z:
      //   word = GameConstants.getRandomWordPart(length: 2);
      //   shape[0][0] = Utils.getCharCode(word.substring(0, 1));
      //   shape[0][1] = Utils.getCharCode(word.substring(1, 2));

      //   word = GameConstants.getRandomWordPart(length: 2);
      //   shape[1][1] = Utils.getCharCode(word.substring(0, 1));
      //   shape[1][2] = Utils.getCharCode(word.substring(1, 2));
      //   break;
      // case BlockType.S:
      //   word = GameConstants.getRandomWordPart(length: 2);
      //   shape[0][1] = Utils.getCharCode(word.substring(0, 1));
      //   shape[0][2] = Utils.getCharCode(word.substring(1, 2));

      //   word = GameConstants.getRandomWordPart(length: 2);
      //   shape[1][0] = Utils.getCharCode(word.substring(0, 1));
      //   shape[1][1] = Utils.getCharCode(word.substring(1, 2));
      //   break;
      case BlockType.O:
        word = GameConstants.getRandomWordPart(length: 2);
        shape[0][0] = Utils.getCharCode(word.substring(0, 1));
        shape[0][1] = Utils.getCharCode(word.substring(1, 2));

        word = GameConstants.getRandomWordPart(length: 2);
        shape[1][0] = Utils.getCharCode(word.substring(0, 1));
        shape[1][1] = Utils.getCharCode(word.substring(1, 2));
        break;
      // case BlockType.T:
      //   word = GameConstants.getRandomWordPart(length: 3);
      //   shape[0][1] = GameConstants.getRandomCharacterCode();
      //   shape[1][0] = Utils.getCharCode(word.substring(0, 1));
      //   shape[1][1] = Utils.getCharCode(word.substring(1, 2));
      //   shape[1][2] = Utils.getCharCode(word.substring(2, 3));
      //   break;
      case BlockType.D:
        shape[0][0] = GameConstants.getRandomCharacterCode();
        break;
      case BlockType.CLEAR:
        shape[0][0] = GameConstants.CLEAR_VALUE;
        break;
    }
    return Block(type, shape, START_XY[type]!, 0);
  }
}
