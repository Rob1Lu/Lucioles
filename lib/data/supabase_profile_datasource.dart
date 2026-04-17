import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Couche d'accès aux données Supabase pour le profil utilisateur.
class SupabaseProfileDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  /// Retourne les champs `username`, `avatar_url` et `is_admin` du profil courant.
  Future<Map<String, dynamic>?> getProfile() async {
    return await _client
        .from('profiles')
        .select('username, avatar_url, is_admin')
        .eq('id', _userId)
        .maybeSingle();
  }

  /// Met à jour le pseudo. Passer une chaîne vide pour le supprimer.
  Future<void> updateUsername(String username) async {
    await _client.from('profiles').update({
      'username': username.trim().isEmpty ? null : username.trim(),
    }).eq('id', _userId);
  }

  /// Uploade une photo de profil dans le bucket `avatars` et enregistre le
  /// chemin dans `profiles.avatar_url`. Retourne le chemin Storage.
  ///
  /// Le fichier est toujours stocké sous `<userId>/avatar` (sans extension)
  /// pour garantir qu'un upsert remplace l'ancien avatar.
  Future<String> uploadAvatar(XFile photo) async {
    const storagePath = 'avatar';
    final fullPath = '$_userId/$storagePath';
    final ext = p.extension(photo.path).toLowerCase();
    final bytes = await photo.readAsBytes();

    await _client.storage.from('avatars').uploadBinary(
      fullPath,
      bytes,
      fileOptions: FileOptions(
        contentType: _mimeType(ext),
        upsert: true,
      ),
    );

    await _client
        .from('profiles')
        .update({'avatar_url': fullPath})
        .eq('id', _userId);

    return fullPath;
  }

  /// Génère une URL signée (TTL 1 h) pour afficher un avatar privé.
  Future<String?> getAvatarSignedUrl(String path) async {
    try {
      return await _client.storage.from('avatars').createSignedUrl(path, 3600);
    } catch (_) {
      return null;
    }
  }

  String _mimeType(String ext) {
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}
