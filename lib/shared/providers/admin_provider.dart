import 'package:flutter/foundation.dart';

import '../../data/models/admin_feedback.dart';
import '../../data/models/admin_signalement_archive.dart';
import '../../data/models/admin_user.dart';
import '../../data/models/entree.dart';
import '../../data/models/signalement_item.dart';
import '../../data/supabase_admin_datasource.dart';

class AdminStats {
  const AdminStats({required this.userCount, required this.lucioleCount});
  final int userCount;
  final int lucioleCount;
}

class AdminProvider extends ChangeNotifier {
  AdminProvider({SupabaseAdminDatasource? datasource})
      : _datasource = datasource ?? SupabaseAdminDatasource();

  final SupabaseAdminDatasource _datasource;

  AdminStats? _stats;
  List<AdminUser> _utilisateurs = [];
  List<SignalementItem> _signalements = [];
  List<AdminFeedback> _feedbacks = [];
  List<AdminSignalementArchive> _signalementsArchives = [];
  bool _chargementStats = false;
  bool _chargementUtilisateurs = false;
  bool _chargementSignalements = false;
  bool _chargementFeedbacks = false;
  bool _chargementArchives = false;
  String? _erreur;

  AdminStats? get stats => _stats;
  List<AdminUser> get utilisateurs => _utilisateurs;
  List<SignalementItem> get signalements => _signalements;
  List<AdminFeedback> get feedbacks => _feedbacks;
  List<AdminSignalementArchive> get signalementsArchives => _signalementsArchives;
  bool get chargementStats => _chargementStats;
  bool get chargementUtilisateurs => _chargementUtilisateurs;
  bool get chargementSignalements => _chargementSignalements;
  bool get chargementFeedbacks => _chargementFeedbacks;
  bool get chargementArchives => _chargementArchives;
  String? get erreur => _erreur;

  List<AdminUser> filtrer(String query) {
    if (query.trim().isEmpty) return _utilisateurs;
    final q = query.trim().toLowerCase();
    return _utilisateurs
        .where((u) =>
            u.email.toLowerCase().contains(q) ||
            (u.username?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  Future<void> chargerStats() async {
    _chargementStats = true;
    _erreur = null;
    notifyListeners();
    try {
      final data = await _datasource.getStats();
      _stats = AdminStats(
        userCount: data['user_count']!,
        lucioleCount: data['luciole_count']!,
      );
    } catch (e) {
      _erreur = e.toString();
    } finally {
      _chargementStats = false;
      notifyListeners();
    }
  }

  Future<void> chargerUtilisateurs() async {
    _chargementUtilisateurs = true;
    _erreur = null;
    notifyListeners();
    try {
      _utilisateurs = await _datasource.getUsers();
    } catch (e) {
      _erreur = e.toString();
    } finally {
      _chargementUtilisateurs = false;
      notifyListeners();
    }
  }

  Future<bool> supprimerUtilisateur(String userId) async {
    try {
      await _datasource.deleteUser(userId);
      _utilisateurs.removeWhere((u) => u.id == userId);
      notifyListeners();
      return true;
    } catch (e) {
      _erreur = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> chargerSignalements() async {
    _chargementSignalements = true;
    _erreur = null;
    notifyListeners();
    try {
      _signalements = await _datasource.getSignalements();
    } catch (e) {
      _erreur = e.toString();
    } finally {
      _chargementSignalements = false;
      notifyListeners();
    }
  }

  Future<void> reviewerEntree(String entreeId, String action) async {
    try {
      await _datasource.reviewEntree(entreeId, action);
      _signalements.removeWhere((s) => s.entreeId == entreeId);
      notifyListeners();
    } catch (e) {
      _erreur = e.toString();
      notifyListeners();
    }
  }

  Future<void> chargerFeedbacks() async {
    _chargementFeedbacks = true;
    _erreur = null;
    notifyListeners();
    try {
      _feedbacks = await _datasource.getFeedbacks();
    } catch (e) {
      _erreur = e.toString();
    } finally {
      _chargementFeedbacks = false;
      notifyListeners();
    }
  }

  Future<void> chargerSignalementsArchives() async {
    _chargementArchives = true;
    _erreur = null;
    notifyListeners();
    try {
      _signalementsArchives = await _datasource.getSignalementsArchives();
    } catch (e) {
      _erreur = e.toString();
    } finally {
      _chargementArchives = false;
      notifyListeners();
    }
  }

  Future<List<Entree>> chargerEntreesUtilisateur(String userId) =>
      _datasource.getUserEntrees(userId);

  Future<String?> getAvatarSignedUrl(String path) =>
      _datasource.getAvatarSignedUrl(path);
}
