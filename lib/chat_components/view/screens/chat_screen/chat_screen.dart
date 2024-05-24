import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/view/widgets/chat_message/date_view.dart';
import 'package:chatcomponent/chat_components/view/widgets/empty_data_view/empty_data_view.dart';
import 'package:chatcomponent/chat_components/view/widgets/loader/loader_view.dart';
import 'package:chatcomponent/chat_components/view/widgets/toast_view/toast_view.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../../../model/function_helper/date_time_convertor/date_time_convertor.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../../widgets/chat_message/file_view.dart';
import '../../widgets/chat_message/image_view.dart';
import '../../widgets/chat_message/image_zoom_view.dart';
import '../../widgets/chat_message/message_view.dart';
import '../../widgets/common_button/common_text_button.dart';
import '../../widgets/icon_button/icon_button.dart';
import '../../widgets/log_print/log_print_condition.dart';
import '../../widgets/message_box_field/message_box_field.dart';
import '../../widgets/text_chip/text_chip.dart';
import '../../widgets/user_detail_view_chat/user_details_view_chatscreen.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    ChatController controller = Get.put(ChatController());

    return Obx(() => WillPopScope(
      onWillPop: () async {
        if (controller.isAudioRecorderStart.isTrue) {
          controller.isAudioRecorderStart.value = false;
          controller.stopRecording();
          return false;
        }else if(controller.isDialogOpen.isTrue) {
          controller.isDialogOpen.value = false;
          return false;
        }else {
          return true;
        }
      }
      ,
      child: GestureDetector(
        onTap: () => controller.onScreenTap(),
        child: Scaffold(
          backgroundColor: controller.themeArguments?.colorArguments
              ?.backgroundColor ?? ChatHelpers.white,
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  controller.isError.isTrue ?
                  EmptyDataView(title: ChatHelpers.instance.errorMissingData,
                      isButton: false,
                      image: ChatHelpers.instance.somethingWentWrong)
                      : Stack(
                    children: [
                      Column(
                        children: [
                          Obx(() =>
                              UserViewChatScreen(
                                userName: controller.isUserId.isTrue
                                    ? controller.users.value.profileName ?? ""
                                    : controller.isFirstCurrent.isTrue
                                    ? controller.chatRoomModel.value.userSecond
                                    ?.userName
                                    .toString()
                                    .capitalizeFirst ?? ""
                                    : controller.chatRoomModel.value.userFirst
                                    ?.userName
                                    .toString()
                                    .capitalizeFirst ?? "",
                                userProfile: controller.isUserId.isTrue
                                    ? controller.users.value.signInType ==
                                    SignType.google.name ? (controller.users.value
                                    .profileImage ?? "") : controller
                                    .chatArguments.imageBaseUrlFirebase +
                                    (controller.users.value.profileImage ?? "")
                                    : controller.isFirstCurrent.isTrue
                                    ? controller.chatRoomModel.value.userSecond
                                    ?.userSignType == SignType.google.name
                                    ? (controller.chatRoomModel.value.userSecond
                                    ?.userProfile ?? "")
                                    : controller.chatArguments
                                    .imageBaseUrlFirebase +
                                    (controller.chatRoomModel.value.userSecond
                                        ?.userProfile ?? "")
                                    : controller.chatRoomModel.value.userFirst
                                    ?.userSignType == SignType.google.name
                                    ? (controller.chatRoomModel.value.userFirst
                                    ?.userProfile ?? "")
                                    : controller.chatArguments
                                    .imageBaseUrlFirebase +
                                    (controller.chatRoomModel.value.userFirst
                                        ?.userProfile ?? ""),
                                presence: controller.userTypingStatus.isFalse
                                    ? controller.users.value.presence ==
                                    PresenceStatus.online.name
                                    ? controller.users.value.presence
                                    ?.capitalizeFirst ?? "" : ""
                                    : PresenceStatus.typing.name
                                    .capitalizeFirst ?? "",
                                backButtonTap: () => Get.back(),
                                audioCallButtonTap: () =>
                                (controller.chatArguments.agoraAppId
                                    ?.isNotEmpty ?? false) &&
                                    controller.agoraChannelName.isNotEmpty ? Get
                                    .toNamed(ChatHelpers.outGoingScreen,
                                    arguments: CallArguments(
                                        user: controller.users.value,
                                        callType: CallType.audioCall.name,
                                        callId: "",
                                        imageBaseUrl: controller.chatArguments
                                            .imageBaseUrlFirebase,
                                        agoraAppId: controller.chatArguments
                                            .agoraAppId ?? "",
                                        agoraAppCertificate: controller
                                            .chatArguments.agoraAppCertificate ??
                                            "",
                                        userId: controller.users.value.id ?? "",
                                        currentUserId: controller.currentUser
                                            .value.id ?? "",
                                        firebaseServerKey: controller
                                            .chatArguments.firebaseServerKey,
                                        currentUser: controller.currentUser.value,
                                        agoraChannelName: controller
                                            .agoraChannelName.value,
                                        agoraToken: controller.agoraToken.value,
                                        themeArguments: controller
                                            .themeArguments)) : toastShow(
                                    massage: "Please give agora Details to use this ",
                                    error: true),
                                videoCallButtonTap: () =>
                                (controller.chatArguments.agoraAppId
                                    ?.isNotEmpty ?? false) &&
                                    controller.agoraChannelName.isNotEmpty ? Get
                                    .toNamed(ChatHelpers.outGoingScreen,
                                    arguments: CallArguments(
                                        user: controller.users.value,
                                        callType: CallType.videoCall.name,
                                        callId: "",
                                        imageBaseUrl: controller.chatArguments
                                            .imageBaseUrlFirebase,
                                        agoraAppId: controller.chatArguments
                                            .agoraAppId ?? "",
                                        agoraAppCertificate: controller
                                            .chatArguments.agoraAppCertificate ??
                                            "",
                                        userId: controller.users.value.id ?? "",
                                        currentUserId: controller.currentUser
                                            .value.id ?? "",
                                        firebaseServerKey: controller
                                            .chatArguments.firebaseServerKey,
                                        currentUser: controller.currentUser.value,
                                        agoraChannelName: controller
                                            .agoraChannelName.value,
                                        agoraToken: controller.agoraToken.value,
                                        themeArguments: controller
                                            .themeArguments)) : toastShow(
                                    massage: "Please give agora Details to use this ",
                                    error: true),
                                chatController: controller,
                              )),
                          Expanded(
                            child: Obx(() =>
                            controller.isLoadingChats.isFalse
                                ? controller.messages.isEmpty
                                ? SizedBox(
                                height: 300,
                                child: Lottie.asset(
                                    ChatHelpers.instance.hello,
                                    package: 'chatcomponent'))
                                :
                            Column(
                              children: [
                                controller.isLoadingPreviousChats.isFalse ?
                                Container(
                                  height: 80,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                                  child: Center(
                                    child: LoaderView(loaderColor: controller.themeArguments?.colorArguments?.mainColor ?? ChatHelpers.mainColor,),
                                  ),
                                ): const SizedBox(),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only( top: controller.isLoadingPreviousChats.isFalse ? ChatHelpers.marginSizeExtraSmall : 0,
                                        bottom: ChatHelpers.marginSizeExtraSmall),
                                    child: ListView(
                                      reverse: true,
                                      controller: controller.scrollController,
                                      physics: const BouncingScrollPhysics(),
                                      children: List
                                          .generate(
                                          controller.messages.length,
                                              (index) {
                                            return
                                              controller.messages[index].messageType ==
                                                  'text' ?
                                              Column(
                                                children: [
                                                  index == 0 ?
                                                  DateView(date: DateTimeConvertor
                                                      .dateTimeShowMessages(
                                                      controller.messages[index].time ??
                                                          ""))
                                                      : DateTimeConvertor
                                                      .dateTimeExt(
                                                      controller.messages[index - 1]
                                                          .time ?? "")
                                                      .day != DateTimeConvertor
                                                      .dateTimeExt(
                                                      controller.messages[index].time ??
                                                          "")
                                                      .day
                                                      ? DateView(date: DateTimeConvertor
                                                      .dateTimeShowMessages(
                                                      controller.messages[index].time ??
                                                          ""))
                                                      : const SizedBox(),
                                                  MessageView(
                                                    index: index,
                                                    chatController: controller,
                                                    onLongTap: () {
                                                      controller.selectReactionIndex
                                                          .value = index.toString();
                                                      controller.isReaction.value =
                                                      !controller.isReaction.value;
                                                    },
                                                    message: controller.messages[index]
                                                        .message ?? '',
                                                    time: DateTimeConvertor.timeExt(
                                                        controller.messages[index]
                                                            .time ?? ''),
                                                    isSender: controller.messages[index]
                                                        .sender ==
                                                        controller.currentUserId.value,
                                                    isSeen: controller.messages[index]
                                                        .isSeen ?? false,
                                                    visible: controller.messages[index]
                                                        .sender ==
                                                        controller.currentUserId.value
                                                        ? controller.messages.length -
                                                        1 == index ? true : false
                                                        : false,
                                                    isReaction: controller.isReaction
                                                        .value,
                                                    reactionList: controller.emoji,
                                                    reaction: controller.messages[index]
                                                        .reaction ?? 7,
                                                  ),
                                                ],
                                              )
                                                  : controller.messages[index].file
                                                  ?.fileType == FileTypes.image.name ?
                                              Column(
                                                children: [
                                                  index == 0 ?
                                                  DateView(date: DateTimeConvertor
                                                      .dateTimeShowMessages(
                                                      controller.messages[index].time ??
                                                          ""))
                                                      : DateTimeConvertor
                                                      .dateTimeExt(
                                                      controller.messages[index - 1]
                                                          .time ?? "")
                                                      .day != DateTimeConvertor
                                                      .dateTimeExt(
                                                      controller.messages[index].time ??
                                                          "")
                                                      .day
                                                      ? DateView(date: DateTimeConvertor
                                                      .dateTimeShowMessages(
                                                      controller.messages[index].time ??
                                                          ""))
                                                      : const SizedBox(),
                                                  ImageView(
                                                    isAdding: controller.messages[index].file?.isAdding ?? true,
                                                    imageMessage: controller.messages[index].message ?? "",
                                                    reaction: controller.messages[index]
                                                        .reaction ?? 7,
                                                    time: DateTimeConvertor.timeExt(
                                                        controller.messages[index]
                                                            .time ?? ""),
                                                    image: controller.messages[index]
                                                        .file?.fileUrl ?? '',
                                                    isSender: controller.messages[index]
                                                        .sender ==
                                                        controller.currentUserId.value,
                                                    onTap: () =>
                                                        Get.to(
                                                          ViewImageAndPlayVideoScreen(
                                                            file: controller
                                                                .messages[index].file
                                                                ?.fileUrl ??
                                                                '',
                                                            chatController: controller,
                                                          ),
                                                        ),
                                                    isSeen: controller.messages[index]
                                                        .isSeen ?? false,
                                                    isVisible: controller
                                                        .messages[index].sender ==
                                                        controller.currentUserId.value
                                                        ? controller.messages.length -
                                                        1 == index ? true : false
                                                        : false,
                                                    onLongPress: () {
                                                      controller.selectReactionIndex
                                                          .value = index.toString();
                                                      controller.isReaction.value =
                                                      !controller.isReaction.value;
                                                    },
                                                    index: index,
                                                    chatController: controller,
                                                  ),
                                                ],
                                              )
                                                  : Column(
                                                children: [
                                                  index == 0 ?
                                                  DateView(date: DateTimeConvertor
                                                      .dateTimeShowMessages(
                                                      controller.messages[index].time ??
                                                          ""))
                                                      : DateTimeConvertor
                                                      .dateTimeExt(
                                                      controller.messages[index - 1]
                                                          .time ?? "")
                                                      .day != DateTimeConvertor
                                                      .dateTimeExt(
                                                      controller.messages[index].time ??
                                                          "")
                                                      .day
                                                      ? DateView(date: DateTimeConvertor
                                                      .dateTimeShowMessages(
                                                      controller.messages[index].time ??
                                                          ""))
                                                      : const SizedBox(),
                                                  FileView(
                                                    isAdding: controller.messages[index].file?.isAdding ?? true,
                                                    reaction: controller.messages[index]
                                                        .reaction ?? 7,
                                                    isSeen: controller.messages[index]
                                                        .isSeen ??
                                                        false,
                                                    isVisible: controller
                                                        .messages[index].sender ==
                                                        controller.currentUserId.value
                                                        ? controller.messages.length -
                                                        1 == index ? true : false
                                                        : false,
                                                    onLongPress: () {
                                                      controller.selectReactionIndex
                                                          .value = index.toString();
                                                      controller.isReaction.value =
                                                      !controller.isReaction.value;
                                                    },
                                                    index: index,
                                                    chatController: controller,
                                                    time:
                                                    DateTimeConvertor.timeExt(
                                                        controller.messages[index]
                                                            .time ?? ""),
                                                    fileName: controller.messages[index]
                                                        .file?.fileName ?? '',
                                                    isSender: controller.messages[index]
                                                        .sender ==
                                                        controller.currentUserId.value,
                                                  ),
                                                ],
                                              );
                                          }
                                      )
                                          .reversed
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : const Center(
                              child: CircularProgressIndicator(),
                            )),
                          ),
                          Obx(() =>
                          controller.isLoadingChats.isFalse
                              ? controller.messages.isEmpty
                              ? Container(
                              margin: const EdgeInsets.only(left: 5),
                              height: 55,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                    controller.suggestions.length,
                                        (index) =>
                                        TextChip(
                                          message:
                                          controller.suggestions[index],
                                          tap: () =>
                                              controller.chipMessage(index),
                                        )),
                              ))
                              : const SizedBox()
                              : const SizedBox()),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Row(
                              children: [
                                MessageField(
                                  onChange: (String? value) {
                                    controller.typingStatus(true);
                                    EasyDebounce.debounce('TypingStatus',
                                        const Duration(milliseconds: 1000), () =>
                                            controller.typingStatus(false));
                                    return null;
                                  },
                                  height: 50,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.80,
                                  controller: controller.messageController,
                                  hintText: 'Enter Message',
                                  onValidators: (String? value) => null,
                                  unFocusedColor: controller.themeArguments
                                      ?.colorArguments?.messageTextFieldColor,
                                  focusedColors: controller.themeArguments
                                      ?.colorArguments?.messageTextFieldColor,
                                  focusedRadius: controller.themeArguments
                                      ?.borderRadiusArguments
                                      ?.messageTextFieldRadius,
                                  hintTextStyle: controller.themeArguments
                                      ?.styleArguments
                                      ?.messageTextFieldHintTextStyle,
                                  textStyle: controller.themeArguments
                                      ?.styleArguments?.messageTextFieldTextStyle,
                                  suffixValue: Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * .22,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        controller.chatArguments
                                            .isAttachmentSendEnable
                                            ? CircleIconButton(
                                          height: ChatHelpers
                                              .iconSizeExtraOverLarge,
                                          width: ChatHelpers
                                              .iconSizeExtraOverLarge,
                                          padding: 0,
                                          splashColor: ChatHelpers.black
                                              .withOpacity(.3),
                                          boxColor: ChatHelpers.transparent,
                                          isImage: false,
                                          colors: controller.themeArguments
                                              ?.colorArguments
                                              ?.attachmentIconColor ??
                                              ChatHelpers.textColor_4,
                                          icons: Icons.attach_file,
                                          onTap: () => controller.openDialog(),
                                        )
                                            : const SizedBox(),
                                        controller.chatArguments
                                            .isCameraImageSendEnable
                                            ? CircleIconButton(
                                          height: ChatHelpers
                                              .iconSizeExtraOverLarge,
                                          width: ChatHelpers
                                              .iconSizeExtraOverLarge,
                                          padding: 0,
                                          splashColor: ChatHelpers.black
                                              .withOpacity(.3),
                                          boxColor: ChatHelpers.transparent,
                                          isImage: false,
                                          icons: Icons.camera_alt,
                                          colors: controller.themeArguments
                                              ?.colorArguments?.cameraIconColor ??
                                              ChatHelpers.textColor_4,
                                          onTap: () =>
                                              controller.goToCameraScreen(),
                                        )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                  focus: controller.messageFocus,
                                  maxLines: 5,
                                ),
                                CircleIconButton(
                                  height: 50,
                                  width: 50,
                                  boxColor: controller.themeArguments
                                      ?.colorArguments?.mainColorLight ??
                                      ChatHelpers.mainColorLight,
                                  isImage: false,
                                  icons: Icons.send,
                                  sendBtn: controller.themeArguments
                                      ?.customWidgetsArguments
                                      ?.customSendIconButtonWidgets,
                                  colors: controller.themeArguments
                                      ?.colorArguments?.sendIconColor ??
                                      controller.themeArguments?.colorArguments
                                          ?.iconColor ?? ChatHelpers.white,
                                  onTap: () => controller.sendMessage(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: ChatHelpers.marginSizeExtraSmall,),
                          Obx(() =>
                              AnimatedOpacity(
                                opacity: controller.isDialogOpen.isTrue ? 1.0 : 0,
                                duration: const Duration(milliseconds: 500),
                                child: AnimatedContainer(
                                  height: controller.isDialogOpen.isTrue ? (controller.imageArguments?.isAudioRecorderEnable ?? false) && (controller.imageArguments?.isDocumentsSendEnable?? false) && (controller.imageArguments?.isImageFromCamera?? false) && (controller.imageArguments?.isImageFromGallery?? false) ? 160 : 90 : 0,
                                  width: controller.isDialogOpen.isTrue
                                      ? MediaQuery
                                      .of(context)
                                      .size
                                      .width
                                      : 0,
                                  padding: const EdgeInsets.all(
                                      ChatHelpers.marginSizeSmall),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(
                                          ChatHelpers.cornerRadius)),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart,
                                  child: controller.isAudioRecorderStart.isFalse ?
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      controller.imageArguments
                                          ?.isImageFromCamera ?? false ?
                                      CommonIconVBtn(
                                        // onPressed: () => controller.cameraPermission(),
                                        onPressed: () => controller.goToCameraScreen(),
                                        title: 'Camera',
                                        icons: Icons.camera_alt,
                                        height: 70,
                                        width: MediaQuery.of(context).size.width * .25,
                                        fontSize: ChatHelpers.marginSizeLarge,
                                        color: controller.themeArguments
                                            ?.colorArguments
                                            ?.attachmentCameraIconColor ??
                                            ChatHelpers.mainColorLight,
                                        iconSize: ChatHelpers.iconSizeLarge,
                                      ) : const SizedBox(),
                                      controller.imageArguments
                                          ?.isImageFromGallery ?? false ?
                                      CommonIconVBtn(
                                        onPressed: () =>
                                            controller.photoPermission(),
                                        title: 'Gallery',
                                        icons: Icons.photo_album,
                                        height: 70,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * .25,
                                        fontSize: ChatHelpers.marginSizeLarge,
                                        color: controller.themeArguments
                                            ?.colorArguments
                                            ?.attachmentGalleryIconColor ??
                                            ChatHelpers.red,
                                        iconSize: ChatHelpers.iconSizeLarge,
                                      ) : const SizedBox(),
                                      controller.imageArguments
                                          ?.isDocumentsSendEnable ?? false ?
                                      CommonIconVBtn(
                                        onPressed: () => controller.pickFile(),
                                        title: 'Documents',
                                        icons: Icons.folder,
                                        height: 70,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * .25,
                                        fontSize: ChatHelpers.marginSizeLarge,
                                        color: controller.themeArguments
                                            ?.colorArguments
                                            ?.attachmentDocumentsIconColor ??
                                            ChatHelpers.green,
                                        iconSize: ChatHelpers.iconSizeLarge,
                                      ) : const SizedBox(),
                                      controller.imageArguments
                                          ?.isAudioRecorderEnable ?? false ? CommonIconVBtn(
                                        onPressed: () {
                                          controller.isAudioRecorderStart.value = true;
                                          controller.startRecording();
                                        },
                                        title: 'Recorder',
                                        icons: Icons.mic,
                                        height: 70,
                                        width: MediaQuery.of(context).size.width * .25,
                                        fontSize: ChatHelpers.marginSizeLarge,
                                        color: controller.themeArguments
                                            ?.colorArguments
                                            ?.attachmentDocumentsIconColor ??
                                            ChatHelpers.green,
                                        iconSize: ChatHelpers.iconSizeLarge,
                                      ) : const SizedBox(),
                                    ],
                                  )
                                  : SizedBox(
                                    height: 90,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle
                                          ),
                                          height: 200,
                                            child: Lottie.asset(ChatHelpers.instance.soundEffectLottie,
                                              // package: "chatcomponent",
                                            )),
                                        CircleIconButton(onTap: () async {
                                          var value = await controller.stopRecording();
                                          logPrint("recorder stoped vlaue = : $value");
                                        }, isImage: false,icons: Icons.mic,colors: ChatHelpers.white,height: 50,width: 50,shapeRec: false,),
                                      ],
                                    ),
                                  )
                                ),
                              ))
                        ],
                      ),
                      controller.isLoading.isFalse
                          ? SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, child: Center(child: LoaderView(loaderColor: controller.themeArguments?.colorArguments?.mainColor ?? ChatHelpers.mainColor,),))
                          : const SizedBox(),
                    ],
                  ),
                ],
              )),
        ),
      ),
    ));
  }
}