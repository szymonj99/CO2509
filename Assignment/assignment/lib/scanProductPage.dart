// Szymon Janusz G20792986

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import "openFoodFactsAPI.dart";

import "databaseHelper.dart";

import "constants.dart";

int currentProductCalories = 0;
String currentProductIngredients = "";
String currentProductNutrients = "";

String getUniqueProductCode() {
  return DateFormat("ssmmhhddMMyyyy").format(DateTime.now());
}

class ScanProductPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScanProductPageState();
  }
}

class GetProductNameContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (currentProduct.toJson() == emptyProduct.toJson()) {
      return new Container(
          width: 200, alignment: Alignment.centerRight, child: Text(""));
    }
    if (currentProduct.productName == null) {
      currentProduct.productName = "Name not found.";
      return new Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: Text("Name not found."));
    }
    if (currentProduct.productName == "Not found.") {
      return new Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: Text("Not found."));
    }
    TextEditingController _controller =
        TextEditingController(text: currentProduct.productName);
    return new Container(
        width: 200,
        alignment: Alignment.centerRight,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.right,
          onChanged: (String value) => currentProduct.productName = value,
        ));
  }
}

class GetProductEcoGradeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (currentProduct == emptyProduct) {
      return new Container(
          width: 200, alignment: Alignment.centerRight, child: Text(""));
    }
    if (currentProduct.ecoscoreGrade == null ||
        currentProduct.ecoscoreGrade == "unknown") {
      currentProduct.ecoscoreGrade = "E";
      return new Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: Text("Eco Grade not found. Defaulting to E."));
    }

    return new Container(
        width: 200,
        alignment: Alignment.centerRight,
        child: new Container(
            width: 200,
            alignment: Alignment.centerRight,
            child: Text(currentProduct.ecoscoreGrade)));
  }
}

class GetProductNovaGradeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (currentProduct == emptyProduct) {
      return new Container(
          width: 200, alignment: Alignment.centerRight, child: Text(""));
    }

    if (currentProduct.nutriments == null ||
        currentProduct.nutriments.novaGroup == null) {
      currentProduct.nutriments.novaGroup = 0;
      return new Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: new Container(
              width: 200,
              alignment: Alignment.centerRight,
              child: Text("Nova Grade not found. Defaulting to 0.")));
    }

    return new Container(
        width: 200,
        alignment: Alignment.centerRight,
        child: new Container(
            width: 200,
            alignment: Alignment.centerRight,
            child: Text(currentProduct.nutriments.novaGroup.toString())));
  }
}

class GetProductIngredientsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (currentProduct == emptyProduct) {
      return new Container(
          width: 200, alignment: Alignment.centerRight, child: Text(""));
    }

    if (currentProduct.ingredientsText == null ||
        currentProduct.ingredientsText.length == 0) {
      currentProduct.ingredientsText = "Empty";
      currentProduct.ingredients = [new Ingredient(text: "Empty")];
      return new Container(
        alignment: Alignment.centerRight,
        child: new Text("Empty"),
        width: 200,
      );
    }

    print("DEBUG: Product ingredients are: " + currentProduct.ingredientsText);

    return new Container(
      alignment: Alignment.centerRight,
      child: new Text(currentProduct.ingredientsText),
      width: 200,
    );
  }
}

class GetProductNutrientsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (currentProduct == emptyProduct) {
      return new Container(
          width: 200, alignment: Alignment.centerRight, child: Text(""));
    }
    if (currentProduct.nutrientLevels.levels.length == 0 ||
        currentProduct.nutrientLevels.levels == null) {
      return new Container(
        alignment: Alignment.centerRight,
        child: new Text("Nutrients not found."),
        width: 200,
      );
    }

    currentProductNutrients = "";
    currentProduct.nutrientLevels.levels.forEach((key, value) {
      currentProductNutrients =
          currentProductNutrients + key + ": " + value.value.toString() + ", ";
    });
    // Remove trialing comma and whitespace
    currentProductNutrients = currentProductNutrients.substring(
        0, currentProductNutrients.length - 2);
    return new Container(
      alignment: Alignment.centerRight,
      child: new Text(currentProductNutrients),
      width: 200,
    );
  }
}

class GetProductCalorieContainer extends StatelessWidget {
  _setCalories(String value) {
    if (int.tryParse(value) == null || int.tryParse(value) < 0) {
      currentProductCalories = 0;
    }
    currentProductCalories = int.tryParse(value);
  }

  @override
  Widget build(BuildContext context) {
    if (currentProduct == emptyProduct) {
      return new Container(
          width: 200, alignment: Alignment.centerRight, child: Text(""));
    }

    if (currentProduct.servingSize == null ||
        currentProduct.servingSize == "0" ||
        currentProduct.nutriments.energyKcal100g == null ||
        currentProduct.nutriments.energyKcal100g == 0.0) {
      // Return an editable text box.
      TextEditingController _controller = TextEditingController(text: "0");

      return new Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: TextField(
              controller: _controller,
              textAlign: TextAlign.right,
              onEditingComplete: () => _setCalories(_controller.text)));
    }

    // Work out calories per serving
    int per100g = currentProduct.nutriments.energyKcal100g.toInt();
    String portionSize = currentProduct.servingSize;
    portionSize = portionSize.substring(0, portionSize.length - 1);
    int portion = int.parse(portionSize);
    int energyPerPortion = per100g ~/ (100 / portion); // As int
    print("DEBUG: " + energyPerPortion.toString());

