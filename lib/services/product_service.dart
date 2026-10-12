import '../core/network/api_client.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await ApiClient.request('GET', '/products', auth: false);
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Product> fetchProduct(int productId) async {
    final response = await ApiClient.request(
      'GET',
      '/products/$productId',
      auth: false,
    );
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected product response');
    }

    return Product.fromJson(decoded);
  }
}
