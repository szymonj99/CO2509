// Szymon Janusz G20792986

import 'package:assignment/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import "constants.dart";
import "scanProductPage.dart";

import "breakfastPage.dart";
import "dinnerPage.dart";
import "supperPage.dart";
import "addedProductsPage.dart";

import "package:flutter/services.dart";

final double containerHeight = 80;
final double spacerSize = 15;

final double titleSize = 24;
final double valueSize = 20;

final Container mySpacer = Container(height: spacerSize);

String today = DateFormat("dd/MM/yyyy").format(DateTime.now());

var listNames = [
  "Breakfast",
  "Dinner",
  "Supper",
  "Scan a Product",
  "Added Products"
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new AppStart());
  });
}

class AppStart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppStartState();
  }
}

class AppStartState extends State<AppStart> {
  void _updatePage() {
    setState(() {});
  }

  _breakfastContainer() {
    return new Container(
        height: containerHeight,
        child: Builder(
            builder: (context) => FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  print(listNames[0] + " button pressed.");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BreakfastPage()));
                },
                hoverColor: Colors.grey,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        Text(listNames[0],
                            style: TextStyle(
                                fontSize: titleSize,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Spacer()
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Spacer(),
                        Text(_breakfastCalories.toString(),
                            style: TextStyle(
                                fontSize: valueSize, color: Colors.black)),
                        Spacer()
                      ],
                    )
                  ],
                ))));
  }

  _dinnerContainer() {
    return new Container(
        height: containerHeight,
        child: Builder(
            builder: (context) => FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  print(listNames[1] + " button pressed.");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DinnerPage()));
                },
                hoverColor: Colors.grey,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        Text(listNames[1],
                            style: TextStyle(
                                fontSize: titleSize,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Spacer()
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Spacer(),
                        Text(_dinnerCalories.toString(),
                            style: TextStyle(
                                fontSize: valueSize, color: Colors.black)),
                        Spacer()
                      ],
                    )
                  ],
                ))));
  }

  _supperContainer() {
    return new Container(
        height: containerHeight,
        child: Builder(
            builder: (context) => FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  print(listNames[2] + " button pressed.");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SupperPage()));
                },
                hoverColor: Colors.grey,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        Text(listNames[2],
                            style: TextStyle(
                                fontSize: titleSize,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Spacer()
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Spacer(),
                        Text(_supperCalories.toString(),
                            style: TextStyle(
                                fontSize: valueSize, color: Colors.black)),
                        Spacer()
                      ],
                    )
                  ],
                ))));
  }

  _scanProductContainer() {
    return new Container(
        height: containerHeight,
        child: Builder(
          builder: (context) => FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                print(listNames[3] + " button pressed.");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanProductPage()));
              },
              hoverColor: Colors.grey,
              child: Center(
                child: Text(
                  listNames[3],
                  style: TextStyle(
                      fontSize: titleSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ));
  }

  _calorieCounterContainer() {
    return new CircleAvatar(
      backgroundColor: Colors.blue,
      radius: 100,
      child: Center(
          child: Column(
        children: [
          Spacer(),
          Center(
              child: Text(
            "Calories:",
            style: TextStyle(fontSize: 36, color: Colors.white),
          )),
          Container(height: 15),
          Center(
              child: Text(
            (_breakfastCalories + _dinnerCalories + _supperCalories)
                .toString(), // Change
            style: TextStyle(fontSize: 36, color: Colors.white),
          )),
          Spacer()
        ],
      )),
    );
  }

  _addedProductsContainer() {
    return new Container(
        height: containerHeight,
        child: Builder(
          builder: (context) => FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                print(listNames[4] + " button pressed.");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddedProductsPage()));
              },
              hoverColor: Colors.grey,
              child: Center(
                child: Text(
                  listNames[4],
                  style: TextStyle(
                      fontSize: titleSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ));
  }

  _updateCalories() async {
    _breakfastCalories =
        await DatabaseHelper.instance.getBreakfastCaloriesToday();
    if (_breakfastCalories == null) {
      _breakfastCalories = 0;
    }
    _dinnerCalories = await DatabaseHelper.instance.getDinnerCaloriesToday();
    if (_dinnerCalories == null) {
      _dinnerCalories = 0;
    }
    _supperCalories = await DatabaseHelper.instance.getSupperCaloriesToday();
    if (_supperCalories == null) {
      _supperCalories = 0;
    }
  }

  _body() {
    return new Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: <Widget>[
          new Container(
              child: new Row(
            children: [
              new Spacer(),
              new FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async {
                    await _updateCalories();
                    _updatePage();
                  },
                  child: new Text("Press to refresh")),
              new Spacer()
            ],
          )),
          Container(height: 50),
          _calorieCounterContainer(),
          Container(height: containerHeight),
          // Breakfast Page - Navigated
          _breakfastContainer(),
          mySpacer,
          // Dinner Page - Navigated
          _dinnerContainer(),
          mySpacer,
          // Supper Page - Navigated
          _supperContainer(),
          mySpacer,
          // Scan a Product page - Navigated
          _scanProductContainer(),
          mySpacer,
          // Added Products page
          _addedProductsContainer(),
          Container(height: 50)
        ]));
  }

  int _breakfastCalories = 0;
  int _dinnerCalories = 0;
  int _supperCalories = 0;

  _appBar() {
    return new AppBar(
        title: Text(gAppName, style: TextStyle(fontSize: 30)),
        centerTitle: true,
        leading: Icon(Icons.food_bank_outlined, size: 50));
  }

  @override
  Widget build(BuildContext context) {
    //print(today);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _appBar(),
            body: _body()));
  }
}
