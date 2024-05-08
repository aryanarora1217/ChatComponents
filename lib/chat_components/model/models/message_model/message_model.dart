
class MessageModel {
  String? id;
  String? message;
  String? messageType;
  Files? file;
  String? sender;
  String? time;
  int? reaction;
  bool? isSeen;

  MessageModel({
    this.id,
    this.message,
    this.messageType,
    this.file,
    this.sender,
    this.time,
    this.isSeen,
    this.reaction,
  });


  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["id"],
    message: json["message"],
    messageType: json["messageType"],
    file:json["file"] == null ? null : Files.fromJson(json["file"]),
    sender: json["sender"],
    time: json["time"],
    isSeen: json["isSeen"],
    reaction: json["reaction"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "messageType": messageType,
    "file": file?.toJson(),
    "sender": sender,
    "time": time,
    "isSeen": isSeen,
    "reaction": reaction,
  };
}

class Files {
  String? fileName;
  String? fileUrl;
  String? fileType;
  String? fileMimeType;
  bool? isAdding;

  Files({
    this.fileName,
    this.fileUrl,
    this.fileType,
    this.fileMimeType,
    this.isAdding,
  });


  factory Files.fromJson(Map<String, dynamic> json) => Files(
    fileName: json["file_name"],
    fileUrl: json["file_url"],
    fileType: json["file_type"],
    fileMimeType: json["file_mime_type"],
    isAdding: json["isAdding"],
  );

  Map<String, dynamic> toJson() => {
    "file_name": fileName,
    "file_url": fileUrl,
    "file_type": fileType,
    "file_mime_type": fileMimeType,
    "isAdding": isAdding,
  };
}
