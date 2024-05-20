import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_gallery/photo_gallery.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';


class CameraScnController extends GetxController {

  RxBool isCameraRear = false.obs;
  RxBool isCameraVisible = true.obs;
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

  RxList<CameraDescription> availableCamera = <CameraDescription>[].obs;

  RxList<File> imageList = <File>[].obs;
  RxList<File> cropImageList = <File>[].obs;
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
      imageList.add(File(image.value.path));
      cropImageList.add(File(image.value.path));
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

      imageList.add(File(image.path));
      cropImageList.add(File(image.path));

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

  Future<void> _initCamera(CameraDescription description) async {
    cameraController =
        CameraController(description, ResolutionPreset.max, enableAudio: false);
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
    imageList.add(File(image.value.path));
    cropImageList.add(File(image.value.path));
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
      imageList.add(File(image.value.path));
      cropImageList.add(File(image.value.path));
      logPrint("ImageList : ${imageList.toString()}");
    }else{
      image.value = await selectedMedia.getFile();
      selectedMediumList.removeWhere((element) => element.id == selectedMedia.id);
      imageList.removeWhere((element) => element.path == image.value.path);
      cropImageList.removeWhere((element) => element.path == image.value.path);
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
    image.value = imageList[index];
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
        imageList[index] = image.value;
        cropImageList[index] = File(cropped.path);
      }
    }catch(e){
      logPrint("error in editing image $e");
    }

  }

  void drawImage(int index) async {
    image.value = isCropped.isTrue ? cropImageList[index] : imageList[index];
    Get.toNamed(ChatHelpers.drawEditScreen,arguments: image.value)?.then((value) {
      image.value = value ;
      isCropped.isTrue ? cropImageList[index] = image.value : imageList[index] = image.value;
      logPrint("value : $value , ${isCropped.value} , $cropImageList ,$imageList");
    });
  }


  @override
  void onClose() {
   try{
     cameraController.dispose();
   }catch(e){
     logPrint("error : $e");
   }
    super.onClose();
  }


}
