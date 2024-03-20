import 'dart:convert';

class Users {
  String? id;
  String? signInType;
  String? profileName;
  String? profileImage;
  String? email;
  String? phoneNo;
  String? password;
  String? dob;
  String? gender;
  String? status;
  String? deviceToken;
  String? deviceType;
  String? presence;

  Users({
    this.id,
    this.signInType,
    this.profileName,
    this.profileImage,
    this.email,
    this.phoneNo,
    this.password,
    this.dob,
    this.gender,
    this.status,
    this.deviceToken,
    this.deviceType,
    this.presence,
  });

  factory Users.fromRawJson(String str) => Users.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    signInType: json["signInType"],
    profileName: json["profile_name"],
    profileImage: json["profile_image"],
    email: json["email"],
    phoneNo: json["phone_no"],
    password: json["password"],
    dob: json["dob"],
    gender: json["gender"],
    status: json["status"],
    deviceToken: json["device_token"],
    deviceType: json["device_type"],
    presence: json["presence"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "signInType": signInType,
    "profile_name": profileName,
    "profile_image": profileImage,
    "email": email,
    "phone_no": phoneNo,
    "password": password,
    "dob": dob,
    "gender": gender,
    "status": status,
    "device_token": deviceToken,
    "device_type": deviceType,
    "presence": presence,
  };
}

