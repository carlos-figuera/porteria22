// To parse this JSON data, do
//
//     final mVisitas = mVisitasFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

MVisitas mVisitasFromJson(String str) => MVisitas.fromJson(json.decode(str));

String mVisitasToJson(MVisitas data) => json.encode(data.toJson());

class MVisitas {
  MVisitas({
   this.id,
   this.name,
   this.dni,
   this.phone,
   this.type,
   this.company,
   this.arl,
   this.eps,
   this.arlEps,
   this.plate,
   this.checkin,
   this.checkout,
   this.extension,
   this.adminId,
   this.picture,
   this.estado
  });

  int id;
  String name;
  String dni;
  String phone;
  String type;
  dynamic company;
  dynamic arl;
  dynamic eps;
  String arlEps;
  String plate;
  String checkin;
  String checkout;
  Extension extension;
  String adminId;
  String picture;
  int estado;
  factory MVisitas.fromJson(Map<String, dynamic> json) => MVisitas(
    id: json["id"],
    name: json["name"]!=null?json["name"]:"",
    dni: json["dni"]!=null?json["dni"]:"",
    phone: json["phone"]!=null?json["phone"]:"",
    type: json["type"]!=null?json["type"]:"",
    company: json["company"]!=null?json["company"]:"",
    arl: json["arl"]!=null?json["arl"]:"",
    eps: json["eps"]!=null?json["eps"]:"",
    arlEps: json["arl_eps"]!=null?json["arl_eps"]:"",
    plate: json["plate"]!=null?json["plate"]:"",
    checkin:json["checkin"]!=null? DateFormat('yyyy-MM-dd').format(DateTime.parse(json["checkin"]) )  :"",
    checkout: json["checkout"]!=null? DateFormat('yyyy-MM-dd HH:MM').format(DateTime.parse(json["checkout"]) )  :"",
    extension:json["extension"]==null?Extension(id: 0,name:""): Extension.fromJson(json["extension"]),
    adminId: json["admin_id"]??"",
    picture:json["picture"],
    estado: 1
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "dni": dni,
    "phone": phone,
    "type": type,
    "company": company,
    "arl": arl,
    "eps": eps,
    "arl_eps": arlEps,
    "plate": plate,
   // "checkin": checkin.toIso8601String(),
    "checkout": checkout,
    "extension": extension.toJson(),
    "admin_id": adminId,
    "picture": picture,
  };
}

class Extension {
  Extension({
  this.id,
  this.name,
  });

  int id;
  String name;

  factory Extension.fromJson(Map<String, dynamic> json) => Extension(
    id: json["id"]??0,
    name: json["name"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
