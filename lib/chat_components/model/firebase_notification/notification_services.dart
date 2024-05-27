import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';



class NotificationService {
  static Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();


    String appName = packageInfo.appName;

    String packageName = packageInfo.packageName;

    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: "chat_messages",
              channelName: "chatdemo",
              channelDescription: "chatdemo",
              importance: NotificationImportance.Max,
              channelShowBadge: true,
              playSound: true,
              criticalAlerts: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              defaultColor: const Color(0xFF9D58D0),
              ledColor: Colors.white
          )
        ],
        debug: true);
    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == 'true') {
      // locator<NavigationService>().navigateToWithParams(notificationRoute, {'title': payload['title']!, 'body': payload['body']!});
    }
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> show({
    required final String title,
    required final String body,
    required final String id,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();


    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: "chat_messages",
          title: title,
          body: body,
          groupKey:'com.chat.demo.$id' ,
          actionType: actionType,
          notificationLayout: notificationLayout,
          summary: summary,
          category: category,
          payload: payload,
          bigPicture: bigPicture,
        ),
        actionButtons: actionButtons,
        schedule: scheduled
            ? NotificationInterval(
            interval: interval,
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
            preciseAlarm: true)
            : null
    );
  }
}