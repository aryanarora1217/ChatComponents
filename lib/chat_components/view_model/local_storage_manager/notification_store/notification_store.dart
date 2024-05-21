import 'package:hive/hive.dart';

import '../../../view/widgets/log_print/log_print_condition.dart';

class NotificationLocalStoreManger{

  static const hiveBox = "Notification_manager";

  static Future<List<Map<String,String>>> getNotificationList(String userId) async {
    var notificationBox = await Hive.openBox(hiveBox);
    try {
      logPrint("get notification user recent messages :${notificationBox.get(userId, defaultValue: "").toString()}");
      final recentMessagesBox = await notificationBox.get(userId, defaultValue: "");
      logPrint("get recent messaage lsit : $recentMessagesBox , ${recentMessagesBox.runtimeType}");
      return recentMessagesBox;
    }
    catch(e){
      return [];
    }
  }

  static Future<void> setNotificationList({required String userId,required List<Map<String,String>>? recentMessageList}) async {
    var notificationBox = await Hive.openBox(hiveBox);

    await notificationBox.put(userId, recentMessageList);
    return ;
  }

}