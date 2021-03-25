// Szymon Janusz G20792986

import 'package:assignment/main.dart';
import 'package:assignment/openFoodFactsAPI.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import "constants.dart";

class DatabaseHelper {
  static final _databaseName = gDatabaseName;
  static final _databaseVersion = 2;
  static final _productsTable = "products";
  static final _listsTable = "lists";
  static final _productsToListsTable = "products_to_lists";

  static final _productCode = "code";
  static final _productName = "name";
  static final _productEcoScore = "grade";
  static final _productNovaGroup = "nova_group";
  static final _productIngredients = "ingredients";
  static final _productNutrients = "nutrients";
  static final _productCalories = "calories";

  // Breakfast table
  // Table name: breakfastTable
  // Columns:
  //  day = String, not null, primary key
  // calories, int
  static final _breakfastTable = 'breakfastTable';
  static final _calories = 'calories';

  // Dinner table
  // Table name: dinnerTable
  // Columns:
  //  day = String, not null, primary key
  // calories, int
  static final _dinnerTable = 'dinnerTable';

  // Supper table
  // Table name: supperTable
  // Columns:
  //  day = String, not null, primary key
  // calories, int
  static final _supperTable = 'supperTable';

  static final _caloriesDay = "day";

  static final _listsID = "id";
  static final _listsName = "name";
  static final _listsDescription = "description";

