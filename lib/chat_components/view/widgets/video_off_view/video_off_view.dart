import 'package:flutter/material.dart';

import '../../../model/chatHelper/chat_helper.dart';
import '../../../model/models/user_model/user_model.dart';
import '../cricle_image_view/profile_image_view.dart';


class VideoOffView extends StatelessWidget {
  final Users users;
  final bool isRemote;
  final double? height;
  final double? width;
  final double? fontSize;
  final String imageBaseUrl;

  const VideoOffView(
      {super.key,
      required this.users,
      required this.isRemote,
      this.height,
      this.width,
      this.fontSize, required this.imageBaseUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          isRemote ? ChatHelpers.transparent : ChatHelpers.mainColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle,
              color: ChatHelpers.backcolor,
            ),
              child: ProfileImageView(
            profileImage: users.signInType == SignType.google.name
                ? users.profileImage ?? ""
                : imageBaseUrl + (users.profileImage ?? ""),
            height: height,
            width: width,
          )),
          const SizedBox(
            height: 10,
          ),
          Text(
            users.profileName ?? "User Name",
            style: ChatHelpers.instance.styleRegular(
                fontSize ?? ChatHelpers.fontSizeDefault,
                ChatHelpers.white),
          )
        ],
      ),
    );
  }
}
