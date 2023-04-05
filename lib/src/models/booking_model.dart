import 'dart:convert';

BookingModel bookingModelFromJson(String str) => BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
  BookingModel({
    required this.success,
    required this.error,
    required this.message,
  });

  final bool? success;
  final bool? error;
  final String? message;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    success: json["success"] ?? false,
    error: json["error"] ?? false,
    message: json["message"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "message": message,
  };
}
