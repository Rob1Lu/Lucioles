/// Constantes globales de l'application Lucioles.
class AppConstants {
  AppConstants._();

  /// Limite de caractères pour une entrée hebdomadaire
  static const int maxCaracteres = 280;

  /// Coordonnées par défaut : centre de la France
  static const double defaultLatitude = 46.2276;
  static const double defaultLongitude = 2.2137;
  static const double defaultZoom = 5.5;

  /// Zoom d'une entrée géolocalisée sur la carte
  static const double zoomEntree = 14.0;

  /// Taille du marqueur luciole sur la carte
  static const double markerSize = 32.0;

  /// Durée du cycle d'animation d'une luciole (pulsation)
  static const Duration animationLuciole = Duration(milliseconds: 2200);

  /// Nom de la base de données SQLite
  static const String dbName = 'lucioles.db';
  static const int dbVersion = 1;

  /// Table des entrées
  static const String tableEntrees = 'entrees';
}

/// Plages de dates disponibles dans le filtre de la carte
enum PlageDate {
  aujourdhui("Aujourd'hui"),
  semaine('Cette semaine'),
  mois('Ce mois-ci'),
  annee('Cette année'),
  personnalisee('Personnalisé');

  const PlageDate(this.label);
  final String label;

  /// Label court pour le bouton du header (espace limité)
  String get labelCourt {
    switch (this) {
      case PlageDate.aujourdhui:  return "Auj.";
      case PlageDate.semaine:     return "Semaine";
      case PlageDate.mois:        return "Ce mois";
      case PlageDate.annee:       return "Cette année";
      case PlageDate.personnalisee: return "Perso.";
    }
  }
}

/// Saisons de l'année pour le filtre du fil du temps
enum Saison {
  toutes('Toutes'),
  printemps('Printemps'),
  ete('Été'),
  automne('Automne'),
  hiver('Hiver');

  const Saison(this.label);
  final String label;

  /// Retourne la saison correspondant à un mois donné (1–12)
  static Saison pourMois(int mois) {
    if (mois >= 3 && mois <= 5) return Saison.printemps;
    if (mois >= 6 && mois <= 8) return Saison.ete;
    if (mois >= 9 && mois <= 11) return Saison.automne;
    return Saison.hiver;
  }
}
