import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Couche d'accès aux données pour les signalements de lucioles.
///
/// Un utilisateur ne peut signaler une entrée qu'une seule fois
/// (contrainte UNIQUE en base). L'edge function [check-signalements]
/// est invoquée après chaque signalement pour restreindre automatiquement
/// les entrées ayant atteint 3 signalements distincts.
class SignalementDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  /// Insère un signalement puis déclenche la vérification côté serveur.
  ///
  /// Lance une [PostgrestException] si l'utilisateur a déjà signalé cette entrée.
  /// L'appel à l'edge function est best-effort : son échec n'est pas propagé
  /// au caller (le signalement est déjà enregistré en base).
  Future<void> signalerEntree({
    required String entreeId,
    required String raison,
    String? details,
  }) async {
    // 1. Insérer le signalement — erreur fatale si ça échoue (doublon, RLS…)
    await _client.from('signalements').insert({
      'entree_id': entreeId,
      'reporter_id': _userId,
      'raison': raison,
      if (details != null && details.isNotEmpty) 'details': details,
    });

    // 2. Déclencher la vérification du seuil de restriction (best-effort)
    try {
      await _client.functions.invoke(
        'check-signalements',
        body: {'entree_id': entreeId},
      );
    } catch (e, stack) {
      // L'insert a réussi — on logue sans propager l'erreur
      debugPrint('[SignalementDatasource] edge function check-signalements: $e\n$stack');
    }
  }

  /// Vérifie si l'utilisateur courant a déjà signalé cette entrée.
  Future<bool> aDejaSignale(String entreeId) async {
    final data = await _client
        .from('signalements')
        .select('id')
        .eq('entree_id', entreeId)
        .eq('reporter_id', _userId)
        .limit(1);
    return data.isNotEmpty;
  }
}