    TextEditingController _controller =
        TextEditingController(text: energyPerPortion.toString());
    _setCalories(_controller.text);
    return new Container(
        width: 200,
        alignment: Alignment.centerRight,
        child: TextField(
            controller: _controller,
            textAlign: TextAlign.right,
            onEditingComplete: () => _setCalories(_controller.text)));
  }
}

class ScanProductPageState extends State<ScanProductPage> {
  void _updateProduct() {
    setState(() {});
  }

  bool barcodeValid() {
    return currentProduct.barcode != "-1" && currentProduct.barcode != null;
  }

  _scanTextContainer() {
    return new Container(
      child: new Text("Press the camera icon to scan a barcode."),
      alignment: Alignment.center,
    );
  }

  _scanButtonContainer() {
    return new Container(
      child: new IconButton(
          icon: new Icon(Icons.photo_camera_outlined),
          iconSize: 200,
          onPressed: () async {
            String barcodeString = await readBarcode();
            print("DEBUG: Printing barcode: " + barcodeString);
            if (barcodeString != "-1") {
              currentProduct = await getProduct(barcodeString);
              if (currentProduct != emptyProduct) {
                if (currentProduct.productName != null) {
                  print("DEBUG: The product name is: " +
                      currentProduct.productName);
                }
                _updateProduct();
              }
              // If Empty product
              else {
                currentProduct.productName = "Not found.";
                _updateProduct();
              }
            }
          }),
      alignment: Alignment.center,
    );
  }

  _containerBoxDecoration() {
    return new BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)));
  }

  _productNameContainer() {
    return new Container(
        constraints: BoxConstraints(minHeight: 40),
        decoration: _containerBoxDecoration(),
        child: new Row(
          children: [
            new Container(child: new Text(productInfoList[0])),
            new Spacer(),
            new Container(child: new GetProductNameContainer()),
          ],
        ));
  }

  _productEcoGradeContainer() {
    return new Container(
        constraints: BoxConstraints(minHeight: 40),
        decoration: _containerBoxDecoration(),
        child: new Row(
          children: [
            new Container(child: new Text(productInfoList[1])),
            new Spacer(),
            new Container(child: new GetProductEcoGradeContainer()),
          ],
        ));
  }

  _productNovaGradeContainer() {
    return new Container(
        constraints: BoxConstraints(minHeight: 40),
        decoration: _containerBoxDecoration(),
        child: new Row(
          children: [
            new Container(child: new Text(productInfoList[2])),
            new Spacer(),
            new Container(child: new GetProductNovaGradeContainer()),
          ],
        ));
  }

  _productIngredientsContainer() {
    return new Container(
        constraints: BoxConstraints(minHeight: 40),
        decoration: _containerBoxDecoration(),
        child: new Row(
          children: [
            new Container(child: new Text(productInfoList[3])),
            new Spacer(),
            new Container(child: new GetProductIngredientsContainer()),
          ],
        ));
  }

  _productNutrientContainer() {
    return new Container(
        constraints: BoxConstraints(minHeight: 40),
        decoration: _containerBoxDecoration(),
        child: new Row(
          children: [
            new Container(child: new Text(productInfoList[4])),
            new Spacer(),
            new Container(child: new GetProductNutrientsContainer()),
          ],
        ));
  }

  _productCaloriesContainer() {
    return new Container(
        constraints: BoxConstraints(minHeight: 40),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: new Row(
          children: [
            new Container(child: new Text(productInfoList[5])),
            new Spacer(),
            new Container(child: new GetProductCalorieContainer()),
          ],
        ));
  }

  _addProduct(String code, String name, String grade, int nova,
      String ingredients, String nutrients, int calories) {
    DatabaseHelper.instance.insertProductToDatabase(
        currentProduct.productName.toUpperCase().replaceAll(' ', ''),
        currentProduct.productName,
        currentProduct.ecoscoreGrade,
        currentProduct.nutriments.novaGroup,
        currentProductIngredients,
        currentProductNutrients,
        currentProductCalories);
    currentProduct = emptyProduct;
    _updateProduct();
  }

  _productAddButton() {
    return new Container(
        child: new Row(
      children: [
        new Spacer(),
        new FlatButton(
          // onPressed: Check if all fields are filled and barcode is not -1
          onPressed: (!barcodeValid() || currentProduct == emptyProduct)
              ? null
              : () => _addProduct(
                  currentProduct.productName.toUpperCase().replaceAll(' ', ''),
                  currentProduct.productName,
                  currentProduct.ecoscoreGrade,
                  currentProduct.nutriments.novaGroup,
                  currentProductIngredients,
                  currentProductNutrients,
                  currentProductCalories),
          child: new Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue, disabledColor: Colors.grey[400],
        ),
        new Spacer()
      ],
    ));
  }

  _mySpacer() {
    return new Container(height: 10);
  }

  _body() {
    return new ListView(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      children: [
        // Instruction label
        _scanTextContainer(),
        // Button to scan item
        _scanButtonContainer(),
        // Product name container
        _productNameContainer(),
        _mySpacer(),
        // Eco Grade Container
        _productEcoGradeContainer(),
        _mySpacer(),
        // Nova Grade Container
        _productNovaGradeContainer(),
        _mySpacer(),
        // Ingredients Container
        _productIngredientsContainer(),
        _mySpacer(),
        // Nutrients Container
        _productNutrientContainer(),
        _mySpacer(),
        // Calories Container
        _productCaloriesContainer(),
        _mySpacer(),
        // Add button
        _productAddButton()
      ],
    );
  }

  _appBar() {
    return new AppBar(
      title: new Text("Scan a Product"),
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
