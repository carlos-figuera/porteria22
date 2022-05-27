

import 'dart:convert';

import 'package:intl/intl.dart';

Mplaca mautorizadosFromJson(String str) => Mplaca.fromJson(json.decode(str),2);

String mautorizadosToJson(Mplaca data) => json.encode(data.toJson());

class Mplaca {
    Mplaca({
       this.id,
       this.createdAt,
       this.updatedAt,
       this.name,
       this.dni,
       this.plate,
       this.authorizedAt,
       this.extensionId,
       this.estado
    });

    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String name;
    String dni;
    String plate;
    String authorizedAt;
    String extensionId;
    int estado;

    factory Mplaca.fromJson(Map<String, dynamic> json,int estate) => Mplaca(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        dni: json["dni"],
        plate: json["plate"]!=null?json["plate"]:"",
        authorizedAt:DateFormat('yyyy-MM-dd HH:MM').format(DateTime.parse(json["authorized_at"]) ),
        extensionId: json["extension_id"],
        estado:estate
    );


    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "dni": dni,
        "plate": plate,
        //"authorized_at": "${authorizedAt.year.toString().padLeft(4, '0')}-${authorizedAt.month.toString().padLeft(2, '0')}-${authorizedAt.day.toString().padLeft(2, '0')}",
        "extension_id": extensionId,
    };
}
