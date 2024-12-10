import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1/order'; 
  // Method to create an order
  static Future<bool> createOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$_baseUrl/orders');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }
}
