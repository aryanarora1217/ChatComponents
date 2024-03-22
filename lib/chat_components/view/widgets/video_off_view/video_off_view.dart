import 'package:chatcomponent/chat_components/model/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final Color? backGroundColor;
  final Color? textColor;


  const VideoOffView(
      {super.key,
      required this.users,
      required this.isRemote,
      this.height,
      this.width,
      this.fontSize, required this.imageBaseUrl, this.backGroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          isRemote ? ChatHelpers.transparent : backGroundColor ?? ChatHelpers.mainColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle,
              color:  backGroundColor ?? ChatHelpers.backcolor,
            ),
              child: ProfileImageView(
                textColor: Get.find<ChatServices>().chatArguments.themeArguments?.colorArguments?.textColor,
                boxColor: Get.find<ChatServices>().chatArguments.themeArguments?.colorArguments?.mainColor,
            profileImage: users.signInType == SignType.google.name
                ? users.profileImage ?? ""
                : imageBaseUrl + (users.profileImage ?? ""),
            profileName: users.profileName?.isNotEmpty ?? false ? users.profileName![0] : "",
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
                textColor ?? ChatHelpers.white),
          )
        ],
      ),
    );
  }
}
