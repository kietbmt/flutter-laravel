import 'package:flutter/material.dart';
import 'package:shopping/models/product_model.dart';
import 'package:shopping/models/comment_model.dart';
import 'package:shopping/repository/comment_service.dart';
import 'package:get/get.dart';
import 'package:shopping/ui/cart/cart_screen.dart';  // Make sure this is correctly imported

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Comment> comments = [];
  TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  final CommentService _commentService = CommentService();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  // Load comments for the current product
  void _loadComments() async {
    try {
      List<Comment> fetchedComments = await _commentService.getCommentsByProduct(widget.product.id);
      setState(() {
        comments = fetchedComments;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load comments: ${e.toString()}')),
        );
      }
    }
  }

  // Submit a comment to the server
  void _submitComment() async {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _commentService.addComment(
          productId: widget.product.id,
          content: _commentController.text,
          name: 'Anonymous', // Placeholder name, update as needed
          url: 'default-url', // Placeholder URL, update as needed
          email: null, // Optional email field, update as needed
        );

        _loadComments(); // Reload comments after adding a new one
        _commentController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Comment added successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add comment: ${e.toString()}')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Delete a comment
  void _deleteComment(int commentId) async {
    try {
      await _commentService.deleteComment(commentId);
      _loadComments(); // Reload comments after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete comment')),
      );
    }
  }

  // Add product to cart
  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product image
            if (widget.product.photo.isNotEmpty)
              Image.network(
                widget.product.photo[0],
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              )
            else
              Container(
                height: 250,
                color: Colors.grey[300],
                child: Center(child: Text("No Image Available")),
              ),
            SizedBox(height: 16),

            // Product title and price
            Text(
              widget.product.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${widget.product.price}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 16),

            // Product description
            Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.product.description ?? "No description available.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),

            // Add to Cart button
            ElevatedButton(
  onPressed: () {
    CartScreen.addToCart(widget.product, context);
  },
  child: const Text('Add to Cart'),
),

            SizedBox(height: 20),

            // Comments section
            Text(
              "Comments:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Show loading spinner if fetching comments
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(comment.content),
                          subtitle: Text('By: ${comment.name}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteComment(comment.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            SizedBox(height: 20),

            // Comment input field
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Enter your comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),

            // Submit button for comment
            ElevatedButton(
              onPressed: _submitComment,
              child: Text('Submit Comment'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
