import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/notification_remote_datasource.dart';

final notificationDatasourceProvider =
    Provider((_) => NotificationRemoteDatasource());

final notificationsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) =>
        ref.watch(notificationDatasourceProvider).getNotifications());

final unreadCountProvider = StreamProvider<int>((ref) =>
    ref.watch(notificationDatasourceProvider).watchUnreadCount());

class NotificationNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() =>
      ref.watch(notificationDatasourceProvider).getNotifications();

  Future<void> markAsRead(String id) async {
    await ref.read(notificationDatasourceProvider).markAsRead(id);
    ref.invalidateSelf();
  }

  Future<void> markAllAsRead() async {
    await ref.read(notificationDatasourceProvider).markAllAsRead();
    ref.invalidateSelf();
  }
}

final notificationNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, List<Map<String, dynamic>>>(
        NotificationNotifier.new);
