// Szymon Janusz G20792986

import 'package:openfoodfacts/model/User.dart';

String gAppName = "Nutri-Smart";
String gDatabaseName = gAppName + ".sqlite";

class OpenFoodFactsAPIConstants {
  static const User user = const User(
      userId: "szymon-j",
      password: "iW8vFpLpvk7DNXHM2Oxd",
      comment: "Hello Open Food Facts.");
}

var productInfoList = [
  "Name: ",
  "Eco-Grade: ",
  "Nova-Grade: ",
  "Ingredients: ",
  "Nutrients: ",
  "Calories Per Serving: "
];
