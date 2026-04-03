import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/supabase_client.dart';

class NotificationRemoteDatasource {
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await supabase
        .from(AppConstants.tableNotifications)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(data as List);
  }

  Future<void> markAsRead(String id) async {
    await supabase
        .from(AppConstants.tableNotifications)
        .update({'is_read': true})
        .eq('id', id);
  }

  Future<void> markAllAsRead() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase
        .from(AppConstants.tableNotifications)
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  Stream<int> watchUnreadCount() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return const Stream.empty();
    return supabase
        .from(AppConstants.tableNotifications)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((rows) => rows.where((r) => r['is_read'] == false).length);
  }
}
