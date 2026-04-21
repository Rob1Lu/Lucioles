class AdminUser {
  const AdminUser({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
    required this.createdAt,
    required this.isAdmin,
    required this.lucioleCount,
  });

  final String id;
  final String email;
  final String? username;
  final String? avatarUrl; // chemin Storage, pas une URL signée
  final DateTime createdAt;
  final bool isAdmin;
  final int lucioleCount;

  String get displayName => username ?? email;

  AdminUser copyWith({bool? isAdmin}) => AdminUser(
        id: id,
        email: email,
        username: username,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
        isAdmin: isAdmin ?? this.isAdmin,
        lucioleCount: lucioleCount,
      );

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as String,
        email: json['email'] as String,
        username: json['username'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        isAdmin: json['is_admin'] as bool? ?? false,
        lucioleCount: (json['luciole_count'] as num?)?.toInt() ?? 0,
      );
}
