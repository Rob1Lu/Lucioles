import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase_config.dart';

/// Gère l'état d'authentification Supabase.
///
/// Écoute le flux [onAuthStateChange] pour rester synchronisé avec la session
/// active, même après une redirection OAuth ou un refresh de token automatique.
class AuthProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSub;

  User? _user;
  bool _chargement = false;
  String? _erreur;

  AuthProvider() {
    // Récupère la session existante (ex: relance après kill de l'app)
    _user = _client.auth.currentUser;

    _authSub = _client.auth.onAuthStateChange.listen((data) async {
      _user = data.session?.user;
      _erreur = null;
      notifyListeners();
      // Rafraîchit l'utilisateur depuis l'API pour avoir les identités à jour.
      // linkIdentity émet un userUpdated dont le User ne contient pas toujours
      // les identités mises à jour.
      if (data.session != null) {
        try {
          final fresh = await _client.auth.getUser();
          _user = fresh.user;
          notifyListeners();
        } catch (_) {}
      }
    });
  }

  // ─── Getters publics ───────────────────────────────────────────────────────

  bool get estConnecte => _user != null;
  User? get utilisateur => _user;
  String? get email => _user?.email;
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  // ─── Authentification email / mot de passe ────────────────────────────────

  Future<void> seConnecter({
    required String email,
    required String password,
  }) async {
    _setChargement(true);
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      _erreur = _messageErreurAuth(e);
      notifyListeners();
    } catch (_) {
      _erreur = _messageErreurGenerique;
      notifyListeners();
    } finally {
      _setChargement(false);
    }
  }

  Future<void> sInscrire({
    required String email,
    required String password,
  }) async {
    _setChargement(true);
    try {
      await _client.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      _erreur = _messageErreurAuth(e);
      notifyListeners();
    } catch (_) {
      _erreur = _messageErreurGenerique;
      notifyListeners();
    } finally {
      _setChargement(false);
    }
  }

  // ─── OAuth (navigateur → deep link) ──────────────────────────────────────

  /// Ouvre le navigateur pour l'authentification Google.
  /// La session est récupérée automatiquement via le deep link
  /// [SupabaseConfig.authRedirectUrl] que l'app intercepte.
  Future<void> seConnecterGoogle() async {
    _setChargement(true);
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: SupabaseConfig.authRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      _erreur = _messageErreurAuth(e);
      notifyListeners();
    } catch (_) {
      _erreur = _messageErreurGenerique;
      notifyListeners();
    } finally {
      _setChargement(false);
    }
  }

  /// Ouvre le navigateur pour l'authentification Apple.
  Future<void> seConnecterApple() async {
    _setChargement(true);
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: SupabaseConfig.authRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      _erreur = _messageErreurAuth(e);
      notifyListeners();
    } catch (_) {
      _erreur = _messageErreurGenerique;
      notifyListeners();
    } finally {
      _setChargement(false);
    }
  }

  /// Lie un compte Google au compte actuellement connecté.
  /// Ouvre le navigateur pour Google OAuth et ajoute cette identité au compte.
  Future<void> lierGoogle() async {
    _setChargement(true);
    try {
      // externalApplication : iOS gère le retour à l'app via le scheme custom,
      // contrairement à inAppBrowserView dont la SFSafariViewController ne se ferme
      // pas automatiquement après linkIdentity (l'event est userUpdated, pas signedIn).
      await _client.auth.linkIdentity(
        OAuthProvider.google,
        redirectTo: SupabaseConfig.authRedirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      _erreur = _messageErreurAuth(e);
      notifyListeners();
    } catch (_) {
      _erreur = _messageErreurGenerique;
      notifyListeners();
    } finally {
      _setChargement(false);
    }
  }

  // ─── Déconnexion ──────────────────────────────────────────────────────────

  Future<void> seDeconnecter() async {
    _setChargement(true);
    try {
      await _client.auth.signOut();
    } finally {
      _setChargement(false);
    }
  }

  // ─── Suppression de compte ────────────────────────────────────────────────

  /// Supprime définitivement le compte via la fonction SQL `supprimer_compte`.
  /// Les entrées existantes sont conservées en base (marquées orphelines).
  Future<void> supprimerCompte() async {
    _setChargement(true);
    try {
      await _client.rpc('supprimer_compte');
      // Le compte n'existe plus — vider la session locale
      try {
        await _client.auth.signOut();
      } catch (_) {}
      _user = null;
      _erreur = null;
      notifyListeners();
    } catch (_) {
      _erreur = 'La suppression du compte a échoué. Réessaie.';
      notifyListeners();
    } finally {
      _setChargement(false);
    }
  }

  // ─── Utilitaires ──────────────────────────────────────────────────────────

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }

  void _setChargement(bool val) {
    _chargement = val;
    notifyListeners();
  }

  /// Traduit les codes d'erreur Supabase en messages compréhensibles.
  /// Les messages de l'API sont en anglais — on les intercepte par code/message.
  String _messageErreurAuth(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_grant')) {
      return 'E-mail ou mot de passe incorrect.';
    }
    if (msg.contains('user already registered') ||
        msg.contains('already registered')) {
      return 'Un compte existe déjà avec cet e-mail.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Confirme ton adresse e-mail avant de te connecter.';
    }
    if (msg.contains('rate limit')) {
      return 'Trop de tentatives. Réessaie dans quelques minutes.';
    }
    return e.message;
  }

  static const String _messageErreurGenerique =
      'Une erreur est survenue. Réessaie.';

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
