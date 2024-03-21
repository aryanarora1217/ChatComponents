
import 'package:flutter/material.dart';
import '../../../model/chatHelper/chat_helper.dart';


class CircleIconButton extends StatelessWidget {
  final bool isImage;
  final bool? isImageText;
  final IconData? icons;
  final String? image;
  final bool? shapeRec;
  final VoidCallback onTap;
  final Color? colors;
  final Color? boxColor;
  final Color? splashColor;
  final double? height;
  final double? width;
  final double? padding;
  final Widget? sendBtn;

  const CircleIconButton(
      {super.key,
      this.isImageText,
      this.icons,
        this.sendBtn,
      required this.onTap,
      this.colors,
      this.height,
      this.width,
      this.splashColor,
      this.shapeRec,
      this.image,
      required this.isImage,
      this.boxColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return shapeRec == false
        ? InkWell(
         borderRadius: BorderRadius.circular(ChatHelpers.roundButtonRadius),
          splashColor: splashColor ?? ChatHelpers.textColor_4,
          onTap: onTap,
          child: Container(
            height: height ?? ChatHelpers.iconSizeExtraLarge,
            width: width ?? ChatHelpers.iconSizeExtraLarge,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: boxColor ?? ChatHelpers.mainColorLight,
              ),
            padding: EdgeInsets.all(padding??ChatHelpers.marginSizeExtraSmall),
            child: ClipOval(
                child: Material(
                  color: ChatHelpers.transparent,
                  child: isImage == true
                      ? isImageText ?? false
                          ? Text(
                              image ?? "",style: const TextStyle(fontSize: ChatHelpers.fontSizeExtraLarge),textAlign: TextAlign.center,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(
                                  ChatHelpers.marginSizeDefault),
                              child: Image.asset(
                                image ?? "",
                                color: colors,
                                fit: BoxFit.fill,
                              ),
                            )
                      : Icon(
                          icons,
                          color: colors ?? ChatHelpers.textColor_4,
                        ),
                ),
              ),
          ),
        )
        : InkWell(
      borderRadius: BorderRadius.circular(ChatHelpers.roundButtonRadius),
      splashColor: splashColor ?? ChatHelpers.mainColorLight,
          onTap: onTap,
          child: sendBtn ?? ClipRRect(
            borderRadius:
                  BorderRadius.circular(ChatHelpers.cornerRadius),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: boxColor ?? ChatHelpers.mainColorLight,
                  borderRadius:
                      BorderRadius.circular(ChatHelpers.cornerRadius),
                ),
              height: height ?? ChatHelpers.iconSizeExtraLarge,
              width: width ?? ChatHelpers.iconSizeExtraLarge,
              padding: EdgeInsets.all(padding??ChatHelpers.marginSizeExtraSmall),
              child: Material(
                  color: ChatHelpers.transparent,
                  child: isImage == true
                      ? isImageText ?? false
                          ? Text(
                              image ?? "",
                            )
                          : Image.asset(
                              image ?? "",
                              height: 10,
                              width: 10,
                              color: colors,
                            )
                      : Icon(
                          icons,
                          color: colors ?? ChatHelpers.textColor_4,
                        ),
                ),
            ),
          ),
        );
  }
}
