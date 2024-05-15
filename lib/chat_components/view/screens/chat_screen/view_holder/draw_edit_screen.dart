import 'package:chatcomponent/chat_components/view/widgets/icon_button/icon_button.dart';
import 'package:chatcomponent/chat_components/view_model/controller/chat_screen_controller/draw_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';

import '../../../../model/chatHelper/chat_helper.dart';

class DrawEditScreen extends StatelessWidget {
  const DrawEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DrawEditController controller = Get.put(DrawEditController());

    return Scaffold(
      body: Container(
        color: ChatHelpers.black,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height ,
              width: MediaQuery.of(context).size.width ,
              child: ImagePainter.file(
                controller.image.value,
                controller: controller.imagePainterController,
                showControls: true,
                controlsAtTop: false,
                clearAllIcon: Icon(
                  Icons.refresh_rounded,
                  color: ChatHelpers.black.withOpacity(.7),
                ),
              ),
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: ChatHelpers.marginSizeExtraLarge,
                  ),
                  CircleIconButton(
                    shapeRec: false,
                    height: 50,
                    width: 50,
                    onTap: Get.back,
                    isImage: false,
                    icons: Icons.close,
                    colors: ChatHelpers.white,
                    boxColor: ChatHelpers.mainColor,
                  ),
                  const Spacer(),
                  CircleIconButton(
                      shapeRec: false,
                      height: 50,
                      width: 50,
                      onTap: () => controller.onBackTap(),
                      isImage: false,
                      icons: Icons.check,
                      colors: ChatHelpers.white,
                      boxColor: ChatHelpers.mainColor),
                  const SizedBox(
                    width: ChatHelpers.marginSizeExtraLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
