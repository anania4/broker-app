// To parse this JSON data, do
//
//     final brokerModel = brokerModelFromJson(jsonString);

import 'dart:convert';

BrokerModel brokerModelFromJson(String str) =>
    BrokerModel.fromJson(json.decode(str));

String brokerModelToJson(BrokerModel data) => json.encode(data.toJson());

class BrokerModel {
  Broker? broker;

  BrokerModel({
    this.broker,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) => BrokerModel(
        broker: json["broker"] == null ? null : Broker.fromJson(json["broker"]),
      );

  Map<String, dynamic> toJson() => {
        "broker": broker?.toJson(),
      };
}

class Broker {
  int? id;
  dynamic googleId;
  String? fullName;
  dynamic email;
  String? phone;
  String? password;
  String? brokerBio;
  String? photo;
  bool? approved;
  DateTime? approvedDate;
  bool? avilableForWork;
  DateTime? serviceExprireDate;
  double? locationLongtude;
  double? locationLatitude;
  bool? hasCar;
  String? resetOtp;
  DateTime? resetOtpExpiration;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Topup>? topup;
  List<Address>? addresses;

  Broker({
    this.id,
    this.googleId,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.brokerBio,
    this.photo,
    this.approved,
    this.approvedDate,
    this.avilableForWork,
    this.serviceExprireDate,
    this.locationLongtude,
    this.locationLatitude,
    this.hasCar,
    this.resetOtp,
    this.resetOtpExpiration,
    this.createdAt,
    this.updatedAt,
    this.topup,
    this.addresses,
  });

  factory Broker.fromJson(Map<String, dynamic> json) => Broker(
        id: json["id"],
        googleId: json["googleId"],
        fullName: json["fullName"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        brokerBio: json["bio"],
        photo: json["photo"],
        approved: json["approved"],
        approvedDate: json["approvedDate"] == null
            ? null
            : DateTime.parse(json["approvedDate"]),
        avilableForWork: json["avilableForWork"],
        serviceExprireDate: json["serviceExprireDate"] == null
            ? null
            : DateTime.parse(json["serviceExprireDate"]),
        locationLongtude: json["locationLongtude"]?.toDouble(),
        locationLatitude: json["locationLatitude"]?.toDouble(),
        hasCar: json["hasCar"],
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
        topup: json["Topup"] == null
            ? []
            : List<Topup>.from(json["Topup"]!.map((x) => Topup.fromJson(x))),
        addresses: json["addresses"] == null
            ? []
            : List<Address>.from(
                json["addresses"]!.map((x) => Address.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "googleId": googleId,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "password": password,
        "bio": brokerBio,
        "photo": photo,
        "approved": approved,
        "approvedDate": approvedDate?.toIso8601String(),
        "avilableForWork": avilableForWork,
        "serviceExprireDate": serviceExprireDate?.toIso8601String(),
        "locationLongtude": locationLongtude,
        "locationLatitude": locationLatitude,
        "hasCar": hasCar,
        "resetOtp": resetOtp,
        "resetOtpExpiration": resetOtpExpiration?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "Topup": topup == null
            ? []
            : List<dynamic>.from(topup!.map((x) => x.toJson())),
        "addresses": addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
      };
}

class Topup {
  int? id;
  String? txRef;
  int? brokerId;
  int? packageId;
  DateTime? createdAt;
  DateTime? updatedAt;
  PackageMOdel? package;

  Topup({
    this.id,
    this.txRef,
    this.brokerId,
    this.packageId,
    this.createdAt,
    this.updatedAt,
    this.package,
  });

  factory Topup.fromJson(Map<String, dynamic> json) => Topup(
        id: json["id"],
        txRef: json["tx_ref"],
        brokerId: json["brokerId"],
        packageId: json["packageId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        package: json["package"] == null
            ? null
            : PackageMOdel.fromJson(json["package"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tx_ref": txRef,
        "brokerId": brokerId,
        "packageId": packageId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "package": package?.toJson(),
      };
}

class PackageMOdel {
  int? id;
  int? totalDays;
  String? name;
  int? discount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  PackageMOdel({
    this.id,
    this.totalDays,
    this.name,
    this.discount,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory PackageMOdel.fromJson(Map<String, dynamic> json) => PackageMOdel(
        id: json["id"],
        totalDays: json["totalDays"],
        name: json["name"],
        discount: json["discount"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalDays": totalDays,
        "name": name,
        "discount": discount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
      };
}

class Address {
  int? id;
  int? brokerId;
  double? longitude;
  double? latitude;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Address({
    this.id,
    this.brokerId,
    this.longitude,
    this.latitude,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        brokerId: json["brokerId"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        name: json["name"] != null ? json["name"].toString() : null,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brokerId": brokerId,
        "longitude": longitude,
        "latitude": latitude,
        "addressLine": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
