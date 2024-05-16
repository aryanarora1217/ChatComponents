import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:flutter/material.dart';

class DateView extends StatelessWidget {
  final String date;
  const DateView({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeDefault,vertical: ChatHelpers.marginSizeExtraSmall-1),
        margin: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeDefault,vertical: ChatHelpers.marginSizeSmall),
        decoration: BoxDecoration(
            color: ChatHelpers.mainColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(ChatHelpers.roundButtonRadius)
        ),
        child: Text(
          date,
          textAlign: TextAlign.center,
          style: ChatHelpers.instance.styleRegular(ChatHelpers.fontSizeSmall, ChatHelpers.white),
        ),
      ),
    );
  }
}
