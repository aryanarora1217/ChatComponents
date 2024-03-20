
import 'package:chatcomponent/chat_components/model/models/user_model/user_model.dart';
import 'package:flutter/cupertino.dart';

/// Chat screen Arguments
class ChatArguments {
  final String userId;
  final String currentUserId;
  final String chatRoomId;
  final String firebaseServerKey;
  final String imageBaseUrl;
  final String? agoraAppId;
  final String? agoraChannelName;
  final String? agoraToken;
  final String? agoraAppCertificate;
  final bool isVideoCallEnable;
  final bool isAudioCallEnable;
  final bool isAttachmentSendEnable;
  final ImageArguments? imageArguments;
  final ThemeArguments? themeArguments;
  final bool isCameraImageSendEnable;

  ChatArguments(
      {this.imageArguments,
        this.themeArguments,
      this.agoraChannelName,
      this.agoraToken,
      required this.isVideoCallEnable,
      required this.isAudioCallEnable,
      required this.isAttachmentSendEnable,
      required this.isCameraImageSendEnable,
      required this.chatRoomId,
      required this.imageBaseUrl,
      required this.agoraAppId,
      required this.agoraAppCertificate,
      required this.userId,
      required this.currentUserId,
      required this.firebaseServerKey});
}

/// Image send able Arguments
class ImageArguments {
  final bool isImageFromGallery;
  final bool isImageFromCamera;
  final bool isDocumentsSendEnable;

  ImageArguments({
    required this.isImageFromGallery,
    required this.isImageFromCamera,
    required this.isDocumentsSendEnable,
  });
}

/// theme Arguments
class ThemeArguments {
  final ColorArguments? colorArguments;
  final StyleArguments? styleArguments;
  final BorderRadiusArguments? borderRadiusArguments;
  final CustomWidgetsArguments? customWidgetsArguments;

  ThemeArguments(
      this.colorArguments, this.styleArguments, this.borderRadiusArguments, this.customWidgetsArguments);
}

/// Color change for app theme Arguments
class ColorArguments {
  final Color? mainColor;
  final Color? mainColorLight;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? attachmentIconColor;
  final Color? cameraIconColor;
  final Color? audioCallIconColor;
  final Color? videoCallIconColor;
  final Color? attachmentCameraIconColor;
  final Color? attachmentGalleryIconColor;
  final Color? attachmentDocumentsIconColor;
  final Color? senderMessageBoxColor;
  final Color? receiverMessageBoxColor;
  final Color? buttonColor;

  ColorArguments(
      {this.iconColor,
      this.attachmentIconColor,
      this.cameraIconColor,
      this.audioCallIconColor,
      this.videoCallIconColor,
      this.attachmentCameraIconColor,
      this.attachmentGalleryIconColor,
      this.attachmentDocumentsIconColor,
      this.senderMessageBoxColor,
      this.receiverMessageBoxColor,
      this.buttonColor,
      this.mainColor,
      this.mainColorLight,
      this.textColor,
      this.backgroundColor});
}

/// style changes for app theme Arguments
class StyleArguments {
  final TextStyle? appbarNameStyle;
  final TextStyle? appbarPresenceStyle;
  final TextStyle? messageTextStyle;
  final TextStyle? messagesTimeTextStyle;
  final TextStyle? textStyles;

  StyleArguments(
      {this.appbarNameStyle,
      this.appbarPresenceStyle,
      this.messageTextStyle,
      this.messagesTimeTextStyle,
      this.textStyles});
}

/// border Radius  changes for app  theme Arguments
class BorderRadiusArguments {
  final double? messageTextFieldRadius;
  final double? messageBoxSenderTopLeftRadius;
  final double? messageBoxSenderTopRightRadius;
  final double? messageBoxSenderBottomRightRadius;
  final double? messageBoxSenderBottomLeftRadius;
  final double? messageBoxReceiverTopLeftRadius;
  final double? messageBoxReceiverTopRightRadius;
  final double? messageBoxReceiverBottomRightRadius;
  final double? messageBoxReceiverBottomLeftRadius;
  final double? sendButtonRadius;
  final double? iconButtonsRadius;
  final double? reactionBoxRadius;

  BorderRadiusArguments(
      {this.reactionBoxRadius,
      this.messageTextFieldRadius,
      this.messageBoxSenderTopLeftRadius,
      this.messageBoxSenderTopRightRadius,
      this.messageBoxSenderBottomRightRadius,
      this.messageBoxSenderBottomLeftRadius,
      this.messageBoxReceiverTopLeftRadius,
      this.messageBoxReceiverTopRightRadius,
      this.messageBoxReceiverBottomRightRadius,
      this.messageBoxReceiverBottomLeftRadius,
      this.sendButtonRadius,
      this.iconButtonsRadius});
}

/// custom Widget changes for app theme Arguments 
class CustomWidgetsArguments {
  final Widget customIconButtonWidgets;
  final Widget customSendIconButtonWidgets;

  CustomWidgetsArguments(
      this.customIconButtonWidgets, this.customSendIconButtonWidgets);
}

/// Call screen Arguments
class CallArguments {
  final String userId;
  final Users user;
  final Users currentUser;
  final String currentUserId;
  final String callType;
  final String callId;
  final String firebaseServerKey;
  final String imageBaseUrl;
  final String agoraAppId;
  final String agoraChannelName;
  final String agoraToken;
  final String agoraAppCertificate;
  final bool? isMicOn;

  CallArguments(
      {required this.agoraChannelName,
      required this.agoraToken,
      this.isMicOn,
      required this.user,
      required this.currentUser,
      required this.callType,
      required this.callId,
      required this.imageBaseUrl,
      required this.agoraAppId,
      required this.agoraAppCertificate,
      required this.userId,
      required this.currentUserId,
      required this.firebaseServerKey});
}
