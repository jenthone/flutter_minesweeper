import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/utility/bus_state.dart';
import 'package:flutter_minesweeper/utility/event.dart';
import 'package:flutter_minesweeper/utility/utility.dart';

import '../game.dart';

class BoardView extends StatefulWidget {
  BoardView({Key key}) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends BusState<BoardView> {
  @override
  void initState() {
    super.initState();

    eventBusSubscription = eventBus.on<GameEvent>().listen((event) {
      if (event is GameResetEvent) {
        setState(() {
          board.reset();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: board.column,
      children: List.generate(board.row * board.column, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _onTapAt(index);
            });
          },
          onDoubleTap: () {
            setState(() {
              _onDoubleTapAt(index);
            });
          },
          onLongPress: () {
            setState(() {
              _onLongPressAt(index);
            });
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageAt(index),
              ),
              borderRadius: BorderRadius.circular(1.0),
            ),
          ),
        );
      }),
    );
  }

  AssetImage _imageAt(int index) {
    final row = index ~/ board.column;
    final column = (index - (row * board.column)) % board.row;
    final cell = board.cellAt(row, column);
    if (cell.isHidden() && !board.gameOver) {
      return AssetImage(pathOfImages('facingDown.png'));
    }
    if (cell.isFlagged()) {
      return AssetImage(pathOfImages('flagged.png'));
    }
    if (cell.isBomb()) {
      return AssetImage(pathOfImages('bomb.png'));
    }
    return AssetImage(pathOfImages('${cell.bombsAround}.png'));
  }

  void _onTapAt(int index) {
    final row = index ~/ board.column;
    final column = (index - (row * board.column)) % board.row;
    board.open(row, column);
    if (board.gameOver) {
      eventBus.fire(GameOverEvent());
    }
  }

  void _onDoubleTapAt(int index) {
    final row = index ~/ board.column;
    final column = (index - (row * board.column)) % board.row;
    board.quickOpenAround(row, column);
  }

  void _onLongPressAt(int index) {
    final row = index ~/ board.column;
    final column = (index - (row * board.column)) % board.row;
    board.toggleFlag(row, column);
  }
}
