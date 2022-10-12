// To parse this JSON data, do
//
//     final extensiones = extensionesFromJson(jsonString);

import 'dart:convert';

MExtensiones extensionesFromJson(String str) => MExtensiones.fromJson(json.decode(str));

String extensionesToJson(MExtensiones data) => json.encode(data.toJson());

class MExtensiones {
    MExtensiones({
        this.id,
        this.name,
        this.phone1,
        this.phone2,
        this.phone3,
        this.phone4,
        this.ownerPhone,
        this.email,
        this.password,
        this.phones,
    });

    int id;
    String name;
    String phone1;
    String phone2;
    String phone3;
    String phone4;
    String ownerPhone;
    String email;
    String password;
    List<String> phones;

    factory MExtensiones.fromJson(Map<String, dynamic> json) => MExtensiones(
        id: json["id"],
        name: json["name"],
        phone1: json["phone_1"],
        phone2: json["phone_2"],
        phone3: json["phone_3"],
        phone4: json["phone_4"],
        ownerPhone: json["owner_phone"],
        email: json["_email"],
        password: json["_password"],
        phones: List<String>.from(json["phones"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_1": phone1,
        "phone_2": phone2,
        "phone_3": phone3,
        "phone_4": phone4,
        "owner_phone": ownerPhone,
        "_email": email,
        "_password": password,
        "phones": List<dynamic>.from(phones.map((x) => x)),
    };
}
