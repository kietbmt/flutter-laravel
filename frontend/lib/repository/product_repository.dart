import 'package:http/http.dart' as http;
import 'package:shopping/constants/apilist.dart';
import 'package:shopping/models/product_model.dart';
import 'dart:convert';

class ProductRepository {
  final String apiUrlProduct = 'http://127.0.0.1:8000/api/v1/products'; // Đảm bảo URL chính xác

  // Cập nhật phương thức fetchProducts với xử lý lỗi và phân tích phản hồi chi tiết
  Future<List<Product>> fetchProducts(String token) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrlProduct),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Thêm header Authorization với token
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Kiểm tra nếu 'products' có tồn tại trong phản hồi
        if (data.containsKey('products')) {
          List<dynamic> products = data['products']; // Dữ liệu sản phẩm từ API
          print('Fetched Products: $products');

          // Phân tích danh sách sản phẩm và chuyển đổi thành đối tượng Product
          return products.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('API response does not contain products');
        }
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load products: $e');
    }
  }
}
