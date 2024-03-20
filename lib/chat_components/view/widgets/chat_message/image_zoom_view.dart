import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';



class ViewImageAndPlayVideoScreen extends StatelessWidget {
  final String file;
  TransformationController ?transformationController;
  RxInt quarterTurns=4.obs;
  TapDownDetails? doubleTapDetails;
  final ChatController chatController;

  ViewImageAndPlayVideoScreen({super.key,required this.file, required this.chatController}){
    transformationController=TransformationController();
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
          Obx(()=>RotatedBox(
            quarterTurns: quarterTurns.value,
            child: Hero(
              tag: file,
              key: Key(file),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                  onDoubleTapDown: handleDoubleTapDown,
                  onDoubleTap: handleDoubleTap,
                  child: InteractiveViewer(
                    transformationController: transformationController,
                    child: Image.network(fit: BoxFit.contain,  chatController.imageBaseUrl+file,),
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
                  icon:const Icon(
                    Icons.rotate_left_outlined,
                    color: Colors.white,
                    size: 30,
                  ))),
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 5,
              child: IconButton(onPressed: ()=>Get.back(),icon: Icon(Icons.arrow_back_ios , color: ChatHelpers.white,),)),
        ],
      ),
    );
  }
}
