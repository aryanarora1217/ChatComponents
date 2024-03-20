import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/view/widgets/icon_button/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      color: ChatHelpers.mainColor,
      padding:
      EdgeInsets.only(top: statusBarHeight+5, bottom: 10),
      child: SizedBox(
        height: 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5,),
            CircleIconButton(onTap: backButtonTap, isImage: false,icons: Icons.arrow_back,colors: ChatHelpers.white,boxColor: ChatHelpers.transparent,),
            const SizedBox(width: 10,),
            ProfileImageView(
                height: 38,
                width: 38,
                profileName: userName,
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
                    style: ChatHelpers.instance.styleSemiBold(
                        ChatHelpers.fontSizeDefault,
                        ChatHelpers.white)),
                presence== "" ? const SizedBox() :Text(
                    presence,
                    style: ChatHelpers.instance.styleRegular(
                        ChatHelpers.fontSizeExtraSmall,
                        ChatHelpers.white.withOpacity(.9))),
              ],
            ),
            const Spacer(),
            chatController.isAudioCallEnable.isTrue ?CircleIconButton(
              isImage: false,
              boxColor: ChatHelpers.transparent,
              icons: Icons.call,
              onTap: audioCallButtonTap,
              colors: ChatHelpers.white,
            ) : const SizedBox(),
            const SizedBox(
              width: 15,
            ),
            chatController.isVideoCallEnable.isTrue ? CircleIconButton(
              boxColor: ChatHelpers.transparent,
              isImage: false,
              icons: Icons.videocam,
              onTap: videoCallButtonTap,
              colors: ChatHelpers.white,
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
