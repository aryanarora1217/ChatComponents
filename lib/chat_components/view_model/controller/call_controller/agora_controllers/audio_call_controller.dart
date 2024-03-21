import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatcomponent/chat_components/model/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../model/chatHelper/chat_helper.dart';
import '../../../../model/chat_arguments/chat_arguments.dart';
import '../../../../model/function_helper/debounce_function.dart';
import '../../../../model/models/call_model/call_model.dart';
import '../../../../model/network_services/firebase_database.dart';
import '../../../../view/widgets/log_print/log_print_condition.dart';

class AudioCallController extends GetxController {
/// agora engine variable
  RtcEngine agoraRtcEngine = createAgoraRtcEngine();
  /// user details current and other user
  // Rx<Users> currentUser = Users().obs;
  // Rx<Users> user = Users().obs;
  // final expirationInSeconds = 3600;
  // final currentTimestamp = DateTime
  //     .now()
  //     .millisecondsSinceEpoch ~/ 1000;
  RxBool localUserJoined = false.obs;
  int localUserId = 0;
  RxInt remoteUid = 0.obs;
  RxBool isMicOn=true.obs;
  RxBool isSpeakerOn=true.obs;
  RxBool isUserMicOn=true.obs;
  /// timer variables
  late Timer timer;
  RxInt start = 0.obs;

  /// call details
  CallModel callDetails = CallModel();
  // String callId = "";
  // String channelName = '';
  // String token = '';

  /// firebase methods call variable
  var firebase = FirebaseDataBase();
  /// call refernce stream
  Stream<DocumentSnapshot<Map<String, dynamic>>>? streamRef;

  /// call agruments
  late CallArguments callArguments;

  // RxString userId = "".obs;
  // RxString currentUserId ="".obs;
  // String firebaseServerKey = "";
  // RxString imageBaseUrl="".obs;
  // RxString agoraAppId="".obs;
  // String? agoraAppCertificate="";

/// timer for display time on screen
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        start++;
      },
    );
  }

/// setup agora engine for audio call
  Future<void> setupAgoraEngine() async {
    agoraRtcEngine = createAgoraRtcEngine();
    await agoraRtcEngine.initialize(RtcEngineContext(
        appId: callArguments.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting));
    agoraRtcEngine.registerEventHandler(getEventHandler());
    await agoraRtcEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await agoraRtcEngine.enableAudio();
  }

  /// mic on off on click
  void onMicTap(){
    if(isMicOn.isTrue){
      isMicOn.value = false;
      agoraRtcEngine.disableAudio();
    }else{
      isMicOn.value = true;
      agoraRtcEngine.enableAudio();
    }
  }

  /// fetch user details
  // Future<void> fetchUsers() async {
  //   callArguments.currentUser = await firebase.fetchUser(callDetails.receiverId??"") ?? Users();
  //   callArguments.user = (callDetails.callerId == currentUser.value.id ?  await firebase.fetchUser(callDetails.receiverId??"") : await firebase.fetchUser(callDetails.callerId??"")) ?? Users();
  //   logPrint("user joined details");
  //   logPrint(user.value.id);
  // }

  /// fetch call details functions
  fetchCallDetails() async {
    try{
      streamRef = firebase.callReferenceById(callArguments.callId).snapshots();
      DocumentReference<Map<String, dynamic>> reference = firebase.callReferenceById(callArguments.callId);
      await reference.get().then((value) {
        callDetails = CallModel.fromJson(value.data()??{});
        // fetchUsers();
        logPrint("user details in call");
        logPrint(callArguments.currentUser);
        logPrint(callArguments.user);
      });
      await streamListener();
      logPrint(callDetails.callStatus);
      callDetails.callStatus = CallStatus.running.name;
      firebase.updateCallStatus(callDetails);
    }catch(e){
      logPrint("Error fetch call details : $e");
    }
  }

/// speaker on off functions
  void onSpeakerTap(){
    if(isSpeakerOn.isTrue){
      isSpeakerOn.value = false;
      agoraRtcEngine.muteAllRemoteAudioStreams(true);
    }else{
      isSpeakerOn.value = true;
      agoraRtcEngine.muteAllRemoteAudioStreams(false);
    }
  }

  /// agora rtc event handler function
  RtcEngineEventHandler getEventHandler() {
    return RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          logPrint("local user ${connection.localUid} joined");

          localUserJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          logPrint("remote user $remoteUid joined");
          startTimer();
          remoteUid.value = uid;
        },
        onUserOffline: (RtcConnection connection, int uid,
            UserOfflineReasonType reason) {
          logPrint("remote user $remoteUid left channel");
          remoteUid.value = 0;
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          logPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
        onUserMuteAudio: (RtcConnection connection, int remoteUid, bool muted){
          logPrint("remote user $remoteUid , $muted muted the audio");
          isUserMicOn.value = muted;
        },
    );
  }

  /// initlaize agora engine
  Future<void> agoraInit() async {
    try {
      await [Permission.microphone, Permission.camera].request();
      await setupAgoraEngine();
      await agoraRtcEngine.isSpeakerphoneEnabled();
      logPrint("tokens is");
      logPrint(callArguments.agoraToken);
      await agoraRtcEngine.joinChannel(options: const ChannelMediaOptions(), token: callArguments.agoraToken, channelId: callArguments.agoraChannelName, uid: 0);
    } catch (e) {
      logPrint("error agora room : $e");
    }
  }

  /// init method
  @override
  void onInit() {
    /// call arguments adding value to variables
    callArguments = Get.arguments;

    // user.value = callArguments.user;
    // callId = callArguments.callId;
    // userId.value = callArguments.userId;
    // currentUserId.value = callArguments.currentUserId;
    // currentUser.value = callArguments.currentUser;
    // firebaseServerKey = callArguments.firebaseServerKey;
    // imageBaseUrl.value = callArguments.imageBaseUrl;
    // agoraAppId.value = callArguments.agoraAppId;
    // agoraAppCertificate = callArguments.agoraAppCertificate;
    // channelName = callArguments.agoraChannelName;
    // token = callArguments.agoraToken;

    isMicOn.value = callArguments.isMicOn??false;

    /// fetch call details method call
    fetchCallDetails();
    /// inilaize agora call
    agoraInit();
    super.onInit();
  }

  /// call refrence listner
  Future<void> streamListener() async {
    streamRef?.listen((event) {
      logPrint("event ");
      callDetails = CallModel.fromJson(event.data() ?? {});
      if (callDetails.callStatus == CallStatus.ended.name) {
        endCall(false);
        DebounceHelper.instance.debounceFunction(
            onDebounceCall: () => Get.back(),
            duration: const Duration(milliseconds: 200));
      }
    });
  }

  /// dipose or close method controller
  @override
  void onClose() {
    logPrint(" close dispose");
    super.onClose();
  }

  /// endcall method
  Future<void> endCall(bool isClose) async {
    await agoraRtcEngine.leaveChannel();
    await agoraRtcEngine.release();
    if(callDetails.callStatus != CallStatus.ended.name){
      callDetails.callTimeOn = start.toString();
      callDetails.callStatus = CallStatus.ended.name;
      logPrint(callDetails.callStatus);
      logPrint(callDetails.callId);
      await firebase.updateCallStatus(callDetails);
    }
  }

}
