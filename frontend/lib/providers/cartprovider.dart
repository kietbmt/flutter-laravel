import 'package:flutter/material.dart';
import 'package:frontend/models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  // Add item to cart
  void addToCart(Product product) {
    final existingProductIndex = _items.indexWhere((item) => item.id == product.id);
    if (existingProductIndex >= 0) {
      _items[existingProductIndex].quantity += product.quantity;
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  // Clear the cart
  void clearCart() {
    _items = [];
    notifyListeners();
  }
}
