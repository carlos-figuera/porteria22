// To parse this JSON data, do
//
//     final mApartameto = mApartametoFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';



String mApartametoToJson(MApartameto data) => json.encode(data.toJson());

class MApartameto {
  MApartameto({
 this.id,
 this.name,
 this.parkingNumbersStr,
 this.petsCount,
 this.plates,
 this.adminId,
 this.residents,
 this.visitors,  this.estado

  });

  int id;
  String name;
  String parkingNumbersStr;
  int petsCount;
  String plates;
  int adminId;
  int estado;
  List<Resident> residents;
  List<Visitor> visitors;

  factory MApartameto.fromJson(Map<String, dynamic> json ) => MApartameto(
    id: json["id"]??0,
    name: json["name"]??"",
    parkingNumbersStr: json["parking_numbers_str"],
    petsCount: json["pets_count"]??0,
    plates: json["plate"]??"",
    adminId: json["admin_id"]??0,
    residents: List<Resident>.from(json["residents"].map((x) => Resident.fromJson(x))),
    visitors: [],
     estado: 1
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "parking_numbers_str": parkingNumbersStr,
    "pets_count": petsCount,
    "plates": plates,
    "admin_id": adminId,
    "residents": List<dynamic>.from(residents.map((x) => x.toJson())),
    "visitors": List<dynamic>.from(visitors.map((x) => x.toJson())),
  };
}

class Resident {
  Resident({
 this.name,
 this.age,
 this.dni,
 this.isOwner,
 this.isResident,
 this.extensionId,
 this.id,
 this.isAuthorized,
 this.disability,
 this.card,
 this.estado
  });

  String name;
  int age;
  String dni;
  int isOwner;
  int isResident;
  int extensionId;
  int id;
  int isAuthorized;
  int disability;
  String card;
  int estado;
  factory Resident.fromJson(Map<String, dynamic> json) => Resident(
    name: json["name"]??"",
    age: json["age"]??0,
    dni: json["dni"]??"",
    isOwner: json["is_owner"]??0,
    isResident: json["is_resident"]??0,
    extensionId: json["extension_id"]??0,
    id: json["id"]??0,
    estado: 1,
    isAuthorized: json["is_authorized"]??0,
    disability: json["disability"]??0,
    card: json["card"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "age": age,
    "dni": dni,
    "is_owner": isOwner,
    "is_resident": isResident,
    "extension_id": extensionId,
    "id": id,
    "is_authorized": isAuthorized,
    "disability": disability,
    "card": card == null ? null : card,
  };
}

class Visitor {
  Visitor({
 this.id,
 this.createdAt,
 this.updatedAt,
 this.name,
 this.dni,
 this.plate,
 this.authorizedAt,
 this.extensionId,
 this.qr,
 this.estado
  });

  int id;
  String createdAt;
  String updatedAt;
  String name;
  String dni;
  dynamic plate;
  String authorizedAt;
  String extensionId;
  Qr qr;
  int estado;

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
    id: json["id"]?? 1,
    estado:1,
    createdAt:json["created_at"]==null ?DateTime.now().toString() :  DateFormat('yyyy-MM-dd').format(DateTime.parse(json["created_at"]  )).toString()     ,
    updatedAt:json["updated_at"]==null ?DateTime.now().toString() : DateFormat('yyyy-MM-dd').format(DateTime.parse(json["updated_at"]  )).toString()       ,
    name:json["name"] ?? "",
    dni: json["dni"]?? "",
    plate: json["plate"]?? "",
    authorizedAt:  DateFormat('yyyy-MM-dd').format(DateTime.parse(json["authorized_at"] )).toString()  ?? DateTime.now().toString()      ,
    extensionId: json["extension_id"]?? "",
    qr: Qr.fromJson(json["qr"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,

    "name": name,
    "dni": dni,
    "plate": plate,

    "extension_id": extensionId,
    "qr": qr.toJson(),
  };
}

class Qr {
  Qr({
     this.path,
     this.url,
  });

  String path;
  String url;

  factory Qr.fromJson(Map<String, dynamic> json) => Qr(
    path: json["path"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "url": url,
  };
}
