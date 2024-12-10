import 'package:flutter/material.dart';
import 'package:shopping/models/product_model.dart';
import 'package:get/get.dart';  // Đảm bảo đã import Get package

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartScreen extends StatefulWidget {
  final Product product;
  
  // Sử dụng RxList để theo dõi các thay đổi trong giỏ hàng
  static RxList<CartItem> cartItems = <CartItem>[].obs;  // Đảm bảo sử dụng `.obs` để làm cho danh sách này trở thành một đối tượng có thể theo dõi.

  const CartScreen({Key? key, required this.product}) : super(key: key);

  static void addToCart(Product product, BuildContext context) {
    final existingItem = cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      cartItems.add(CartItem(product: product));  // Thêm sản phẩm vào giỏ hàng
    } else {
      existingItem.quantity++;  // Tăng số lượng của sản phẩm nếu đã có trong giỏ
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _updateQuantity(CartItem item, bool increase) {
    setState(() {
      if (increase) {
        item.quantity++;
      } else if (item.quantity > 1) {
        item.quantity--;
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      CartScreen.cartItems.remove(item);  // Sử dụng `remove` để xóa sản phẩm khỏi giỏ hàng
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = CartScreen.cartItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Obx(() => CartScreen.cartItems.isEmpty 
        ? const Center(child: Text('Cart is empty'))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: CartScreen.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = CartScreen.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: item.product.photo.isNotEmpty
                            ? Image.network(
                                item.product.photo[0],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(item.product.title),
                        subtitle: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _updateQuantity(item, false),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateQuantity(item, true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeItem(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (CartScreen.cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Điều hướng đến màn hình thanh toán
                          Get.toNamed('/checkout_payment');
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ),
    );
  }
}
