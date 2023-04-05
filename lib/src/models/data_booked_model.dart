import 'dart:convert';

DataBookedModel dataBookedModelFromJson(String str) => DataBookedModel.fromJson(json.decode(str));

String dataBookedModelToJson(DataBookedModel data) => json.encode(data.toJson());

class DataBookedModel {
  DataBookedModel({
    required this.id,
    required this.station,
    required this.batteryId,
    required this.status,
    required this.bookingBy,
    required this.bookingTime,
    required this.secretCode,
    required this.createdAt,
    required this.payment,
  });

  final String? id;
  final String? station;
  final int? batteryId;
  final Status? status;
  final String? bookingBy;
  final int? bookingTime;
  final String? secretCode;
  final String? createdAt;
  final String? payment;

  factory DataBookedModel.fromJson(Map<String, dynamic> json) => DataBookedModel(
    id: json["_id"] ?? '',
    station: json["stationId"] ?? '',
    batteryId: json["batteryId"] ?? 0,
    // status: Status.fromJson(json["status"]),
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
    bookingBy: json["bookingBy"] ?? '',
    bookingTime: json["bookingTime"] ?? 0,
    secretCode: json["secretCode"] ?? '',
    createdAt: json["createdAt"] ?? '',
    payment: json["payment"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "stationId": station,
    "batteryId": batteryId,
    // "status": status.toJson(),
    "status": status == null ? null : status!.toJson(),
    "bookingBy": bookingBy,
    "bookingTime": bookingTime,
    "secretCode": secretCode,
    "createdAt": createdAt,
    "payment": payment,
  };
}

class Status {
  Status({
    required this.booked,
    required this.canceled,
    required this.finished,
    required this.timeout,
  });

  final bool? booked;
  final bool? canceled;
  final bool? finished;
  final bool? timeout;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    booked: json["booked"] ?? false,
    canceled: json["canceled"] ?? false,
    finished: json["finished"] ?? false,
    timeout: json["timeout"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "booked": booked,
    "canceled": canceled,
    "finished": finished,
    "timeout": timeout,
  };
}
