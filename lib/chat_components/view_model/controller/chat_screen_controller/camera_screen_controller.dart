import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/model/models/picker_file_modal/picker_file_modal.dart';
import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_player/video_player.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';


class CameraScnController extends GetxController {

  RxBool isCameraRear = false.obs;
  RxBool isCameraVisible = true.obs;
  RxBool isStartRecording = false.obs;
  RxBool isVideoRecorded = false.obs;
  RxBool isFlashOn = false.obs;
  RxBool isCropped = false.obs;
  RxBool isImagePainterOpen = false.obs;
  RxBool isLoading = false.obs;

  RxInt selectedImageIndex = 0.obs;

  RxList<Album> imageAlbums = <Album>[].obs;
  RxList<Medium> mediaList = <Medium>[].obs;

  Rx<File> image = File('').obs;

  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  VideoPlayerController? videoPlayerController;
  late ChewieController chewieController;
  FlickManager? flickManager;




  RxList<CameraDescription> availableCamera = <CameraDescription>[].obs;


  RxList<PickerFileModal> imageList = <PickerFileModal>[].obs;
  RxList<PickerFileModal> cropImageList = <PickerFileModal>[].obs;
  RxList<Medium> selectedMediumList = <Medium>[].obs;
  RxList<TextEditingController> messageControllerList = <TextEditingController>[].obs;




  @override
  Future<void> onInit() async {
    super.onInit();
    await initServices();
  }


  Future<void> initServices() async {
    isLoading.value = true;

    image.value = Get.arguments;
    if(image.value.path == ""){
      availableCamera.value = await availableCameras();

      final firstCamera = availableCamera.first;
      _initCamera(firstCamera);
      imageAlbums.value = await PhotoGallery.listAlbums();
      MediaPage mediaPage = await imageAlbums.first.listMedia();
      mediaList.value = mediaPage.items;
      logPrint("media image : ${mediaList.first.toString()}");
      isLoading.value = false;
    }else {
      imageList.add(PickerFileModal(file: File(image.value.path), isVideo: false));
      cropImageList.add(PickerFileModal(file: File(image.value.path), isVideo: false));
      logPrint("ImageList : ${imageList.toString()}");
      for(var image in imageList){
        logPrint(image);
        messageControllerList.add(TextEditingController());
      }
      isCameraVisible.value = false;
    }

  }


  /// camera switch on click
  void onCameraSwitchTap() {
    isLoading.value = true;
    isCameraRear.value = !isCameraRear.value;

    final lensDirection = cameraController.description.lensDirection;
    CameraDescription newDescription;

    logPrint("avaible cameras : ${availableCamera.toString()}");

    if (lensDirection == CameraLensDirection.front) {
      newDescription = availableCamera.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = availableCamera.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    _initCamera(newDescription);
    isLoading.value = false;
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    isFlashOn.value = FlashMode.off == mode ? false : true;
    cameraController.setFlashMode(mode).then((_) {
      logPrint('Flash mode set to ${mode.toString().split('.').last}');
    });

  }

  Future<void> clickImage(BuildContext context) async {
    try {
      await initializeControllerFuture;

      final image = await cameraController.takePicture();

      logPrint("image cliked : ${image.path}");

      if (!context.mounted) return;

      imageList.add(PickerFileModal(file: File(image.path), isVideo: false));
      cropImageList.add(PickerFileModal(file: File(image.path), isVideo: false));

      logPrint("ImageList : ${imageList.toString()}");
      for(var image in imageList){
        logPrint(image);
        messageControllerList.add(TextEditingController());
      }
      isCameraVisible.value = false;
    } catch (e) {
      logPrint(e);
    }
  }

  /// video recorder
  Future<void> recordVideo() async {
    try {
      await initializeControllerFuture;

      await cameraController.startVideoRecording();

      isStartRecording.value = true;

    } catch (e) {
      logPrint(e);
    }
  }

  Future<void> stopRecording(BuildContext context) async {
    try{

      XFile videoFile = await cameraController.stopVideoRecording();

      
      logPrint("stop recording : ${videoFile.path} ");


      if (!context.mounted) return;


      videoPlayerController = VideoPlayerController.file(File(videoFile.path));

      flickManager = FlickManager(videoPlayerController: VideoPlayerController.file(File(videoFile.path)),autoPlay: true,autoInitialize: true);


      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: true,
      );

      imageList.add(PickerFileModal(file: File(videoFile.path), isVideo: true));
      cropImageList.add(PickerFileModal(file: File(videoFile.path), isVideo: true));

      logPrint("ImageList : ${imageList.toString()} , aspect radio : ${videoPlayerController?.value.aspectRatio},  ${videoPlayerController?.value.rotationCorrection}");


      for(var image in imageList){
        logPrint(image);
        messageControllerList.add(TextEditingController());
      }

      isStartRecording.value = false;
      isVideoRecorded.value = true;
      isCameraVisible.value = false;
    }catch(e){
      logPrint(e);
    }
  }

