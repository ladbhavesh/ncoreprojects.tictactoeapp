import 'dart:math';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:tictactoeapp/gamePosition.dart';
import 'package:tictactoeapp/gameStatus.dart';
import 'package:tictactoeapp/playerTypes.dart';

class BoardPage extends StatefulWidget {
  BoardPage(this.app, this.playerType, this.gameCode);
  final FirebaseApp app;
  final PlayerTypes playerType;
  final String gameCode;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BoardPageState(app, playerType, gameCode);
  }
}

class _BoardPageState extends State<BoardPage> {
  _BoardPageState(this.app, this.playerType, this.gameCode);

  final FirebaseApp app;
  final PlayerTypes playerType;
  final String gameCode;
  FirebaseDatabase database;

  bool _myTurn = true;
  final Color _finalColor = Colors.red[100];
  var _colors = [
    Colors.green[100],
    Colors.green[100],
    Colors.green[100],
    Colors.green[100],
    Colors.green[100],
    Colors.green[100],
    Colors.green[100],
    Colors.green[100],
    Colors.green[100]
  ];

  var _positions = ['', '', '', '', '', '', '', '', ''];

  GameStatus _getGetStatus() {
    if (_positions.where((element) => element != '').length < 5)
      return GameStatus.InProgress;

    var myIndicator = playerType == PlayerTypes.primary ? "X" : "0";
    var opponentIndicator = myIndicator == "X" ? "0" : "X";

    var myStatus = _getGameStusForPlayer(myIndicator);
    var opponentStaus = _getGameStusForPlayer(opponentIndicator);

    if (myStatus == GameStatus.Won) {
      return GameStatus.Won;
    }

    if (opponentStaus == GameStatus.Won) {
      return GameStatus.Lost;
    }

    if (_positions.where((element) => element != "").length == 9) {
      return GameStatus.Drawn;
    }

    return GameStatus.InProgress;
  }

  void _showStatus(GameStatus status) {
    var gameStatus = "";
    switch (status) {
      case GameStatus.Drawn:
        gameStatus = "Drawn";
        break;
      case GameStatus.Lost:
        gameStatus = "Lost";
        break;
      case GameStatus.Won:
        gameStatus = "Won";
        break;
      case GameStatus.InProgress:
        gameStatus = "Inprogress";
        break;
    }

    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Game over'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('You ${gameStatus}'),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  GameStatus _getGameStusForPlayer(String player) {
    if (_positions[0] == player &&
        _positions[1] == player &&
        _positions[2] == player) {
      return GameStatus.Won;
    }

    if (_positions[3] == player &&
        _positions[4] == player &&
        _positions[5] == player) {
      return GameStatus.Won;
    }

    if (_positions[6] == player &&
        _positions[7] == player &&
        _positions[8] == player) {
      return GameStatus.Won;
    }

    if (_positions[0] == player &&
        _positions[3] == player &&
        _positions[6] == player) {
      return GameStatus.Won;
    }

    if (_positions[1] == player &&
        _positions[4] == player &&
        _positions[7] == player) {
      return GameStatus.Won;
    }

    if (_positions[2] == player &&
        _positions[5] == player &&
        _positions[8] == player) {
      return GameStatus.Won;
    }

    if (_positions[0] == player &&
        _positions[4] == player &&
        _positions[8] == player) {
      return GameStatus.Won;
    }

    if (_positions[2] == player &&
        _positions[4] == player &&
        _positions[6] == player) {
      return GameStatus.Won;
    }

    return GameStatus.InProgress;
  }

