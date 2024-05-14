import 'dart:io';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../model/chatHelper/chat_helper.dart';
import '../../../view/widgets/common_button/common_text_button.dart';

class DrawEditController extends GetxController{

  final ImagePainterController imagePainterController = ImagePainterController(
    color: ChatHelpers.green,
    strokeWidth: 4,
    mode: PaintMode.line,
  );

  Rx<File> image = File('').obs;


  @override
  void onInit() {
    super.onInit();
    image.value = Get.arguments;
  }

  onBackTap() async {

    try{

      final imageNew = await imagePainterController.exportImage();
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';

      PermissionStatus status = await Permission.storage.status;
      AndroidDeviceInfo? androidInfo;

      if (Platform.isAndroid) {
        androidInfo = await DeviceInfoPlugin().androidInfo;
        logPrint(androidInfo.version.sdkInt);
      }
      logPrint("storage permission : $status");
      if (Platform.isAndroid &&
          (androidInfo?.version.sdkInt ?? 0) >= 33 ) {
        await Permission.storage.request().isGranted;

        final directory = await getExternalStorageDirectory();
        logPrint("directory path : ${directory?.absolute.path}");
        await Directory('${directory?.absolute.path}/sample').create(recursive: true);
        final fullPath = '${directory?.absolute.path}/sample/$imageName';
        final imgFile = File(fullPath);
        imgFile.writeAsBytesSync(imageNew??[]);

        logPrint("imge new : $imgFile , $fullPath");
        Get.back(result: imgFile);

      }
      else if (Platform.isAndroid &&
          (androidInfo?.version.sdkInt ?? 0) <= 32 &&
          status == PermissionStatus.denied) {
        askPermissionBox();
      } else {
        if (Platform.isIOS) {
          var tempDir = await getApplicationDocumentsDirectory();
          final deviceDirectoryPath = tempDir.absolute.path;
          final directory = Directory(deviceDirectoryPath);

          logPrint("directory path : ${directory.absolute.path}");
          await Directory('${directory.absolute.path}/sample').create(recursive: true);
          final fullPath = '${directory.absolute.path}/sample/$imageName';
          final imgFile = File(fullPath);
          imgFile.writeAsBytesSync(imageNew??[]);

          logPrint("imge new : $imgFile , $fullPath");
          Get.back(result: imgFile);
        }
        final directory = await getExternalStorageDirectory();
        logPrint("directory path : ${directory?.absolute.path}");
        await Directory('${directory?.absolute.path}/sample').create(recursive: true);
        final fullPath = '${directory?.absolute.path}/sample/$imageName';
        final imgFile = File(fullPath);
        imgFile.writeAsBytesSync(imageNew??[]);

        logPrint("imge new : $imgFile , $fullPath");
        Get.back(result: imgFile);
      }
    }catch(e){
      logPrint("errror in draw image export : $e");
    }



  }


  void askPermissionBox() {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: ChatHelpers.white,
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Permission",
                      style: ChatHelpers.instance.styleSemiBold(
                          ChatHelpers.fontSizeLarge, ChatHelpers.black),
                    ),
                    const Text(
                        "Please give storage permission for files downloads."),
                    CommonButton(
                        onPressed: () async {
                          Get.back();
                          await Permission.storage.request().then((value) async {
                            onBackTap();
                          });
                        },
                        title: "Give Permission",
                        colors: ChatHelpers.white,
                        fillColor: ChatHelpers.mainColor,
                        loading: false)
                  ],
                ),
              ),
            ),
          );
        });
  }

}