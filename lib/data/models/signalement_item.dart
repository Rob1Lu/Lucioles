class SignalementItem {
  const SignalementItem({
    required this.entreeId,
    required this.texte,
    this.photoUrl,
    required this.dateCreation,
    required this.isRestricted,
    required this.signalementCount,
    this.userId,
    this.userEmail,
    this.username,
    this.avatarUrl,
    required this.userReportedCount,
    required this.userDeleted,
  });

  final String entreeId;
  final String texte;
  final String? photoUrl;
  final DateTime dateCreation;
  final bool isRestricted;
  final int signalementCount;
  final String? userId;
  final String? userEmail;
  final String? username;
  final String? avatarUrl;
  final int userReportedCount;
  final bool userDeleted;

  String get displayName => username ?? userEmail ?? '—';

  factory SignalementItem.fromJson(Map<String, dynamic> json) {
    return SignalementItem(
      entreeId: json['entree_id'] as String,
      texte: json['texte'] as String,
      photoUrl: json['photo_url'] as String?,
      dateCreation: DateTime.parse(json['date_creation'] as String),
      isRestricted: json['is_restricted'] as bool? ?? false,
      signalementCount: (json['signalement_count'] as num).toInt(),
      userId: json['user_id'] as String?,
      userEmail: json['user_email'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      userReportedCount: (json['user_reported_count'] as num?)?.toInt() ?? 0,
      userDeleted: json['user_deleted'] as bool? ?? false,
    );
  }

  SignalementItem copyWith({String? photoUrl}) {
    return SignalementItem(
      entreeId: entreeId,
      texte: texte,
      photoUrl: photoUrl ?? this.photoUrl,
      dateCreation: dateCreation,
      isRestricted: isRestricted,
      signalementCount: signalementCount,
      userId: userId,
      userEmail: userEmail,
      username: username,
      avatarUrl: avatarUrl,
      userReportedCount: userReportedCount,
      userDeleted: userDeleted,
    );
  }
}
