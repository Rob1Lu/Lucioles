import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/admin_feedback.dart';
import 'models/admin_signalement_archive.dart';
import 'models/admin_user.dart';
import 'models/entree.dart';
import 'models/signalement_item.dart';

class SupabaseAdminDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, int>> getStats() async {
    final data =
        await _client.rpc('admin_get_stats') as Map<String, dynamic>;
    return {
      'user_count': (data['user_count'] as num).toInt(),
      'luciole_count': (data['luciole_count'] as num).toInt(),
    };
  }

  Future<List<AdminUser>> getUsers() async {
    final data = await _client.rpc('admin_get_users') as List<dynamic>;
    return data
        .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteUser(String userId) async {
    await _client
        .rpc('admin_delete_user', params: {'target_user_id': userId});
  }

  Future<List<Entree>> getUserEntrees(String userId) async {
    final data = await _client.rpc(
      'admin_get_user_entrees',
      params: {'target_user_id': userId},
    ) as List<dynamic>;

    final entrees = data
        .map((e) => Entree.fromJson(e as Map<String, dynamic>))
        .toList();

    // Génère les signed URLs pour les photos en parallèle
    return Future.wait(entrees.map((e) async {
      if (e.photoUrl == null) return e;
      final url = await _signedUrl('entree-photos', e.photoUrl!);
      return e.copyWith(photoUrl: url);
    }));
  }

  Future<List<SignalementItem>> getSignalements() async {
    final data =
        await _client.rpc('admin_get_signalements') as List<dynamic>;
    final items = data
        .map((e) => SignalementItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return Future.wait(items.map((item) async {
      if (item.photoUrl == null) return item;
      final url = await _signedUrl('entree-photos', item.photoUrl!);
      return url != null ? item.copyWith(photoUrl: url) : item;
    }));
  }

  Future<List<AdminFeedback>> getFeedbacks() async {
    final data = await _client.rpc('admin_get_feedbacks') as List<dynamic>;
    return data
        .map((e) => AdminFeedback.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AdminSignalementArchive>> getSignalementsArchives() async {
    final data =
        await _client.rpc('admin_get_signalements_archives') as List<dynamic>;
    return data
        .map((e) =>
            AdminSignalementArchive.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> reviewEntree(String entreeId, String action) async {
    await _client.rpc('admin_review_entree', params: {
      'target_entree_id': entreeId,
      'action': action,
    });
  }

  Future<String?> getAvatarSignedUrl(String path) =>
      _signedUrl('avatars', path);

  Future<String?> _signedUrl(String bucket, String path) async {
    try {
      return await _client.storage.from(bucket).createSignedUrl(path, 3600);
    } catch (_) {
      return null;
    }
  }
}
