import 'package:flutter/material.dart';

import '../../../model/chatHelper/chat_helper.dart';

class MessageField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixValue;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final FocusNode? focus;
  final bool? isFocused;
  final int maxLines;
  final double? height;
  final double? width;
  final double? focusedRadius;
  final double? unFocusedRadius;
  final Color? focusedColors;
  final Color? unFocusedColor;
  final String? Function(String?) onChange;
  final String? Function(String?) onValidators;

  const MessageField({super.key, required this.controller, required this.hintText, this.hintTextStyle, required this.onValidators, this.focus, this.suffixValue, this.height, this.width, required this.onChange, required this.maxLines, this.focusedColors, this.unFocusedColor, this.focusedRadius, this.unFocusedRadius, this.textStyle, this.isFocused = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ChatHelpers.marginSizeSmall),
        decoration: isFocused == false ? focus?.hasFocus == true ? ChatHelpers.instance.focusedMessageFieldRadius(focusedColors ?? ChatHelpers.mainColorLight, focusedRadius ?? ChatHelpers.cornerRadius) : ChatHelpers.instance.borderMessageFieldRadius(unFocusedColor ?? ChatHelpers.textColor_4, unFocusedRadius ?? ChatHelpers.cornerRadius) : ChatHelpers.instance.focusedMessageFieldRadius(focusedColors ?? ChatHelpers.mainColorLight, focusedRadius ?? ChatHelpers.cornerRadius),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 80.0,
                    minHeight: 50
                ),
                child: TextFormField(
                  onChanged: onChange,
                  focusNode: focus,
                  validator: onValidators,
                  controller: controller,
                  minLines: null,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: textStyle ?? ChatHelpers.instance.styleRegular(ChatHelpers.fontSizeDefault, ChatHelpers.black),
                  decoration:  InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 12),
                    hintText: hintText,
                    counterText: "",
                    filled: true,
                    fillColor: ChatHelpers.transparent,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorStyle: ChatHelpers.instance.styleRegular(ChatHelpers.fontSizeDefault, ChatHelpers.red),
                    hintStyle: hintTextStyle ?? const  TextStyle(color:  ChatHelpers.textColor_4, fontSize: ChatHelpers.fontSizeDefault),
                  ),
                ),
              ),
            ),
            suffixValue ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}
