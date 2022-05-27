import 'dart:convert';

import 'package:porteria/app/modelos/model_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future guardarDataUser(String data_user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (data_user != null) {
    await prefs.setString('data_user', data_user);
  } else {
    await prefs.setString('data_user', null);
  }
}

Future<UserData> obtenerDataUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  UserData userData =   UserData();

  try {
    String Datos = await prefs.getString('data_user').toString();
    var resBody = json.decode(Datos);
    print(Datos );
    userData = UserData.fromJson1(resBody);
  } catch (e) {
    userData = null;
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