import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/model/services/chat_services.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        otherUserId: "BdHleEqAmaVLcB1b60xoYU5ET6N2",
        currentUserId: "4BOKnOShPIe8JeeyZZbxRaufM3h1",
        imageBaseUrlFirebase:
            'https://firebasestorage.googleapis.com/v0/b/chatcomponents.appspot.com',
        firebaseServerKey:
            'AAAA45SJcD8:APA91bEXoiP3PLnWsajOYz_PojFSu2AJAnbLJg2iqA3qCzSQDkw6qQw9vsMZoTdsQCo1ZQ8P0g4ALl6OauERl-qXghfK7qyk-Cbke5fnaW-HdfGKSm7kOkydH2LIobJfP2oABA1B0SE-',
        imageArguments: ImageArguments(isImageFromCamera: true),
        isAttachmentSendEnable: true,
        isAudioCallEnable: true,
      ));
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
          onPressed: () => Get.toNamed(
            ChatHelpers.chatScreen,
          ),
          child: const Text(
            'Chat Screen',
            style: TextStyle(color: ChatHelpers.white),
          ),
        ),
      ),
    );
  }
}
