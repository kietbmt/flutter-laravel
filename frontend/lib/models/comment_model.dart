class Comment {
  final int id;
  final String name;
  final String content;
  final String url;
  final int productId;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.name,
    required this.content,
    required this.url,
    required this.productId,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      url: json['url'],
      productId: json['product_id'],
      email: json['email'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'url': url,
      'product_id': productId,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}