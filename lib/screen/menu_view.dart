import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game.dart';
import 'package:flutter_minesweeper/utility/bus_state.dart';
import 'package:flutter_minesweeper/utility/event.dart';

class MenuView extends StatefulWidget {
  MenuView({Key key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends BusState<MenuView> {
  var _secondsCounter = 0;

  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsCounter += 1;
      });
    });

    eventBusSubscription = eventBus.on<GameEvent>().listen((event) {
      if (event is GameResetEvent) {
        setState(() {
          _secondsCounter = 0;
        });
      } else if (event is GameOverEvent) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Text('${_displayDuration()}', style: TextStyle(fontSize: 25)),
    );
  }

  String _displayDuration() {
    if (board.gameOver) {
      if (board.winner) {
        return 'WIN';
      } else {
        return 'LOSE';
      }
    }
    return '${(_secondsCounter ~/ 60).toString().padLeft(2, '0')}:${(_secondsCounter % 60).toString().padLeft(2, '0')}';
  }
}
