import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/api.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    _products = await Api.getProduct();
    notifyListeners();
  }

  Future<void> createProduct(Product product) async {
    final pdata = {
      "productName": product.productName,
      "price": product.price.toString(),
      "stock": product.stock.toString(),
    };
    await Api.createProduct(pdata);
    await fetchProducts();
  }

  Future<void> updateProduct(int id, Product updatedProduct) async {
    final body = {
      "productName": updatedProduct.productName,
      "price": updatedProduct.price.toString(),
      "stock": updatedProduct.stock.toString(),
    };
    await Api.updateProduct(id, body);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await Api.deletedProduct(id);
    await fetchProducts();
  }

  Product? getProductById(int id) {
    return _products.firstWhere((p) => p.productId == id);
  }
}
