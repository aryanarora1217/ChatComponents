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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              ChatHelpers.mainColor,
              ChatHelpers.mainColorLight,
              ChatHelpers.grey
            ],
          ),
        ),
        child: Stack(
          children: [
            controller.callType == CallType.audioCall.name
                ? const SizedBox()
                : SizedBox(
                    child: CameraAwesomeBuilder.awesome(
                    saveConfig: SaveConfig.photo(
                      mirrorFrontCamera: false,
                    ),
                    sensorConfig: SensorConfig.single(
                      aspectRatio: CameraAspectRatios.ratio_4_3,
                      sensor: Sensor.position(SensorPosition.front),
                      zoom: 0.0,
                    ),
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
                            ? 'Incoming ${controller.callType}'
                            : 'Outgoing ${controller.callType}',
                        style: ChatHelpers.instance.styleMedium(
                            ChatHelpers.fontSizeExtraLarge,
                            ChatHelpers.white),
                      ))),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    controller.userDetails.value.profileName ?? "UserName",
                    style: ChatHelpers.instance.styleMedium(
                        ChatHelpers.fontSizeExtraLarge,
                        ChatHelpers.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                            height: 200,
                            child: Lottie.asset(ChatHelpers
                                .instance.soundEffectLottie)),
                        ProfileImageView(
                          profileImage:
                          controller.userDetails.value.profileImage == null
                              ? ""
                              : controller.userDetails.value.signInType ==
                              SignType.google.name
                              ? controller
                              .userDetails.value.profileImage ??
                              ""
                              : controller.imageBaseUrl +
                              (controller.userDetails
                                  .value.profileImage ??
                                  ''),
                          profileName: controller
                              .userDetails.value.profileName?[0].capitalizeFirst
                              .toString(),
                          height: 100,
                          width: 100,
                        ),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => Text(
                    controller.callDetails.value.callStatus ?? "calling",
                    style: ChatHelpers.instance.styleMedium(
                        ChatHelpers.fontSizeExtraLarge,
                        ChatHelpers.white),
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
                        controller.callType ==
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
                          colors: ChatHelpers.white,
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
                          colors: ChatHelpers.white,
                          height: 60,
                          width: 60,
                        ),
                        CircleIconButton(
                          boxColor: ChatHelpers.red,
                          isImage: false,
                          shapeRec: false,
                          onTap: () => controller.onEndCall(),
                          icons: Icons.call_end_rounded,
                          colors: ChatHelpers.white,
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
                          colors: ChatHelpers.white,
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
                          colors: ChatHelpers.white,
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
                      style: ChatHelpers.instance.styleMedium(
                          ChatHelpers.fontSizeDefault,
                          ChatHelpers.white),
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
