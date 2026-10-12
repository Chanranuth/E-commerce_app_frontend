import '../core/network/api_client.dart';
import '../models/category.dart';

class CategoryService {
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await ApiClient.request('GET', '/categories', auth: false);
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! List) {
      return const [];
    }

    return decoded
        .map(
          (item) =>
              CategoryModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
