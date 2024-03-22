import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:get/get.dart';
import '../chatHelper/chat_helper.dart';

/// get values form user and add to Chat Arguments to use in whole app

class ChatServices extends GetxService {
  late ChatArguments chatArguments;

  Future<ChatServices> init(
      {ImageArguments? imageArguments,
      ThemeArguments? themeArguments,
      String? agoraChannelName,
      String? agoraToken,
      bool? isVideoCallEnable,
      bool? isAudioCallEnable,
      bool? isAttachmentSendEnable,
      bool? isCameraImageSendEnable,
      String? chatRoomId,
      required String imageBaseUrlFirebase,
      String? agoraAppId,
      String? agoraAppCertificate,
      required String otherUserId,
      required String currentUserId,
      required String firebaseServerKey}) async {
    chatArguments = ChatArguments(
        chatRoomId: chatRoomId ?? ChatHelpers.instance.chatRoomId,
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        isVideoCallEnable: isVideoCallEnable ?? false,
        isAudioCallEnable: isAudioCallEnable ?? false,
        isAttachmentSendEnable: isAttachmentSendEnable ?? false,
        isCameraImageSendEnable: isCameraImageSendEnable ?? false,
        imageBaseUrlFirebase: imageBaseUrlFirebase,
        imageArguments: imageArguments,
        agoraAppId: agoraAppId,
        agoraAppCertificate: agoraAppCertificate,
        agoraChannelName: agoraChannelName,
        agoraToken: agoraToken,
        firebaseServerKey: firebaseServerKey,
        themeArguments: themeArguments);

    return this;
  }
}
