import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipout/Constants/AppConstants.dart';
import 'package:tipout/main.dart';

class LoginViewMain extends StatefulWidget {
  bool loggedIn = false;
  LoginViewMain({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginViewMainState createState() => new _LoginViewMainState();
}

class _LoginViewMainState extends State<LoginViewMain> {
  final username = TextEditingController();
  final password = TextEditingController();

  void _showDialog(String msg, String title, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 18, 18, 1.0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: 10,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.blueAccent),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Tip Out'),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: 10,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.blueAccent),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                child: TextField(
                controller: this.username,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    border: InputBorder.none,
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
              ),
              ),
              width: 300,
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                child: TextField(
                controller: this.password,
                obscureText: true,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
              ),
              ),
              width: 300,
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  if (this.username.text == null || this.username.text == "" || this.password.text == null || this.password.text == "") {
                    this._showDialog("Missing username or password!", "Invalid Login", context);
                    return;
                  }
                  var map = {
                      'username': this.username.value.text,
                      'password': this.password.value.text
                    };

                    String url = AppConstants.appURL + "login";
                    try {
                      var response1 = await http
                          .post(url, body: jsonEncode(map), headers: {
                        "content-type": "application/json",
                      });
                      if (response1.statusCode == 200) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('token', response1.body);
                        await prefs.setString('dataid', this.username.text);
                        MyHomePage.loggedIn = true;
                        Navigator.pushReplacementNamed(context, '/main');
                      }
                      else{
                        this._showDialog("There has been an issue, please try again.", "Error", context);
                      }
                    } catch (e) {
                      this._showDialog("There has been an issue!", "Error", context);
                    }
                },
                child: Text('Submit'),
              ),
              SizedBox(width: 15),
              RaisedButton(
                  child: Text('Or Sign Up'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  })
            ])
          ],
        ),
      )),
    );
  }
}