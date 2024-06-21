import 'package:chatcomponent/chat_components/view/widgets/loader/loader_view.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:chatcomponent/chat_components/view/widgets/toast_view/toast_view.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../model/chatHelper/chat_helper.dart';
import '../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';

class FullScreenVideoPlayer extends StatelessWidget {
  final String file;
  final String imageThumbnail;
  final ChatController chatController;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  RxBool isLoading = true.obs;

  FullScreenVideoPlayer({super.key, required this.file, required this.chatController, required this.imageThumbnail}){
    try{
      isLoading.call(true);
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(file));
      chewieController = ChewieController(videoPlayerController: videoPlayerController!,aspectRatio: 9/16,autoPlay: true,looping: false);
      isLoading.call(false);
    }catch(e){
      logPrint("error in addding videos :$e");
      toastShow(massage: "Error in playing Video", error: true);
      Get.back();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(()=>Positioned(
            child: Hero(
              tag: imageThumbnail,
              key: Key(imageThumbnail),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading.isTrue ?
                const Center(
                  child: LoaderView(size: 40,),
                )
                    : AspectRatio(
                  aspectRatio: 9/16,
                  child: Chewie(
                    controller: chewieController!,
                  ),
                ),
              ),
            ),
          )),
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 5,
              child: IconButton(onPressed: ()=>Get.back(),icon: Icon(Icons.arrow_back_ios , color: chatController.themeArguments?.colorArguments?.backButtonIconColor ?? chatController.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,),)),
        ],
      ),
    );
  }
}
