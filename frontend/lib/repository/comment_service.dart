import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping/models/comment_model.dart';

class CommentService {
  final String baseUrl = 'http://127.0.0.1:8000/api/v1/comments';

  // Get all comments with optional product filter
  Future<List<Comment>> getComments({int? productId}) async {
    var url = baseUrl;
    if (productId != null) {
      url += '?product_id=$productId';
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> comments = responseData['data'];
        return comments.map((commentJson) => Comment.fromJson(commentJson)).toList();
      } else {
        throw Exception('Error fetching comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      throw e;
    }
  }

  // Get comments by product ID (using dedicated endpoint)
  Future<List<Comment>> getCommentsByProduct(int productId) async {
    final url = '$baseUrl/product/$productId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> comments = responseData['data'] ?? [];
        return comments.map((commentJson) => Comment.fromJson(commentJson)).toList();
      } else {
        throw Exception('Error fetching comments for product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments for product: $e');
      throw e;
    }
  }

  // Add a new comment
  Future<Comment> addComment({
    required int productId,
    required String content,
    required String name,
    required String url,
    String? email,
  }) async {
    final data = {
      'product_id': productId,  // Send as integer, not string
      'content': content,
      'name': name,
      'url': url,
      if (email != null) 'email': email,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return Comment.fromJson(responseData['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Error adding comment: ${errorData['message']}\n${errorData['errors'] ?? ''}'
        );
      }
    } catch (e) {
      print('Error adding comment: $e');
      throw e;
    }
  }

  // Update an existing comment
  Future<Comment> updateComment({
    required int id,
    String? content,
    String? name,
    String? url,
    int? productId,
    String? email,
  }) async {
    final data = {
      if (content != null) 'content': content,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (productId != null) 'product_id': productId,
      if (email != null) 'email': email,
    };

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Comment.fromJson(responseData['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Error updating comment: ${errorData['message']}\n${errorData['errors'] ?? ''}'
        );
      }
    } catch (e) {
      print('Error updating comment: $e');
      throw e;
    }
  }

  // Delete a comment
  Future<void> deleteComment(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception('Error deleting comment: ${errorData['message']}');
      }
    } catch (e) {
      print('Error deleting comment: $e');
      throw e;
    }
  }
}