import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game.dart';
import 'package:flutter_minesweeper/screen/board_view.dart';
import 'package:flutter_minesweeper/screen/menu_view.dart';
import 'package:flutter_minesweeper/utility/bus_state.dart';
import 'package:flutter_minesweeper/utility/event.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends BusState<GameScreen> {
  @override
  Widget build(BuildContext context) {
    board.reset();

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          new IconButton(icon: new Icon(Icons.refresh), onPressed: _reset),
        ],
        title: Text(widget.title),
      ),
      body: Container(
        decoration: new BoxDecoration(color: Colors.grey),
        child: Column(
          children: <Widget>[
            MenuView(),
            Expanded(
              child: BoardView(),
            ),
          ],
        ),
      ),
    );
  }

  void _reset() {
    eventBus.fire(GameResetEvent());
  }
}
