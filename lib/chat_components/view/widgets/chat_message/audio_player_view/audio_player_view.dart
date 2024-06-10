import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/view/widgets/icon_button/icon_button.dart';
import 'package:chatcomponent/chat_components/view/widgets/toast_view/toast_view.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../../../view_model/controller/chat_screen_controller/chat_screen_controller.dart';
import '../../log_print/log_print_condition.dart';
import '../../reaction_view/reaction_view.dart';



/*
// class AudioPlayerView extends StatefulWidget {
//
//   final String time;
//   final int index;
//   final int reaction;
//   final bool isSender;
//   final bool isSeen;
//   final bool visible;
//   final bool isReaction;
//   final List<String> reactionList;
//   final VoidCallback onLongTap;
//   final ChatController chatController;
//   final String audioUrl;
//
//
//    const AudioPlayerView({super.key, required this.audioUrl, required this.time, required this.index, required this.reaction, required this.isSender, required this.isSeen, required this.visible, required this.isReaction, required this.reactionList, required this.onLongTap, required this.chatController});
//
//   @override
//   AudioPlayerViewState createState() => AudioPlayerViewState();
//
//
// }
//
// class AudioPlayerViewState extends State<AudioPlayerView> with WidgetsBindingObserver {
//
//   final player = AudioPlayer();
//
//   bool isLoading = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     ambiguate(WidgetsBinding.instance)!.addObserver(this);
//     _init();
//   }
//
//   @override
//   void didUpdateWidget(AudioPlayerView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _init();
//   }
//
//
//   Future<void> _init() async {
//
//     final session = await AudioSession.instance;
//     await session.configure(const AudioSessionConfiguration.speech());
//     player.playbackEventStream.listen((event) {},
//         onError: (Object e, StackTrace stackTrace) {
//           logPrint('A stream error occurred: $e');
//         });
//     try {
//         await player.setAudioSource(AudioSource.uri(Uri.parse(widget.audioUrl)));
//     } on PlayerException catch (e) {
//       logPrint("Error loading audio source: $e");
//       toastShow(massage: "Audio not found ", error: true);
//     }
//   }
//
//   @override
//   void dispose() {
//     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
//
//     player.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//
//       player.stop();
//     }
//   }
//
//   Stream<PositionData> get _positionDataStream =>
//       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//           player.positionStream,
//           player.bufferedPositionStream,
//           player.durationStream,
//               (position, bufferedPosition, duration) => PositionData(
//               position, bufferedPosition, duration ?? Duration.zero));
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: widget.onLongTap,
//       child: Align(
//         alignment: widget.isSender == true ? Alignment.centerRight : Alignment.centerLeft,
//         child: Column(
//           crossAxisAlignment: widget.isSender == true
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .85, minWidth: 5),
//               child: Stack(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(
//                       left: widget.isSender == true ? ChatHelpers.marginSizeSmall : 0,
//                       right: widget.isSender == true ? 0 : ChatHelpers.marginSizeSmall ,
//                       bottom: widget.reaction != 7 ? 10 : 0,
//                       top: ChatHelpers.marginSizeExtraSmall,
//                     ),
//                     padding: const EdgeInsets.all(
//                         ChatHelpers.paddingSizeSmall),
//                     decoration: BoxDecoration(
//                       color: widget.isSender == true
//                           ? widget.chatController.themeArguments?.colorArguments
//                           ?.senderMessageBoxColor ??
//                           ChatHelpers.mainColor
//                           : widget.chatController.themeArguments?.colorArguments
//                           ?.receiverMessageBoxColor ??
//                           ChatHelpers.backcolor,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: widget.isSender == true
//                             ? Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxSenderBottomLeftRadius ??
//                             ChatHelpers.cornerRadius)
//                             : Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxReceiverBottomLeftRadius ??
//                             ChatHelpers.cornerRadius),
//                         topRight: widget.isSender == true
//                             ? Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxSenderTopRightRadius ??
//                             ChatHelpers.cornerRadius)
//                             : Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxReceiverTopRightRadius ??
//                             ChatHelpers.cornerRadius),
//                         topLeft: widget.isSender == true
//                             ? Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxSenderTopLeftRadius ??
//                             ChatHelpers.cornerRadius)
//                             : Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxReceiverTopLeftRadius ??
//                             ChatHelpers.cornerRadius),
//                         bottomRight: widget.isSender == true
//                             ? Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxSenderBottomRightRadius ??
//                             ChatHelpers.cornerRadius)
//                             : Radius.circular(widget.chatController
//                             .themeArguments
//                             ?.borderRadiusArguments
//                             ?.messageBoxReceiverBottomRightRadius ??
//                             ChatHelpers.cornerRadius),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: widget.isSender
//                           ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           height: 70,
//                           margin: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
//                           padding: const EdgeInsets.symmetric(horizontal:ChatHelpers.marginSizeSmall,vertical: ChatHelpers.marginSizeSmall),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
//                            color: ChatHelpers.mainColorLight,
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Expanded(
//                                 child: StreamBuilder<PositionData>(
//                                   stream: _positionDataStream,
//                                   builder: (context, snapshot) {
//                                     final positionData = snapshot.data;
//                                     return SeekBar(
//                                       duration: positionData?.duration ?? Duration.zero,
//                                       position: positionData?.position ?? Duration.zero,
//                                       bufferedPosition:
//                                       positionData?.bufferedPosition ?? Duration.zero,
//                                       onChangeEnd: player.seek,
//                                     );
//                                   },
//                                 ),
//                               ),
//                               StreamBuilder<PlayerState>(
//                                 stream: player.playerStateStream,
//                                 builder: (context, snapshot) {
//                                   final playerState = snapshot.data;
//                                   final processingState = playerState?.processingState;
//                                   final playing = playerState?.playing;
//                                   if (processingState == ProcessingState.loading ||
//                                       processingState == ProcessingState.buffering) {
//                                     return Container(
//                                       margin: const EdgeInsets.all(8.0),
//                                       width: 25.0,
//                                       height: 25.0,
//                                       child: const LoaderView(loaderColor: ChatHelpers.white , size: 20),
//                                     );
//                                   } else if (playing != true) {
//                                     return IconButton(
//                                       icon: const Icon(Icons.play_arrow),
//                                       iconSize: 35.0,
//                                       disabledColor: ChatHelpers.grey,
//                                       onPressed: player.play ,
//                                       color: ChatHelpers.white,
//                                     );
//                                   } else if (processingState != ProcessingState.completed) {
//                                     return IconButton(
//                                       icon: const Icon(Icons.pause),
//                                       iconSize: 35.0,
//                                       onPressed: player.pause,
//                                       disabledColor: ChatHelpers.grey,
//                                       color: ChatHelpers.white,
//                                     );
//                                   } else {
//                                     return IconButton(
//                                       icon: const Icon(Icons.replay),
//                                       iconSize: 35.0,
//                                       color: ChatHelpers.white,
//                                       disabledColor: ChatHelpers.grey,
//                                       onPressed: () => player.seek(Duration.zero),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: ChatHelpers.marginSizeExtraSmall,
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const SizedBox(
//                               width: ChatHelpers.marginSizeSmall,
//                             ),
//                             Text(
//                               widget.time,
//                               style: widget.chatController
//                                   .themeArguments
//                                   ?.styleArguments
//                                   ?.messagesTimeTextStyle ??
//                                   ChatHelpers.instance.styleLight(
//                                       ChatHelpers.fontSizeExtraSmall,
//                                       widget.isSender == true
//                                           ? widget.chatController
//                                           .themeArguments
//                                           ?.colorArguments
//                                           ?.senderMessageTextColor ??
//                                           ChatHelpers.white
//                                           : widget.chatController
//                                           .themeArguments
//                                           ?.colorArguments
//                                           ?.receiverMessageTextColor ??
//                                           ChatHelpers.black),
//                             ),
//                             const SizedBox(
//                               width: ChatHelpers.marginSizeExtraSmall,
//                             ),
//                             widget.isSender == true
//                                 ? Image.asset(
//                                 ChatHelpers.instance.doubleTickImage,
//                                 height: 15,
//                                 width: 15,
//                                 color: widget.isSeen
//                                     ? widget.chatController
//                                     .themeArguments
//                                     ?.colorArguments
//                                     ?.tickSeenColor ??
//                                     ChatHelpers.backcolor
//                                     : widget.chatController
//                                     .themeArguments
//                                     ?.colorArguments
//                                     ?.tickUnSeenColor ??
//                                     ChatHelpers.grey,
//                                 package: 'chatcomponent')
//                                 : const SizedBox()
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   widget.reaction != 7
//                       ? Positioned(
//                     left: widget.isSender ? 0 : null,
//                     right: widget.isSender ? null: 0,
//                     bottom: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: ChatHelpers.blueLight),
//                       child: Text(
//                         widget.reactionList[widget.reaction],
//                         style: const TextStyle(
//                             fontSize: ChatHelpers.fontSizeSmall),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   )
//                       : const SizedBox()
//                 ],
//               ),
//             ),
//             if (widget.chatController.selectReactionIndex.value ==
//                 widget.index.toString())
//               Padding(
//                 padding: widget.isReaction
//                     ? const EdgeInsets.symmetric(
//                     vertical: ChatHelpers.marginSizeExtraSmall)
//                     : const EdgeInsets.all(0),
//                 child: ReactionView(
//                   isSender: widget.isSender,
//                   isChange: widget.isReaction,
//                   reactionList: widget.reactionList,
//                   chatController: widget.chatController,
//                   messageIndex: widget.index,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }*/

