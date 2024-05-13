import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/view/widgets/image_view/image_view.dart';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:chatcomponent/chat_components/view_model/controller/chat_screen_controller/camera_screen_controller.dart';
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
      body: Obx(() {
        logPrint("is cropped value and ${controller.isCropped.value}  , ${controller.cropImageList} ,${controller.imageList} ");
        return controller.isCameraVisible.isTrue ?
        controller.isLoading.isFalse
            ? Column(
          children: [
            Stack(
              children: [
                Container(
                  color: ChatHelpers.black,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .85,
                  // child: CameraAwesomeBuilder.awesome(
                  //   saveConfig: SaveConfig.photo(
                  //     mirrorFrontCamera: false,
                  //   ),
                  //   sensorConfig: SensorConfig.single(
                  //     aspectRatio: CameraAspectRatios.ratio_16_9,
                  //     sensor: Sensor.position(SensorPosition.front),
                  //     zoom: 0.0,
                  //   ),
                  //   topActionsBuilder: (state) {
                  //     controller.cameraState = state;
                  //     return const SizedBox();
                  //   },
                  //   middleContentBuilder: (state) => const SizedBox(),
                  //   bottomActionsBuilder: (state) {
                  //     controller.cameraState = state;
                  //     return AwesomeBottomActions(
                  //       state: state,
                  //       left: AwesomeFlashButton(
                  //         state: state,
                  //       ),
                  //       captureButton: AwesomeCaptureButton(state: state),
                  //       right: AwesomeCameraSwitchButton(
                  //           state: state,
                  //           scale: 1.0,
                  //           onSwitchTap: (state) =>
                  //               controller.onCameraSwitchTap(state)),
                  //     );
                  //   },
                  // )),
                  child:
                  FutureBuilder<void>(
                    future: controller.initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(controller.cameraController);
                      } else {
                        return const Center(child: LoaderView(loaderColor: ChatHelpers.mainColor,));
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.width * .2,
                    color: ChatHelpers.black.withOpacity(.4),
                    width: MediaQuery.of(context).size.width,
                    child: controller.imageList.isEmpty ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleIconButton(
                          boxColor: ChatHelpers.grey.withOpacity(.4),
                          isImage: false,
                          shapeRec: false,
                          onTap: () =>
                              controller.onCameraSwitchTap(),
                          icons: Icons.cameraswitch_rounded,
                          colors: ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                        CircleIconButton(
                          boxColor: ChatHelpers.white,
                          isImage: false,
                          shapeRec: false,
                          splashColor: ChatHelpers.grey.withOpacity(.4),
                          onTap: () async => await controller.clickImage(context),
                          icons: null,
                          height: 70,
                          width: 70,
                        ),
                        CircleIconButton(
                          boxColor: ChatHelpers.grey.withOpacity(.4),
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.onSetFlashModeButtonPressed(controller.cameraController.value.flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch),
                          icons: controller.isFlashOn.isTrue ? Icons.flash_on : Icons.flash_off,
                          colors: ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ) : Center(
                      child: CircleIconButton(
                        boxColor: ChatHelpers.grey.withOpacity(.4),
                        isImage: false,
                        shapeRec: false,
                        onTap: () =>
                            controller.onTapSelectImages(),
                        icons: Icons.chevron_right_rounded,
                        colors: ChatHelpers.white,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: ChatHelpers.marginSizeExtraSmall,
            ),
            ImageView(
              height: MediaQuery.of(context).size.width * .2,
              width: MediaQuery.of(context).size.width * .2,
              mediaList: controller.mediaList, controller: controller,
            ),
          ],
        )
            : const Center(child: LoaderView(loaderColor: ChatHelpers.mainColor,),)
            : Container(
               height:  MediaQuery.of(context).size.height,
               width:  MediaQuery.of(context).size.width,
               color: ChatHelpers.black,
               padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
               child: controller.imageList.isNotEmpty
                   ?  ListView(
                 shrinkWrap: true,
                 scrollDirection: Axis.horizontal,
                 physics: const NeverScrollableScrollPhysics(),
                 children: [
                   ...List.generate( controller.isCropped.isTrue ? controller.cropImageList.length
                       : controller.imageList.length, (index) =>
                       SizedBox(
                         height: MediaQuery.of(context).size.height,
                         width:  MediaQuery.of(context).size.width,
                         child: Stack(
                           children: [
                             Positioned(
                                 bottom: 0,
                                 left: 0,
                                 right: 0,
                                 child: SizedBox(
                                   height:  MediaQuery.of(context).size.height,
                                   width:  MediaQuery.of(context).size.width,
                                   child: Image.file(
                                     File(controller.isCropped.isTrue ? controller.cropImageList[controller.selectedImageIndex.value].path  : controller.imageList[controller.selectedImageIndex.value].path),
                                     fit: BoxFit.fitWidth,
                                   ),
                                 )),
                             Positioned(
                                 child: Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(ChatHelpers.marginSizeDefault),
                                       child: CircleIconButton(height: 50,width: 50,onTap: () => controller.cropImage(index), isImage: false,icons: Icons.crop,boxColor: ChatHelpers.mainColor,colors: ChatHelpers.white,shapeRec: false,),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(ChatHelpers.marginSizeDefault),
                                       child: CircleIconButton(height: 50,width: 50,onTap: () => controller.drawImage(index), isImage: true,image: ChatHelpers.instance.scribbleIcon,isImageText: false, boxColor: ChatHelpers.mainColor,colors: ChatHelpers.white,shapeRec: false,padding: 0,),
                                     ),
                                   ],)),
                             Positioned(
                               top: controller.imageList.length == 1 ? MediaQuery.of(context).size.height * .88 - MediaQuery.of(context).viewInsets.bottom  : MediaQuery.of(context).size.height * .79 - MediaQuery.of(context).viewInsets.bottom,
                               child: Container(
                                 width: MediaQuery.of(context).size.width,
                                 height: MediaQuery.of(context).size.width,
                                 color: ChatHelpers.black.withOpacity(.4),
                               ),
                             ),
                             controller.imageList.length == 1 || controller.imageList.isEmpty ? const  SizedBox()  : Positioned(
                               top: MediaQuery.of(context).size.height * .8 - MediaQuery.of(context).viewInsets.bottom,
                               left: MediaQuery.of(context).size.width * .05,
                               right: MediaQuery.of(context).size.width * .05,
                               child: Container(
                                 height: 50,
                                 alignment: Alignment.center,
                                 child: ListView(
                                   shrinkWrap: true,
                                   scrollDirection: Axis.horizontal,
                                   children: List.generate(controller.imageList.length, (index) => GestureDetector(
                                     onTap: () => controller.selectedImageIndex.value = index,
                                     child: Container(
                                       height: 50,
                                       width: 50,
                                       color: controller.selectedImageIndex.value == index ? ChatHelpers.mainColorLight : ChatHelpers.white  ,
                                       padding: const EdgeInsets.all(2),
                                       margin: const EdgeInsets.symmetric(horizontal: 2),
                                       child: FadeInImage(
                                           fit: BoxFit.cover,
                                           placeholder: MemoryImage(kTransparentImage),
                                           image: FileImage(File(controller.imageList[index].path),)
                                       ),
                                     ),
                                   )),
                                 ),
                               ),
                             ),
                             Positioned(
                               bottom: 10+MediaQuery.of(context).viewInsets.bottom,
                               child: SizedBox(
                                 width: MediaQuery
                                     .of(context)
                                     .size
                                     .width,
                                 child: Row(
                                   children: [
                                     MessageField(
                                       onChange: (String? value) {
                                         return value;
                                       },
                                       height: 50,
                                       width: MediaQuery
                                           .of(context)
                                           .size
                                           .width *
                                           0.80,
                                       controller: controller
                                           .messageControllerList[controller.selectedImageIndex.value],
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
                                     const SizedBox(
                                       width: ChatHelpers.marginSizeExtraSmall,
                                     )
                                   ],
                                 ),
                               ),
                             ),

                           ],
                         ),
                       )),
                   ...List.generate( controller.isCropped.isTrue ? controller.cropImageList.length : controller.imageList.length, (index) =>
                       SizedBox(
                         height: MediaQuery.of(context).size.height,
                         width:  MediaQuery.of(context).size.width,
                         child: Stack(
                           children: [
                             Positioned(
                                 bottom: 0,
                                 top: 0,
                                 left: 0,
                                 right: 0,
                                 child: Image.file(
                                   height:  MediaQuery.of(context).size.height,
                                   width:  MediaQuery.of(context).size.width,
                                   File(controller.isCropped.isTrue ? controller.cropImageList[controller.selectedImageIndex.value].path  : controller.imageList[controller.selectedImageIndex.value].path),
                                   fit: BoxFit.fill,
                                 )),
                             Positioned(
                                 child: Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(ChatHelpers.marginSizeDefault),
                                       child: CircleIconButton(height: 50,width: 50,onTap: () => controller.cropImage(index), isImage: false,icons: Icons.crop,boxColor: ChatHelpers.mainColor,colors: ChatHelpers.white,shapeRec: false,),
                                     )
                                   ],)),
                             Positioned(
                               top: controller.imageList.length == 1 ? MediaQuery.of(context).size.height * .88 - MediaQuery.of(context).viewInsets.bottom  : MediaQuery.of(context).size.height * .79 - MediaQuery.of(context).viewInsets.bottom,
                               child: Container(
                                 width: MediaQuery.of(context).size.width,
                                 height: MediaQuery.of(context).size.width,
                                 color: ChatHelpers.black.withOpacity(.4),
                               ),
                             ),
                             controller.imageList.length == 1 || controller.imageList.isEmpty ? const  SizedBox()  : Positioned(
                               top: MediaQuery.of(context).size.height * .8 - MediaQuery.of(context).viewInsets.bottom,
                               left: MediaQuery.of(context).size.width * .05,
                               right: MediaQuery.of(context).size.width * .05,
                               child: Container(
                                 height: 50,
                                 alignment: Alignment.center,
                                 child: ListView(
                                   shrinkWrap: true,
                                   scrollDirection: Axis.horizontal,
                                   children: List.generate(controller.imageList.length, (index) => GestureDetector(
                                     onTap: () => controller.selectedImageIndex.value = index,
                                     child: Container(
                                       height: 50,
                                       width: 50,
                                       color: controller.selectedImageIndex.value == index ? ChatHelpers.mainColorLight : ChatHelpers.white  ,
                                       padding: const EdgeInsets.all(2),
                                       margin: const EdgeInsets.symmetric(horizontal: 2),
                                       child: FadeInImage(
                                           fit: BoxFit.cover,
                                           placeholder: MemoryImage(kTransparentImage),
                                           image: FileImage(File(controller.imageList[index].path),)
                                       ),
                                     ),
                                   )),
                                 ),
                               ),
                             ),
                             Positioned(
                               bottom: 10+MediaQuery.of(context).viewInsets.bottom,
                               child: SizedBox(
                                 width: MediaQuery
                                     .of(context)
                                     .size
                                     .width,
                                 child: Row(
                                   children: [
                                     MessageField(
                                       onChange: (String? value) {
                                         return value;
                                       },
                                       height: 50,
                                       width: MediaQuery
                                           .of(context)
                                           .size
                                           .width *
                                           0.80,
                                       controller: controller
                                           .messageControllerList[controller.selectedImageIndex.value],
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
                                     const SizedBox(
                                       width: ChatHelpers.marginSizeExtraSmall,
                                     )
                                   ],
                                 ),
                               ),
                             ),

                           ],
                         ),
                       )),
                 ],
               )
                   : const Center(child: LoaderView(loaderColor: ChatHelpers.mainColor,)),
                    );
      }
      ),
    );
  }
}
