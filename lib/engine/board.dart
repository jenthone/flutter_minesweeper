import 'dart:collection';
import 'dart:math';

import 'package:flutter_minesweeper/engine/cell.dart';
import 'package:tuple/tuple.dart';

class Board {
  static const dr8 = [-1, 0, 1, 1, 1, 0, -1, -1];
  static const dc8 = [1, 1, 1, 0, -1, -1, -1, 0];

  final int _row;
  final int _column;
  final int _numOfBombs;

  var _openedCell = 0;
  bool get winner => _openedCell == _row * column - _numOfBombs;

  List<List<Cell>> _cells;
  bool _gameOver = false;

  Board(this._row, this._column, this._numOfBombs) {
    _cells = List<List<Cell>>.generate(
        _row, (i) => List<Cell>.generate(_column, (j) => Cell()));
  }

  int get row => _row;

  int get column => _column;

  bool get gameOver => _gameOver;

  bool isValid(int row, int column) =>
      row >= 0 && column >= 0 && row < _row && column < _column;

  void generateBombs() {
    var numOfBombs = _numOfBombs;
    final random = Random();
    while (numOfBombs > 0) {
      final row = random.nextInt(_row);
      final column = random.nextInt(_column);
      final cell = _cells[row][column];
      if (!cell.isBomb()) {
        cell.makeBomb();
        numOfBombs -= 1;
      }
    }
  }

  void generateBombAround() {
    for (var i = 0; i < _row; i++) {
      for (var j = 0; j < _column; j++) {
        if (isValid(i, j) && !_cells[i][j].isBomb()) {
          calculateNumber(i, j);
        }
      }
    }
  }

  List<Tuple3<int, int, Cell>> findCellAround(int row, int column) {
    final cells = List<Tuple3<int, int, Cell>>();
    for (var i = 0; i < dr8.length; i++) {
      final r = row + dr8[i];
      final c = column + dc8[i];
      if (!isValid(r, c)) {
        continue;
      }
      cells.add(Tuple3<int, int, Cell>(r, c, _cells[r][c]));
    }
    return cells;
  }

  void generateCells() {
    generateBombs();
    generateBombAround();
  }

  void calculateNumber(int row, int column) {
    var bombsAround = 0;
    findCellAround(row, column)
        .where((tuple) => tuple.item3.isBomb())
        .forEach((tuple) {
      bombsAround += 1;
    });
    _cells[row][column].makeValue(bombsAround);
  }

  void open(int row, int column) {
    final cell = _cells[row][column];
    if (cell.isFlagged()) {
      cell.flag();
      return;
    }

    if (cell.isOpened()) {
      return;
    }

    if (cell.isEmpty()) {
      openEmpty(row, column, cell);
      checkWinner();
      return;
    }

    final canOpend = cell.open();
    if (!canOpend) {
      return;
    }
    if (cell.isBomb()) {
      _gameOver = true;
    } else {
      _openedCell += 1;
    }
    checkWinner();
  }

  void toggleFlag(int row, int column) {
    final cell = _cells[row][column];
    cell.flag();
  }

  void quickOpenAround(int row, int column) {
    final cell = _cells[row][column];
    if (!cell.isOpened()) {
      return;
    }

    final list = List<Tuple3<int, int, Cell>>();

    var totalBombsVisible = 0;

    findCellAround(row, column).forEach((tuple) {
      final r = tuple.item1;
      final c = tuple.item2;
      final cell = tuple.item3;
      if ((cell.isFlagged() || (cell.isOpened() && cell.isBomb()))) {
        totalBombsVisible += 1;
      } else {
        list.add(Tuple3<int, int, Cell>(r, c, cell));
      }
    });

    if (totalBombsVisible != cell.bombsAround) {
      return;
    }

    list.forEach((t) {
      final r = t.item1;
      final c = t.item2;
      final cell = t.item3;
      if (cell.isBomb() && cell.isHidden()) {
        _gameOver = true;
        return;
      }
      open(r, c);
    });
  }

  void openEmpty(int row, int column, Cell cell) {
    final queue = Queue<Tuple3<int, int, Cell>>();

    queue.add(Tuple3<int, int, Cell>(row, column, cell));

    while (queue.isNotEmpty) {
      final t = queue.removeFirst();
      final r = t.item1;
      final c = t.item2;
      final cell = t.item3;
      cell.open();
      _openedCell += 1;
      if (!cell.isEmpty()) {
        continue;
      }
      findCellAround(r, c).where((t) => t.item3.isHidden()).forEach((t) {
        if (!queue.contains(t)) {
          queue.add(t);
        }
      });
    }
  }

  void printBoard() {
    for (var i = 0; i < _row; i++) {
      var strLine = '';
      for (var j = 0; j < _column; j++) {
        final cell = _cells[i][j];
        if (cell.isBomb()) {
          strLine += 'B';
        } else if (cell.isEmpty()) {
          strLine += '-';
        } else {
          strLine += '${cell.bombsAround}';
        }
      }
      print(strLine);
    }
  }

  Cell cellAt(int row, int column) {
    return _cells[row][column];
  }

  void reset() {
    _cells.forEach((cells) => cells.forEach((cell) => cell.makeEmpty()));
    generateCells();
    _gameOver = false;
    _openedCell = 0;
  }

  void checkWinner() {
    if (_gameOver) {
      return;
    }
    if (_openedCell == _row * column - _numOfBombs) {
      _gameOver = true;
    }
  }
}
