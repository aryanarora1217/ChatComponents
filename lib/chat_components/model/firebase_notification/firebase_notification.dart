import 'dart:convert';
import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../chatHelper/chat_helper.dart';
import '../models/call_model/call_model.dart';
import '../models/chat_model/chat_model.dart';
import '../models/message_model/message_model.dart';
import '../models/user_model/user_model.dart';
import '../network_services/firebase_database.dart';
import 'package:http/http.dart' as http;


class FirebaseNotification {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;
  Users userDetails = Users();
  Users otherUserDetails = Users();
  CallModel callDetails = CallModel();
  MessageModel messageDetails = MessageModel();
  ChatRoomModel chatRoomModel = ChatRoomModel();
  RxBool isMessages = false.obs;
  RxBool isCall = false.obs;
  String callTypes = "";
  String callId = "";
  String messageId = "";
  String chatRoomID = "";
  String token = '';
  var firebase = FirebaseDataBase();

  RxMap<String, dynamic> presence = <String, dynamic>{}.obs;

  /// send notification function
  Future<void> sendNotification(
      String? callType,
      Users currentUsers,
      String userToken,
      CallModel? callModel,
      bool isMessage,
      MessageModel? messageModel,
      String? chatRoomId,
      String firebaseServerKey,
      Users users) async {
    try {
      userDetails = currentUsers;
      token = userToken;
      isMessages.value = isMessage;
      otherUserDetails = users;
      if (isMessage) {
        chatRoomID = chatRoomId ?? "";
        messageDetails = messageModel ?? MessageModel();
      } else {
        callTypes = callType ?? "";
        callDetails = callModel ?? CallModel();
        logPrint("call id : ${callDetails.callId}");
      }
      http.Response response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=$firebaseServerKey',
          },
          body: constructFCMPayload(currentUsers.id??""));

