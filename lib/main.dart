import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/model/services/chat_services.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'chat_components/model/chatHelper/chat_helper.dart';
import 'chat_components/model/firebase_notification/firebase_notification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Firebase.initializeApp();
  await FirebaseNotification().initMessaging();
  runChatServices();
  await FirebaseMessaging.instance
      .getToken()
      .then((value) => logPrint("firebase token : ${value.toString()}"));

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

Future<void> runChatServices() async {
  Get.putAsync(() => ChatServices().init(
          imageBaseUrlFirebase: 'https://firebasestorage.googleapis.com/v0/b/chatcomponents.appspot.com',
          firebaseServerKey: 'AAAA45SJcD8:APA91bEXoiP3PLnWsajOYz_PojFSu2AJAnbLJg2iqA3qCzSQDkw6qQw9vsMZoTdsQCo1ZQ8P0g4ALl6OauERl-qXghfK7qyk-Cbke5fnaW-HdfGKSm7kOkydH2LIobJfP2oABA1B0SE-',
          imageArguments: ImageArguments(isImageFromCamera: true,isDocumentsSendEnable: true),
          isAttachmentSendEnable: true,
          isAudioCallEnable: true,
          agoraAppId: "ea835372061d44c9b99dda29f68b0a99",
          agoraAppCertificate: "70354931b78c4ea08efe43d520c6548d",
          suggestionsMessages: [
            'hello',
            "Whats",
            'Hey there',
            'how are you',
            'What are you doing',
            "What's up"
          ]));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      getPages: getPages,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ChatHelpers.mainColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ChatHelpers.white,
      child: Center(
        child: MaterialButton(
          color: ChatHelpers.mainColor,
          onPressed: () => ChatHelpers.instance.chatScreenNavigation(
              otherUserID: "4BOKnOShPIe8JeeyZZbxRaufM3h1",
              currentUserID: "BdHleEqAmaVLcB1b60xoYU5ET6N2",
              agoraChannelName: "DemoRoom",
              agoraToken: "007eJxTYLCvrVOZVLHT+tv/5fP6P34rv2VT09/NfiPsmoX72icveBwVGFITLYxNjc2NDMwMU0xMki2TLC1TUhKNLNPMLJIMEi0tTT9rpjUEMjJIz7jHysgAgSA+B4NLam5+UH5+LgMDAGY8IoE="),
          child: const Text(
            'Chat Screen',
            style: TextStyle(color: ChatHelpers.white),
          ),
        ),
      ),
    );
  }
}
