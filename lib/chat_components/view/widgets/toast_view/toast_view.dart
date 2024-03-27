import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/chatHelper/chat_helper.dart';


toastShow({required String massage,required bool error}){
  showFlash(
    context: Get.context!,
    duration: const Duration(seconds: 2),
    builder: (_, c) {
      return Flash(
        controller: c,
        barrierDismissible: false,
        alignment: Alignment.bottomCenter,
        borderRadius: BorderRadius.circular(ChatHelpers.marginSizeExtraLarge),
        backgroundColor: error? ChatHelpers.red : ChatHelpers.mainColor,
        margin: const EdgeInsets.symmetric(horizontal: ChatHelpers.cornerRadius, vertical: ChatHelpers.marginSizeExtraLarge),
        child: FlashBar(
          padding: const EdgeInsets.symmetric(vertical: ChatHelpers.marginSizeSmall-2),
          content: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: ChatHelpers.marginSizeDefault),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ChatHelpers.cornerRadius),
                color:error?ChatHelpers.red: ChatHelpers.mainColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ChatHelpers.instance.logo,height: ChatHelpers.iconSizeSmall,package: "chatcomponent",),
                const SizedBox(width: 10,),
                Text(
                  massage ,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ChatHelpers.white,fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}