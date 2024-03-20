class CallModel {
  String? callId;
  String? callerId;
  String? receiverId;
  String? callType;
  String? callStatus;
  String? callTimeStamp;
  String? callTimeOn;
  List<dynamic>? callMembers;


  CallModel({
    this.callId,
    this.callerId,
    this.receiverId,
    this.callType,
    this.callStatus,
    this.callTimeStamp,
    this.callTimeOn,
    this.callMembers
  });

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
    callId: json["callId"],
    callerId: json["callerId"],
    receiverId: json["receiverId"],
    callType: json["callType"],
    callStatus: json["callStatus"],
    callTimeStamp: json["callTimeStamp"],
    callTimeOn: json["callTimeOn"],
    callMembers: json["call_members"],
  );

  Map<String, dynamic> toJson() => {
    "callId": callId,
    "callerId": callerId,
    "receiverId": receiverId,
    "callType": callType,
    "callStatus": callStatus,
    "callTimeStamp": callTimeStamp,
    "callTimeOn": callTimeOn,
    "call_members": callMembers,
  };
}
