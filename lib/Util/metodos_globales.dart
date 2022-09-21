import 'dart:io';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
//Parametros
//Color= 1 es para un mensaje de exito
//Color= 2 es para un mensaje de  error
// Mensaje:  depende del caso
Toast_Resull(int Color, String Mensage) async {
  showToast(
    "$Mensage",
    duration: const Duration(seconds: 10),
    position: ToastPosition.center,

    textPadding:const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    backgroundColor: Colors.grey   ,

    textAlign: TextAlign.center,
    radius: 10.0,

    textStyle: TextStyle(fontSize: 30.0, color:Color==1?  Colors.red:Colors.green ,),
  );


}



Future<bool> checkConnection() async {
  bool hasConnection = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      hasConnection = true;
    } else {
      hasConnection = false;
      Toast_Resull(1,
          "No hay conexión a internet, Verifica tu conexión y vuelve  a intentarlo.");
    }
  } on SocketException catch (_) {
    hasConnection = false;
    Toast_Resull(1,
        "No hay conexión a internet, Verifica tu conexión y vuelve  a intentarlo.");
  }

  return hasConnection;
}

Future<String> Convert_12_A_24(String hora_12) async {
  String hora_final = "";

  // print("La hora es ${list_hora[1]} ${list_hora[0]}");
  // print("La hora es  ${list_h_m[0]}");
  // print("El minuto exacto es  ${list_h_m[1]}");

  try {
    List list_hora = hora_12.split(" ");
    List list_h_m = list_hora[0].split(":");

    if (list_hora[1] == "AM") {
      if (list_h_m[0] == "12") {
        hora_final = "00:${list_h_m[1]}";
      } else {
        hora_final = list_hora[0];
      }
    } else {
      if (list_h_m[0] == "12") {
        hora_final = list_hora[0];
      } else {
        int hora = int.parse(list_h_m[0]) + 12;
        print("La hora despues de covertir  $hora");
        hora_final = "$hora:${list_h_m[1]}";
      }
    }
  } on SocketException catch (_) {
    hora_final = "";
  }
  return hora_final;
}

Future<String> Estado_local(String apertura, String cierre) async {
  String estado = "Cerrado";
  try {
    // String hora_apertura= await Convert_12_A_24(apertura);
    //  String hora_cierre= await Convert_12_A_24(cierre);
    var redsde = await checkConnection;
    String hora_apertura = apertura;
    String hora_cierre = cierre;
    final format_date = new DateFormat('yyyy-MM-dd');
    final format_time = new DateFormat('porteria:ss');

    var ahora = DateTime.now();

    String fecha_actual = format_date.format(ahora);
    var date_apertura = DateTime.parse(fecha_actual + " $hora_apertura");
    var date_cierre = DateTime.parse(fecha_actual + " $hora_cierre");

    var despues_apertura = ahora.isAfter(date_apertura);
    var antes_cierre = ahora.isBefore(date_cierre);
    print("comparacion apertura $ahora  $date_apertura ");
    print("comparacion cierre $ahora  $date_cierre ");
    print("comparacion apertura ${ahora.weekday} ");
    var diff = await ahora.difference(date_cierre);
    var diff1 = await ahora.difference(date_apertura);
    print(diff1.inMinutes);
    print(diff.inMinutes);

    if (despues_apertura && antes_cierre) {
      print("Ellocal esta abierto $despues_apertura   $antes_cierre ");
      estado = "Abierto ";
    } else {
      print("Ellocal esta Cerrado $despues_apertura   $antes_cierre ");
      estado = "Cerrado ";
      print("Cerrado apertura $hora_apertura $hora_cierre");
    }
  } on SocketException catch (_) {
    estado = "Cerrado";
  }
  return estado;
}
