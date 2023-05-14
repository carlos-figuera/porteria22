import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  int  id=0;
  String email;
  String password;
  String userDataPassword;
  String name;
  String phone1;
  String phone2;
  String phone3;
  String phone4;
  String ownerPhone;
  String petsCount;
  String parkingNumber1;
  String parkingNumber2;
  int  hasDeposit;
  String  userDataEmail;
  String  apiToken;
  int  adminId;

  UserData({
   this.id,
   this.email,
   this.password,
   this.userDataPassword,
   this.name,
   this.phone1,
   this.phone2,
   this.phone3,
   this.phone4,
   this.ownerPhone,
   this.petsCount,
   this.parkingNumber1,
   this.parkingNumber2,
   this.hasDeposit,
   this.userDataEmail,
   this.apiToken,
   this.adminId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"]??0,
    email: json["_email"]??"",
    password: json["_password"]??"",
    userDataPassword: json["password"]??"",
    name: json["name"]??"",
    phone1: json["phone_1"]??"",
    phone2: json["phone_2"]??"",
    phone3: json["phone_3"]??"",
    phone4: json["phone_4"]??"",
    ownerPhone: json["owner_phone"]??"",
    petsCount: json["pets_count"]??"",
    parkingNumber1: json["parking_number1"]??"",
    parkingNumber2: json["parking_number2"]??"",
    hasDeposit: json["has_deposit"]??0,
    userDataEmail: json["email"]??"",
    apiToken: json["api_token"]??"",
    adminId: json["admin_id"]??0,
  );


  UserData.fromJson1(Map json) {
    id= json["id"];
    email= json["_email"];
    password= json["_password"];
    userDataPassword= json["password"];
    name= json["name"];
    phone1= json["phone_1"];
    phone2=json["phone_2"];
    phone3= json["phone_3"];
    phone4=json["phone_4"];
    ownerPhone= json["owner_phone"];
    petsCount= json["pets_count"];
    parkingNumber1= json["parking_number1"];
    parkingNumber2= json["parking_number2"];
    hasDeposit= json["has_deposit"];
    userDataEmail= json["email"];
    apiToken= json["api_token"];
    adminId= json["admin_id"];
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "_email": email,
    "_password": password,
    "password": userDataPassword,
    "name": name,
    "phone_1": phone1,
    "phone_2": phone2,
    "phone_3": phone3,
    "phone_4": phone4,
    "owner_phone": ownerPhone,
    "pets_count": petsCount,
    "parking_number1": parkingNumber1,
    "parking_number2": parkingNumber2,
    "has_deposit": hasDeposit,
    "email": userDataEmail,
    "api_token": apiToken,
    "admin_id": adminId,
  };
}
