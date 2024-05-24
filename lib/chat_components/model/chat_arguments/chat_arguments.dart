import 'package:chatcomponent/chat_components/model/models/user_model/user_model.dart';
import 'package:flutter/material.dart';

/// Chat screen Arguments
class ChatArguments {
  String firebaseServerKey;
  String imageBaseUrlFirebase;
  String? agoraAppId;
  String? agoraAppCertificate;
  bool isVideoCallEnable;
  bool isAudioCallEnable;
  bool isAttachmentSendEnable;
  ImageArguments? imageArguments;
  ThemeArguments? themeArguments;
  bool isCameraImageSendEnable;
  List<String>? suggestionsMessages;
  List<String>? reactionsEmojisIcons;

  ChatArguments(
      {this.imageArguments,
      this.themeArguments,
      this.suggestionsMessages,
      this.reactionsEmojisIcons,
      required this.isVideoCallEnable,
      required this.isAudioCallEnable,
      required this.isAttachmentSendEnable,
      required this.isCameraImageSendEnable,
      required this.imageBaseUrlFirebase,
      required this.agoraAppId,
      required this.agoraAppCertificate,
      required this.firebaseServerKey});
}

/// Image send able Arguments
class ImageArguments {
  final bool? isImageFromGallery;
  final bool? isImageFromCamera;
  final bool? isDocumentsSendEnable;
  final bool? isAudioRecorderEnable;

  ImageArguments({
    this.isAudioRecorderEnable = false,
    this.isImageFromGallery = false,
    this.isImageFromCamera = false,
    this.isDocumentsSendEnable = false,
  });
}

/// theme Arguments
class ThemeArguments {
  final ColorArguments? colorArguments;
  final StyleArguments? styleArguments;
  final BorderRadiusArguments? borderRadiusArguments;
  final CustomWidgetsArguments? customWidgetsArguments;

  ThemeArguments(
      {this.colorArguments,
      this.styleArguments,
      this.borderRadiusArguments,
      this.customWidgetsArguments});
}

/// Color change for app theme Arguments
class ColorArguments {
  final Color? mainColor;
  final Color? mainColorLight;
  final Color? textColor;
  final Color? appBarNameTextColor;
  final Color? appBarPresenceTextColor;
  final Color? senderMessageTextColor;
  final Color? receiverMessageTextColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? sendIconColor;
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
  final Color? callButtonsBackgroundColors;
  final Color? backButtonIconColor;
  final Color? reactionViewBoxColor;
  final Color? reactionBoxColor;
  final Color? messageTextFieldColor;
  final Color? tickSeenColor;
  final Color? tickUnSeenColor;

  ColorArguments(
      {this.tickSeenColor,
      this.tickUnSeenColor,
      this.messageTextFieldColor,
      this.iconColor,
      this.sendIconColor,
      this.reactionViewBoxColor,
      this.reactionBoxColor,
      this.appBarNameTextColor,
      this.appBarPresenceTextColor,
      this.senderMessageTextColor,
      this.receiverMessageTextColor,
      this.attachmentIconColor,
      this.cameraIconColor,
      this.audioCallIconColor,
      this.videoCallIconColor,
      this.backButtonIconColor,
      this.attachmentCameraIconColor,
      this.attachmentGalleryIconColor,
      this.attachmentDocumentsIconColor,
      this.senderMessageBoxColor,
      this.receiverMessageBoxColor,
      this.buttonColor,
      this.mainColor,
      this.mainColorLight,
      this.textColor,
      this.backgroundColor,
      this.callButtonsBackgroundColors});
}

/// style changes for app theme Arguments
class StyleArguments {
  final TextStyle? appbarNameStyle;
  final TextStyle? appbarPresenceStyle;
  final TextStyle? messageTextStyle;
  final TextStyle? messageTextFieldHintTextStyle;
  final TextStyle? messageTextFieldTextStyle;
  final TextStyle? messagesTimeTextStyle;
  final TextStyle? callNameTextStyles;

  StyleArguments(
      {this.messageTextFieldHintTextStyle,
      this.messageTextFieldTextStyle,
      this.appbarNameStyle,
      this.appbarPresenceStyle,
      this.callNameTextStyles,
      this.messageTextStyle,
      this.messagesTimeTextStyle});
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
  final Widget? customSendIconButtonWidgets;

  CustomWidgetsArguments({this.customSendIconButtonWidgets});
}

/// Call screen Arguments
class CallArguments {
  String userId;
  Users user;
  Users currentUser;
  String currentUserId;
  String callType;
  String callId;
  String firebaseServerKey;
  String imageBaseUrl;
  String agoraAppId;
  String agoraChannelName;
  String agoraToken;
  String agoraAppCertificate;
  bool? isMicOn;
  ThemeArguments? themeArguments;

  CallArguments(
      {required this.agoraChannelName,
      required this.agoraToken,
      this.isMicOn,
      this.themeArguments,
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
