
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../cached_network_imagewidget/cached_network_image_widget.dart';
import '../reaction_view/reaction_view.dart';

class ImageView extends StatelessWidget {
  final String time;
  final String image;
  final String imageMessage;
  final int index;
  final int reaction;
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
      required this.chatController, required this.index, required this.reaction, required this.imageMessage
      });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSender == true
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 210,minWidth: 220,maxWidth: 220),
              child: Stack(
                children: [
                  Hero(
                    tag: image,
                    child: Container(
                      margin: EdgeInsets.only(top:ChatHelpers.marginSizeExtraSmall,
                        left: isSender == true ? ChatHelpers.marginSizeSmall : 0,
                        right: isSender == true ? 0 : ChatHelpers.marginSizeSmall ,
                        bottom: reaction != 7 ? 10 : 0,),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 190,
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeExtraSmall),
                            margin: const EdgeInsets.only(
                                bottom: ChatHelpers.marginSizeExtraSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                imageMessage.isEmpty || imageMessage == "" ? const SizedBox() :   Flexible(
                                  child: Text(
                                    imageMessage,
                                    textAlign: TextAlign.start,
                                    style: chatController.themeArguments?.styleArguments?.messageTextStyle ?? ChatHelpers.instance.styleRegular(
                                        ChatHelpers.fontSizeDefault,
                                        isSender == true
                                            ? chatController.themeArguments?.colorArguments?.senderMessageTextColor ?? ChatHelpers.white
                                            : chatController.themeArguments?.colorArguments?.receiverMessageTextColor ?? ChatHelpers.black),
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(height: ChatHelpers.marginSizeExtraSmall,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeExtraSmall),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          time,
                                          textAlign: TextAlign.start,
                                          style: chatController.themeArguments?.styleArguments?.messagesTimeTextStyle ??  ChatHelpers.instance.styleLight(ChatHelpers.fontSizeExtraSmall,
                                              isSender == true
                                                  ? chatController.themeArguments?.colorArguments?.senderMessageTextColor ?? ChatHelpers.white
                                                  : chatController.themeArguments?.colorArguments?.receiverMessageTextColor ?? ChatHelpers.black)
                                      ),
                                      const SizedBox(
                                        width: ChatHelpers.marginSizeExtraSmall,
                                      ),
                                      isSender == true
                                          ? Image.asset(ChatHelpers.instance.doubleTickImage,height: 15,width: 15,  color: isSeen ? chatController.themeArguments?.colorArguments?.tickSeenColor ?? ChatHelpers.backcolor : chatController.themeArguments?.colorArguments?.tickUnSeenColor ?? ChatHelpers.grey ,package: 'chatcomponent')
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        style: const TextStyle(fontSize: ChatHelpers.fontSizeLarge),
                        textAlign: TextAlign.start,
                                            ),
                                          ),
                      )
                      : const SizedBox(),
                ],
              ),
            ),
            if(chatController.selectReactionIndex.value == index.toString())
              Padding(
                padding: chatController.isReaction.isTrue ? const EdgeInsets.symmetric(vertical:ChatHelpers.marginSizeExtraSmall) : const EdgeInsets.all(0),
                child: ReactionView(
                  messageIndex: index,
                  isSender:isSender,
                  isChange: chatController.isReaction.value,
                  reactionList: chatController.emoji,
                  chatController: chatController,
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
