import '../core/network/api_client.dart';
import '../models/order.dart';

class OrderService {
  Future<List<Order>> fetchOrders() async {
    final response = await ApiClient.request('GET', '/orders');
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .map((item) => Order.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Order> fetchOrder(int orderId) async {
    final response = await ApiClient.request('GET', '/orders/$orderId');
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected order response');
    }

    return Order.fromJson(decoded);
  }

  Future<List<Order>> checkout() async {
    final response = await ApiClient.request('POST', '/checkout');
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected checkout response');
    }

    final ordersJson = decoded['orders'] as List<dynamic>? ?? const [];
    return ordersJson
        .map((item) => Order.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Order> updateStatus(int orderId, String status) async {
    final response = await ApiClient.request(
      'PUT',
      '/orders/$orderId',
      body: {'status': status},
    );

    final decoded = ApiClient.decodeJson(response);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected order update response');
    }

    return Order.fromJson(decoded);
  }
}
