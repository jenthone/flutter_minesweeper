import 'package:flutter_minesweeper/engine/board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test board simple with 1 bomb", () {
    final board = Board(1, 1, 1);
    board.open(0, 0);
    expect(board.gameOver, equals(true));
  });

  test("Test board simple with 0 bomb", () {
    final board = Board(1, 1, 0);
    board.open(0, 0);
    expect(board.gameOver, equals(false));
  });

  test("Test print", () {
    final board = Board(8, 8, 6);
    board.printBoard();
  });
}
