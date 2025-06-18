import 'dart:convert';

PackageModel packageModelFromJson(String str) =>
    PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
  List<Settting>? settting;
  List<Package>? packages;

  PackageModel({
    this.settting,
    this.packages,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        settting: json["settting"] == null
            ? []
            : List<Settting>.from(
                json["settting"]!.map((x) => Settting.fromJson(x))),
        packages: json["packages"] == null
            ? []
            : List<Package>.from(
                json["packages"]!.map((x) => Package.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "settting": settting == null
            ? []
            : List<dynamic>.from(settting!.map((x) => x.toJson())),
        "packages": packages == null
            ? []
            : List<dynamic>.from(packages!.map((x) => x.toJson())),
      };
}

class Package {
  int? id;
  int? totalDays;
  String? name;
  String? price;
  int? discount;
  DateTime? createdAt;
  DateTime? updatedAt;

  Package({
    this.id,
    this.totalDays,
    this.name,
    this.price,
    this.discount,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        totalDays: json["totalDays"],
        name: json["name"],
        price: json["price"].toString(),
        discount: json["discount"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalDays": totalDays,
        "name": name,
        "price": price,
        "discount": discount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Settting {
  int? id;
  int? dailyFee;
  DateTime? createdAt;
  DateTime? updatedAt;

  Settting({
    this.id,
    this.dailyFee,
    this.createdAt,
    this.updatedAt,
  });

  factory Settting.fromJson(Map<String, dynamic> json) => Settting(
        id: json["id"],
        dailyFee: json["dailyFee"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dailyFee": dailyFee,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
