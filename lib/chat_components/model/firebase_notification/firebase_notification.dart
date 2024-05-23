import 'dart:convert';
import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/model/services/chat_services.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:chatcomponent/chat_components/view_model/local_storage_manager/notification_store/notification_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

    /// flutter local notification plugin intilaize for both android snd ios


    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();
    fltNotification = FlutterLocalNotificationsPlugin();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    List<Map<String,String>> recentNotificationList = [];

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;

    await fltNotification.pendingNotificationRequests();



    // var androidDetailsChannel = AndroidNotificationChannelGroup(
    //     appName, appName,);
    //
    //
    //
    // await fltNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannelGroup(androidDetailsChannel);
    //
    // const List<String> lines = <String>[
    //   'Alex Faarborg  Check this out',
    //   'Jeff Chang    Launch Party'
    // ];
    //
    // const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
    //     lines,
    //     contentTitle: '2 messages',
    //     summaryText: 'janedoe@example.com');

    var androidDetails = AndroidNotificationDetails(
      appName,
      appName,
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      // groupKey: packageName,
      // groupAlertBehavior: GroupAlertBehavior.all,
      // setAsGroupSummary: true,
      onlyAlertOnce: false,
    );

    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    var androiInit = const AndroidInitializationSettings('logo');
    var iosInit = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    fltNotification.initialize(initSetting,
        onSelectNotification: (String? payload) {
          // if (payload != null) {
          //   Get.toNamed(ChatHelpers.chatScreen, arguments: {
          //     ChatHelpers.instance.chatRoomId: payload,
          //     ChatHelpers.instance.userId:
          //     ChatHelpers.instance.userId
          //   });
          // }
        });

    /// notification listner form firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          String isMessage = message.data[ChatHelpers.instance.isMessage];
          userDetails  = Users.fromJson(jsonDecode(message.data[ChatHelpers.instance.userDetails]));
      otherUserDetails = Users.fromJson(jsonDecode(message.data[ChatHelpers.instance.otherUserDetails]));
          if (isMessage == "true") {
            chatRoomID = message.data[ChatHelpers.instance.chatRoomId];
            chatRoomModel = await fetchChatroomDetails(chatRoomID);
            // if (chatRoomModel.userFirstId == userDetails.id) {
            //   try{
            //     recentNotificationList = await NotificationLocalStoreManger.getNotificationList(userDetails.id??"");
            //   }catch(e){
            //     logPrint("error fetching recent list : $e");
            //   }
            //
            //   if(recentNotificationList.isEmpty){
            //     recentNotificationList.add({"messageId": chatRoomModel.recentMessage?.id??"","message" : (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "" });
            //     /// show message notifications
            //     fltNotification.show(ChatHelpers.instance.removeCharFromStringToInt(userDetails.id??""), userDetails.profileName, (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "", generalNotificationDetails, payload: chatRoomID);
            //     // }
            //     NotificationLocalStoreManger.setNotificationList(userId: userDetails.id??"", recentMessageList: recentNotificationList);
            //   }else{
            //     recentNotificationList.add({"messageId": chatRoomModel.recentMessage?.id??"","message" : (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "" });
            //     NotificationLocalStoreManger.setNotificationList(userId: userDetails.id??"", recentMessageList: recentNotificationList);
            //     Map<String, dynamic> data = {"title":userDetails.id??"","body":(chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file"),"messages":recentNotificationList};
            //     handleInboxStyleNotification(data,appName);
            //   }
            // }
            // else {
            //   // if (chatRoomModel.userSecond?.userActiveStatus == false || chatRoomModel.userSecond?.userActiveStatus == null) {
            //     /// show message notification for messages
            //   try{
            //     recentNotificationList = await NotificationLocalStoreManger.getNotificationList(userDetails.id??"");
            //   }catch(e){
            //     logPrint("error fetching recent list : $e");
            //   }
            //
            //   if(recentNotificationList.isEmpty){
            //     recentNotificationList.add({"messageId": chatRoomModel.recentMessage?.id??"","message" : (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "" });
            //     /// show message notifications
            //     fltNotification.show(ChatHelpers.instance.removeCharFromStringToInt(userDetails.id??""), userDetails.profileName, (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "", generalNotificationDetails, payload: chatRoomID);
            //     // }
            //     NotificationLocalStoreManger.setNotificationList(userId: userDetails.id??"", recentMessageList: recentNotificationList);
            //   }else{
            //     recentNotificationList.add({"messageId": chatRoomModel.recentMessage?.id??"","message" : (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "" });
            //     NotificationLocalStoreManger.setNotificationList(userId: userDetails.id??"", recentMessageList: recentNotificationList);
            //     Map<String, dynamic> data = {"title":userDetails.id??"","body":(chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file"),"messages":recentNotificationList};
            //     handleInboxStyleNotification(data,appName);
            //   }
            //   // }
            // }
            logPrint("notification deatils : current user ${otherUserDetails.toJson()} , sender  ${userDetails.toJson()}");

            try{
              recentNotificationList = await NotificationLocalStoreManger.getNotificationList(userDetails.id??"");
            }catch(e){
              logPrint("error fetching recent list : $e");
            }

            logPrint(" recent message lsit : ${recentNotificationList.length}");

            if(recentNotificationList.isEmpty){
              recentNotificationList.add({"userId":userDetails.id ?? "","messageId": chatRoomModel.recentMessage?.id??"","message" : (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "" });
              /// show message notifications
              fltNotification.show(ChatHelpers.instance.removeCharFromStringToInt(userDetails.id??""), userDetails.profileName, (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "", generalNotificationDetails, payload: chatRoomID);
              // }
              NotificationLocalStoreManger.setNotificationList(userId: otherUserDetails.id??"", recentMessageList: recentNotificationList);
            }else{
              if(recentNotificationList.first["userId"] == userDetails.id)
                {
                  recentNotificationList.add({"userId":userDetails.id ?? "","messageId": chatRoomModel.recentMessage?.id??"","message" : (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "" });
              NotificationLocalStoreManger.setNotificationList(userId: otherUserDetails.id??"", recentMessageList: recentNotificationList);
              Map<String, dynamic> data = {"title":userDetails.id??"","body":(chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file"),"messages":recentNotificationList};
              handleInboxStyleNotification(data,appName,packageName);
                }else {
                logPrint("notification received form diffrent user ");
              }
            }
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

  void handleInboxStyleNotification(Map<String, dynamic> data,String appName,String packageName) {
    // const List<String> lines = <String>[
    //   'Alex Faarborg  Check this out',
    //   'Jeff Chang    Launch Party'
    // ];
    //

    // Extract notification data (title, body, messages for inbox style)
    List<Map<String,String>> recentMessagesList = data['messages']?? [] as List<Map<String,String>>;
    List<String> messageList = recentMessagesList.map((e) => e["message"]??"").toList();

    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        messageList,
        contentTitle: " ${messageList.length} messages received from ${userDetails.profileName} ",
        summaryText: userDetails.profileName);

    var androidDetails = AndroidNotificationDetails(
      appName,
      appName,
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: inboxStyleInformation,
      groupKey: packageName + userDetails.id.toString(),
      // groupAlertBehavior: GroupAlertBehavior.all,
      // setAsGroupSummary: true,
      // onlyAlertOnce: false,
    );

    // Generate a platform-specific notification
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Use a notification provider to show the notification (e.g., flutter_local_notifications)
    fltNotification.show(ChatHelpers.instance.removeCharFromStringToInt(userDetails.id??""), userDetails.profileName, (chatRoomModel.recentMessage?.messageType == MessageType.text.name ? chatRoomModel.recentMessage?.message : chatRoomModel.recentMessage?.file?.fileType == FileTypes.image.name ? chatRoomModel.recentMessage?.sender == userDetails.id ? "send image" : "Receive image" : chatRoomModel.recentMessage?.sender == userDetails.id ? "send file" : "Receive file") ?? "", generalNotificationDetails, payload: chatRoomID);
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
