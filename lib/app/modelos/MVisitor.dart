// To parse this JSON data, do
//
//     final visitor = visitorFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Visitors visitorFromJson(String str) => Visitors.fromJson(json.decode(str));

String visitorToJson(Visitors data) => json.encode(data.toJson());

class Visitors {
    int id;
    String name;
    String dni;
    String phone;
    String plate;
    String type;
    String company;
    String arl;
    String eps;
    String arlEps;
    String picture;

    Visitors({
        this.id,
          this.name,
          this.dni,
          this.phone,
          this.plate,
          this.type,
          this.company,
          this.arl,
          this.eps,
          this.arlEps,
          this.picture,
    });


    factory Visitors.fromJson(Map<String, dynamic> json) => Visitors(
        id: json["id"]??0,
        name: json["name"]??"",
        dni: json["dni"]??"",
        phone: json["phone"]??"",
        plate: json["plate"]??"",
        type: json["type"]??"",
        company: json["company"]??"",
        arl: json["arl"]??"",
        eps: json["eps"]??"",
        arlEps: json["arl_eps"]??"",
        picture: json["picture"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dni": dni,
        "phone": phone,
        "plate": plate,
        "type": type,
        "company": company,
        "arl": arl,
        "eps": eps,
        "arl_eps": arlEps,
        "picture": picture,
    };
}
