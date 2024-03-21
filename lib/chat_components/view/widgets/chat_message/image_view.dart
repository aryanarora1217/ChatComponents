
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../cached_network_imagewidget/cached_network_image_widget.dart';
import '../reaction_view/reaction_view.dart';

class ImageView extends StatelessWidget {
  final String time;
  final String image;
  final int index;
  final bool isSender;
  final bool isSeen;
  final bool isVisible;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ChatController chatController;

  const ImageView(
      {
        super.key,
      required this.time,
      required this.image,
      required this.isSender,
      required this.onTap,
      required this.isSeen,
      required this.isVisible,
      required this.onLongPress,
      required this.chatController, required this.index
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: image,
              child: Container(
                height: 180,
                width: 220,
                margin: const EdgeInsets.only(top:ChatHelpers.marginSizeExtraSmall),
                decoration: BoxDecoration(
                  color: isSender == true
                      ? chatController.themeArguments?.colorArguments?.senderMessageBoxColor ?? ChatHelpers.mainColor
                      : chatController.themeArguments?.colorArguments?.receiverMessageBoxColor ?? ChatHelpers.backcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: isSender == true
                        ? Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxSenderBottomLeftRadius ?? ChatHelpers.cornerRadius)
                        : Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxReceiverBottomLeftRadius ?? ChatHelpers.cornerRadius),
                    topRight: isSender == true
                        ? Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxSenderTopRightRadius ?? ChatHelpers.cornerRadius)
                        : Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxReceiverTopRightRadius ?? ChatHelpers.cornerRadius),
                    topLeft: isSender == true
                        ? Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxSenderTopLeftRadius ?? ChatHelpers.cornerRadius)
                        : Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxReceiverTopLeftRadius ?? ChatHelpers.cornerRadius),
                    bottomRight: isSender == true
                        ? Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxSenderBottomRightRadius ?? ChatHelpers.cornerRadius)
                        : Radius.circular(chatController.themeArguments?.borderRadiusArguments?.messageBoxReceiverBottomRightRadius ?? ChatHelpers.cornerRadius),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      width: 220,
                      margin: const EdgeInsets.all(
                          ChatHelpers.marginSizeExtraSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            ChatHelpers.marginSizeDefault),
                        color: isSender == true
                            ? chatController.themeArguments?.colorArguments?.senderMessageBoxColor ?? ChatHelpers.mainColor
                            : chatController.themeArguments?.colorArguments?.receiverMessageBoxColor ?? ChatHelpers.backcolor,
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(ChatHelpers.marginSizeSmall),
                          child: cachedNetworkImage(
                              isProfile: false,
                              url: chatController.chatArguments.imageBaseUrlFirebase + image)),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: ChatHelpers.marginSizeDefault,
                            bottom: ChatHelpers.marginSizeSmall),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          time,
                          style: chatController.themeArguments?.styleArguments?.messagesTimeTextStyle ??  ChatHelpers.instance.styleLight(ChatHelpers.fontSizeExtraSmall,
                              isSender == true
                                  ? chatController.themeArguments?.colorArguments?.senderMessageTextColor ?? ChatHelpers.white
                                  : chatController.themeArguments?.colorArguments?.receiverMessageTextColor ?? ChatHelpers.black)
                        ),
                      ),
                    ),
                    chatController.reactionIndex.value != 7
                        ? Positioned(
                      bottom: -5,
                      left: 0,
                      child: Text(
                        chatController.emoji[chatController.reactionIndex.value],
                        style: const TextStyle(fontSize: ChatHelpers.fontSizeExtraLarge),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            if(chatController.selectReactionIndex.value == index.toString())
              Padding(
                padding: chatController.isReaction.isTrue ? const EdgeInsets.symmetric(vertical:ChatHelpers.marginSizeExtraSmall) : const EdgeInsets.all(0),
                child: ReactionView(
                  isSender:isSender,
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
                style: ChatHelpers.instance.styleRegular(ChatHelpers.fontSizeSmall, ChatHelpers.black),
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
