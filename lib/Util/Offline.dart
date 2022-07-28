import 'dart:convert';

import 'package:porteria/app/modelos/model_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future guardarDataUser({String dataUser}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (dataUser != null) {
      prefs.setString('user', dataUser);


  } else {
      prefs.setString('user', null);
  }
}

Future<UserData> obtenerDataUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  UserData userData =   UserData();

  try {
    String Datos = prefs.getString('user').toString();
    print(Datos);
    var resBody = json.decode(Datos);

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