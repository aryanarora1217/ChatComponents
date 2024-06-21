import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/model/function_helper/debounce_function.dart';
import 'package:chatcomponent/chat_components/view/widgets/image_view/image_view.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:chatcomponent/chat_components/view_model/controller/chat_screen_controller/camera_screen_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../widgets/icon_button/icon_button.dart';
import '../../../widgets/loader/loader_view.dart';
import '../../../widgets/message_box_field/message_box_field.dart';


class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CameraScnController controller = Get.put(CameraScnController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ChatHelpers.black,
      body: Obx(
            () => WillPopScope(
          onWillPop: () async {
            if (controller.pageMainIndex.value == 0) {
              return true;
            } else {
              controller.imageList.clear();
              controller.pageViewMainController.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
              controller.isLoading.value = false;
              return false;
            }
          },
          child: controller.isLoading.isTrue
              ? const Center(child: LoaderView(loaderColor: ChatHelpers.mainColor))
              : SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                controller.pageMainIndex.call(value);
              },
              controller: controller.pageViewMainController,
              children: [
                _buildCameraPage(context,controller),
                _buildImageListPage(context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageListPage(BuildContext context, CameraScnController controller) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ChatHelpers.black,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: controller.imageList.isNotEmpty
          ? ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          controller.isCropped.isTrue ? controller.cropImageList.length : controller.imageList.length,
              (index) => SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  bottom: controller.isVideoRecorded.isTrue ? MediaQuery.of(context).size.height * 0.08 : 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: controller.isVideoRecorded.isTrue ? MediaQuery.of(context).size.height * 0.9 : MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: controller.isVideoRecorded.isTrue
                        ? AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Chewie(
                        controller: controller.chewieController,
                      ),
                    )
                        : Image.file(
                      File(
                        controller.isCropped.isTrue
                            ? (controller.cropImageList[controller.selectedImageIndex.value].file?.path ?? "")
                            : (controller.imageList[controller.selectedImageIndex.value].file?.path ?? ""),
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                controller.isVideoRecorded.isTrue
                    ? const SizedBox()
                    : Positioned(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(ChatHelpers.marginSizeDefault),
                        child: CircleIconButton(
                          height: 50,
                          width: 50,
                          onTap: () => controller.cropImage(index),
                          isImage: false,
                          icons: Icons.crop,
                          boxColor: ChatHelpers.mainColor,
                          colors: ChatHelpers.white,
                          shapeRec: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(ChatHelpers.marginSizeDefault),
                        child: CircleIconButton(
                          height: 50,
                          width: 50,
                          onTap: () => controller.drawImage(index),
                          isImage: true,
                          image: ChatHelpers.instance.scribbleIcon,
                          isImageText: false,
                          boxColor: ChatHelpers.mainColor,
                          colors: ChatHelpers.white,
                          shapeRec: false,
                          padding: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: controller.imageList.length == 1
                      ? MediaQuery.of(context).size.height * 0.88 - MediaQuery.of(context).viewInsets.bottom
                      : MediaQuery.of(context).size.height * 0.79 - MediaQuery.of(context).viewInsets.bottom,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    color: ChatHelpers.black.withOpacity(0.4),
                  ),
                ),
                controller.imageList.length == 1 || controller.imageList.isEmpty
                    ? const SizedBox()
                    : Positioned(
                  top: MediaQuery.of(context).size.height * 0.8 - MediaQuery.of(context).viewInsets.bottom,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        controller.imageList.length,
                            (index) => GestureDetector(
                          onTap: () => controller.selectedImageIndex.value = index,
                          child: Container(
                            height: 50,
                            width: 50,
                            color: controller.selectedImageIndex.value == index
                                ? ChatHelpers.mainColorLight
                                : ChatHelpers.white,
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: MemoryImage(kTransparentImage),
                              image: FileImage(File(controller.imageList[index].file?.path ?? "")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        MessageField(
                          onChange: (String? value) {
                            return value;
                          },
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.80,
                          controller: controller.messageControllerList[controller.selectedImageIndex.value],
                          hintText: 'Enter Message',
                          onValidators: (String? value) => null,
                          isFocused: true,
                          maxLines: 5,
                        ),
                        CircleIconButton(
                          height: 50,
                          width: 50,
                          boxColor: ChatHelpers.mainColorLight,
                          isImage: false,
                          icons: Icons.send,
                          colors: ChatHelpers.white,
                          onTap: controller.sendOnTap,
                        ),
                        const SizedBox(width: ChatHelpers.marginSizeExtraSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : const Center(child: LoaderView(loaderColor: ChatHelpers.mainColor)),
    );
  }

  Widget _buildCameraPage(BuildContext context, CameraScnController controller) {
    return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails drag) {
          DebounceHelper.instance.debounceFunction(onDebounceCall: (){
            if (drag.delta.dy > 0) {
              logPrint("flips ");
              controller.onCameraSwitchTap();
            } else if (drag.delta.dy < 0) {
              logPrint("flips ");
              controller.onCameraSwitchTap();
            }
          },duration: const Duration(milliseconds: 250));
        },
      onHorizontalDragUpdate: (DragUpdateDetails drag) {
        DebounceHelper.instance.debounceFunction(onDebounceCall: (){
          if (drag.delta.dx > 0) {
            if(controller.pageCameraIndex.value == 1){
              controller.pageViewCameraController.animateToPage(0, duration: const Duration(milliseconds: 1), curve: Curves.ease);
            }
          } else if (drag.delta.dx < 0) {
            if(controller.pageCameraIndex.value == 0){
              controller.pageViewCameraController.animateToPage(1, duration: const Duration(milliseconds: 1), curve: Curves.ease);
            }
          }
        },duration: const Duration(milliseconds: 250));
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: ChatHelpers.black,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                child: FutureBuilder<void>(
                  future: controller.initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(controller.cameraController);
                    } else {
                      return const Center(child: LoaderView(loaderColor: ChatHelpers.mainColor));
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.2,
            color: ChatHelpers.black.withOpacity(0.4),
            width: MediaQuery.of(context).size.width,
            child: PageView(
              controller: controller.pageViewCameraController,
              onPageChanged: (value) {
                controller.pageCameraIndex.call(value);
              },
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.2,
                    color: ChatHelpers.black.withOpacity(0.4),
                    width: MediaQuery.of(context).size.width,
                    child: controller.imageList.isEmpty
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleIconButton(
                          boxColor: ChatHelpers.grey.withOpacity(0.4),
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.onCameraSwitchTap(),
                          icons: Icons.cameraswitch_rounded,
                          colors: ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                        GestureDetector(
                          onTap: () async => await controller.clickImage(context),
                          onLongPressStart: (details) {
                            logPrint("long press started ");
                            controller.recordVideo();
                          },
                          onLongPressEnd: (details) {
                            logPrint("long press ended ");
                            controller.stopRecording(context);
                          },
                          child: CircleIconButton(
                            boxColor: controller.isStartRecording.value ? ChatHelpers.red : ChatHelpers.white,
                            isImage: false,
                            shapeRec: false,
                            splashColor: ChatHelpers.grey.withOpacity(0.4),
                            onTap: () async => await controller.clickImage(context),
                            icons: null,
                            height: 70,
                            width: 70,
                          ),
                        ),
                        CircleIconButton(
                          boxColor: ChatHelpers.grey.withOpacity(0.4),
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.onSetFlashModeButtonPressed(
                            controller.cameraController.value.flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch,
                          ),
                          icons: controller.isFlashOn.isTrue ? Icons.flash_on : Icons.flash_off,
                          colors: ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    )
                        : Center(
                      child: CircleIconButton(
                        boxColor: ChatHelpers.grey.withOpacity(0.4),
                        isImage: false,
                        shapeRec: false,
                        onTap: () => controller.onTapSelectImages(),
                        icons: Icons.chevron_right_rounded,
                        colors: ChatHelpers.white,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.2,
                  color: ChatHelpers.black.withOpacity(0.4),
                  width: MediaQuery.of(context).size.width,
                  child: controller.imageList.isEmpty
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleIconButton(
                        boxColor: ChatHelpers.grey.withOpacity(0.4),
                        isImage: false,
                        shapeRec: false,
                        onTap: () => controller.onCameraSwitchTap(),
                        icons: Icons.cameraswitch_rounded,
                        colors: ChatHelpers.white,
                        height: 60,
                        width: 60,
                      ),
                      GestureDetector(
                        onTap: () async => controller.isStartRecording.value ? controller.stopRecording(context) : controller.recordVideo(),
                        onLongPressStart: (details) {
                          logPrint("long press started ");
                          controller.recordVideo();
                        },
                        onLongPressEnd: (details) {
                          logPrint("long press ended ");
                          controller.stopRecording(context);
                        },
                        child: Container(
                          padding:  EdgeInsets.all(controller.isStartRecording.value ? ChatHelpers.marginSizeExtraSmall : ChatHelpers.marginSizeDefault),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ChatHelpers.white
                          ),
                          child: CircleIconButton(
                            boxColor: ChatHelpers.red,
                            isImage: false,
                            shapeRec: false,
                            splashColor: ChatHelpers.grey.withOpacity(0.4),
                            onTap: () async => controller.isStartRecording.value ? controller.stopRecording(context) : controller.recordVideo(),
                            icons: null,
                            height: controller.isStartRecording.value ? 60 : 40,
                            width: controller.isStartRecording.value ? 60 : 40,
                          ),
                        ),
                      ),
                      CircleIconButton(
                        boxColor: ChatHelpers.grey.withOpacity(0.4),
                        isImage: false,
                        shapeRec: false,
                        onTap: () => controller.onSetFlashModeButtonPressed(
                          controller.cameraController.value.flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch,
                        ),
                        icons: controller.isFlashOn.isTrue ? Icons.flash_on : Icons.flash_off,
                        colors: ChatHelpers.white,
                        height: 60,
                        width: 60,
                      ),
                    ],
                  )
                      : Center(
                    child: CircleIconButton(
                      boxColor: ChatHelpers.grey.withOpacity(0.4),
                      isImage: false,
                      shapeRec: false,
                      onTap: () => controller.onTapSelectImages(),
                      icons: Icons.chevron_right_rounded,
                      colors: ChatHelpers.white,
                      height: 70,
                      width: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ChatHelpers.marginSizeExtraSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => controller.pageViewCameraController.animateToPage(0,duration: const Duration(milliseconds: 1),curve: Curves.ease),
                child: Container(
                  padding: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
                  decoration: BoxDecoration(
                      color: controller.pageCameraIndex.value == 0 ? ChatHelpers.white : ChatHelpers.transparent,
                      borderRadius: BorderRadius.circular(ChatHelpers.circularImage)
                  ),
                  child: Text("Photo",style: ChatHelpers.instance.styleMedium(ChatHelpers.fontSizeDefault,controller.pageCameraIndex.value == 0 ? ChatHelpers.mainColor : ChatHelpers.white),),
                ),
              ),
              const SizedBox(width: ChatHelpers.marginSizeSmall,),
              GestureDetector(
                onTap: () => controller.pageViewCameraController.animateToPage(1,duration: const Duration(milliseconds: 1),curve: Curves.ease),
                child: Container(
                  padding: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
                  decoration: BoxDecoration(
                      color: controller.pageCameraIndex.value == 1 ? ChatHelpers.white : ChatHelpers.transparent,
                      borderRadius: BorderRadius.circular(ChatHelpers.circularImage)
                  ),
                  child: Text("Video",style: ChatHelpers.instance.styleMedium(ChatHelpers.fontSizeDefault, controller.pageCameraIndex.value == 1 ? ChatHelpers.mainColor : ChatHelpers.white),),
                ),
              )
            ],
          ),
          const SizedBox(height: ChatHelpers.marginSizeExtraSmall),
          ImageListView(
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            mediaList: controller.mediaList,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

