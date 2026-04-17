import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/entree.dart';

/// Couche d'accès aux données Supabase pour les entrées.
///
/// Toutes les requêtes sont filtrées par [_userId] — la RLS côté Supabase
/// constitue une deuxième ligne de défense.
class SupabaseEntreeDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  Future<List<Entree>> getAllEntrees() async {
    final data = await _client
        .from('entrees')
        .select()
        .eq('user_id', _userId)
        .order('date_creation', ascending: false);

    final entrees = data.map<Entree>((row) => Entree.fromJson(row)).toList();
    return _populerSignedUrls(entrees);
  }

  Future<bool> hasEntreeCeJour() async {
    final now = DateTime.now();
    final debutJour = DateTime(now.year, now.month, now.day);
    final finJour = debutJour.add(const Duration(days: 1));

    final data = await _client
        .from('entrees')
        .select('id')
        .eq('user_id', _userId)
        .gte('date_creation', debutJour.toIso8601String())
        .lt('date_creation', finJour.toIso8601String())
        .limit(1);

    return data.isNotEmpty;
  }

  Future<Entree?> getEntreeCeJour() async {
    final now = DateTime.now();
    final debutJour = DateTime(now.year, now.month, now.day);
    final finJour = debutJour.add(const Duration(days: 1));

    final data = await _client
        .from('entrees')
        .select()
        .eq('user_id', _userId)
        .gte('date_creation', debutJour.toIso8601String())
        .lt('date_creation', finJour.toIso8601String())
        .limit(1);

    if (data.isEmpty) return null;
    final entrees = await _populerSignedUrls([Entree.fromJson(data.first)]);
    return entrees.first;
  }

  Future<void> insertEntree(Entree entree) async {
    await _client.from('entrees').insert({
      ...entree.toJson(),
      'user_id': _userId,
    });
  }

  Future<void> deleteEntree(String id) async {
    await _client.from('entrees').delete().eq('id', id);
  }

  /// Met à jour uniquement le champ photo_url d'une entrée existante.
  Future<void> updatePhotoUrl(String id, String photoUrl) async {
    await _client
        .from('entrees')
        .update({'photo_url': photoUrl})
        .eq('id', id)
        .eq('user_id', _userId);
  }

  /// Récupère toutes les lucioles géolocalisées — tous les users, y compris orphelines.
  ///
  /// Utilisé par la carte en mode communautaire.
  Future<List<Entree>> getAllGeolocalisees() async {
    final data = await _client
        .from('entrees')
        .select('id, texte, latitude, longitude, lieu_nom, photo_url, date_creation, saison')
        .not('latitude', 'is', null)
        .not('longitude', 'is', null)
        .eq('is_restricted', false)
        .order('date_creation', ascending: false);

    final entrees = data.map<Entree>((row) => Entree.fromJson(row)).toList();
    if (_client.auth.currentUser == null) return entrees;
    return _populerSignedUrls(entrees);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Remplace les chemins Storage par des URLs signées (1 h) en un seul appel.
  Future<List<Entree>> _populerSignedUrls(List<Entree> entrees) async {
    final paths = entrees
        .where((e) => e.photoUrl != null)
        .map((e) => e.photoUrl!)
        .toList();

    if (paths.isEmpty) return entrees;

    final signedUrls = await _client.storage
        .from('entree-photos')
        .createSignedUrls(paths, 3600);

    final urlMap = {
      for (final s in signedUrls) s.path: s.signedUrl,
    };

    return entrees.map((e) {
      if (e.photoUrl == null) return e;
      final signed = urlMap[e.photoUrl];
      return signed != null ? e.copyWith(photoUrl: signed) : e;
    }).toList();
  }
}
