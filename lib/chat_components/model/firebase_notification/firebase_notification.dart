import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/model/firebase_notification/notification_services.dart';
import 'package:chatcomponent/chat_components/model/services/chat_services.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  CallArguments? callArguments;


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
      Users users,CallArguments callArgument) async {
    try {
      userDetails = currentUsers;
      token = userToken;
      isMessages.value = isMessage;
      otherUserDetails = users;
      callArguments = callArgument;
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
          // 'sound': isMessages.isTrue ? "Default" : "cellphone_sound" ,
          'sound': "Default",
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
          ChatHelpers.instance.agoraChannelName: callArguments?.agoraChannelName,
          ChatHelpers.instance.agoraToken: callArguments?.agoraToken,
          ChatHelpers.instance.agoraAppId: callArguments?.agoraAppId,
          ChatHelpers.instance.agoraCertificate: callArguments?.agoraAppCertificate,
        },
        'to': token
      },
    );
  }


  Future<void> initMessaging() async {

    /// notification listner form firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        logPrint("message recived ");
        if (notification != null && android != null) {
          String isMessage = message.data[ChatHelpers.instance.isMessage];
          userDetails  = Users.fromJson(jsonDecode(message.data[ChatHelpers.instance.userDetails]));
          otherUserDetails = Users.fromJson(jsonDecode(message.data[ChatHelpers.instance.otherUserDetails]));
          if (isMessage == "true") {
            chatRoomID = message.data[ChatHelpers.instance.chatRoomId];
            chatRoomModel = await fetchChatroomDetails(chatRoomID);


            logPrint("notification deatils : current user ${otherUserDetails.toJson()} , sender  ${userDetails.toJson()}");


            logPrint("user notificaitons : ${chatRoomModel.recentMessage?.message} , ${chatRoomModel.recentMessage?.sender}");
            
              NotificationService.show(title: userDetails.profileName ??"", body: (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "",notificationLayout: NotificationLayout.MessagingGroup,category: NotificationCategory.Email,summary:"",id: userDetails.profileName ??"");

            }
          else {
            String agoraAppID = message.data[ChatHelpers.instance.agoraAppId];
            String agoraCertificate = message.data[ChatHelpers.instance.agoraCertificate];
            String agoraChannelName = message.data[ChatHelpers.instance.agoraChannelName];
            String agoraToken = message.data[ChatHelpers.instance.agoraToken];
            callTypes = message.data[ChatHelpers.instance.callType];
            callId = message.data[ChatHelpers.instance.callId];
            logPrint("Call details : ${callDetails.callId} , $callId , $callArguments");
            if (callId != "") {
              /// navigate to outgoing screen when call notification screens
              Get.toNamed(ChatHelpers.outGoingScreen,
                  arguments:  CallArguments(themeArguments: Get.find<ChatServices>().chatArguments.themeArguments,user: otherUserDetails, callType: callTypes, callId: callId, imageBaseUrl: Get.find<ChatServices>().chatArguments.imageBaseUrlFirebase, agoraAppId: agoraAppID, agoraAppCertificate: agoraCertificate, userId: otherUserDetails.id??"", currentUserId: userDetails.id ??"", firebaseServerKey: Get.find<ChatServices>().chatArguments.firebaseServerKey, currentUser: userDetails, agoraChannelName: agoraChannelName, agoraToken: agoraToken));
            }
          }
        }
      } catch (e) {
        logPrint("error fetching notification : $e }");
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


Map<String, List<Map<String, dynamic>>> groupNotificationsByUserId(
    List<Map<String, dynamic>> notificationList,
    ) {
  final groupedNotifications = <String, List<Map<String, dynamic>>>{};
  for (final notification in notificationList) {
    final userId = notification["userId"] ?? "";
    groupedNotifications[userId] = groupedNotifications[userId] ?? [];
    groupedNotifications[userId]!.add(notification);
  }
  return groupedNotifications;
}



/// firebase background message listner
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logPrint(
      "Handling a background message: ${message.messageId},${message.data}");
}