class AudioPlayerView extends StatefulWidget {

  final String time;
  final int index;
  final int reaction;
  final bool isSender;
  final bool isSeen;
  final bool visible;
  final bool isReaction;
  final List<String> reactionList;
  final VoidCallback onLongTap;
  final ChatController chatController;
  final String audioUrl;


  const AudioPlayerView({super.key, required this.time, required this.index, required this.reaction, required this.isSender, required this.isSeen, required this.visible, required this.isReaction, required this.reactionList, required this.onLongTap, required this.chatController, required this.audioUrl});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {

  late final Rx<PlayerController> controller;
  late StreamSubscription<PlayerState> playerStateSubscription;



  final Rx<File> audioFile = File("").obs;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  @override
  void dispose() {
    super.dispose();
    playerStateSubscription.cancel();
    controller.value.dispose();
  }

   downloadFile() async {
    try{
      Permission.storage.isGranted;
      String fileName = widget.chatController.messages[widget.index].id ?? "";
      var tempDir = await getExternalStorageDirectory();
      HttpClient httpClient = HttpClient();
      File file = File('${tempDir?.path}/$fileName');
      logPrint("file exists : ${await file.exists()}");
      if (!await file.exists()) {
        var request = await httpClient.getUrl(Uri.parse(widget.audioUrl));
        var response = await request.close();
        logPrint(response.statusCode);
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          logPrint('${tempDir?.path}/$fileName');
          logPrint(
              "file path vlaue : ${file.path}  ${tempDir?.path}/$fileName");
          try {
            await file.writeAsBytes(bytes);
          }catch(e){
            logPrint("error file creating audio file $e");
          }
        }else{
          logPrint("error playing this file and downlaoding file");
          toastShow(massage: "error playing this file", error: true);
        }
      }
      audioFile.value = file;
      controller = PlayerController().obs;
      controller.value.preparePlayer(path: audioFile.value.path,shouldExtractWaveform: true);
      controller.refresh();
      playerStateSubscription = controller.value.onPlayerStateChanged.listen((_) {
        setState(() {});
      });
      logPrint("audio file : ${audioFile.value} , ${controller.value}");
    }catch(e){
      logPrint("error in download and setting file $e");
    }
  }

