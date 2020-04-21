import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipout/Constants/AppConstants.dart';
import 'package:tipout/Models/TipModel.dart';
import 'package:tipout/Views/LoginView.dart';
import 'package:tipout/Views/RegisterView.dart';
import 'package:tipout/Views/TipListView.dart';

void main() {
  if (Platform.isAndroid) {
    print('Android based');
  }

  if (kDebugMode) {
    print('Running in debug mode');
  }

  if (kReleaseMode) {
    print('Running in release mode');
  }

  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/register': (context) => RegisterViewMain(),
        '/login': (context) => LoginViewMain(),
        '/tips': (context) => TipsListViewMain(),
        '/main': (context) => MyHomePage()
      },
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        backgroundColor: Color(0xFF000000),
        accentColor: Colors.white,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black54,
      ),
      home: LoginViewMain(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static bool loggedIn = false;
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final username = TextEditingController();
  final password = TextEditingController();

  String usersName = '';

  List<TipModel> tips = [];

  _MyHomePageState() {
    loadAppState();
  }

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

  void loadAppState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String d = prefs.getString("dataid");
    String url = AppConstants.appURL + "crud/" + d;
    try {
      var response1 = await http.get(url, headers: {
        "content-type": "application/json",
      });
      if (response1.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('data', response1.body);
        setState(() {
          usersName = d;
        });
      } else {
        this._showDialog(
            "There has been an issue, please try again.", "Error", context);
      }
    } catch (e) {
      this._showDialog("There has been an issue!", "Error", context);
    }
  }

  double foodCalc() {
    double foodcalc = (double.parse(this.password.text) / 100) *
        double.parse(this.username.text);
    double mod = foodcalc * 20;
    double foodrounded = mod.roundToDouble();
    double food = foodrounded / 20;
    return food;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 18, 18, 1.0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => TipsListViewMain()),); }),
          IconButton(icon: Icon(Icons.settings), onPressed: () {})
          ],
        title: Text(
          'Tipout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ready To Tipout ' + usersName + '?',
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                child: TextField(
                  controller: this.username,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      border: InputBorder.none,
                      hintText: 'Tip amount',
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: 'Tip amount',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              width: MediaQuery.of(context).size.width / 1.5,
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                child: TextField(
                  controller: this.password,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      border: InputBorder.none,
                      hintText: 'Percent to tipout',
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: 'Percent to tipout',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              width: MediaQuery.of(context).size.width / 1.5,
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
                onPressed: () {
                  var output = this.foodCalc();

                  TipModel t = new TipModel();
                  t.ownerID = usersName;
                  t.tipAmount = double.parse(this.username.text);
                  t.tipoutAmount = output;
                  t.tipPercentage = double.parse(this.password.text);
                  t.shiftDate = DateTime.now();
                  setState(() {
                    tips.add(t);
                  });

                  this.username.text = "";
                  this.password.text = "";

                  this._showDialog("Amount To Tip Out: " + output.toString(),
                      "Result", context);
                },
                child: Text("Calculate")),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: tips.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Tip Out Amount: ' + tips[index].tipoutAmount.toString()),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String url = AppConstants.appURL + "tip";
            for (var i = 0; i < tips.length; i++) {
              var map = {
                'id': tips[i].id,
                'tipAmount': tips[i].tipAmount,
                "tipoutAmount": tips[i].tipoutAmount,
                "workplace": tips[i].workplace,
                "shiftDate": tips[i].shiftDate.toIso8601String(),
                "tipPercentage": tips[i].tipPercentage,
                "ownerID": tips[i].ownerID
              };
              try {
                var response1 =
                    await http.post(url, body: jsonEncode(map), headers: {
                  "content-type": "application/json",
                });
                if (response1.statusCode != 200) {
                  this._showDialog("There has been an issue, please try again.",
                      "Error", context);
                }
              } catch (e) {
                this._showDialog("There has been an issue!", "Error", context);
                return;
              }

              setState(() {
                tips = new List<TipModel>();
              });

              this.loadAppState();
            }
          },
          child: Icon(Icons.save)),
    );
  }
}
