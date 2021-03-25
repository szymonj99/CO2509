// Szymon Janusz G20792986

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import "databaseHelper.dart";

import 'package:flutter/rendering.dart';

class SupperPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SupperPageState();
  }
}

class SupperPageState extends State<SupperPage> {
  void _updatePage() {
    setState(() {});
  }

  _appBar() {
    return new AppBar(
      title: Text("My Supper"),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_left_rounded),
        iconSize: 40,
        tooltip: "Go Back",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _getAllProducts() async {
    _allProducts = await DatabaseHelper.instance.queryAllProductsRows();
  }

  List<Map<String, dynamic>> _allProducts;

  int _supperCalories = 0;

  _updateBodyButton() {
    return new ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: [
        new Row(
          children: [
            new Spacer(),
            new FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  await _getAllProducts();
                  await _updateCaloriesToday();
                  _updatePage();
                },
                child: new Text("Press to refresh.")),
            new Spacer()
          ],
        )
      ],
    );
  }

  _getProductsListHeader() {
    if (_allProducts != null) {
      return new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: [
            new Row(
              children: [
                new Spacer(),
                new Text(
                    "Supper Calories for Today: " + _supperCalories.toString()),
                new Spacer()
              ],
            ),
            new Row(
              children: [
                new Spacer(),
                new Text("\nProducts List"),
                new Spacer()
              ],
            ),
          ]);
    } else {
      return new Container();
    }
  }

  _displayProductsList() {
    return new ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: [_getProductsListHeader(), _productListViewBuilder()],
    );
  }

  _updateCaloriesToday() async {
    int result = await DatabaseHelper.instance.getSupperCaloriesToday();
    if (result == null) {
      _supperCalories = 0;
    } else {
      _supperCalories = result;
    }
  }

  _productListViewBuilder() {
    if (_allProducts != null) {
      return new ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: _allProducts.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: new Text(
                    _allProducts[index].values.elementAt(1).toString() +
                        "\nCalories: " +
                        _allProducts[index].values.elementAt(6).toString()),
                trailing: new IconButton(
                    icon: new Icon(Icons.add_box),
                    onPressed: () async {
                      await _getAllProducts();
                      // Add product calories to breakfast sql query
                      await DatabaseHelper.instance.addCaloriesToSupper(
                          _allProducts[index].values.elementAt(6));
                      await _updateCaloriesToday();
                      _updatePage();
                    }));
          });
    } else {
      return new Container();
    }
  }

  _body() {
    return new ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      children: [_updateBodyButton(), _displayProductsList()],
    );
  }
  //, _allProductsList()

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: new Scaffold(appBar: _appBar(), body: _body()));
  }
}
