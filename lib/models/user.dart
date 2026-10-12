class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown user',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'CUSTOMER',
    );
  }

  final int id;
  final String name;
  final String email;
  final String role;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
