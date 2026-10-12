class CategoryModel {
  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unnamed category',
    );
  }

  final int id;
  final String name;
}
