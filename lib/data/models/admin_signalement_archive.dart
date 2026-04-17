class AdminSignalementArchive {
  const AdminSignalementArchive({
    required this.entreeId,
    required this.texte,
    required this.dateCreation,
    required this.adminReviewedAt,
    required this.isRestricted,
    required this.signalementCount,
    this.userId,
    this.userEmail,
    this.username,
    required this.userDeleted,
  });

  final String entreeId;
  final String texte;
  final DateTime dateCreation;
  final DateTime adminReviewedAt;
  final bool isRestricted;
  final int signalementCount;
  final String? userId;
  final String? userEmail;
  final String? username;
  final bool userDeleted;

  String get displayName => username ?? userEmail ?? '—';

  factory AdminSignalementArchive.fromJson(Map<String, dynamic> json) {
    return AdminSignalementArchive(
      entreeId: json['entree_id'] as String,
      texte: json['texte'] as String,
      dateCreation: DateTime.parse(json['date_creation'] as String),
      adminReviewedAt: DateTime.parse(json['admin_reviewed_at'] as String),
      isRestricted: json['is_restricted'] as bool? ?? false,
      signalementCount: (json['signalement_count'] as num).toInt(),
      userId: json['user_id'] as String?,
      userEmail: json['user_email'] as String?,
      username: json['username'] as String?,
      userDeleted: json['user_deleted'] as bool? ?? false,
    );
  }
}
