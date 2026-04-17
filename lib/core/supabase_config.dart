/// Configuration du client Supabase.
///
/// Les valeurs sont injectées au moment du build via `--dart-define-from-file`.
/// Copier `.env.example` en `.env.local` (dev) ou `.env.production` (prod)
/// et y renseigner les valeurs réelles.
///
/// Usage :
///   flutter run --dart-define-from-file=.env.local
///   flutter build ios --dart-define-from-file=.env.production
class SupabaseConfig {
  SupabaseConfig._();

  /// URL du projet Supabase (ex: https://xxxx.supabase.co)
  static const String url = String.fromEnvironment('FLUTTER_SUPABASE_URL');

  /// Clé publique anon — protégée par les policies RLS côté serveur.
  static const String anonKey = String.fromEnvironment('FLUTTER_SUPABASE_ANON_KEY');

  // ── Noms des buckets Storage ────────────────────────────────────────────
  static const String bucketEntreePhotos = 'entree-photos';
  static const String bucketAvatars = 'avatars';

  // ── URL scheme pour les redirections OAuth ──────────────────────────────
  static const String authRedirectScheme = 'fr.orbit.lucioles';
  static const String authRedirectUrl = '$authRedirectScheme://login-callback';

  // ── Méthodes d'authentification activées ────────────────────────────────
  // Contrôlées via .env.local / .env.production (dart-define-from-file).
  // false par défaut pour éviter d'activer par inadvertance en cas d'oubli.
  static const bool authEmailActif =
      bool.fromEnvironment('AUTH_EMAIL_ENABLED', defaultValue: false);
  static const bool authGoogleActif =
      bool.fromEnvironment('AUTH_GOOGLE_ENABLED', defaultValue: false);
  static const bool authAppleActif =
      bool.fromEnvironment('AUTH_APPLE_ENABLED', defaultValue: false);
}