      isMessage ? null : firebase.addCall(callDetails);
      logPrint("status: ${response.statusCode} | Message Sent Successfully!");
      logPrint("status: ${response.statusCode} $token | Message Sent Successfully!");
      logPrint("status: ${response.body} | Message Sent Successfully!");
    } catch (e) {
      logPrint("error push notification $e");
    }
  }

  /// data send in json format in notification
  String constructFCMPayload(String currentUserID) {
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': isMessages.isTrue
              ? (messageDetails.messageType == MessageType.text.name
              ? messageDetails.message
              : messageDetails.file?.fileType == FileTypes.image.name
              ? messageDetails.sender == currentUserID
              ? "send image"
              : "Receive image"
              : messageDetails.sender == currentUserID
              ? "send file"
              : "Receive file") ??
              ""
              : "${userDetails.profileName} is calling",
          'title': userDetails.profileName,
          'sound': isMessages.isTrue ? "cellphone_sound" : "Default",
          "priority": "high",
        },
        'data': isMessages.isTrue
            ? <String, dynamic>{
          ChatHelpers.instance.isMessage: isMessages.value,
          ChatHelpers.instance.userDetails: userDetails.toJson(),
          ChatHelpers.instance.otherUserDetails: otherUserDetails.toJson(),
          ChatHelpers.instance.chatRoomId: chatRoomID,
        }
            : <String, dynamic>{
          ChatHelpers.instance.isMessage: isMessages.value,
          ChatHelpers.instance.callType: callTypes,
          ChatHelpers.instance.userDetails: userDetails.toJson(),
          ChatHelpers.instance.otherUserDetails: otherUserDetails.toJson(),
          ChatHelpers.instance.callId: callDetails.callId,
        },
        'to': token
      },
    );
  }
  

  Future<void> initMessaging() async {

    /// flutter local notification plugin intilaize for both android snd ios

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();
    fltNotification = FlutterLocalNotificationsPlugin();

    await fltNotification.pendingNotificationRequests();
    var androidDetailsChannel = const AndroidNotificationChannel(
        'syncChat', 'syncApp',
        playSound: true, importance: Importance.max);

    await fltNotification
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidDetailsChannel);

    // var androidDetailsC = const AndroidNotificationDetails(
    //   'syncChat',
    //   'syncApp',
    //   sound: RawResourceAndroidNotificationSound('cellphone_sound'),
    //   playSound: true,
    //   importance: Importance.max,
    //   priority: Priority.max,
    // );

    var androidDetails = const AndroidNotificationDetails(
      'syncChat',
      'syncApp',
      sound: RawResourceAndroidNotificationSound('cellphone_sound'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
    );

    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    var androiInit = const AndroidInitializationSettings('logo');
    var iosInit = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    fltNotification.initialize(initSetting,
        onSelectNotification: (String? payload) {
          if (payload != null) {
            Get.toNamed(ChatHelpers.chatScreen, arguments: {
              ChatHelpers.instance.chatRoomId: payload,
              ChatHelpers.instance.userId:
              ChatHelpers.instance.userId
            });
          }
        });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   try {
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;
    //     logPrint("message resciving : $chatRoomID , ${message.data}");
    //     if (notification != null && android != null) {
    //       String isMessage = message.data[ChatHelpers.instance.isMessage];
    //       otherUserDetails = Users.fromJson(
    //           jsonDecode(message.data[ChatHelpers.instance.userDetails]));
    //       if (isMessage == "true") {
    //         chatRoomID = message.data[ChatHelpers.instance.chatRoomId];
    //         chatRoomModel = await fetchMessages(chatRoomID);
    //         Get.toNamed(ChatHelpers.chatScreen,
    //         //     arguments: {
    //         //   ChatHelpers.instance.chatRoomId: chatRoomID.toString(),
    //         //   ChatHelpers.instance.userId: ChatHelpers.instance.userId
    //         // }
    //           arguments: ChatArguments(chatRoomId: chatRoomID.toString(), userId: ChatHelpers.instance.userId, isVideoCallEnable: true, isAudioCallEnable: true, isFileSendEnable: true, isImageSendEnable: true, imageBaseUrl: '', agoraAppId: '', agoraAppCertificate: '', currentUserId: '', firebaseServerKey: '')
    //         );
    //       }
    //       else {
    //         callTypes = message.data[ChatHelpers.instance.callType];
    //         callId = message.data[ChatHelpers.instance.callId];
    //         if (callDetails.callId != "") {
    //           // Get.toNamed(Routes.outGoingScreen, arguments: {
    //           //   ChatHelpers.instance.callType: callTypes,
    //           //   ChatHelpers.instance.userDetails: otherUserDetails,
    //           //   ChatHelpers.instance.callId: callId,
    //           // });
    //           Get.toNamed(ChatHelpers.outGoingScreen,
    //               arguments: CallArguments(user: userDetails, callType: callTypes, callId: callId, imageBaseUrl: '', agoraAppId: 'ea835372061d44c9b99dda29f68b0a99', agoraAppCertificate: '', userId: userDetails.id??"", currentUserId: otherUserDetails.id??"", firebaseServerKey: 'AAAA45SJcD8:APA91bEXoiP3PLnWsajOYz_PojFSu2AJAnbLJg2iqA3qCzSQDkw6qQw9vsMZoTdsQCo1ZQ8P0g4ALl6OauERl-qXghfK7qyk-Cbke5fnaW-HdfGKSm7kOkydH2LIobJfP2oABA1B0SE-', currentUser: otherUserDetails, agoraChannelName: 'demoRoom', agoraToken: '007eJxTYJjwwlJKyr5oy0qjfLX0f7deXvF3z5IU/rJe5dihFfkHvrQoMKQmWhibGpsbGZgZppiYJFsmWVqmpCQaWaaZWSQZJFpaMuT9TG0IZGQ44lHHzMgAgSA+B0NKam5+UH5+LgMDAPphIa4='));
    //         }
    //       }
    //     }
    //   } catch (e) {
    //     logPrint("error fetching notification : $e");
    //   }
    // });

    /// notification listner form firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          String isMessage = message.data[ChatHelpers.instance.isMessage];
          otherUserDetails = Users.fromJson(
              jsonDecode(message.data[ChatHelpers.instance.userDetails]));
          userDetails = Users.fromJson(
              jsonDecode(message.data[ChatHelpers.instance.otherUserDetails]));
          if (isMessage == "true") {
            chatRoomID = message.data[ChatHelpers.instance.chatRoomId];
            chatRoomModel = await fetchChatroomDetails(chatRoomID);
            if (chatRoomModel.userFirstId == userDetails.id) {
              if (chatRoomModel.userFirst?.userActiveStatus == false ||
                  chatRoomModel.userFirst?.userActiveStatus == null) {
                /// show message notifications
                fltNotification.show(
                    notification.hashCode,
                    userDetails.profileName,
                    (chatRoomModel.recentMessage?.messageType ==
                        MessageType.text.name
                        ? chatRoomModel.recentMessage?.message
                        : chatRoomModel.recentMessage?.file?.fileType ==
                        FileTypes.image.name
                        ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image"
                        : chatRoomModel.recentMessage?.sender ==
                        userDetails.id
                        ? "send file"
                        : "Receive file") ??
                        "",
                    generalNotificationDetails,
                    payload: chatRoomID);
              }
            } else {
              if (chatRoomModel.userSecond?.userActiveStatus == false || chatRoomModel.userSecond?.userActiveStatus == null) {
                /// show message notification for messages
                fltNotification.show(
                    notification.hashCode,
                    userDetails.profileName,
                    (chatRoomModel.recentMessage?.messageType ==
                        MessageType.text.name
                        ? chatRoomModel.recentMessage?.message
                        : chatRoomModel.recentMessage?.file?.fileType ==
                        FileTypes.image.name
                        ? chatRoomModel.recentMessage?.sender ==
                        userDetails.id
                        ? "send image"
                        : "Receive image"
                        : chatRoomModel.recentMessage?.sender ==
                        userDetails.id
                        ? "send file"
                        : "Receive file") ??
                        "",
                    generalNotificationDetails,
                    payload: chatRoomID);
              }
            }
          }
          else {
            callTypes = message.data[ChatHelpers.instance.callType];
            callId = message.data[ChatHelpers.instance.callId];
            logPrint("Call details : ${callDetails.callId} , $callId");
            if (callId != "") {
              /// navigate to outgoing screen when call notification screens
              Get.toNamed(ChatHelpers.outGoingScreen,
                  arguments: CallArguments(user: otherUserDetails, callType: callTypes, callId: callId, imageBaseUrl: '', agoraAppId: 'ea835372061d44c9b99dda29f68b0a99', agoraAppCertificate: '', userId: otherUserDetails.id??"", currentUserId: userDetails.id??"", firebaseServerKey: 'AAAA45SJcD8:APA91bEXoiP3PLnWsajOYz_PojFSu2AJAnbLJg2iqA3qCzSQDkw6qQw9vsMZoTdsQCo1ZQ8P0g4ALl6OauERl-qXghfK7qyk-Cbke5fnaW-HdfGKSm7kOkydH2LIobJfP2oABA1B0SE-', currentUser: userDetails, agoraChannelName: 'demoRoom', agoraToken: '007eJxTYJjwwlJKyr5oy0qjfLX0f7deXvF3z5IU/rJe5dihFfkHvrQoMKQmWhibGpsbGZgZppiYJFsmWVqmpCQaWaaZWSQZJFpaMuT9TG0IZGQ44lHHzMgAgSA+B0NKam5+UH5+LgMDAPphIa4='));
            }
          }
        }
      } catch (e) {
        logPrint("error fetching notification : $e");
      }
    });
  }

  /// fetching chatroom detials
  Future<ChatRoomModel> fetchChatroomDetails(String chatRoomId) async {
    ChatRoomModel chatRoom = ChatRoomModel();
    try {
      DocumentReference<Map<String, dynamic>> reference =
      firebase.recentMessageRef(chatRoomId);
      await reference.get().then((value) {
        logPrint("get data ${value.data()}");
        chatRoom = ChatRoomModel.fromJson(value.data() ?? {});
      });
    } catch (e) {
      logPrint("error fetching message details : $e");
    }
    return chatRoom;
  }
}

/// firebase background message listner
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logPrint(
      "Handling a background message: ${message.messageId},${message.data}");
}
