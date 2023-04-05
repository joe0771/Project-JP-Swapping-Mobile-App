import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.message,
    this.data,
    this.token,
  });

  final String? message;
  final Data? data;
  final String? token;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? null : data!.toJson(),
    "token": token,
  };
}

class Data {
  Data({
    this.acknowledged,
  });

  final bool? acknowledged;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    acknowledged: json["acknowledged"],
  );

  Map<String, dynamic> toJson() => {
    "acknowledged": acknowledged,
  };
}