  static final _productsToListsCode = "product_code";
  static final _productsToListsID = "list_id";
  static final _favouritesListID = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Create Products Table
    await db.execute('''CREATE TABLE $_productsTable(
          $_productCode STRING PRIMARY KEY NOT NULL, 
          $_productName STRING NOT NULL, 
          $_productEcoScore STRING NOT NULL, 
          $_productNovaGroup INTEGER NOT NULL, 
          $_productIngredients STRING NOT NULL, 
          $_productNutrients STRING NOT NULL, 
          $_productCalories INTEGER NOT NULL)''');
    // Create Lists Table (Favourites)
    await db.execute('''CREATE TABLE $_listsTable(
          $_listsID INTEGER PRIMARY KEY NOT NULL, 
          $_listsName STRING, 
          $_listsDescription STRING)''');
    // Create Products To Lists Table (Adding products to Favourites)
    await db.execute('''CREATE TABLE $_productsToListsTable(
      $_productsToListsCode STRING NOT NULL,
      $_productsToListsID INTEGER NOT NULL,
      FOREIGN KEY ($_productsToListsCode) REFERENCES $_productsTable($_productCode),
      FOREIGN KEY ($_productsToListsID) REFERENCES $_listsTable($_listsID),
      PRIMARY KEY ($_productsToListsCode, $_productsToListsID))''');
    // Create Breakfast Calories Table
    await db.execute('''CREATE TABLE $_breakfastTable(
          $_caloriesDay STRING PRIMARY KEY NOT NULL, 
          $_calories INT)''');
    // Create Dinner Calories Table
    await db.execute('''CREATE TABLE $_dinnerTable(
          $_caloriesDay STRING PRIMARY KEY NOT NULL, 
          $_calories INT)''');
    // Create Supper Calories Table
    await db.execute('''CREATE TABLE $_supperTable(
          $_caloriesDay STRING PRIMARY KEY NOT NULL, 
          $_calories INT)''');
    print("DEBUG: Database created");
  }

  Future<int> deleteProduct(String code) async {
    Database db = await instance.database;
    return await db
        .delete(_productsTable, where: '$_productCode = ?', whereArgs: [code]);
  }

  Future<void> insertProductToDatabase(String code, String name, String grade,
      int nova, String ingredients, String nutrients, int calories) async {
    Database db = await instance.database;

    Map<String, String> values = {
      "code": code,
      "name": name,
      "grade": grade,
      "nova_group": nova.toString(),
      "ingredients": ingredients,
      "nutrients": nutrients,
      "calories": calories.toString()
    };

    currentProduct = emptyProduct;

    db.insert(_productsTable, values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllProductsRows() async {
    Database db = await instance.database;
    var result = await db.query(_productsTable, orderBy: "$_productCode DESC");
    return result;
  }

  Future<List<Map<String, dynamic>>> queryFavouriteProductsRows() async {
    Database db = await instance.database;
    var result = await db.query(_productsTable, orderBy: "$_productCode DESC");
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllFavouriteProducts() async {
    // We only care about the name and calories.
    Database db = await instance.database;
    // WHERE products_to_lists.list_id=1 AND products.code=products_to_lists.product_code
    var result = await db
        .rawQuery('SELECT products.name, products.calories FROM products');
    //print("DEBUG: Successfully got favourite products.");
    return result;
  }

  Future<bool> removeProductFromFavourites(String productCode) async {
    Database db = await instance.database;
    int result = await db.delete(_productsToListsTable,
        where: '$_productsToListsCode = ? AND list_id = $_favouritesListID',
        whereArgs: [productCode]);

    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> addProductToFavourites(String productCode) async {
    Database db = await instance.database;
    var toInsert = {'product_code': productCode, 'list_id': _favouritesListID};
    var result = await db.insert(_productsToListsTable, toInsert);

    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> isItemFavourited(String productCode) async {
    Database db = await instance.database;
    var result = await db.query(_productsToListsTable,
        where: 'product_code = ?', whereArgs: [productCode]);

    if (result == null || result.length == null || result.length == 0) {
      return false;
    }
    return true;
  }

  Future<int> getTodayCalories() async {
    // Database db = await instance.database;
    // var result = await db
    //     .query(_caloriesTable, where: '$_caloriesDay = ?', whereArgs: [today]);
    return await getBreakfastCaloriesToday() +
        await getDinnerCaloriesToday() +
        await getSupperCaloriesToday();
  }

  Future<bool> addCaloriesToBreakfast(int calories) async {
    Database db = await instance.database;

    var result = await db.query(_breakfastTable,
        columns: ['calories'], where: 'day = ?', whereArgs: [today]);
    bool entryExists = (result != null && result.length > 0);
    if (entryExists) {
      var toInsert = {
        'day': today,
        'calories': calories + await getBreakfastCaloriesToday()
      };
      var outcome = await db.update(_breakfastTable, toInsert);
      if (outcome > 0) {
        return true;
      }
      return false;
    } else {
      var toInsert = {'day': today, 'calories': calories};
      var result = await db.insert(_breakfastTable, toInsert);
      if (result > 0) {
        return true;
      }
      return false;
    }
  }

  Future<bool> addCaloriesToDinner(int calories) async {
    Database db = await instance.database;

    var result = await db.query(_dinnerTable,
        columns: ['calories'], where: 'day = ?', whereArgs: [today]);
    bool entryExists = (result != null && result.length > 0);
    if (entryExists) {
      var toInsert = {
        'day': today,
        'calories': calories + await getDinnerCaloriesToday()
      };
      var outcome = await db.update(_dinnerTable, toInsert);
      if (outcome > 0) {
        return true;
      }
      return false;
    } else {
      var toInsert = {'day': today, 'calories': calories};
      var result = await db.insert(_dinnerTable, toInsert);
      if (result > 0) {
        return true;
      }
      return false;
    }
  }

  Future<bool> addCaloriesToSupper(int calories) async {
    Database db = await instance.database;

    var result = await db.query(_supperTable,
        columns: ['calories'], where: 'day = ?', whereArgs: [today]);
    bool entryExists = (result != null && result.length > 0);
    if (entryExists) {
      var toInsert = {
        'day': today,
        'calories': calories + await getSupperCaloriesToday()
      };
      var outcome = await db.update(_supperTable, toInsert);
      if (outcome > 0) {
        return true;
      }
      return false;
    } else {
      var toInsert = {'day': today, 'calories': calories};
      var result = await db.insert(_supperTable, toInsert);
      if (result > 0) {
        return true;
      }
      return false;
    }
  }

  Future<int> getBreakfastCaloriesToday() async {
    Database db = await instance.database;
    var result =
        await db.query(_breakfastTable, where: 'day = ?', whereArgs: [today]);
    if (result != null && result.length > 0) {
      return result[0].values.elementAt(1);
    } else {
      return 0;
    }
  }

  Future<int> getDinnerCaloriesToday() async {
    Database db = await instance.database;
    var result =
        await db.query(_dinnerTable, where: 'day = ?', whereArgs: [today]);
    if (result != null && result.length > 0) {
      return result[0].values.elementAt(1);
    } else {
      return 0;
    }
  }

  Future<int> getSupperCaloriesToday() async {
    Database db = await instance.database;
    var result =
        await db.query(_supperTable, where: 'day = ?', whereArgs: [today]);
    if (result != null && result.length > 0) {
      return result[0].values.elementAt(1);
    } else {
      return 0;
    }
  }
}
