class OrderItemSnapshot {
  OrderItemSnapshot({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemSnapshot.fromJson(Map<String, dynamic> json) {
    return OrderItemSnapshot(
      id: json['id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? 'Unknown item',
      sku: json['sku'] as String? ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0.0,
    );
  }

  final int id;
  final int productId;
  final String productName;
  final String sku;
  final double price;
  final int quantity;
  final double subtotal;
}

class Order {
  Order({
    required this.id,
    required this.customerId,
    required this.sellerId,
    required this.totalAmount,
    required this.status,
    this.items = const [],
    this.sellerName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];

    return Order(
      id: json['id'] as int? ?? 0,
      customerId: json['customer_id'] as int? ?? 0,
      sellerId: json['seller_id'] as int? ?? 0,
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '') ?? 0.0,
      status: json['status'] as String? ?? 'PENDING',
      items: itemsJson
          .map(
            (item) => OrderItemSnapshot.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      sellerName: json['seller'] is Map
          ? json['seller']['name'] as String?
          : null,
    );
  }

  final int id;
  final int customerId;
  final int sellerId;
  final double totalAmount;
  final String status;
  final List<OrderItemSnapshot> items;
  final String? sellerName;
}
