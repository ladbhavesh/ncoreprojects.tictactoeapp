import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tictactoeapp/board.dart';
import 'package:tictactoeapp/playerTypes.dart';

class GameJoin extends StatefulWidget {
  final FirebaseApp app;

  GameJoin(this.app);
  @override
  State<StatefulWidget> createState() {
    return _GameJoinState(app);
  }
}

class _GameJoinState extends State<GameJoin> {
  final FirebaseApp app;
  final _textController = TextEditingController();
  _GameJoinState(this.app);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var column = new Column(children: <Widget>[
      TextField(
        controller: _textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter game code',
        ),
      ),
      MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        elevation: 5.0,
        minWidth: 50.0,
        height: 35,
        color: Color(0xFF801E48),
        child: new Text('Join',
            style: new TextStyle(fontSize: 16.0, color: Colors.white)),
        onPressed: () {
          var code = _textController.text;

          if (code != null || code != '') {
            var database = FirebaseDatabase(app: app);
            database.reference().child(code).once().then((snapshot) {
              if (snapshot.value != null) {
                print(snapshot.value);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BoardPage(app, PlayerTypes.secondary, code)));
              } else {
                print("snapshot is null");

                Fluttertoast.showToast(
                    msg: "Invalid game code",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            });
          }
        },
      )
    ]);

    return new Scaffold(
        body: Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 0),
      child: column,
    ));
  }
}