  Future<void> _initCamera(CameraDescription description) async {
    cameraController =
        CameraController(description, ResolutionPreset.max, enableAudio: true);
    cameraController.setFlashMode(FlashMode.off);
    try {
      initializeControllerFuture = cameraController.initialize();
    } catch (e) {
      logPrint("error in camera : $e");
    }
  }


  Future<void> tapOnImage(int index) async {
    Medium selectedMedia = mediaList[index];
    image.value = await selectedMedia.getFile();
    if(image.value.path.endsWith("mp4") || image.value.path.endsWith("mp3")){
      imageList.add(PickerFileModal(file: File(image.value.path), isVideo: true));
      cropImageList.add(PickerFileModal(file: File(image.value.path), isVideo: true));


      videoPlayerController = VideoPlayerController.file(File(image.value.path));

      flickManager = FlickManager(videoPlayerController: VideoPlayerController.file(File(image.value.path)),autoPlay: true,autoInitialize: true);

      logPrint("flick maanger details :${flickManager?.flickVideoManager}");



      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: true,
      );

      isVideoRecorded.value = true;

    }else{
      imageList.add(PickerFileModal(file: File(image.value.path), isVideo: false));
      cropImageList.add(PickerFileModal(file: File(image.value.path), isVideo: false));
    }

    logPrint("ImageList : ${imageList.toString()}");
    for(var image in imageList){
      logPrint(image);
      messageControllerList.add(TextEditingController());
    }
    isCameraVisible.value = false;
  }

  Future<void> longPressOnImage(int index) async {
    Medium selectedMedia = mediaList[index];
    bool isExist = selectedMediumList.any((element) => element.id == selectedMedia.id);
    image.value = await selectedMedia.getFile();
    if(!isExist){
      image.value = await selectedMedia.getFile();
      selectedMediumList.add(selectedMedia);
      imageList.add(PickerFileModal(file: File(image.value.path), isVideo: false));
      cropImageList.add(PickerFileModal(file: File(image.value.path), isVideo: false));
      logPrint("ImageList : ${imageList.toString()}");
    }else{
      image.value = await selectedMedia.getFile();
      selectedMediumList.removeWhere((element) => element.id == selectedMedia.id);
      imageList.removeWhere((element) => (element.file?.path ?? "") == image.value.path);
      cropImageList.removeWhere((element) => (element.file?.path ??"") == image.value.path);
    }

  }

  void onTapSelectImages(){
    messageControllerList.clear();
    for(var image in imageList){
      logPrint(image);
      messageControllerList.add(TextEditingController());
    }
    isCameraVisible.value = false;
  }

  void sendOnTap(){
    Get.back(result: {"ImageList": isCropped.isTrue ? cropImageList : imageList,"textMessageList":messageControllerList});
  }

  Future cropImage(int index) async {
    image.value = imageList[index].file ?? File("");
    try{
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: image.value.path,
          aspectRatioPresets:
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: ChatHelpers.mainColor,
                toolbarWidgetColor: ChatHelpers.white,
                statusBarColor:ChatHelpers.white,
                cropGridColor: ChatHelpers.white,
                activeControlsWidgetColor: ChatHelpers.mainColor,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        isCropped.value = true;
        imageList[index].file = image.value;
        cropImageList[index].file = File(cropped.path);
      }
    }catch(e){
      logPrint("error in editing image $e");
    }

  }

  void drawImage(int index) async {
    image.value = isCropped.isTrue ? (cropImageList[index].file ?? File("")) : (imageList[index].file ?? File(""));
    Get.toNamed(ChatHelpers.drawEditScreen,arguments: image.value)?.then((value) {
      image.value = value ;
      isCropped.isTrue ? cropImageList[index].file = image.value : imageList[index].file = image.value;
      logPrint("value : $value , ${isCropped.value} , $cropImageList ,$imageList");
    });
  }


  @override
  Future<void> onClose() async {
   try{
     await cameraController.dispose();
     await videoPlayerController?.initialize();
     await videoPlayerController?.dispose();
     chewieController.dispose();
     await flickManager?.dispose();
   }catch(e){
     logPrint("error : $e");
   }
    super.onClose();
  }


}
