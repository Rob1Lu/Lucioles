import '../../core/constants.dart';

/// Modèle d'une entrée quotidienne dans l'atlas émotionnel.
///
/// Une entrée représente un moment positif noté par l'utilisateur,
/// associé optionnellement à un lieu géolocalisé et/ou une photo.
class Entree {
  const Entree({
    required this.id,
    required this.texte,
    required this.dateCreation,
    this.latitude,
    this.longitude,
    this.lieuNom,
    this.photoUrl,
    this.isRestricted = false,
  });

  final String id;

  /// Le texte de l'entrée (280 caractères max)
  final String texte;

  /// Coordonnées GPS optionnelles
  final double? latitude;
  final double? longitude;

  /// Nom du lieu (saisi manuellement ou dérivé des coordonnées)
  final String? lieuNom;

  /// URL signée Supabase Storage (null si pas de photo).
  /// Valeur temporaire : générée côté client à chaque chargement (TTL 1 h).
  final String? photoUrl;

  final DateTime dateCreation;

  /// true si un admin a restreint cette entrée (masquée de la communauté)
  final bool isRestricted;

  // ─── Propriétés dérivées ──────────────────────────────────────────────────

  /// Indique si l'entrée possède des coordonnées GPS valides
  bool get aLieu => latitude != null && longitude != null;

  /// Affichage court du lieu (nom ou coordonnées arrondies)
  String get lieuAffichage {
    if (lieuNom != null && lieuNom!.isNotEmpty) return lieuNom!;
    if (aLieu) {
      return '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';
    }
    return '';
  }

  /// Saison à laquelle appartient cette entrée
  Saison get saison => Saison.pourMois(dateCreation.month);

  // ─── Sérialisation Supabase ───────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'texte': texte,
        'latitude': latitude,
        'longitude': longitude,
        'lieu_nom': lieuNom,
        'photo_url': photoUrl,
        'date_creation': dateCreation.toIso8601String(),
        'saison': saison.name,
      };

  factory Entree.fromJson(Map<String, dynamic> json) => Entree(
        id: json['id'] as String,
        texte: json['texte'] as String,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        lieuNom: json['lieu_nom'] as String?,
        photoUrl: json['photo_url'] as String?,
        dateCreation: DateTime.parse(json['date_creation'] as String),
        isRestricted: json['is_restricted'] as bool? ?? false,
      );

  Entree copyWith({
    String? id,
    String? texte,
    double? latitude,
    double? longitude,
    String? lieuNom,
    String? photoUrl,
    DateTime? dateCreation,
    bool? isRestricted,
  }) =>
      Entree(
        id: id ?? this.id,
        texte: texte ?? this.texte,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        lieuNom: lieuNom ?? this.lieuNom,
        photoUrl: photoUrl ?? this.photoUrl,
        dateCreation: dateCreation ?? this.dateCreation,
        isRestricted: isRestricted ?? this.isRestricted,
      );

  @override
  bool operator ==(Object other) => other is Entree && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
