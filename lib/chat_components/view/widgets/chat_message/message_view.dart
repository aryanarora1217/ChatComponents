import 'package:chatcomponent/chat_components/view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../reaction_view/reaction_view.dart';

class MessageView extends StatelessWidget {
  final String message;
  final String time;
  final int index;
  final int reaction;
  final bool isSender;
  final bool isSeen;
  final bool visible;
  final bool isReaction;
  final List<String> reactionList;
  final VoidCallback onLongTap;
  final ChatController chatController;

  const MessageView(
      {super.key,
      required this.message,
      required this.time,
      required this.isSender,
      required this.index,
      required this.reaction,
      required this.isSeen,
      required this.onLongTap,
      required this.visible,
      required this.isReaction,
      required this.reactionList,
      required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onLongPress: onLongTap,
          child: Align(
            alignment: isSender == true ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: isSender == true
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .85, minWidth: 5),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: isSender == true ? ChatHelpers.marginSizeSmall : 0,
                          right: isSender == true ? 0 : ChatHelpers.marginSizeSmall ,
                          bottom: reaction != 7 ? 10 : 0,
                          top: ChatHelpers.marginSizeExtraSmall,
                        ),
                        padding: const EdgeInsets.all(
                            ChatHelpers.paddingSizeSmall),
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: isSender
                                        ? ChatHelpers.marginSizeSmall
                                        : ChatHelpers.marginSizeDefault),
                                child: Text(
                                  message,
                                  style: chatController
                                          .themeArguments
                                          ?.styleArguments
                                          ?.messageTextStyle ??
                                      ChatHelpers.instance.styleRegular(
                                          ChatHelpers.fontSizeDefault,
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
                                  softWrap: true,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: ChatHelpers.marginSizeExtraSmall,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: ChatHelpers.marginSizeSmall,
                                ),
                                Text(
                                  time,
                                  style: chatController
                                          .themeArguments
                                          ?.styleArguments
                                          ?.messagesTimeTextStyle ??
                                      ChatHelpers.instance.styleLight(
                                          ChatHelpers.fontSizeExtraSmall,
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
                                        ChatHelpers.instance.doubleTickImage,
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
                            )
                          ],
                        ),
                      ),
                      reaction != 7
                          ? Positioned(
                            left: isSender ? 0 : null,
                            right: isSender ? null: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ChatHelpers.blueLight),
                              child: Text(
                                reactionList[reaction],
                                style: const TextStyle(
                                    fontSize: ChatHelpers.fontSizeSmall),
                                textAlign: TextAlign.center,
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
                    padding: isReaction
                        ? const EdgeInsets.symmetric(
                        vertical: ChatHelpers.marginSizeExtraSmall)
                        : const EdgeInsets.all(0),
                    child: ReactionView(
                      isSender: isSender,
                      isChange: isReaction,
                      reactionList: reactionList,
                      chatController: chatController,
                      messageIndex: index,
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
