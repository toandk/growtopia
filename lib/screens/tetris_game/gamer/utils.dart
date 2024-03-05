import 'dart:math' as math;
import 'dart:math';

import 'block.dart';
import 'constants.dart';
import 'game_state.dart';

class Utils {
  Utils._();

  static int getCharCode(String char) {
    return char.codeUnitAt(0) - 96;
  }

  static String numberToCharacter(int number) {
    final character =
        number != 0 && number <= 26 ? String.fromCharCode(number + 96) : '';
    return character;
  }

  static int getRandomCharacterCode(List list) {
    final char = list[math.Random().nextInt(list.length)];
    return getCharCode(char);
  }

  static List<List<int>> copyList(List<List<int>> list) {
    List<List<int>> backupData = [];
    for (int i = 0; i < list.length; i++) {
      backupData.add([]);
      for (int j = 0; j < list[i].length; j++) {
        backupData[i].add(list[i][j]);
      }
    }
    return backupData;
  }

  ///Traverse the table
  ///i 为 row
  ///j 为 column
  static void forTable(dynamic Function(int row, int column) function) {
    for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
        final b = function(i, j);
        if (b is bool && b) {
          break;
        }
      }
    }
  }

  static void clearArray(List<List<int>> data) {
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        data[i][j] = 0;
      }
    }
  }

  static String _getCharacterAt(int row, int column, List<List<int>> data) {
    int number = data[row][column];
    final character = number != 0 ? String.fromCharCode(number + 96) : ' ';
    return character;
  }

  // static List<List<int>> findClearableCells2(
  //     List<String> listWords, Block current, List<List<int>> data) {
  //   List<List<int>> map = [];
  //   for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
  //     map.add([]);
  //     for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
  //       map[i].add(0);
  //     }
  //   }
  //   Block rotatedBlock = current.clone();

  //   for (int c = 0; c < 3; c++) {
  //     for (int rr = 0; rr < GameConstants.GAME_PAD_MATRIX_W; rr++) {
  //       List<List<int>> cloneData = copyList(data);
  //       rotatedBlock.xy[0] = rr;
  //       for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
  //         final fall = rotatedBlock.fall(step: i + 1);
  //         if (!fall.isValidInMatrix(data)) {
  //           // mixxing
  //           forTable(
  //               (i, j) => cloneData[i][j] = fall.get(j, i) ?? cloneData[i][j]);
  //           final clearData =
  //               Utils.findClearCells(GameConstants.LIST_WORDS, cloneData);
  //           forTable(
  //               (i, j) => map[i][j] = clearData.map[i][j] != 0 ? 1 : map[i][j]);
  //           break;
  //         }
  //       }
  //     }
  //     rotatedBlock = rotatedBlock.rotate();
  //   }
  //   return map;
  // }

  static List<List<int>> findClearableCells(
      List<String> listWords, Block current, List<List<int>> data) {
    List<List<int>> map = [];
    for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
      map.add([]);
      for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
        map[i].add(0);
      }
    }
    Block cloneBlock = current.clone();

    List<List<int>> cloneData = copyList(data);
    for (int step = 0; step < GameConstants.GAME_PAD_MATRIX_H; step++) {
      Block fall = cloneBlock.fall(step: step + 1);
      if (!fall.isValidInMatrix(data)) {
        fall = cloneBlock.fall(step: step);
        if (current.type == BlockType.CLEAR) {
          final row = min(fall.xy[1] + 1, GameConstants.GAME_PAD_MATRIX_H - 1);
          for (int col = 0; col < GameConstants.GAME_PAD_MATRIX_W; col++) {
            map[row][col] = cloneData[row][col] != 0 ? 1 : 0;
          }
          return map;
        }
        // mixxing
        forTable((i, j) => cloneData[i][j] = fall.get(j, i) ?? cloneData[i][j]);
        final clearData = Utils.findClearCells(listWords, cloneData);
        forTable(
            (i, j) => map[i][j] = clearData.map[i][j] != 0 ? 1 : map[i][j]);
        print('found clearable cells ${clearData.clearCount}');
        break;
      }
    }
    return map;
  }

  // static ClearData findClearCells2(
  //     List<String> listWords, List<List<int>> data) {
  //   List map = [];
  //   for (int i = 0; i < GameConstants.GAME_PAD_MATRIX_H; i++) {
  //     map.add([]);
  //     for (int j = 0; j < GameConstants.GAME_PAD_MATRIX_W; j++) {
  //       map[i].add(0);
  //     }
  //   }
  //   int clearCount = 0;

  //   for (String word in listWords) {
  //     String reversedWord = word.split('').reversed.join();
  //     for (int row = 0; row < GameConstants.GAME_PAD_MATRIX_H; row++) {
  //       for (int col = 0; col < GameConstants.GAME_PAD_MATRIX_W; col++) {
  //         // Check row
  //         String rowWord = '';
  //         for (int c = col; c < GameConstants.GAME_PAD_MATRIX_W; c++) {
  //           rowWord += _getCharacterAt(row, c, data);
  //           if (rowWord == word || rowWord == reversedWord) {
  //             for (int ii = col; ii <= c; ii++) {
  //               map[row][ii] = 1;
  //             }
  //             clearCount++;
  //             print('Found "$word" in row from ($row, $col) to ($row, $c)');
  //             break;
  //           }
  //         }

  //         // Check column
  //         String colWord = '';
  //         for (int r = row; r < GameConstants.GAME_PAD_MATRIX_H; r++) {
  //           colWord += map[r][col] == 0 ? _getCharacterAt(r, col, data) : ' ';
  //           if (colWord == word || colWord == reversedWord) {
  //             for (int ii = row; ii <= r; ii++) {
  //               map[ii][col] = 1;
  //             }
  //             clearCount++;
  //             print('Found "$word" in column from ($row, $col) to ($r, $col)');
  //             break;
  //           }
  //         }
  //       }
  //     }
  //   }
  //   print('found $clearCount clearable words');

  //   return ClearData(clearCount, map);
  // }

  static ClearData findClearCells(
      List<String> listWords, List<List<int>> data) {
    final cloneData = Utils.copyList(data);
    Map<String, List<List>> wordCellsMap = {};
    final startTime = DateTime.now();

    int clearCount = 0;
    List<List<bool>> visited = List.generate(GameConstants.GAME_PAD_MATRIX_H,
        (i) => List.filled(GameConstants.GAME_PAD_MATRIX_W, false));
    final list = listWords.map((e) => e.substring(0, 1)).toList();

    for (int row = 0; row < GameConstants.GAME_PAD_MATRIX_H; row++) {
      for (int col = 0; col < GameConstants.GAME_PAD_MATRIX_W; col++) {
        final char = _getCharacterAt(row, col, cloneData);
        if (char != ' ' && list.contains(char)) {
          dfs(row, col, '', listWords, cloneData, visited, [], wordCellsMap);
        }
      }
    }
    List<List<int>> map = List.generate(GameConstants.GAME_PAD_MATRIX_H,
        (i) => List.filled(GameConstants.GAME_PAD_MATRIX_W, 0));
    for (String word in listWords) {
      final paths = wordCellsMap[word];
      if (paths != null) {
        for (int i = 0; i < paths.length; i++) {
          clearCount += paths[i].length;
          for (int j = 0; j < paths[i].length; j++) {
            map[paths[i][j][0]][paths[i][j][1]] = 1;
          }
        }
      }
    }
    final diff = DateTime.now().difference(startTime);
    print('finding time ${diff.inMilliseconds}');

    return ClearData(clearCount, map);
  }

  static bool _isExistedInList(String currentWord, List<String> listWords) {
    for (String word in listWords) {
      if (word.indexOf(currentWord) == 0) {
        return true;
      }
    }
    return false;
  }

  static bool dfs(
      int row,
      int col,
      String currentWord,
      List<String> listWords,
      List<List<int>> data,
      List<List<bool>> visited,
      List<List> currentPath,
      Map<String, List<List>> wordCellsMap) {
    int numCols = data.isEmpty ? 0 : data[0].length;
    if (row < 0 ||
        row >= data.length ||
        col < 0 ||
        col >= numCols ||
        visited[row][col]) {
      return false;
    }
    final char = _getCharacterAt(row, col, data);
    if (char == ' ') return false;

    currentWord += char;
    if (!_isExistedInList(currentWord, listWords)) return false;

    visited[row][col] = true;
    List<List> newPath = List.from(currentPath)..add([row, col]);

    if (listWords.contains(currentWord)) {
      if (wordCellsMap[currentWord] == null) {
        wordCellsMap[currentWord] = [];
      }
      wordCellsMap[currentWord]?.add(newPath);
      return true;
    }

    final neighbors = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
    ];

    for (final neighbor in neighbors) {
      final newRow = row + neighbor[0];
      final newCol = col + neighbor[1];
      final hasResult = dfs(newRow, newCol, currentWord, listWords, data,
          visited, newPath, wordCellsMap);
      if (hasResult) break;
    }

    visited[row][col] = false;
    return false;
  }
}
