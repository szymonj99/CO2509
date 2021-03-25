// Szymon Janusz G20792986

import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:openfoodfacts/utils/LanguageHelper.dart';
import 'package:openfoodfacts/utils/ProductFields.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Product currentProduct = new Product();
final Product emptyProduct = currentProduct;

Future<String> readBarcode() async {
  String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", "Cancel", true, ScanMode.DEFAULT);
  return barcode;
}

Future<Product> getProduct(final String barcode) async {
  ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
      language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
  ProductResult result = await OpenFoodAPIClient.getProduct(configuration);
  if (result.status == 1) {
    return result.product;
  }
  return emptyProduct;
}
