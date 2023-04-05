import 'dart:convert';

QrCodeModel qrCodeModelFromJson(String str) => QrCodeModel.fromJson(json.decode(str));

String qrCodeModelToJson(QrCodeModel data) => json.encode(data.toJson());

class QrCodeModel {
  QrCodeModel({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory QrCodeModel.fromJson(Map<String, dynamic> json) => QrCodeModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}