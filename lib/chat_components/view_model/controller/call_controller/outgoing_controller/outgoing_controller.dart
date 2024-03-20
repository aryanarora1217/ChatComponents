import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../model/chatHelper/chat_helper.dart';
import '../../../../model/firebase_notification/firebase_notification.dart';
import '../../../../model/function_helper/debounce_function.dart';
import '../../../../model/models/call_model/call_model.dart';
import '../../../../model/models/message_model/message_model.dart';
import '../../../../model/models/user_model/user_model.dart';
import '../../../../model/network_services/firebase_database.dart';
import '../../../../model/randomkey/randomkey.dart';
import '../../../../view/widgets/log_print/log_print_condition.dart';

class OutGoingController extends GetxController {
  /// user details of current and other user
  Rx<Users> userDetails = Users().obs;
  Rx<Users> currentUser = Users().obs;
  /// call details
  String callType = "";
  String callId = "";
  Rx<CallModel> callDetails = CallModel().obs;
  RxBool isIncoming = false.obs;
  RxBool isMicOn = true.obs;
  RxBool isSpeakerOn = false.obs;
  RxBool isCameraRear = false.obs;
  RxString isStatus = "".obs;
  /// camera state for video visble on screen in video call
  late CameraState cameraState;
  /// firebase databse class variable
  var firebase = FirebaseDataBase();
  /// firebase notification variable
  FirebaseNotification firebaseNotification = FirebaseNotification();

  /// stream reference variable for listner
  Stream<DocumentSnapshot<Map<String, dynamic>>>? streamRef;

  /// audioplayer variable  for audio play when screen opens
  final player = AudioPlayer();


  /// end call on tap
  Future<void> onEndCall() async {
    logPrint(callDetails.value.callId);
    callDetails.value.callStatus =
        isIncoming.isTrue ? CallStatus.rejected.name : CallStatus.ended.name;
    await firebase.updateCallStatus(callDetails.value);
  }

  /// on off mic onClick
  void onMicTap() {
    isMicOn.value = !isMicOn.value;
  }

  /// speaker on off Onclick
  void onSpeakerTap() {
    isSpeakerOn.value = !isSpeakerOn.value;
  }

  /// camera switch on click
  void onCameraSwitchTap(CameraState state) {
    isCameraRear.value = !isCameraRear.value;
    state.switchCameraSensor(
      aspectRatio: state.sensorConfig.aspectRatio,
    );
    logPrint(isCameraRear.value);
  }

  /// send notification to user for call
  Future<void> sendInvite() async {
    String id = getRandomString();
    callId = callId;
    callDetails.value = CallModel(
        callerId: currentUserId.value,
        callId: id,
        receiverId: userDetails.value.id,
        callType: callType,
        callStatus: CallStatus.calling.name,
        callTimeStamp: DateTime.now().toUtc().toString(),
      callMembers: [userDetails.value.id,currentUserId.value]
    );
    await firebaseNotification.sendNotification(callType,
        currentUser.value,
        userDetails.value.deviceToken ?? "",
        callDetails.value,false,MessageModel(),"",firebaseServerKey,userDetails.value);
  }

  /// ans call on click
  Future<void> ansCall() async {
    callDetails.value.callStatus = CallStatus.accepted.name;
    logPrint(callDetails.value.callStatus);
    logPrint(callDetails.value.callId);
    await firebase.updateCallStatus(callDetails.value);
    logPrint(callDetails.value.callId);
  }


