import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:get/get.dart';

/// get values form user and add to Chat Arguments to use in whole app

class ChatServices extends GetxService {

  late ChatArguments chatArguments;

  Future<ChatServices> init({
    ImageArguments? imageArguments,
    ThemeArguments? themeArguments,
    bool? isVideoCallEnable,
    bool? isAudioCallEnable,
    bool? isAttachmentSendEnable,
    bool? isCameraImageSendEnable,
    String? chatRoomId,
    required String imageBaseUrlFirebase,
    String? agoraAppId,
    String? agoraAppCertificate,
    List<String>? suggestionsMessages,
    List<String>? reactionsEmojisIcons,
    required String firebaseServerKey,
  }) async {
    chatArguments = ChatArguments(
        isVideoCallEnable: isVideoCallEnable ?? false,
        isAudioCallEnable: isAudioCallEnable ?? false,
        isAttachmentSendEnable: isAttachmentSendEnable ?? false,
        isCameraImageSendEnable: isCameraImageSendEnable ?? false,
        imageBaseUrlFirebase: imageBaseUrlFirebase,
        imageArguments: imageArguments,
        agoraAppId: agoraAppId,
        suggestionsMessages: suggestionsMessages,
        reactionsEmojisIcons: reactionsEmojisIcons,
        agoraAppCertificate: agoraAppCertificate,
        firebaseServerKey: firebaseServerKey,
        themeArguments: themeArguments);

    return this;
  }
}
