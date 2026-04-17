import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants.dart';
import '../../data/models/entree.dart';
import '../../data/repositories/entree_repository.dart';

/// Provider central — source de vérité pour toutes les entrées de l'app.
///
/// Utilisé par les trois écrans (Saisie, Carte, Profil) via Provider.of<>.
/// S'abonne à [onAuthStateChange] pour charger/vider les données
/// automatiquement selon l'état de connexion.
class EntreesProvider extends ChangeNotifier {
  EntreesProvider({EntreeRepository? repository})
      : _repository = repository ?? EntreeRepository() {
    // Charge immédiatement — les lucioles communautaires sont publiques
    chargerToutesGeolocalisees();
    if (Supabase.instance.client.auth.currentUser != null) {
      charger();
    }

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        charger();
        chargerToutesGeolocalisees();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _entrees = [];
        _dejaEntreeCeJour = false;
        _entreeJour = null;
        notifyListeners();
        chargerToutesGeolocalisees();
      }
    });
  }

  final EntreeRepository _repository;
  late final StreamSubscription<AuthState> _authSub;

  // ─── État ─────────────────────────────────────────────────────────────────

  List<Entree> _entrees = [];
  List<Entree> _toutesGeolocalisees = [];
  bool _chargement = false;
  bool _dejaEntreeCeJour = false;
  Entree? _entreeJour;
  Saison _filtreSaison = Saison.toutes;

  // ─── Getters publics ──────────────────────────────────────────────────────

  bool get chargement => _chargement;
  bool get dejaEntreeCeJour => _dejaEntreeCeJour;
  Entree? get entreeJour => _entreeJour;
  Saison get filtreSaison => _filtreSaison;

  /// Toutes les entrées, sans filtre
  List<Entree> get entrees => _entrees;

  /// Entrées filtrées par saison (pour le fil du temps)
  List<Entree> get entreesFiltrees {
    if (_filtreSaison == Saison.toutes) return _entrees;
    return _entrees.where((e) => e.saison == _filtreSaison).toList();
  }

  /// Entrées de l'utilisateur avec coordonnées GPS
  List<Entree> get entreesGeolocalisees =>
      _entrees.where((e) => e.aLieu).toList();

  /// Toutes les lucioles géolocalisées de la communauté (tous les users)
  List<Entree> get toutesGeolocalisees => _toutesGeolocalisees;

  // ─── Actions ──────────────────────────────────────────────────────────────

  /// Charge les entrées de l'utilisateur connecté.
  /// Sans effet si l'utilisateur n'est pas connecté.
  Future<void> charger() async {
    if (Supabase.instance.client.auth.currentUser == null) return;

    _chargement = true;
    notifyListeners();

    _entrees = await _repository.getAll();
    _dejaEntreeCeJour = await _repository.hasEntreeCeJour();
    _entreeJour = await _repository.getEntreeCeJour();

    _chargement = false;
    notifyListeners();
  }

  /// Charge toutes les lucioles géolocalisées de la communauté.
  Future<void> chargerToutesGeolocalisees() async {
    _toutesGeolocalisees = await _repository.getAllGeolocalisees();
    notifyListeners();
  }

  /// Enregistre une nouvelle entrée quotidienne.
  Future<void> ajouter(Entree entree) async {
    await _repository.ajouter(entree);
    await Future.wait([charger(), chargerToutesGeolocalisees()]);
  }

  /// Supprime une entrée et recharge la liste.
  Future<void> supprimer(String id) async {
    await _repository.supprimer(id);
    await Future.wait([charger(), chargerToutesGeolocalisees()]);
  }

  /// Met à jour le photo_url de l'entrée du jour puis recharge.
  Future<void> updatePhotoUrl(String entreeId, String photoUrl) async {
    await _repository.updatePhotoUrl(entreeId, photoUrl);
    await Future.wait([charger(), chargerToutesGeolocalisees()]);
  }

  /// Met à jour le filtre de saison pour le fil du temps.
  void setFiltreSaison(Saison saison) {
    _filtreSaison = saison;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
