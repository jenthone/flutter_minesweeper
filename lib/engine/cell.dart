/*
 * {value} in 0..28
 * {value} % 10 == 9: bomb
 * {value} in 0..8: hidden
 * {value} in 10..18: opened
 * {value} in 20..28: flagged
*/
class Cell {
  var _bombsAround = 0;

  int get bombsAround => _bombsAround % 10;

  bool isHidden() => _bombsAround < 10;

  bool isOpened() => _bombsAround > 9 && _bombsAround < 20;

  bool isFlagged() => _bombsAround >= 20;

  bool isBomb() => _bombsAround % 10 == 9;

  bool isEmpty() => _bombsAround % 10 == 0;

  bool open() {
    if (isOpened()) {
      return false;
    }
    _bombsAround = 10 + _bombsAround % 10;
    return true;
  }

  bool flag() {
    if (isOpened()) {
      return false;
    }

    if (isHidden()) {
      _bombsAround = 20 + _bombsAround % 10;
    } else {
      _bombsAround = _bombsAround % 10;
    }

    return true;
  }

  void makeBomb() => _bombsAround = 9;

  void makeValue(int bombsAround) => _bombsAround = bombsAround;

  void makeEmpty() => _bombsAround = 0;
}
