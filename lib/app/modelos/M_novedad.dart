// To parse this JSON data, do
//
//     final mNovedad = mNovedadFromJson(jsonString);

import 'dart:convert';

MNovedad mNovedadFromJson(String str) => MNovedad.fromJson(json.decode(str),1);

String mNovedadToJson(MNovedad data) => json.encode(data.toJson());

class MNovedad {
  MNovedad({
    this.id,
  this.read,
 this.description,
 this.pictures,
 this.porteriaId,
 this.createdAt,
 this.excerpt,
 this.picturesUrl,
  this.estado
  });

  int id;
  int read;
  String description;
  List<Picture> pictures;
  int porteriaId;
  DateTime createdAt;
  String excerpt;
  List<String> picturesUrl;
 int estado;
  factory MNovedad.fromJson(Map<String, dynamic> json, int estado) => MNovedad(
    id: json["id"]??0,
    read: json["read"]??0,
    description: json["description"]??"",
    pictures: List<Picture>.from(json["pictures"].map((x) => Picture.fromJson(x))),
    porteriaId: json["porteria_id"]??0,
    createdAt: DateTime.parse(json["created_at"])??DateTime.now(),
    excerpt: json["excerpt"]??"",
    estado:  estado,
    picturesUrl: List<String>.from(json["pictures_url"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "read": read,
    "description": description,
    "pictures": List<dynamic>.from(pictures.map((x) => x.toJson())),
    "porteria_id": porteriaId,
    "created_at": createdAt.toIso8601String(),
    "excerpt": excerpt,
    "pictures_url": List<dynamic>.from(picturesUrl.map((x) => x)),
  };
}

class Picture {
  Picture({
 this.url,
 this.path,
  });

  String url;
  String path;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    url: json["url"]??"",
    path: json["path"]??"",
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "path": path,
  };
}
