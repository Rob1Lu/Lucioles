class AdminFeedback {
  const AdminFeedback({
    required this.id,
    required this.message,
    required this.createdAt,
    this.userId,
    this.userEmail,
    this.username,
    this.type,
  });

  final String id;
  final String? userId;
  final String? userEmail;
  final String? username;
  final String? type;
  final String message;
  final DateTime createdAt;

  String get displayName => username ?? userEmail ?? '—';

  factory AdminFeedback.fromJson(Map<String, dynamic> json) {
    return AdminFeedback(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      userEmail: json['user_email'] as String?,
      username: json['username'] as String?,
      type: json['type'] as String?,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
