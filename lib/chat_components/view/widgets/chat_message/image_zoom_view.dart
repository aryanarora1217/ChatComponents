import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';


class ViewImageAndPlayVideoScreen extends StatelessWidget {
  final String file;
  TransformationController? transformationController;
  RxInt quarterTurns=4.obs;
  TapDownDetails? doubleTapDetails;
  final ChatController chatController;

  ViewImageAndPlayVideoScreen({super.key,required this.file, required this.chatController}){
    transformationController = TransformationController();
  }

  @override
  Widget build(BuildContext context) {
    void handleDoubleTapDown(TapDownDetails details) {
      doubleTapDetails = details;
    }
    void handleDoubleTap() {
      if (transformationController?.value != Matrix4.identity()) {
        transformationController?.value = Matrix4.identity();
      } else {
        final position = doubleTapDetails!.localPosition;
        transformationController?.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
      }
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(()=>Positioned(
            top: MediaQuery.of(context).size.height * .12,
            child: RotatedBox(
              quarterTurns: quarterTurns.value,
              child: Hero(
                tag: file,
                key: Key(file),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .88,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onDoubleTapDown: handleDoubleTapDown,
                    onDoubleTap: handleDoubleTap,
                    child: InteractiveViewer(
                      transformationController: transformationController,
                      child: Image.network(fit: BoxFit.fill,file,),
                    ),
                  ),
                ),
              ),
            ),
          )),
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 5,
              child: IconButton(
                  onPressed: () {
                    if(quarterTurns.value==4){
                      quarterTurns.value=1;
                    }else{
                      quarterTurns.value=4;
                    }
                  },
                  icon: Icon(
                    Icons.rotate_left_outlined,
                    color: chatController.themeArguments?.colorArguments?.iconColor ?? Colors.white,
                    size: 30,
                  ))),
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 5,
              child: IconButton(onPressed: ()=>Get.back(),icon: Icon(Icons.arrow_back_ios , color: chatController.themeArguments?.colorArguments?.backButtonIconColor ?? chatController.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,),)),
        ],
      ),
    );
  }
}
