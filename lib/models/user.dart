class User {
  int? userId;
  String? username;
  String? email;
  String? password;
  DateTime? createdAt;

  User({
    this.userId,
    required this.username,
    this.email,
    required this.password,
    this.createdAt,
  }) {
    userId ??= 0;
    createdAt ??= DateTime.now();
  }

  Map<String, dynamic> get values {
    return {
      'username': username,
      'email': email,
      'password': password,
      'created_at': createdAt!.toIso8601String(),
    };
  }

  /// Factory constructor to handle conversion from a Map
  factory User.fromMap(Map<String, Object?> map) {
    return User(
      userId: map['user_id'] as int? ?? 0, // Safe fallback default
      username: map['name'] as String? ?? 'Guest', // Safe fallback default
      email: map['email'] as String?, // Kept as nullable
      password: map['password'] as String?, // Kept as nullable
      createdAt: DateTime.parse(
        map['created_at'].toString(),
      ) as DateTime?, // Kept as nullable
    );
  }
}
