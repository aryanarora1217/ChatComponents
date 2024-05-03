import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/view/widgets/icon_button/icon_button.dart';
import 'package:flutter/material.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../cricle_image_view/profile_image_view.dart';


class UserViewChatScreen extends StatelessWidget {

  final String userName;
  final String userProfile;
  final String presence;
  final VoidCallback backButtonTap;
  final VoidCallback audioCallButtonTap;
  final VoidCallback videoCallButtonTap;
  final ChatController chatController;


  const UserViewChatScreen({super.key, required this.userName, required this.userProfile, required this.presence, required this.backButtonTap, required this.audioCallButtonTap, required this.videoCallButtonTap, required this.chatController});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      height: statusBarHeight+55,
      color: chatController.themeArguments?.colorArguments?.mainColor ?? ChatHelpers.mainColor,
      padding:
      EdgeInsets.only(top: statusBarHeight+5, bottom: 10),
      child: SizedBox(
        height: 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5,),
            CircleIconButton(onTap: backButtonTap, isImage: false,icons: Icons.arrow_back,colors: chatController.themeArguments?.colorArguments?.backButtonIconColor ?? chatController.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,boxColor: ChatHelpers.transparent,),
            const SizedBox(width: 10,),
            ProfileImageView(
              boxColor: chatController.themeArguments?.colorArguments?.mainColorLight,
                height: 38,
                width: 38,
                profileName: userName.isNotEmpty ? userName[0] :"",
                profileImage: userProfile),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    userName,
                    style: chatController.themeArguments?.styleArguments?.appbarNameStyle ?? ChatHelpers.instance.styleSemiBold(
                        ChatHelpers.fontSizeDefault,
                        chatController.themeArguments?.colorArguments?.appBarNameTextColor ?? chatController.themeArguments?.colorArguments?.textColor ?? ChatHelpers.white)),
                presence== "" ? const SizedBox() :Text(
                    presence,
                    style: chatController.themeArguments?.styleArguments?.appbarPresenceStyle ?? ChatHelpers.instance.styleRegular(
                        ChatHelpers.fontSizeExtraSmall,
                        chatController.themeArguments?.colorArguments?.appBarPresenceTextColor ?? chatController.themeArguments?.colorArguments?.textColor?.withOpacity(.8) ?? ChatHelpers.white.withOpacity(.9))),
              ],
            ),
            const Spacer(),
            chatController.chatArguments.isAudioCallEnable ? CircleIconButton(
              isImage: false,
              boxColor: ChatHelpers.transparent,
              icons: Icons.call,
              onTap: audioCallButtonTap,
              colors: chatController.themeArguments?.colorArguments?.audioCallIconColor ??  chatController.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
            ) : const SizedBox(),
            const SizedBox(
              width: 15,
            ),
            chatController.chatArguments.isVideoCallEnable ? CircleIconButton(
              boxColor: ChatHelpers.transparent,
              isImage: false,
              icons: Icons.videocam,
              onTap: videoCallButtonTap,
              colors: chatController.themeArguments?.colorArguments?.videoCallIconColor ?? chatController.themeArguments?.colorArguments?.iconColor ??  ChatHelpers.white,
            ) : const SizedBox(),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}
