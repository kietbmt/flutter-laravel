import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/models/product_model.dart';
import 'package:shopping/providers/product_provider.dart';

class ProductListPage extends ConsumerWidget {
  final String token; // Token bạn sẽ truyền vào

  ProductListPage({required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy dữ liệu từ productListProvider với token
    final productListAsyncValue = ref.watch(productListProvider(token));

    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: productListAsyncValue.when(
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.title),
                subtitle: Text("\$${product.price}"),
                leading: product.photo.isNotEmpty
                    ? Image.network(product.photo[0]) // Lấy ảnh đầu tiên trong danh sách photo
                    : Icon(Icons.image), // Nếu không có ảnh, hiển thị icon mặc định
                onTap: () {
                  // Xử lý khi người dùng nhấn vào sản phẩm
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load products')),
      ),
    );
  }
}
