import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:flutter/material.dart';
import '../common_button/common_text_button.dart';

class EmptyDataView extends StatelessWidget {
  final String title;
  final String? buttonText;
  final bool isButton;
  final double? spacing;
  final VoidCallback? onTap;
  final String image;
  const EmptyDataView({super.key, required this.title, this.spacing, this.buttonText,required this.isButton, this.onTap, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,fit: BoxFit.fill,height: MediaQuery.of(context).size.width * .7,package: "chatcomponent",),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeExtraLarge),
            child: Text(title,style: ChatHelpers.instance.styleRegular(ChatHelpers.fontSizeDefault, ChatHelpers.textColor_4),textAlign: TextAlign.center,),
          ),
          isButton ? const SizedBox(height: 30,):const SizedBox(),
          isButton ? CommonButton(onPressed: onTap ?? (){}, title: buttonText??"", colors: ChatHelpers.white, fillColor: ChatHelpers.mainColor, loading: false) : const SizedBox(),
          SizedBox(height: spacing??80,),
        ],
      ),
    );
  }
}
