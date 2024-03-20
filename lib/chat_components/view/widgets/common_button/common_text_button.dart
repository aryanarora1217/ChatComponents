import 'package:flutter/material.dart';

import '../../../model/chatHelper/chat_helper.dart';

class CommonTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color colors;
  final FontWeight? weight;
  final double? fontSize;

  const CommonTextButton(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.colors,
      this.fontSize,
      this.weight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        title,
        style: ChatHelpers.instance
            .styleRegular(ChatHelpers.fontSizeDefault, colors),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color colors;
  final Color fillColor;
  final FontWeight? weight;
  final double? fontSize;
  final double? width;
  final bool loading;
  final bool? isIcon;
  final String? image;
  final bool? isMargin;

  const CommonButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.colors,
    required this.fillColor,
    this.weight,
    this.fontSize,
    this.width,
    required this.loading,
    this.isIcon,
    this.image,
    this.isMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        height: 50,
        margin: const EdgeInsets.symmetric(
            horizontal: ChatHelpers.marginSizeExtraLarge),
        decoration: ChatHelpers.instance.buttonBoxDecoration(fillColor),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(ChatHelpers.roundButtonRadius),
          child: MaterialButton(
              onPressed: onPressed,
              child: Center(
                  child: loading == true
                      ? const CircularProgressIndicator(
                          color: ChatHelpers.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isIcon == true
                                ? Image.asset(
                                    image ?? '',
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              title,
                              style: ChatHelpers.instance.styleRegular(
                                  ChatHelpers.fontSizeLarge, colors),
                            ),
                          ],
                        ))),
        ));
  }
}

class CommonButtonIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color colors;
  final Color? fillColor;
  final Color? borderColor;
  final FontWeight? weight;
  final double? fontSize;
  final double? width;
  final double? height;
  final bool loading;
  final bool? isIcon;
  final String? image;
  final double? margin;

  const CommonButtonIcon(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.colors,
      this.fillColor,
      this.weight,
      this.fontSize,
      this.width,
      required this.loading,
      this.isIcon,
      this.image,
      this.margin,
      this.borderColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
            horizontal: margin ?? ChatHelpers.marginSizeExtraLarge),
      width: width ?? MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: fillColor??ChatHelpers.backcolor,
          borderRadius:
              BorderRadius.circular(ChatHelpers.roundButtonRadius),
        ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(ChatHelpers.roundButtonRadius),
        child: MaterialButton(
          onPressed: onPressed,
          splashColor: ChatHelpers.white.withOpacity(.3),
          child: loading
                ? const Padding(
                  padding: EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                  child:  CircularProgressIndicator(
                      color: ChatHelpers.mainColorLight,
                    ),
                )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isIcon == true
                            ? Image.asset(
                                image ?? '',
                                height: 30,
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          title,
                          style: ChatHelpers.instance.styleRegular(
                              ChatHelpers.fontSizeDefault, colors),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}

class CommonIconVBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String? title;
  final FontWeight? weight;
  final double? fontSize;
  final double? iconSize;
  final double? height;
  final double? width;
  final IconData icons;
  final Color? color;

  const CommonIconVBtn(
      {super.key,
      required this.onPressed,
      this.title,
      this.weight,
      this.fontSize,
      this.height,
      this.width,
      required this.icons,
      this.iconSize,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      color: ChatHelpers.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons,
                color: color ?? ChatHelpers.black,
                size: iconSize,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title ?? "",
                style: ChatHelpers.instance.styleRegular(
                    ChatHelpers.fontSizeDefault, ChatHelpers.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