  void _playAndPause() async {
    controller.value.playerState == PlayerState.playing
        ? await controller.value.pausePlayer()
        : await controller.value.startPlayer(finishMode: FinishMode.pause);
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() =>GestureDetector(
      onLongPress: widget.onLongTap,
      child: Align(
        alignment: widget.isSender == true ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: widget.isSender == true
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .85, minWidth: 5),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: widget.isSender == true ? ChatHelpers.marginSizeSmall : 0,
                      right: widget.isSender == true ? 0 : ChatHelpers.marginSizeSmall ,
                      bottom: widget.reaction != 7 ? 10 : 0,
                      top: ChatHelpers.marginSizeExtraSmall,
                    ),
                    padding: const EdgeInsets.all(
                        ChatHelpers.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: widget.isSender == true
                          ? widget.chatController.themeArguments?.colorArguments
                          ?.senderMessageBoxColor ??
                          ChatHelpers.mainColor
                          : widget.chatController.themeArguments?.colorArguments
                          ?.receiverMessageBoxColor ??
                          ChatHelpers.backcolor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: widget.isSender == true
                            ? Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderBottomLeftRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverBottomLeftRadius ??
                            ChatHelpers.cornerRadius),
                        topRight: widget.isSender == true
                            ? Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderTopRightRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverTopRightRadius ??
                            ChatHelpers.cornerRadius),
                        topLeft: widget.isSender == true
                            ? Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderTopLeftRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverTopLeftRadius ??
                            ChatHelpers.cornerRadius),
                        bottomRight: widget.isSender == true
                            ? Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxSenderBottomRightRadius ??
                            ChatHelpers.cornerRadius)
                            : Radius.circular(widget.chatController
                            .themeArguments
                            ?.borderRadiusArguments
                            ?.messageBoxReceiverBottomRightRadius ??
                            ChatHelpers.cornerRadius),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: widget.isSender
                          ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          return Container(
                            height: 50,
                            margin: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                            padding: const EdgeInsets.symmetric(horizontal:ChatHelpers.marginSizeSmall,vertical: ChatHelpers.marginSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: widget.isSender ? ChatHelpers.mainColorLight : ChatHelpers.backcolor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                audioFile.value.path == "" ?
                                Container(width: MediaQuery.of(context).size.width * .5,
                                  height: 50, decoration: BoxDecoration(
                                      color: ChatHelpers.mainColorLight,
                                      borderRadius: BorderRadius.circular(ChatHelpers.buttonRadius)
                                  ),)
                                    : AudioFileWaveforms(
                                  size: Size( MediaQuery.of(context).size.width * .5, 40.0),
                                  playerController: controller.value,
                                  enableSeekGesture: true,
                                  continuousWaveform: false,
                                  waveformType: WaveformType.long,
                                  waveformData: controller.value.waveformData,
                                  playerWaveStyle: PlayerWaveStyle(
                                    fixedWaveColor: widget.isSender ? ChatHelpers.white.withOpacity(.5) : ChatHelpers.black.withOpacity(.4),
                                    liveWaveColor: widget.isSender ? ChatHelpers.white : ChatHelpers.black,
                                    showSeekLine: false,
                                    spacing: 6,
                                    showBottom: true,
                                    showTop: true,
                                  ),
                                ),
                                const SizedBox(width: ChatHelpers.marginSizeSmall,),
                                CircleIconButton(
                                  icons: controller.value.playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                                  height: 45.0,
                                  width: 45.0,
                                  isImage: false,
                                  iconsSize: 20,
                                  shapeRec: false,
                                  colors: widget.isSender ? ChatHelpers.white : ChatHelpers.black,
                                  onTap: audioFile.value.path == "" ? (){
                                    toastShow(massage: "audio file is loading", error: false);
                                  } : _playAndPause,
                                )
                              ],
                            ),
                          );
                        }),
                        const SizedBox(
                          height: ChatHelpers.marginSizeExtraSmall,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: ChatHelpers.marginSizeSmall,
                            ),
                            Text(
                              widget.time,
                              style: widget.chatController
                                  .themeArguments
                                  ?.styleArguments
                                  ?.messagesTimeTextStyle ??
                                  ChatHelpers.instance.styleLight(
                                      ChatHelpers.fontSizeExtraSmall,
                                      widget.isSender == true ? widget.chatController.themeArguments?.colorArguments?.senderMessageTextColor ?? ChatHelpers.white
                                          : widget.chatController.themeArguments?.colorArguments?.receiverMessageTextColor ?? ChatHelpers.black),
                            ),
                            const SizedBox(
                              width: ChatHelpers.marginSizeExtraSmall,
                            ),
                            widget.isSender == true
                                ? Image.asset(
                                ChatHelpers.instance.doubleTickImage,
                                height: 15,
                                width: 15,
                                color: widget.isSeen
                                    ? widget.chatController
                                    .themeArguments
                                    ?.colorArguments
                                    ?.tickSeenColor ??
                                    ChatHelpers.backcolor
                                    : widget.chatController
                                    .themeArguments
                                    ?.colorArguments
                                    ?.tickUnSeenColor ??
                                    ChatHelpers.grey,
                                package: 'chatcomponent')
                                : const SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                  widget.reaction != 7
                      ? Positioned(
                    left: widget.isSender ? 0 : null,
                    right: widget.isSender ? null: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(ChatHelpers.marginSizeExtraSmall),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ChatHelpers.blueLight),
                      child: Text(
                        widget.reactionList[widget.reaction],
                        style: const TextStyle(
                            fontSize: ChatHelpers.fontSizeSmall),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : const SizedBox()
                ],
              ),
            ),
            if (widget.chatController.selectReactionIndex.value ==
                widget.index.toString())
              Padding(
                padding: widget.isReaction
                    ? const EdgeInsets.symmetric(
                    vertical: ChatHelpers.marginSizeExtraSmall)
                    : const EdgeInsets.all(0),
                child: ReactionView(
                  isSender: widget.isSender,
                  isChange: widget.isReaction,
                  reactionList: widget.reactionList,
                  chatController: widget.chatController,
                  messageIndex: widget.index,
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
