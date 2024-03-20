import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GetImageHelper {
  static GetImageHelper? _instance;
  static GetImageHelper get instance => _instance ??= GetImageHelper();

  Future<File?> getImage(int type) async {
    final pickedImage = await ImagePicker().pickImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    if (pickedImage != null) {
      final selectedImage = File(pickedImage.path);
      return selectedImage;
    } else {
      return null;
    }
  }


}