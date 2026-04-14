import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/supabase_profile_datasource.dart';

/// Gère le profil de l'utilisateur connecté : pseudo et avatar.
///
/// S'abonne à [onAuthStateChange] pour charger / vider les données
/// automatiquement selon l'état de connexion.
class ProfileProvider extends ChangeNotifier {
  ProfileProvider({SupabaseProfileDatasource? datasource})
      : _datasource = datasource ?? SupabaseProfileDatasource() {
    if (Supabase.instance.client.auth.currentUser != null) charger();

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        charger();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _vider();
      }
    });
  }

  final SupabaseProfileDatasource _datasource;
  late final StreamSubscription<AuthState> _authSub;

  String? _username;
  String? _avatarSignedUrl;
  bool _chargement = false;

  String? get username => _username;
  String? get avatarSignedUrl => _avatarSignedUrl;
  bool get chargement => _chargement;

  void _vider() {
    _username = null;
    _avatarSignedUrl = null;
    notifyListeners();
  }

  Future<void> charger() async {
    if (Supabase.instance.client.auth.currentUser == null) return;

    final data = await _datasource.getProfile();
    if (data == null) return;

    _username = data['username'] as String?;
    final avatarPath = data['avatar_url'] as String?;
    _avatarSignedUrl = avatarPath != null
        ? await _datasource.getAvatarSignedUrl(avatarPath)
        : null;

    notifyListeners();
  }

  Future<void> updateUsername(String username) async {
    await _datasource.updateUsername(username);
    _username = username.trim().isEmpty ? null : username.trim();
    notifyListeners();
  }

  Future<void> updateAvatar(XFile photo) async {
    _chargement = true;
    notifyListeners();
    try {
      final storagePath = await _datasource.uploadAvatar(photo);
      _avatarSignedUrl = await _datasource.getAvatarSignedUrl(storagePath);
    } finally {
      _chargement = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
