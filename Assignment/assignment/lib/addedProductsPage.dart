// Szymon Janusz G20792986

import 'package:flutter/material.dart';

import "databaseHelper.dart";

class AddedProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddedProductsPageState();
  }
}

class AddedProductsPageState extends State<AddedProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  void _updatePage() {
    setState(() {
      //_getAllProducts();
    });
  }

  List<Map<String, dynamic>> _allProducts;

// Each item in this list represents whether or not the product at the same index in _allProducts is favourited or not
  List<bool> _favouritedItemsIndex = new List.empty(growable: true);

  Icon _favouriteIcon = new Icon(Icons.favorite);
  Icon _unfavouriteIcon = new Icon(Icons.favorite_border_rounded);

  _getAllProducts() async {
    _allProducts = await DatabaseHelper.instance.queryAllProductsRows();

    // Iterate over every product and see if it's present in favourites list.
    // if it is, add true at index i to _favouritedItemsIndex

    _favouritedItemsIndex.clear();

    for (int i = 0; i < _allProducts.length; i++) {
      bool isFavourite = await DatabaseHelper.instance
          .isItemFavourited(_allProducts[i].values.elementAt(0));
      _favouritedItemsIndex.add(isFavourite);
    }
  }

  _appBar() {
    return new AppBar(
      title: new Text("Added Products"),
      centerTitle: true,
      leading: new IconButton(
        icon: new Icon(Icons.keyboard_arrow_left_rounded),
        iconSize: 40,
        tooltip: "Go Back",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _toggleFavourite(String productCode, int index) async {
    bool isFavourited =
        await DatabaseHelper.instance.isItemFavourited(productCode);
    if (isFavourited) {
      await DatabaseHelper.instance.removeProductFromFavourites(productCode);
    } else {
      await DatabaseHelper.instance.addProductToFavourites(productCode);
    }

    _favouritedItemsIndex[index] =
        !_favouritedItemsIndex[index]; // Toggle favourite
    _updatePage();
  }

  _listViewBuilder() {
    if (_allProducts != null) {
      return new ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: _allProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () async {
                    await DatabaseHelper.instance
                        .deleteProduct(_allProducts[index].values.elementAt(0));
                    await _getAllProducts();
                    _updatePage();
                  }),
              trailing: new IconButton(
                  icon: _favouritedItemsIndex[index]
                      ? _favouriteIcon
                      : _unfavouriteIcon,
                  onPressed: () async {
                    await _toggleFavourite(
                        _allProducts[index].values.elementAt(0), index);
                    _updatePage();
                  }),
              title: new Text(
                  _allProducts[index].values.elementAt(1).toString() +
                      "\nCalories: " +
                      _allProducts[index].values.elementAt(6).toString()));
        },
      );
    }
  }

  _body() {
    return new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: [
          new Container(
              child: new Row(
            children: [
              new Spacer(),
              new FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async {
                    await _getAllProducts();
                    _updatePage();
                  },
                  child: new Text("Press to refresh.")),
              new Spacer()
            ],
          )),
          new Container(child: _listViewBuilder())
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: _appBar(),
            body: _body()));
  }
}
