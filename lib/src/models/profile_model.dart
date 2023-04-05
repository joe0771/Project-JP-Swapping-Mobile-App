import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.email,
    required this.mobilePhone,
    required this.fullName,
    required this.username,
    required this.isBooking,
    required this.balance,
    required this.createdAt,
  });

  final String? id;
  final String? email;
  final String? mobilePhone;
  final String? fullName;
  final String? username;
  final bool? isBooking;
  final int? balance;
  final String? createdAt;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["_id"] ?? '',
    email: json["email"] ?? '',
    mobilePhone: json["mobilePhone"] ?? '',
    fullName: json["fullName"] ?? '',
    username: json["username"] ?? '',
    isBooking: json["isBooking"] ?? false,
    balance: json["balance"] ?? 0,
    createdAt: json["createdAt"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "mobilePhone": mobilePhone,
    "fullName": fullName,
    "username": username,
    "isBooking": isBooking,
    "balance": balance,
    "createdAt": createdAt,
  };
}
