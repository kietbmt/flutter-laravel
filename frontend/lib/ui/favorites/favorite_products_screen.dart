// lib/ui/favorites/favorite_products_screen.dart
import 'package:flutter/material.dart';

class FavoriteProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Products"),
      ),
      body: Center(
        child: Text("No favorite products yet."),
      ),
    );
  }
}
