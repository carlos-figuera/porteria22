// To parse this JSON data, do
//
//     final nuevo = nuevoFromJson(jsonString);

import 'dart:convert';

MQRAuto nuevoFromJson(String str) => MQRAuto.fromJson(json.decode(str));

String nuevoToJson(MQRAuto data) => json.encode(data.toJson());

class MQRAuto {
  MQRAuto({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.dni,
    this.plate,
    this.authorizedAt,
    this.extensionId,
    this.extensionName,
  });

  int id;
  String createdAt;
  String updatedAt;
  String name;
  String dni;
  String plate;
  String authorizedAt;
  String extensionId;
  String extensionName;

  factory MQRAuto.fromJson(Map<String, dynamic> json) => MQRAuto(
    id: json["id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    name: json["name"],
    dni: json["dni"],
    plate: json["plate"],
    authorizedAt: json["authorized_at"],
    extensionId: json["extension_id"],
    extensionName: json["extension_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "name": name,
    "dni": dni,
    "plate": plate,
    "authorized_at": authorizedAt,
    "extension_id": extensionId,
    "extension_name": extensionName,
  };
}
