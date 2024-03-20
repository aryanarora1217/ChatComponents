import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../reaction_view/reaction_view.dart';

class FileView extends StatelessWidget {
  final String fileName;
  final String time;
  final int index;
  final bool isSender;
  final bool isSeen;
  final bool isVisible;
  final Color? senderColor;
  final Color? receiverColor;
  final VoidCallback onLongPress;
  final ChatController chatController;

  const FileView(
      {super.key,
      required this.fileName,
      required this.isSender,
      required this.time,
      required this.index,
      required this.isSeen,
      required this.isVisible,
        this.senderColor,
        this.receiverColor,
      required this.onLongPress,
      required this.chatController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment:
            isSender == true ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 150.0,
                      maxWidth: MediaQuery.of(context).size.width * .8,
                      minWidth: 5),
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: ChatHelpers.marginSizeExtraSmall),
                      padding: const EdgeInsets.symmetric(
                          horizontal: ChatHelpers.marginSizeSmall),
                      decoration: BoxDecoration(
                          color: isSender == true
                              ? ChatHelpers.mainColor
                              : ChatHelpers.backcolor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(
                                  ChatHelpers.cornerRadius),
                              topRight: const Radius.circular(
                                  ChatHelpers.cornerRadius),
                              topLeft: isSender == true
                                  ? const Radius.circular(
                                      ChatHelpers.cornerRadius)
                                  : Radius.zero,
                              bottomRight: isSender == false
                                  ? const Radius.circular(
                                      ChatHelpers.cornerRadius)
                                  : Radius.zero)),
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
                                    ? senderColor ?? ChatHelpers.mainColorLight
                                    : receiverColor ?? ChatHelpers.backcolor,
                                borderRadius: BorderRadius.circular(
                                    ChatHelpers.cornerRadius)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.folder,
                                  color: isSender == true
                                      ? ChatHelpers.white
                                      : ChatHelpers.black,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    fileName,
                                    style: ChatHelpers.instance.styleRegular(
                                        ChatHelpers.fontSizeSmall,
                                        isSender == true
                                            ? ChatHelpers.white
                                            : ChatHelpers.black),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.download,
                                      color: isSender == true
                                          ? ChatHelpers.white
                                          : ChatHelpers.black,
                                    )),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  ChatHelpers.marginSizeExtraSmall),
                              child: Text(
                                time,
                                style: ChatHelpers.instance.styleRegular(
                                    ChatHelpers.fontSizeSmall,
                                    isSender == true
                                        ? ChatHelpers.white
                                        : ChatHelpers.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      )),
                ),
                chatController.reactionIndex.value != 7
                    ? Positioned(
                        bottom: -5,
                        left: 0,
                        child: Text(
                          chatController
                              .emoji[chatController.reactionIndex.value],
                          style: const TextStyle(
                              fontSize: ChatHelpers.fontSizeExtraLarge),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            if (chatController.selectReactionIndex.value == index.toString())
              Padding(
                padding: chatController.isReaction.isTrue
                    ? const EdgeInsets.symmetric(
                        vertical: ChatHelpers.marginSizeExtraSmall)
                    : const EdgeInsets.all(0),
                child: ReactionView(
                  isSender: isSender,
                  isChange: chatController.isReaction.value,
                  reactionList: chatController.emoji,
                  chatController: chatController,
                ),
              ),
            isVisible
                ? Padding(
                    padding: const EdgeInsets.only(
                        right: ChatHelpers.marginSizeSmall),
                    child: Text(
                      isSeen == false ? "Delivered" : "Seen",
                      style: ChatHelpers.instance.styleRegular(
                          ChatHelpers.fontSizeSmall, ChatHelpers.black),
                      textAlign: TextAlign.right,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
