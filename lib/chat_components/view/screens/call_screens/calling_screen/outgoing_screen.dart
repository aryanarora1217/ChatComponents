import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../model/chatHelper/chat_helper.dart';
import '../../../../view_model/controller/call_controller/outgoing_controller/outgoing_controller.dart';
import '../../../widgets/cricle_image_view/profile_image_view.dart';
import '../../../widgets/icon_button/icon_button.dart';


class OutGoingScreen extends StatelessWidget {
  const OutGoingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OutGoingController controller = Get.put(OutGoingController());
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: ChatHelpers.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              controller.callArguments.themeArguments?.colorArguments?.mainColor ?? ChatHelpers.mainColor,
              controller.callArguments.themeArguments?.colorArguments?.mainColorLight ?? ChatHelpers.mainColorLight,
              controller.callArguments.themeArguments?.colorArguments?.mainColorLight ?? ChatHelpers.grey
            ],
          ),
        ),
        child: Stack(
          children: [
            controller.callArguments.callType == CallType.audioCall.name
                ? const SizedBox()
                : SizedBox(
                    child: CameraAwesomeBuilder.awesome(
                    saveConfig: SaveConfig.photo(
                      mirrorFrontCamera: false,),
                    sensorConfig: SensorConfig.single(
                      aspectRatio: CameraAspectRatios.ratio_4_3,
                      sensor: Sensor.position(SensorPosition.front),
                      zoom: 0.0,),
                    topActionsBuilder: (state) {
                      controller.cameraState = state;
                      return const SizedBox();
                    },
                    middleContentBuilder: (state) => const SizedBox(),
                    bottomActionsBuilder: (state) => const SizedBox(),
                  )),
            Container(
              color: ChatHelpers.transparent,
              padding: EdgeInsets.only(top: statusBarPadding + 30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Obx(() => Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        controller.isIncoming.isTrue
                            ? 'Incoming ${controller.callArguments.callType}'
                            : 'Outgoing ${controller.callArguments.callType}',
                        style: controller.callArguments.themeArguments?.styleArguments?.callNameTextStyles ?? ChatHelpers.instance.styleMedium(
                            ChatHelpers.fontSizeExtraLarge,
                            controller.callArguments.themeArguments?.colorArguments?.textColor ??  ChatHelpers.white),
                      ))),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    controller.callArguments.user.profileName ?? "UserName",
                    style: controller.callArguments.themeArguments?.styleArguments?.callNameTextStyles ?? ChatHelpers.instance.styleMedium(
                        ChatHelpers.fontSizeExtraLarge,
                        controller.callArguments.themeArguments?.colorArguments?.textColor ??  ChatHelpers.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                            height: 200,
                            child: Lottie.asset(ChatHelpers.instance.soundEffectLottie,package: "chatcomponent",)),
                        ProfileImageView(
                          textColor: controller.callArguments.themeArguments?.colorArguments?.textColor,
                          boxColor: controller.callArguments.themeArguments?.colorArguments?.mainColorLight,
                          profileImage: controller.callArguments.user.profileImage == null ? ""
                              : controller.callArguments.user.signInType == SignType.google.name
                              ? controller.callArguments.user.profileImage ?? ""
                              : controller.callArguments.imageBaseUrl + (controller.callArguments.user.profileImage ?? ''),
                          profileName: controller.callArguments.user.profileName?[0].capitalizeFirst.toString(),
                          height: 100,
                          width: 100,
                        ),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => Text(
                    controller.callDetails.value.callStatus ?? "calling",
                    style: controller.callArguments.themeArguments?.styleArguments?.callNameTextStyles ?? ChatHelpers.instance.styleMedium(
                        ChatHelpers.fontSizeExtraLarge,
                        controller.callArguments.themeArguments?.colorArguments?.textColor ?? ChatHelpers.white),
                  ),),
                  const Spacer(),
                  Obx(() => controller.callDetails.value.callStatus !=
                      CallStatus.ended.name ||
                      controller.callDetails.value.callStatus !=
                          CallStatus.rejected.name
                      ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        controller.callArguments.callType ==
                            CallType.videoCall.name
                            ? CircleIconButton(
                          boxColor: ChatHelpers.black
                              .withOpacity(.3),
                          isImage: false,
                          shapeRec: false,
                          onTap: () =>
                              controller.onCameraSwitchTap(
                                  controller.cameraState),
                          icons: Icons.cameraswitch_rounded,
                          colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                          height: 60,
                          width: 60,
                        )
                            : const SizedBox(),
                        CircleIconButton(
                          boxColor: ChatHelpers.black
                              .withOpacity(.3),
                          isImage: true,
                          image: controller.isSpeakerOn.isTrue
                              ? ChatHelpers.instance.speaker
                              : ChatHelpers.instance.speakerOff,
                          shapeRec: false,
                          onTap: () => controller.onSpeakerTap(),
                          colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                        CircleIconButton(
                          boxColor: ChatHelpers.red,
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.onEndCall(),
                          icons: Icons.call_end_rounded,
                          colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                          height: 70,
                          width: 70,
                        ),
                        CircleIconButton(
                          boxColor: ChatHelpers.black
                              .withOpacity(.3),
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.onMicTap(),
                          icons: controller.isMicOn.isTrue
                              ? Icons.mic
                              : Icons.mic_off,
                          colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                        controller.isIncoming.isTrue
                            ? CircleIconButton(
                          boxColor: ChatHelpers.green,
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.ansCall(),
                          icons: Icons.call,
                          colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                          height: 70,
                          width: 70,
                        )
                            : const SizedBox(),
                      ],
                    ),
                  )
                      : Center(
                    child: Text(
                      "Call Ended",
                      style: controller.callArguments.themeArguments?.styleArguments?.callNameTextStyles ?? ChatHelpers.instance.styleMedium(
                          ChatHelpers.fontSizeDefault,
                          controller.callArguments.themeArguments?.colorArguments?.textColor ?? ChatHelpers.white),
                    ),
                  )),
                  const SizedBox(
                    height: 60,
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
