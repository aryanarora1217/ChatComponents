import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../reaction_view/reaction_view.dart';

class FileView extends StatelessWidget {
  final String fileName;
  final String time;
  final int index;
  final int reaction;
  final bool isSender;
  final bool isAdding;
  final bool isSeen;
  final bool isVisible;
  final VoidCallback onLongPress;
  final ChatController chatController;

  const FileView(
      {super.key,
      required this.fileName,
      required this.isSender,
      required this.time,
      required this.index,
      required this.reaction,
      required this.isSeen,
      required this.isVisible,
      required this.onLongPress,
      required this.chatController, required this.isAdding});

  @override
  Widget build(BuildContext context) {
    return Obx(() => isAdding ? GestureDetector(
          onLongPress: onLongPress,
          child: Align(
            alignment:
                isSender == true ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: isSender == true
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 150.0,
                      maxWidth: MediaQuery.of(context).size.width * .8,
                      minWidth: 5),
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              top: ChatHelpers.marginSizeExtraSmall,
                            left: isSender == true ? ChatHelpers.marginSizeSmall : 0,
                            right: isSender == true ? 0 : ChatHelpers.marginSizeSmall ,
                            bottom: reaction != 7 ? 10 : 0,),
                          padding: const EdgeInsets.symmetric(
                              horizontal: ChatHelpers.marginSizeSmall),
                          decoration: BoxDecoration(
                            color: isSender == true
                                ? chatController.themeArguments?.colorArguments
                                        ?.senderMessageBoxColor ??
                                    ChatHelpers.mainColor
                                : chatController.themeArguments?.colorArguments
                                        ?.receiverMessageBoxColor ??
                                    ChatHelpers.backcolor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: isSender == true
                                  ? Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxSenderBottomLeftRadius ??
                                      ChatHelpers.cornerRadius)
                                  : Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxReceiverBottomLeftRadius ??
                                      ChatHelpers.cornerRadius),
                              topRight: isSender == true
                                  ? Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxSenderTopRightRadius ??
                                      ChatHelpers.cornerRadius)
                                  : Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxReceiverTopRightRadius ??
                                      ChatHelpers.cornerRadius),
                              topLeft: isSender == true
                                  ? Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxSenderTopLeftRadius ??
                                      ChatHelpers.cornerRadius)
                                  : Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxReceiverTopLeftRadius ??
                                      ChatHelpers.cornerRadius),
                              bottomRight: isSender == true
                                  ? Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxSenderBottomRightRadius ??
                                      ChatHelpers.cornerRadius)
                                  : Radius.circular(chatController
                                          .themeArguments
                                          ?.borderRadiusArguments
                                          ?.messageBoxReceiverBottomRightRadius ??
                                      ChatHelpers.cornerRadius),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: ChatHelpers.marginSizeSmall,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: ChatHelpers.marginSizeDefault,
                                    top: ChatHelpers.marginSizeExtraSmall,
                                    bottom: ChatHelpers.marginSizeExtraSmall),
                                decoration: BoxDecoration(
                                    color: isSender == true
                                        ? chatController
                                                .themeArguments
                                                ?.colorArguments
                                                ?.mainColorLight ??
                                            ChatHelpers.mainColorLight
                                        : chatController
                                                .themeArguments
                                                ?.colorArguments
                                                ?.backgroundColor ??
                                            ChatHelpers.backcolor,
                                    borderRadius: BorderRadius.circular(
                                        ChatHelpers.cornerRadius)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      color: isSender == true
                                          ? chatController.themeArguments
                                                  ?.colorArguments?.iconColor ??
                                              ChatHelpers.white
                                          : chatController.themeArguments
                                                  ?.colorArguments?.iconColor ??
                                              ChatHelpers.black,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Flexible(
                                      child: Text(
                                        fileName,
                                        style: ChatHelpers.instance.styleRegular(
                                            ChatHelpers.fontSizeSmall,
                                            isSender == true
                                                ? chatController
                                                        .themeArguments
                                                        ?.colorArguments
                                                        ?.senderMessageTextColor ??
                                                    ChatHelpers.white
                                                : chatController
                                                        .themeArguments
                                                        ?.colorArguments
                                                        ?.receiverMessageTextColor ??
                                                    ChatHelpers.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    chatController.isDownloadingStart.isTrue
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                                            child: const CircularProgressIndicator(
                                              color: ChatHelpers.white,
                                            ))
                                        : IconButton(
                                            onPressed: () => chatController
                                                .downloadFileFromServer(index),
                                            icon: Icon(
                                              Icons.download,
                                              color: isSender == true
                                                  ? chatController
                                                          .themeArguments
                                                          ?.colorArguments
                                                          ?.iconColor ??
                                                      ChatHelpers.white
                                                  : chatController
                                                          .themeArguments
                                                          ?.colorArguments
                                                          ?.iconColor ??
                                                      ChatHelpers.black,
                                            )),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      ChatHelpers.marginSizeExtraSmall),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        time,
                                        style: ChatHelpers.instance.styleRegular(
                                            ChatHelpers.fontSizeSmall,
                                            isSender == true
                                                ? chatController
                                                        .themeArguments
                                                        ?.colorArguments
                                                        ?.senderMessageTextColor ??
                                                    ChatHelpers.white
                                                : chatController
                                                        .themeArguments
                                                        ?.colorArguments
                                                        ?.receiverMessageTextColor ??
                                                    ChatHelpers.black),
                                      ),
                                      const SizedBox(
                                        width: ChatHelpers.marginSizeExtraSmall,
                                      ),
                                      isSender == true
                                          ? Image.asset(
                                              ChatHelpers
                                                  .instance.doubleTickImage,
                                              height: 15,
                                              width: 15,
                                              color: isSeen
                                                  ? chatController
                                                          .themeArguments
                                                          ?.colorArguments
                                                          ?.tickSeenColor ??
                                                      ChatHelpers.backcolor
                                                  : chatController
                                                          .themeArguments
                                                          ?.colorArguments
                                                          ?.tickUnSeenColor ??
                                                      ChatHelpers.grey,
                                              package: 'chatcomponent')
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          )),
                      reaction != 7
                          ? Positioned(
                            left: isSender ? 0 : null,
                           right: isSender ? null: 0,
                            bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ChatHelpers.blueLight),
                                child: Text(
                                  chatController.emoji[reaction],
                                  style: const TextStyle(fontSize: ChatHelpers.fontSizeSmall),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                if (chatController.selectReactionIndex.value ==
                    index.toString())
                  Padding(
                    padding: chatController.isReaction.isTrue
                        ? const EdgeInsets.symmetric(
                            vertical: ChatHelpers.marginSizeExtraSmall)
                        : const EdgeInsets.all(0),
                    child: ReactionView(
                      messageIndex: index,
                      isSender: isSender,
                      isChange: chatController.isReaction.value,
                      reactionList: chatController.emoji,
                      chatController: chatController,
                    ),
                  ),
              ],
            ),
          ),
        ) : Align(
      alignment:
      isSender == true ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSender == true
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 150.0,
                maxWidth: MediaQuery.of(context).size.width * .8,
                minWidth: 5),
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: ChatHelpers.marginSizeExtraSmall,
                      left: isSender == true ? ChatHelpers.marginSizeSmall : 0,
                      right: isSender == true ? 0 : ChatHelpers.marginSizeSmall ,
                      bottom: reaction != 7 ? 10 : 0,),
                    padding: const EdgeInsets.symmetric(
                        horizontal: ChatHelpers.marginSizeSmall),
                    decoration: BoxDecoration(
                      color: isSender == true
                          ? chatController.themeArguments?.colorArguments
                          ?.senderMessageBoxColor ??
                          ChatHelpers.mainColor
                          : chatController.themeArguments?.colorArguments
                          ?.receiverMessageBoxColor ??
                          ChatHelpers.backcolor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: isSender == true
                            ? Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderBottomLeftRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverBottomLeftRadius ??
                            ChatHelpers.cornerRadius),
                        topRight: isSender == true
                            ? Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderTopRightRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverTopRightRadius ??
                            ChatHelpers.cornerRadius),
                        topLeft: isSender == true
                            ? Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderTopLeftRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverTopLeftRadius ??
                            ChatHelpers.cornerRadius),
                        bottomRight: isSender == true
                            ? Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderBottomRightRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverBottomRightRadius ??
                            ChatHelpers.cornerRadius),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: ChatHelpers.marginSizeSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: ChatHelpers.marginSizeDefault,
                              top: ChatHelpers.marginSizeExtraSmall,
                              bottom: ChatHelpers.marginSizeExtraSmall),
                          decoration: BoxDecoration(
                              color: isSender == true
                                  ? chatController
                                  .themeArguments
                                  ?.colorArguments
                                  ?.mainColorLight ??
                                  ChatHelpers.mainColorLight
                                  : chatController
                                  .themeArguments
                                  ?.colorArguments
                                  ?.backgroundColor ??
                                  ChatHelpers.backcolor,
                              borderRadius: BorderRadius.circular(
                                  ChatHelpers.cornerRadius)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.folder,
                                color: isSender == true
                                    ? chatController.themeArguments
                                    ?.colorArguments?.iconColor ??
                                    ChatHelpers.white
                                    : chatController.themeArguments
                                    ?.colorArguments?.iconColor ??
                                    ChatHelpers.black,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: Text(
                                  fileName,
                                  style: ChatHelpers.instance.styleRegular(
                                      ChatHelpers.fontSizeSmall,
                                      isSender == true
                                          ? chatController
                                          .themeArguments
                                          ?.colorArguments
                                          ?.senderMessageTextColor ??
                                          ChatHelpers.white
                                          : chatController
                                          .themeArguments
                                          ?.colorArguments
                                          ?.receiverMessageTextColor ??
                                          ChatHelpers.black),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            Container(
                                  height: 30,
                                  width: 30,
                                  padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                                  child: const CircularProgressIndicator(
                                    color: ChatHelpers.white,
                                  ))
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(
                                ChatHelpers.marginSizeExtraSmall),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  time,
                                  style: ChatHelpers.instance.styleRegular(
                                      ChatHelpers.fontSizeSmall,
                                      isSender == true
                                          ? chatController
                                          .themeArguments
                                          ?.colorArguments
                                          ?.senderMessageTextColor ??
                                          ChatHelpers.white
                                          : chatController
                                          .themeArguments
                                          ?.colorArguments
                                          ?.receiverMessageTextColor ??
                                          ChatHelpers.black),
                                ),
                                const SizedBox(
                                  width: ChatHelpers.marginSizeExtraSmall,
                                ),
                                isSender == true
                                    ? Image.asset(
                                    ChatHelpers
                                        .instance.doubleTickImage,
                                    height: 15,
                                    width: 15,
                                    color: isSeen
                                        ? chatController
                                        .themeArguments
                                        ?.colorArguments
                                        ?.tickSeenColor ??
                                        ChatHelpers.backcolor
                                        : chatController
                                        .themeArguments
                                        ?.colorArguments
                                        ?.tickUnSeenColor ??
                                        ChatHelpers.grey,
                                    package: 'chatcomponent')
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    )),
                reaction != 7
                    ? Positioned(
                  left: isSender ? 0 : null,
                  right: isSender ? null: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ChatHelpers.blueLight),
                    child: Text(
                      chatController.emoji[reaction],
                      style: const TextStyle(fontSize: ChatHelpers.fontSizeSmall),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
                    : const SizedBox()
              ],
            ),
          ),
          if (chatController.selectReactionIndex.value ==
              index.toString())
            Padding(
              padding: chatController.isReaction.isTrue
                  ? const EdgeInsets.symmetric(
                  vertical: ChatHelpers.marginSizeExtraSmall)
                  : const EdgeInsets.all(0),
              child: ReactionView(
                messageIndex: index,
                isSender: isSender,
                isChange: chatController.isReaction.value,
                reactionList: chatController.emoji,
                chatController: chatController,
              ),
            ),
        ],
      ),
    ));
  }
}
