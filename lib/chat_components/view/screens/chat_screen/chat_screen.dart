import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
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
import '../../widgets/message_box_field/message_box_field.dart';
import '../../widgets/text_chip/text_chip.dart';
import '../../widgets/user_detail_view_chat/user_details_view_chatscreen.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.put(ChatController());

    return GestureDetector(
      onTap: () {
        controller.selectReactionIndex.value = "";
        controller.isReaction.value = false;
        controller.isDialogOpen.value = false;
      },
      child: Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                controller.isLoading.isFalse
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(),
                Column(
                  children: [
                    Obx(() => UserViewChatScreen(
                        userName: controller.isUserId.isTrue
                            ? controller.users.value.profileName ?? ""
                            : controller.isFirstCurrent.isTrue ? controller.chatRoomModel.value.userSecond?.userName.toString().capitalizeFirst ?? ""
                            : controller.chatRoomModel.value.userFirst?.userName.toString().capitalizeFirst ?? "",
                        userProfile: controller.isUserId.isTrue ? controller.users.value.signInType == SignType.google.name ? (controller.users.value.profileImage ?? "") : controller.imageBaseUrl + (controller.users.value.profileImage ?? "") : controller.isFirstCurrent.isTrue ? controller.chatRoomModel.value.userSecond?.userSignType == SignType.google.name ? (controller.chatRoomModel.value.userSecond?.userProfile ?? "")
                            : controller.imageBaseUrl +
                            (controller.chatRoomModel.value.userSecond?.userProfile ?? "")
                            : controller.chatRoomModel.value.userFirst
                            ?.userSignType == SignType.google.name
                            ? (controller.chatRoomModel.value.userFirst?.userProfile ?? "")
                            : controller.imageBaseUrl + (controller.chatRoomModel.value.userFirst?.userProfile ?? ""),
                        presence: controller.userTypingStatus.isFalse ? controller.users.value.presence == PresenceStatus.online.name
                            ? controller.users.value.presence?.capitalizeFirst ?? "" : ""
                            : PresenceStatus.typing.name.capitalizeFirst ?? "",
                        backButtonTap: () => Get.back(),
                        audioCallButtonTap: () => Get.toNamed(ChatHelpers.outGoingScreen,
                                                  arguments: CallArguments(user: controller.users.value, callType: CallType.audioCall.name, callId: "", imageBaseUrl: controller.imageBaseUrl, agoraAppId: controller.agoraAppId, agoraAppCertificate: controller.agoraAppCertificate, userId: controller.users.value.id??"", currentUserId: controller.currentUserId, firebaseServerKey: controller.firebaseServerKey, currentUser: controller.currentUser.value, agoraChannelName: controller.agoraChannelName, agoraToken: controller.agoraToken)),
                        videoCallButtonTap: () => Get.toNamed(ChatHelpers.outGoingScreen,
                                                  arguments: CallArguments(user: controller.users.value, callType: CallType.videoCall.name, callId: "", imageBaseUrl: controller.imageBaseUrl, agoraAppId: controller.agoraAppId, agoraAppCertificate: controller.agoraAppCertificate, userId: controller.users.value.id??"", currentUserId: controller.currentUserId, firebaseServerKey: controller.firebaseServerKey,currentUser: controller.currentUser.value, agoraChannelName: controller.agoraChannelName, agoraToken: controller.agoraToken)), chatController: controller,
                        )),
                    Expanded(
                      child: Obx(() => controller.isLoadingChats.isFalse
                          ? controller.messages.isEmpty
                          ? SizedBox(
                          height: 300,
                          child: Lottie.asset(
                              ChatHelpers.instance.hello))
                          : ListView(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        children: List.generate(
                            controller.messages.length,
                                (index) {
                              // logPrint("last meessage : ${controller.messages.lastWhere((p0) => p0.isSeen==true)}");
                              // String seenLastId = controller.messages.isNotEmpty ? controller.messages.lastWhere((p0) => p0.isSeen==true).id ?? "" : "";
                              return controller.messages[index].messageType == 'text' ? MessageView(
                                index: index,
                                chatController: controller,
                                onLongTap: () {
                                  controller.selectReactionIndex.value = index.toString();
                                  controller.isReaction.value = !controller.isReaction.value;
                                },
                                message: controller.messages[index].message ?? '',
                                time: DateTimeConvertor.timeExt(controller.messages[index].time ?? ''),
                                isSender: controller.messages[index].sender == controller.currentUserId,
                                isSeen: controller.messages[index].isSeen ?? false,
                                visible: controller.messages[index].sender == controller.currentUserId
                                    ? controller.messages.length -1 == index ? true : false
                                    : false,
                                isReaction: controller.isReaction.value,
                                reactionList: controller.emoji,
                              )
                                  : controller.messages[index].file?.fileType == FileTypes.image.name ? ImageView(
                                time: DateTimeConvertor.timeExt(controller.messages[index].time??""),
                                image: controller.messages[index].file?.fileUrl ?? '',
                                isSender: controller.messages[index].sender == controller.currentUserId,
                                onTap: () => Get.to(
                                  ViewImageAndPlayVideoScreen(
                                    file: controller.messages[index].file?.fileUrl ??
                                        '', chatController: controller,
                                  ),
                                ),
                                isSeen: controller.messages[index].isSeen ?? false,
                                isVisible: controller.messages[index].sender == controller.currentUserId
                                    ? controller.messages.length -1 == index ? true : false
                                    : false, onLongPress: () { controller.selectReactionIndex
                                  .value = index.toString();
                              controller.isReaction.value = !controller.isReaction.value; },
                                index: index, chatController: controller,
                              )
                                  : FileView(
                                isSeen: controller.messages[index].isSeen ??
                                    false,
                                isVisible: controller.messages[index].sender == controller.currentUserId
                                    ? controller.messages.length -1 == index ? true : false
                                    : false,
                                onLongPress: () { controller.selectReactionIndex.value = index.toString();
                                controller.isReaction.value = !controller.isReaction.value; },
                                index: index, chatController: controller,
                                time:
                                DateTimeConvertor.timeExt(
                                    controller.messages[index].time??""),
                                fileName: controller.messages[index].file?.fileName ?? '',
                                isSender: controller.messages[index].sender == controller.currentUserId,
                              );
                            }).reversed.toList(),
                      )
                          : const Center(
                        child: CircularProgressIndicator(),
                      )),
                    ),
                    Obx(() => controller.isLoadingChats.isFalse
                        ? controller.messages.isEmpty
                        ? Container(
                        margin: const EdgeInsets.only(left: 5),
                        height: 55,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              controller.suggestions.length,
                                  (index) => TextChip(
                                message:
                                controller.suggestions[index],
                                tap: () =>
                                    controller.chipMessage(index),
                              )),
                        ))
                        : const SizedBox()
                        : const SizedBox()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          MessageField(
                            onChange: (String? value) {
                              controller.typingStatus(true);
                              EasyDebounce.debounce('TypingStatus', const Duration(milliseconds: 1000), () => controller.typingStatus(false));
                              return null;
                            },
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.80,
                            controller: controller.messageController,
                            hintText: 'Enter Message',
                            onValidators: (String? value) {
                              return null;
                            },
                            suffixValue: Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width * .22,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  controller.isFileSendEnable.isTrue ? CircleIconButton(
                                    height: ChatHelpers.iconSizeExtraOverLarge,
                                    width: ChatHelpers.iconSizeExtraOverLarge,
                                    padding: 0,
                                    splashColor: ChatHelpers.black.withOpacity(.3),
                                    boxColor: ChatHelpers.transparent,
                                    isImage: false,
                                    icons: Icons.attach_file,
                                    onTap: () => controller.openDialog(),
                                  ) : const SizedBox(),
                                  controller.isImageSendEnable.isTrue ? CircleIconButton(
                                    height: ChatHelpers.iconSizeExtraOverLarge,
                                    width: ChatHelpers.iconSizeExtraOverLarge,
                                    padding: 0,
                                    splashColor: ChatHelpers.black.withOpacity(.3),
                                    boxColor: ChatHelpers.transparent,
                                    isImage: false,
                                    icons: Icons.camera_alt,
                                    onTap: () => controller.cameraPermission(),
                                  ) : const SizedBox()
                                ],
                              ),
                            ),
                            focus: controller.messageFocus,
                            maxLines: 5,
                          ),
                          CircleIconButton(
                            height: 50,
                            width: 50,
                            boxColor: ChatHelpers.mainColorLight,
                            isImage: false,
                            icons: Icons.send,
                            colors: ChatHelpers.white,
                            onTap: () => controller.sendMessage(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: ChatHelpers.marginSizeExtraSmall,),
                    Obx(() => AnimatedOpacity(
                      opacity: controller.isDialogOpen.isTrue ? 1.0 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: AnimatedContainer(
                        height: controller.isDialogOpen.isTrue ? 90 : 0,
                        width: controller.isDialogOpen.isTrue
                            ? MediaQuery.of(context).size.width
                            : 0,
                        padding: const EdgeInsets.all(
                            ChatHelpers.marginSizeSmall),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(
                                ChatHelpers.cornerRadius)),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuart,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            CommonIconVBtn(
                              onPressed: () async {
                                controller.cameraPermission();
                                controller.isDialogOpen.value = false;
                              },
                              title: 'Camera',
                              icons: Icons.camera_alt,
                              height: 70,
                              width:
                              MediaQuery.of(context).size.width * .25,
                              fontSize: ChatHelpers.marginSizeLarge,
                              color: ChatHelpers.mainColorLight,
                              iconSize: ChatHelpers.iconSizeLarge,
                            ),
                            CommonIconVBtn(
                              onPressed: () async {
                                controller.photoPermission();
                                controller.isDialogOpen.value = false;
                              },
                              title: 'Gallery',
                              icons: Icons.photo_album,
                              height: 70,
                              width:
                              MediaQuery.of(context).size.width * .25,
                              fontSize: ChatHelpers.marginSizeLarge,
                              color: ChatHelpers.red,
                              iconSize: ChatHelpers.iconSizeLarge,
                            ),
                            CommonIconVBtn(
                              onPressed: () async {
                                controller.pickFile();
                                controller.isDialogOpen.value = false;
                              },
                              title: 'Documents',
                              icons: Icons.folder,
                              height: 70,
                              width:
                              MediaQuery.of(context).size.width * .25,
                              fontSize: ChatHelpers.marginSizeLarge,
                              color: ChatHelpers.green,
                              iconSize: ChatHelpers.iconSizeLarge,
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}