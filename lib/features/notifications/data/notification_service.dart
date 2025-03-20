<<<<<<< HEAD
import 'package:eschool_teacher/features/notifications/data/models/customNotification.dart';
=======
import 'package:madares_app_teacher/features/notifications/data/models/customNotification.dart';
>>>>>>> f8116bb26ff7cdb9462a79241b86162b4f4e9bdc
import 'package:hive/hive.dart';

class NotificationService {
  final Box<CustomNotification> notificationBox;

  NotificationService(this.notificationBox);

  Future<void> addNotifications(List<CustomNotification> notifications) async {
    final Map<int, CustomNotification> notificationMap = {
      for (var n in notifications) n.id: n
    };
    await notificationBox.putAll(notificationMap);
  }

  int countNewNotifications(List<CustomNotification> newNotifications) {
    final existingIds = notificationBox.values.map((e) => e.id).toSet();
    return newNotifications
        .where((notification) => !existingIds.contains(notification.id))
        .length;
  }
}
