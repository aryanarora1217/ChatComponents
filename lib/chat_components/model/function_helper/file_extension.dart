String? getFileExtension(String fileName) {
  try {
    return ".${fileName.split('.').last}";
  } catch(e){
    return null;
  }
}