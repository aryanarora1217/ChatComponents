import 'package:flutter/material.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../icon_button/icon_button.dart';

class ReactionView extends StatelessWidget {
  final bool isChange;
  final bool isSender;
  final List<String> reactionList;
  final ChatController chatController;

  const ReactionView(
      {super.key,
      required this.isChange,
      required this.isSender,
      required this.reactionList,
      required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.bottomRight : Alignment.bottomLeft,
      child: AnimatedContainer(
        height: isChange ? 50 : 0,
        width: isChange ? MediaQuery.of(context).size.width * .65 : 0,
        decoration: BoxDecoration(
            borderRadius: isChange ? BorderRadius.circular(ChatHelpers.cornerRadius) : BorderRadius.circular(ChatHelpers.circularImage),
            color: ChatHelpers.mainColor),
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 200),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
              reactionList.length,
              (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeSmall),
                    alignment: Alignment.center,
                    child: CircleIconButton(
                      onTap: () {
                        chatController.isReaction.value =
                            !chatController.isReaction.value;
                        chatController.reactionIndex.value = index;
                        chatController.selectReactionIndex.value = "";
                      },
                      boxColor: ChatHelpers.white,
                      isImage: true,
                      isImageText: true,
                      shapeRec: false,
                      image: reactionList[index],
                    ),
                  )),
        ),
      ),
    );
  }
}
