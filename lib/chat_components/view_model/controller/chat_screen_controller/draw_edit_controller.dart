import 'dart:io';
import 'package:chatcomponent/chat_components/view/widgets/log_print/log_print_condition.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../model/chatHelper/chat_helper.dart';

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

    final imageNew = await imagePainterController.exportImage();
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/$imageName';
    final imgFile = File('$fullPath');
    
    logPrint("imge new : $imgFile , $fullPath");

    Get.back(result: imgFile);

  }

}