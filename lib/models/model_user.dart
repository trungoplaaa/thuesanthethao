class User {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? address;
  final String? role;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.address,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
    );
  }
}