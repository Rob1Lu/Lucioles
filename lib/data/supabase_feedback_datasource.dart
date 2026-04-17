import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFeedbackDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> envoyerFeedback({
    required String message,
    String? type,
  }) async {
    await _client.from('feedbacks').insert({
      'user_id': _client.auth.currentUser?.id,
      'type': type,
      'message': message,
    });
  }
}
