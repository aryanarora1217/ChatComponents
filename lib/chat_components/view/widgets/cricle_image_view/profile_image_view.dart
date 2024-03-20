import 'package:flutter/material.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../cached_network_imagewidget/cached_network_image_widget.dart';

class ProfileImageView extends StatelessWidget {
  final double? height;
  final double? width;
  final String profileImage;
  final String? profileName;
  final bool? isStatus;

  const ProfileImageView({super.key, required this.profileImage, this.height, this.width, this.isStatus, this.profileName,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width ?? 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: isStatus == true?Border.all(color: ChatHelpers.mainColorLight, width: 1.0):null,
        shape: BoxShape.circle,
        color: profileName != null ? ChatHelpers.mainColorLight :ChatHelpers.transparent
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ChatHelpers.circularImage),
        child: profileImage == "" ?  Center(child: Text(profileName??"",style: ChatHelpers.instance.styleBold(ChatHelpers.fontSizeOverExtraLarge, ChatHelpers.white),),)  : cachedNetworkImage(url: profileImage,isProfile: true)
      ),
    );
  }
}
