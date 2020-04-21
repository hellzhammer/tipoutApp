import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipout/Models/TipModel.dart';

class TipsListViewMain extends StatefulWidget {
  bool loggedIn = false;
  TipsListViewMain({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TipsListViewMainState createState() => new _TipsListViewMainState();
}

class _TipsListViewMainState extends State<TipsListViewMain> {
  List<TipModel> tips = [];
  List<TipModel> mainTips = [];
  _TipsListViewMainState(){
    prepareData();
  }

  void prepareData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('data');
    var data = jsonDecode(json);
    if(data != null){
      var _tips = data['tipList'];
      for (var i = 0; i < _tips.length; i++) {
        TipModel t = new TipModel();
        t.id = _tips[i]['id'];
        t.tipAmount = double.parse(_tips[i]['tipAmount'].toString());
        t.tipoutAmount = double.parse(_tips[i]['tipoutAmount'].toString());
        //t.workplace = _tips[i]['workplace'];
        t.shiftDate = DateTime.parse(_tips[i]['shiftDate'].toString());
        t.tipPercentage = double.parse(_tips[i]['tipPercentage'].toString());
        t.ownerID = _tips[i]['ownerID'];
        setState(() {
          tips.add(t);
        });
      }
      mainTips = tips;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 18, 18, 1.0),
      appBar: AppBar(
        title: Text(
          'Tip Viewer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width/4, child:RaisedButton(onPressed: (){
                tips = new List<TipModel>();
                setState(() {
                  for (var i = 0; i < mainTips.length; i++) {
                    var v = DateTime.now().compareTo(mainTips[i].shiftDate); 
                    if(v <= 7){
                      tips.add(mainTips[i]);
                    }
                  }
                });
              }, child: Text("Last 7")),),

              SizedBox(width: MediaQuery.of(context).size.width/4, child: RaisedButton(onPressed: (){
                tips = new List<TipModel>();
                setState(() {
                  for (var i = 0; i < mainTips.length; i++) {
                    var v = DateTime.now().compareTo(mainTips[i].shiftDate); 
                    if(v <= 14){
                      tips.add(mainTips[i]);
                    }
                  }
                });
              }, child: Text("Last 14")),),

              SizedBox(width: MediaQuery.of(context).size.width/4, child: RaisedButton(onPressed: (){
                tips = new List<TipModel>();
                setState(() {
                  for (var i = 0; i < mainTips.length; i++) {
                    var v = DateTime.now().compareTo(mainTips[i].shiftDate); 
                    if(v <= 30){
                      tips.add(mainTips[i]);
                    }
                  }
                });
              }, child: Text("Last 30")),),

              SizedBox(width: MediaQuery.of(context).size.width/4, child: RaisedButton(onPressed: (){
                tips = new List<TipModel>();
                setState(() {
                  for (var i = 0; i < mainTips.length; i++) {
                    tips.add(mainTips[i]);
                  }
                });
              }, child: Text("All")),),

            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.25,
            child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: tips.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text("Date: "+tips[index].shiftDate.toLocal().day.toString() + "/" + tips[index].shiftDate.toLocal().month.toString() + "/" + tips[index].shiftDate.toLocal().year.toString()),
                          SizedBox(height: 10),
                          Text("Total Tips: "+tips[index].tipAmount.toString()),
                          SizedBox(height: 10),
                          Text("Total Tipped Out: "+tips[index].tipoutAmount.toString()),
                          SizedBox(height: 10),
                          Text("Tipout Percentage: "+tips[index].tipPercentage.toString()),
                          SizedBox(height: 10),
                        ],
                      )
                    );
                  }),
          )
        ]
      )
    );
  }
}