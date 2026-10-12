import '../core/network/api_client.dart';
import '../models/cart_item.dart';

class CartService {
  Future<List<CartItem>> fetchCartItems() async {
    final response = await ApiClient.request('GET', '/cart-items');
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .map(
          (item) => CartItem.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<CartItem> addItem({
    required int productId,
    required int quantity,
  }) async {
    final response = await ApiClient.request(
      'POST',
      '/cart-items',
      body: {'product_id': productId, 'quantity': quantity},
    );

    final decoded = ApiClient.decodeJson(response);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected cart response');
    }

    return CartItem.fromJson(decoded);
  }

  Future<CartItem> updateQuantity(int itemId, int quantity) async {
    final response = await ApiClient.request(
      'PUT',
      '/cart-items/$itemId',
      body: {'quantity': quantity},
    );

    final decoded = ApiClient.decodeJson(response);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected cart update response');
    }

    return CartItem.fromJson(decoded);
  }

  Future<void> removeItem(int itemId) async {
    await ApiClient.request('DELETE', '/cart-items/$itemId');
  }
}
