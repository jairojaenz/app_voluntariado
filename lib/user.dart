class User {
  final String id;
  final String name;
  final String last_name;
  final String email;
  final String phone;
  final String password;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.last_name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      last_name: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'Admin', // Valor por defecto
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }
}
