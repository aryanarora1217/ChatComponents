import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/chatHelper/chat_helper.dart';
import '../../../../model/function_helper/date_time_convertor/date_time_convertor.dart';
import '../../../../view_model/controller/call_controller/agora_controllers/video_call_controller.dart';
import '../../../widgets/icon_button/icon_button.dart';
import '../../../widgets/video_off_view/video_off_view.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VideoCallController controller = Get.put(VideoCallController());
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: ChatHelpers.transparent,
      body: Container(
          decoration:  BoxDecoration(
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
          padding: EdgeInsets.only(top: statusBarPadding),
          child: Stack(
            children: [
              Obx(() => _remoteVideo(controller)),
              Align(
                alignment: Alignment.topLeft,
                child: Obx(() => Container(
                    margin: const EdgeInsets.only(
                        left: ChatHelpers.marginSizeDefault,
                        top: ChatHelpers.marginSizeDefault),
                    width: 130,
                    height: 180,
                    decoration: BoxDecoration(
                        color: controller.isVideoOn.isFalse
                            ? controller.callArguments.themeArguments?.colorArguments?.mainColorLight ?? ChatHelpers.mainColorLight
                            : ChatHelpers.transparent,
                        borderRadius: BorderRadius.circular(ChatHelpers.cornerRadius)),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ChatHelpers.cornerRadius),
                      child: controller.isVideoOn.isTrue
                          ? AgoraVideoView(
                              controller: VideoViewController(
                                  rtcEngine: controller.agoraRtcEngine,
                                  canvas: const VideoCanvas(uid: 0)))
                          : Center(
                              child: VideoOffView(
                                backGroundColor: controller.callArguments.themeArguments?.colorArguments?.mainColorLight,
                                textColor: controller.callArguments.themeArguments?.colorArguments?.textColor,
                                isRemote: false,
                                users: controller.callArguments.currentUser, imageBaseUrl: controller.callArguments.imageBaseUrl,
                              ),
                            ),
                    ))),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
                  padding: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
                  decoration: BoxDecoration(
                    color: controller.callArguments.themeArguments?.colorArguments?.mainColorLight ?? ChatHelpers.mainColorLight,
                    borderRadius: BorderRadius.circular(ChatHelpers.buttonRadius)
                  ),
                  child: Obx(()=> Text(
                    DateTimeConvertor.formattedTime(
                        timeInSecond: controller.start.value),
                    style: ChatHelpers.instance.styleRegular(ChatHelpers.fontSizeSmall, controller.callArguments.themeArguments?.colorArguments?.textColor ?? ChatHelpers.white),)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: ChatHelpers.marginSizeExtraLarge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleIconButton(
                        shapeRec: false,
                        boxColor: ChatHelpers.red,
                        isImage: false,
                        onTap: () => controller.endCall(false),
                        icons: Icons.call_end_rounded,
                        colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                        height: 65,
                        width: 65,
                      ),
                    ),
                    Obx(() => Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleIconButton(
                        shapeRec: false,
                        boxColor: ChatHelpers.black
                            .withOpacity(.3),
                        isImage: false,
                        onTap: () => controller.onMicTap(),
                        icons: controller.isMicOn.isTrue
                            ? Icons.mic
                            : Icons.mic_off,
                        colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                        height: 60,
                        width: 60,
                      ),
                    )),
                    Obx(() => Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleIconButton(
                        boxColor: ChatHelpers.black
                            .withOpacity(.3),
                        isImage: false,
                        shapeRec: false,
                        onTap: () => controller.onVideoTap(),
                        icons: controller.isVideoOn.isTrue
                            ? Icons.videocam
                            : Icons.videocam_off_rounded,
                        colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                        height: 60,
                        width: 60,
                      ),
                    )),
                    Obx(() => Align(
                      alignment: Alignment.bottomCenter,
                      child: CircleIconButton(
                        boxColor: ChatHelpers.black
                            .withOpacity(.3),
                        isImage: true,
                        shapeRec: false,
                        onTap: () => controller.onSpeakerTap(),
                        image: controller.isSpeakerOn.isTrue
                            ? ChatHelpers.instance.speaker
                            : ChatHelpers.instance.speakerOff,
                        colors: controller.callArguments.themeArguments?.colorArguments?.iconColor ?? ChatHelpers.white,
                        height: 60,
                        width: 60,
                      ),
                    )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

Widget _remoteVideo(VideoCallController controller) {
  if (controller.remoteUid.value != 0) {
    return controller.isUserVideoOn.isFalse
        ? AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: controller.agoraRtcEngine,
              canvas: VideoCanvas(uid: controller.remoteUid.value),
              connection: RtcConnection(channelId: controller.callArguments.agoraChannelName),
            ),
          )
        : Center(
            child: VideoOffView(
              backGroundColor: controller.callArguments.themeArguments?.colorArguments?.mainColorLight,
              textColor: controller.callArguments.themeArguments?.colorArguments?.textColor,
              imageBaseUrl: controller.callArguments.imageBaseUrl,
              height: 100,
              width: 100,
              isRemote: true,
              fontSize: ChatHelpers.fontSizeDoubleExtraLarge,
              users: controller.callArguments.user,
          ));
  } else {
    return Center(
      child: Text(
        'User Connecting ...',
        style: ChatHelpers.instance.styleMedium(
            ChatHelpers.marginSizeDefault, ChatHelpers.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
