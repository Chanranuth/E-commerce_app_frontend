class Product {
  Product({
    required this.id,
    required this.sellerId,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.description,
    required this.price,
    required this.stock,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      sellerId: json['seller_id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown product',
      sku: json['sku'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  final int id;
  final int sellerId;
  final int categoryId;
  final String name;
  final String sku;
  final String description;
  final double price;
  final int stock;
  final bool isActive;
}
