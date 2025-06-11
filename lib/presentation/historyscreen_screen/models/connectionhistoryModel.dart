// To parse this JSON data, do
//
//     final connectionHistory = connectionHistoryFromJson(jsonString);

import 'dart:convert';

ConnectionHistory connectionHistoryFromJson(String str) =>
    ConnectionHistory.fromJson(json.decode(str));

String connectionHistoryToJson(ConnectionHistory data) =>
    json.encode(data.toJson());

class ConnectionHistory {
  List<Connection>? connections;

  ConnectionHistory({
    this.connections,
  });

  factory ConnectionHistory.fromJson(Map<String, dynamic> json) =>
      ConnectionHistory(
        connections: json["connections"] == null
            ? []
            : List<Connection>.from(
                json["connections"]!.map((x) => Connection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": connections == null
            ? []
            : List<dynamic>.from(connections!.map((x) => x.toJson())),
      };
}

class Connection {
  int? id;
  String? reasonForCancellation;
  String? status;
  double? locationLongtude;
  double? locationLatitude;
  bool? userHasCalled;
  String? locationName;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  int? brokerId;
  int? serviceId;
  UserHistory? user;

  Connection({
    this.id,
    this.reasonForCancellation,
    this.status,
    this.locationLongtude,
    this.locationLatitude,
    this.userHasCalled,
    this.locationName,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.brokerId,
    this.serviceId,
    this.user,
  });

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        id: json["id"],
        reasonForCancellation: json["reasonForCancellation"],
        status: json["status"],
        locationLongtude: json["locationLongtude"]?.toDouble(),
        locationLatitude: json["locationLatitude"]?.toDouble(),
        userHasCalled: json["userHasCalled"],
        locationName: json["locationName"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userId: json["userId"],
        brokerId: json["brokerId"],
        serviceId: json["serviceId"],
        user: json["user"] == null ? null : UserHistory.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reasonForCancellation": reasonForCancellation,
        "status": status,
        "locationLongtude": locationLongtude,
        "locationLatitude": locationLatitude,
        "userHasCalled": userHasCalled,
        "locationName": locationName,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "userId": userId,
        "brokerId": brokerId,
        "serviceId": serviceId,
        "user": user?.toJson(),
      };
}

class UserHistory {
  int? id;
  String? googleId;
  String? fullName;
  String? email;
  String? phone;
  String? photo;
  String? password;
  String? resetOtp;
  DateTime? resetOtpExpiration;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserHistory({
    this.id,
    this.googleId,
    this.fullName,
    this.email,
    this.phone,
    this.photo,
    this.password,
    this.resetOtp,
    this.resetOtpExpiration,
    this.createdAt,
    this.updatedAt,
  });

  factory UserHistory.fromJson(Map<String, dynamic> json) => UserHistory(
        id: json["id"],
        googleId: json["googleId"],
        fullName: json["fullName"],
        email: json["email"],
        phone: json["phone"],
        photo: json["photo"],
        password: json["password"],
        resetOtp: json["resetOtp"],
        resetOtpExpiration: json["resetOtpExpiration"] == null
            ? null
            : DateTime.parse(json["resetOtpExpiration"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "googleId": googleId,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "photo": photo,
        "password": password,
        "resetOtp": resetOtp,
        "resetOtpExpiration": resetOtpExpiration?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
