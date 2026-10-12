import 'product.dart';

class CartItem {
  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];

    return CartItem(
      id: json['id'] as int? ?? 0,
      cartId: json['cart_id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
      product: productJson is Map<String, dynamic>
          ? Product.fromJson(productJson)
          : null,
    );
  }

  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final Product? product;

  double get unitPrice => product?.price ?? 0;
  double get subtotal => unitPrice * quantity;
}