  /// stream listner for call model
  void streamListener() {
    streamRef?.listen((event) async {
      callDetails.value = CallModel.fromJson(event.data() ?? {});
      if (isIncoming.isTrue && callDetails.value.callStatus == CallStatus.calling.name) {
        callDetails.value.callStatus = CallStatus.ringing.name;
        logPrint(callDetails.value.callStatus);
        logPrint(callDetails.value.callId);
        await firebase.updateCallStatus(callDetails.value);
      }
      if (callDetails.value.callStatus == CallStatus.rejected.name || callDetails.value.callStatus == CallStatus.ended.name) {
        logPrint("eneded or rejecteds");
        logPrint(callDetails.value.callId);
        DebounceHelper.instance.debounceFunction(onDebounceCall: () => Get.back(), duration: const Duration(milliseconds: 500));
      } else if (callDetails.value.callStatus == CallStatus.accepted.name) {
        logPrint(callDetails.value.callId);
        DebounceHelper.instance.debounceFunction(
            onDebounceCall: () => callDetails.value.callType == CallType.audioCall.name

                ? Get.offAndToNamed(ChatHelpers.audioCall,
              arguments: CallArguments(isMicOn: isMicOn.value, callId: callDetails.value.callId ?? "",callType: callType,currentUser: currentUser.value,currentUserId: currentUserId.value,user: userDetails.value,userId: userId.value,firebaseServerKey: firebaseServerKey,agoraAppCertificate: agoraAppCertificate,agoraAppId: agoraAppId.value, imageBaseUrl: imageBaseUrl.value,agoraChannelName: 'demoRoom', agoraToken: '007eJxTYJjwwlJKyr5oy0qjfLX0f7deXvF3z5IU/rJe5dihFfkHvrQoMKQmWhibGpsbGZgZppiYJFsmWVqmpCQaWaaZWSQZJFpaMuT9TG0IZGQ44lHHzMgAgSA+B0NKam5+UH5+LgMDAPphIa4='))

                : Get.offAndToNamed(ChatHelpers.videoCall,
                arguments: CallArguments(isMicOn: isMicOn.value, callId: callDetails.value.callId ?? "",callType: callType,currentUser: currentUser.value,currentUserId: currentUserId.value,user: userDetails.value,userId: userId.value,firebaseServerKey: firebaseServerKey,agoraAppCertificate: agoraAppCertificate,agoraAppId: agoraAppId.value, imageBaseUrl: imageBaseUrl.value,agoraChannelName: 'demoRoom', agoraToken: '007eJxTYJjwwlJKyr5oy0qjfLX0f7deXvF3z5IU/rJe5dihFfkHvrQoMKQmWhibGpsbGZgZppiYJFsmWVqmpCQaWaaZWSQZJFpaMuT9TG0IZGQ44lHHzMgAgSA+B0NKam5+UH5+LgMDAPphIa4=')
            ),
            duration: const Duration(milliseconds: 500));
      }
    });
  }


/// dispose outgoing controller
  @override
  void dispose() {
    playerStop();
    super.dispose();
  }

  /// close or dispose outgoing controller
  @override
  void onClose() async {
    logPrint("OutGoingController dismissed");
    playerStop();
    super.onClose();
  }

  /// background sound stop
  Future<void> playerStop() async {
    await player.stop();
  }

  /// call agruments variables
  late CallArguments callArguments;

  RxString userId = "".obs;
  RxString currentUserId ="".obs;
  String firebaseServerKey = "";
  RxString imageBaseUrl="".obs;
  RxString agoraAppId="".obs;
  String agoraAppCertificate="";

  /// call in init method
  Future<void> initServices() async {
    try {
      /// call arguments
      callArguments = Get.arguments;

      userDetails.value = callArguments.user;
      callType = callArguments.callType;
      callId = callArguments.callId;
      userId.value = callArguments.userId;
      currentUserId.value = callArguments.currentUserId;
      currentUser.value = callArguments.currentUser;
      firebaseServerKey = callArguments.firebaseServerKey;
      imageBaseUrl.value = callArguments.imageBaseUrl;
      agoraAppId.value = callArguments.agoraAppId;
      agoraAppCertificate = callArguments.agoraAppCertificate;

/// play sound when screen open
      await player.setAsset(ChatHelpers.instance.ringingSound);
      player.play();
      player.setLoopMode(LoopMode.all);

      /// check if call is incoming or outgoing
      if (callId != "") {
        isIncoming.value = true;
        logPrint("Incoming calling ${isIncoming.value}");
        streamRef = firebase.callReferenceById(callId).snapshots();
      } else {
        isIncoming.value = false;
        logPrint("Incoming calling ${isIncoming.value}");
        sendInvite();
        streamRef =
            firebase.callReferenceById(callDetails.value.callId ?? "").snapshots();
      }
      /// call stream listner of call database
      streamListener();
    } catch (e) {
      logPrint("Error in Calling Screen : $e");
    }
  }

  /// init method
  @override
  void onInit() {
    initServices();
    super.onInit();
  }
}
