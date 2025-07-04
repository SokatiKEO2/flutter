import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class Api {
  static const baseUrl = "http://192.168.1.10:2000";

  static createProduct(Map pdata) async {
    var url = Uri.parse("$baseUrl/products");

    try {
      final res = await http.post(url, body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to get response");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static getProduct() async {
    List<Product> products = [];
    var url = Uri.parse("$baseUrl/products");
    try {
      final res = await http.get(url);
      print(res.body);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        data["products"].forEach(
          (value) => {
            products.add(Product(value["PRODUCTID"], value["PRICE"],
                value["PRODUCTNAME"], value["STOCK"]))
          },
        );
      } else {
        print("Failed to get response");
      }
    } catch (e) {
      print(e.toString());
    }
    return products;
  }

  static updateProduct(productId, body) async {
    print(body);
    var url = Uri.parse("$baseUrl/products/$productId");

    final res = await http.put(url, body: body);
    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
    } else {
      print("Failed to update data");
    }
  }

  static deletedProduct(productId) async {
    var url = Uri.parse("$baseUrl/products/$productId");
    final res = await http.delete(url);

    if (res.statusCode == 200) { // ✅ match backend
      print("success");
    } else {
      print("Failed to delete data");
    }

  }
}
