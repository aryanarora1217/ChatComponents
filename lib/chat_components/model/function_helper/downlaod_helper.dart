import 'dart:io';

import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/view/widgets/common_button/common_text_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../view/widgets/log_print/log_print_condition.dart';
import '../../view/widgets/toast_view/toast_view.dart';

class DownloadHelper {
  Future<void> createFolderAndDownloadFile({required String url,required String fileName,required VoidCallback onSuccess,required VoidCallback onError}) async {

    /// For create folder in memory
    /// Permission is required
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
      downloadFile(
        onError: onError,
          onSuccess: onSuccess,
          url: url,
          fileName: fileName);
    }
    else if (Platform.isAndroid &&
        (androidInfo?.version.sdkInt ?? 0) <= 32 &&
        status == PermissionStatus.denied) {
      askPermissionBox(
          onError: onError,
          onSuccess: onSuccess,
          url: url,
          fileName: fileName);
    } else {
      downloadFile(
          onError: onError,
          onSuccess: onSuccess,
          url: url,
          fileName: fileName);
    }
  }

  void downloadFile(
      {
      required String url,
      required String fileName,required VoidCallback onSuccess,required VoidCallback onError}) async {
    /// Path for creating your folder.
    String deviceDirectoryPath = "";
    Directory directoryPath = Directory("");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;

    logPrint("package info : $appName , $packageName");
    try {
      if (Platform.isAndroid) {
        var tempDir = await getExternalStorageDirectory();
        deviceDirectoryPath = tempDir?.absolute.path
                .replaceAll('/Android/data/$packageName/files', '') ??
            "";
        directoryPath = Directory('$deviceDirectoryPath/Download/$appName');
      } else if (Platform.isIOS) {
        var tempDir = await getApplicationDocumentsDirectory();
        deviceDirectoryPath = tempDir.absolute.path;
        directoryPath = Directory('$deviceDirectoryPath/$appName');
      } else {
        onError.call();
        toastShow(massage: "Something went wrong here", error: false);
      }
    } catch (e) {
      onError.call();
      toastShow(massage: e.toString(), error: false);
    }

    logPrint("tempPath=>$deviceDirectoryPath");
    logPrint("directoryPath=>$directoryPath");
    logPrint("diractory exists : ${await directoryPath.exists()}");

    /// if folder exists in four phone memory.
    if (await directoryPath.exists()) {
      HttpClient httpClient = HttpClient();
      try {
        File file =
            File('${directoryPath.path}/$fileName');
        logPrint("file exists : ${await file.exists()}");
        if (!await file.exists()) {
          var request = await httpClient.getUrl(Uri.parse(url));
          var response = await request.close();
          logPrint(response.statusCode);
          if (response.statusCode == 200) {
            var bytes = await consolidateHttpClientResponseBytes(response);
            logPrint('${directoryPath.path}/$fileName');
            logPrint("file path vlaue : ${file.path}  ${directoryPath.path}/$fileName");
            try {
              await file.writeAsBytes(bytes);
              toastShow(
                  massage:
                      "File is download successfully in your device's $appName folder. ",
                  error: false);
              openFile(file.path);
              refreshGallery(file.path);
              onSuccess.call();
            } catch (e) {
              onError.call();
              logPrint("error in file write $e , $fileName");
              toastShow(massage: "Something went wrong here", error: false);
            }
          } else {
            onError.call();
            toastShow(massage: "Something went wrong here", error: false);
          }
        } else {
          openFile(file.path);
          onSuccess.call();
        }
      } catch (ex) {
        onError.call();
        toastShow(massage: ex.toString(), error: false);
      }
    } else {
      /// Create folder in your memory.
      directoryPath.create(recursive: true).then((value) async {
        logPrint("dicertory value : ${value.path}");
        HttpClient httpClient = HttpClient();
        File file;
        try {
          var request = await httpClient.getUrl(Uri.parse(url));
          var response = await request.close();
          logPrint(response.statusCode);
          if (response.statusCode == 200) {
            var bytes = await consolidateHttpClientResponseBytes(response);
            file = File('${value.path}/$fileName');
            await file.writeAsBytes(bytes);
            toastShow(
                massage:
                    "File is download successfully in your device's $appName folder.",
                error: false);
            openFile(file.path);
            refreshGallery(file.path);
            onSuccess.call();
          } else {
            logPrint("error in downliad : ${response.statusCode}");
            toastShow(
                massage: 'Error code: ${response.statusCode}',
                error: true);
            onError.call();
          }
        } catch (ex) {
          logPrint("error in downliad : ${ex.toString()}");
          onError.call();
        toastShow(massage: ex.toString(), error: false);
        }
      });
    }
  }

  /// open downloaded file
  void openFile(String filePath) {
    try {
      OpenFilex.open(filePath);
    } catch (e) {
      logPrint("error opeing file : $e");
    }
  }

  /// For show image and file in your gallery
  void refreshGallery(String filePath) {
    MediaScanner.loadMedia(path: filePath);
  }

  /// ask permission box
  void askPermissionBox(
      {
      required String url,
      required String fileName,required VoidCallback onSuccess,required VoidCallback onError}) {
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
                          await Permission.storage.request().then((value) {
                            createFolderAndDownloadFile(
                                onError: onError,
                                onSuccess: onSuccess,
                                url: url,
                                fileName: fileName);
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
