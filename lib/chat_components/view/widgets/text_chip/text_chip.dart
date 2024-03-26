import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/chatHelper/chat_helper.dart';

class TextChip extends StatelessWidget {
  final VoidCallback tap;
  final String message;

  const TextChip({super.key, required this.tap, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
        decoration: ChatHelpers.instance.chipDecoration(),
        child: InkWell(
          onTap: tap,
          child: Padding(
            padding: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
            child: Center(
              child: Text(message.capitalizeFirst ?? "",
                  style: ChatHelpers.instance.styleRegular(
                      ChatHelpers.fontSizeDefault, ChatHelpers.black)),
            ),
          ),
        ));
  }
}
