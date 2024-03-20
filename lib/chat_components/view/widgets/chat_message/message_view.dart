import 'package:chatcomponent/chat_components/view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import 'package:flutter/material.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../reaction_view/reaction_view.dart';

class MessageView extends StatelessWidget {
  final String message;
  final String time;
  final int index;
  final bool isSender;
  final bool isSeen;
  final bool visible;
  final Color? senderColor;
  final Color? receiverColor;
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
      required this.isSeen,
      required this.onLongTap,
      required this.visible,
      required this.isReaction,
      required this.reactionList,
      required this.chatController, this.senderColor, this.receiverColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongTap,
      child: Align(
        alignment:
            isSender == true ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSender == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .8,
                      minWidth: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: isSender == true ? ChatHelpers.marginSizeDefault : 0,top: ChatHelpers.marginSizeExtraSmall) ,
                    padding:
                        const EdgeInsets.all(ChatHelpers.paddingSizeSmall),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            message,
                            style: ChatHelpers.instance.styleRegular(
                                ChatHelpers.fontSizeDefault,
                                isSender == true
                                    ? ChatHelpers.white
                                    : ChatHelpers.black),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          time,
                          style: ChatHelpers.instance.styleLight(
                              ChatHelpers.fontSizeExtraSmall,
                              isSender == true
                                  ? senderColor ?? ChatHelpers.white
                                  : receiverColor ?? ChatHelpers.black),
                        )
                      ],
                    ),
                  ),
                ),
                chatController.reactionIndex.value != 7
                    ? Positioned(
                        bottom: -4,
                        left: 7,
                        child: Text(
                          reactionList[chatController.reactionIndex.value],
                          style: const TextStyle(
                              fontSize: ChatHelpers.fontSizeExtraLarge),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            if(chatController.selectReactionIndex.value == index.toString())
              Padding(
                padding:isReaction ? const EdgeInsets.symmetric(vertical:ChatHelpers.marginSizeExtraSmall) : const EdgeInsets.all(0),
                child: ReactionView(
                  isSender: isSender,
                  isChange: isReaction,
                  reactionList: reactionList,
                  chatController: chatController,
                ),
              ),
            visible
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
