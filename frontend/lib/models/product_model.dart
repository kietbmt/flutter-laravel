class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> photo;  // Chuyển `photo` thành List<String>

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.photo,  // Thêm photo như một danh sách
  });

  // Factory method để tạo đối tượng Product từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],  // Đổi từ `name` thành `title`
      description: json['description'],
      price: json['price'].toDouble(),
      photo: List<String>.from(json['photo']),  // Chuyển photo thành List<String>
    );
  }
}
