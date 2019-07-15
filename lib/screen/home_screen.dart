import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/screen/game_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RaisedButton(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameScreen(title: "Minesweeper")),
            );
          },
          child: const Text('Start Game', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
