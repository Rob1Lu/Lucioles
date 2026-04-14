import '../models/entree.dart';
import '../supabase_entree_datasource.dart';

/// Couche repository — abstrait l'accès aux données pour les providers.
///
/// Toute la logique de persistance passe ici ; les écrans ne touchent
/// jamais directement à la base de données.
class EntreeRepository {
  EntreeRepository({SupabaseEntreeDatasource? datasource})
      : _datasource = datasource ?? SupabaseEntreeDatasource();

  final SupabaseEntreeDatasource _datasource;

  Future<List<Entree>> getAll() => _datasource.getAllEntrees();

  Future<bool> hasEntreeCeJour() => _datasource.hasEntreeCeJour();

  Future<Entree?> getEntreeCeJour() => _datasource.getEntreeCeJour();

  Future<void> ajouter(Entree entree) => _datasource.insertEntree(entree);

  Future<void> supprimer(String id) => _datasource.deleteEntree(id);

  /// Toutes les lucioles géolocalisées de la communauté (non-orphelines).
  Future<List<Entree>> getAllGeolocalisees() => _datasource.getAllGeolocalisees();

  /// Met à jour le photo_url d'une entrée existante.
  Future<void> updatePhotoUrl(String id, String photoUrl) =>
      _datasource.updatePhotoUrl(id, photoUrl);
}
