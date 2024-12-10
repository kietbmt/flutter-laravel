// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'package:shopping/repository/product_repository.dart';
import 'package:shopping/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Hàm tải danh sách sản phẩm
  Future<void> fetchProducts(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await _productRepository.fetchProducts(token);
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
