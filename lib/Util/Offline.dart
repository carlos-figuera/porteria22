import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future guardarDataUser({String dataUser}) async {

  final storage =   FlutterSecureStorage();


// Read all values
  //  Map<String, String> allValues = await storage.readAll();

// Delete value
  //   await storage.delete(key: "Home");

// Delete all
  //  await storage.deleteAll();

  print(" guardando  datos del  usuario $dataUser");

  if (dataUser != null) {

      await storage.write(key: "user", value: dataUser );

  } else {

      await storage.write(key: "user", value: null );
  }
}

Future<UserData> obtenerDataUser() async {

  UserData userData =   UserData();
  final storage =   FlutterSecureStorage();
  try {


    String value = await storage.read(key: "user");
    print("  datos del  usuario ${value.toString()}");
    var resBody = json.decode(value);

    userData = UserData.fromJson1(resBody);
  } catch (e) {
    userData = null;
    print("  datos del  usuario ${e}");
  }

  return userData;
}






Future guardarData({String data,String kei}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (data != null) {
    await prefs.setString(kei, data);
  } else {
    await prefs.setString(kei, null);
  }
}

Future<String> Obtener_data({String kei}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String Datos="";
  try {
    Datos = await prefs.getString(kei).toString();



  } catch (e) {
    Datos = null;
  }

  return Datos;
}