import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/screen/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(title: 'Minesweeper'),
    );
  }
}