  bool isMyTurn(GamePosition gamePosition) {
    var lastplayedBy = gamePosition.lastMoveBy;

    if (lastplayedBy == "X" && playerType == PlayerTypes.secondary) {
      return true;
    }

    if (lastplayedBy == "0" && playerType == PlayerTypes.primary) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    if (playerType == PlayerTypes.secondary) {
      _myTurn = false;
    }
    database = FirebaseDatabase(app: widget.app);

    _setRealtimeValue();

    database.reference().child(gameCode).onValue.listen((event) {
      print(event.snapshot.value.toString());
      Map gameDataMap = jsonDecode(event.snapshot.value);
      var newGamePosition = GamePosition.fromJson(gameDataMap);

      if (isMyTurn(newGamePosition)) {
        setState(() {
          if (newGamePosition.pos0 != _positions[0]) {
            _positions[0] = newGamePosition.pos0;
            _colors[0] = _finalColor;
          }
          if (newGamePosition.pos1 != _positions[1]) {
            _positions[1] = newGamePosition.pos1;
            _colors[1] = _finalColor;
          }
          if (newGamePosition.pos2 != _positions[2]) {
            _positions[2] = newGamePosition.pos2;
            _colors[2] = _finalColor;
          }
          if (newGamePosition.pos3 != _positions[3]) {
            _positions[3] = newGamePosition.pos3;
            _colors[3] = _finalColor;
          }
          if (newGamePosition.pos4 != _positions[4]) {
            _positions[4] = newGamePosition.pos4;
            _colors[4] = _finalColor;
          }
          if (newGamePosition.pos5 != _positions[5]) {
            _positions[5] = newGamePosition.pos5;
            _colors[5] = _finalColor;
          }
          if (newGamePosition.pos6 != _positions[6]) {
            _positions[6] = newGamePosition.pos6;
            _colors[6] = _finalColor;
          }
          if (newGamePosition.pos7 != _positions[7]) {
            _positions[7] = newGamePosition.pos7;
            _colors[7] = _finalColor;
          }
          if (newGamePosition.pos8 != _positions[8]) {
            _positions[8] = newGamePosition.pos8;
            _colors[8] = _finalColor;
          }

          _myTurn = true;
          var status = _getGetStatus();
          if (status != GameStatus.InProgress) {
            _showStatus(_getGetStatus());
          }
        });
      }
    });
  }

  _setRealtimeValue() {
    String lastMoveBy;
    if (playerType == PlayerTypes.primary) {
      lastMoveBy = "X";
    } else {
      lastMoveBy = "0";
    }

    var gamePoistion = GamePosition(
        gameCode,
        _positions[0],
        _positions[1],
        _positions[2],
        _positions[3],
        _positions[4],
        _positions[5],
        _positions[6],
        _positions[7],
        _positions[8],
        lastMoveBy,
        DateTime.now().toUtc());

    var jsonString = jsonEncode(gamePoistion);

    database.reference().child(gameCode).set(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    Widget w = _getRow(context); // getGrid(context);
    //Widget w2 = getRow(context);
    Widget g = Expanded(child: _getGrid(context));
    // Widget g2 = Expanded(child: getGrid2(context));
    Widget turn = _getTurnWidget(context);

    var r = Column(
      children: <Widget>[w, g, turn],
    );
    Widget c = Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 0),
      child: r,
    );

    return Material(child: c);
  }

  Widget _getTurnWidget(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(_myTurn ? "Your turn" : "Wait"),
        ],
      ),
    );
  }

  Widget _getRow(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Text(
          "Code: ${gameCode}",
          style: TextStyle(fontSize: 40),
        ),
      ],
    ));
  }

  Widget _getTicTacToeUnit(int index, BuildContext context) {
    return GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            _positions[index],
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 70),
            textAlign: TextAlign.center,
          ),
          color: _colors[index],
        ),
        onTap: () {
          if (!_myTurn || _positions[index] != '') return;

          setState(() {
            _myTurn = false;
            _colors[index] = _finalColor;

            if (playerType == PlayerTypes.primary) {
              _positions[index] = "X";
            } else {
              _positions[index] = "0";
            }
            _setRealtimeValue();
            var status = _getGetStatus();
            if (status != GameStatus.InProgress) {
              _showStatus(status);
            }
          });
        });
  }

  Widget _getGrid2(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: <Widget>[
        _getTicTacToeUnit(0, context),
        _getTicTacToeUnit(1, context),
        _getTicTacToeUnit(2, context),
        _getTicTacToeUnit(3, context),
        _getTicTacToeUnit(4, context),
        _getTicTacToeUnit(5, context),
        _getTicTacToeUnit(6, context),
        _getTicTacToeUnit(7, context),
        _getTicTacToeUnit(8, context),
      ],
    );
  }

  Widget _getGrid(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              _getTicTacToeUnit(0, context),
              _getTicTacToeUnit(1, context),
              _getTicTacToeUnit(2, context),
              _getTicTacToeUnit(3, context),
              _getTicTacToeUnit(4, context),
              _getTicTacToeUnit(5, context),
              _getTicTacToeUnit(6, context),
              _getTicTacToeUnit(7, context),
              _getTicTacToeUnit(8, context),
            ],
          ),
        ),
      ],
    );
  }
}
