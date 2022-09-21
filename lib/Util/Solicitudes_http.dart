import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/widget_globales.dart';

import 'metodos_globales.dart';

class Solicitudes_http {
  BuildContext  context;

  Solicitudes_http(BuildContext context) {
    this.context = context;
  }

  static Loads loads;
  String UrlBase = "https://phenlinea.com";





  Future<Map<String, dynamic>> Delete(
      {BuildContext context, String uri}) async {
    loads = new Loads(context);
    loads.Carga("Procesando...");
    UserData userData = new UserData();
    userData = await obtenerDataUser();

    print(userData.apiToken);
    String token = userData.apiToken;

    final deletData = {
      '_method': "DELETE",
    };
    var url = "$UrlBase$uri";
    //encode Map to JSON
    http.Response response = await http.delete(Uri.parse(url)   , headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      loads.cerrar();
      new Future.delayed(new Duration(seconds: 1), () async {});

      loads.Toast_Resull(2, "El registro fue eliminado");
      return {'ok': true, 'codigo': response.statusCode, "data": ""};
    } else if (response.statusCode == 302) {
      // Si LA PETICION FALLO
      loads.cerrar();
        Future.delayed(new Duration(seconds: 1), () async {
        loads?.Toast_Resull(1, "Ocurrió un error ");
      });
      return {'ok': false, 'codigo': response.statusCode, "data": ""};
    } else if (response.statusCode == 401) {
      // Si LA PETICION FALLO
      loads.cerrar();
        Future.delayed(new Duration(seconds: 1), () async {
        loads.Toast_Resull(1, "Ocurrió un error ");
      });
      return {'ok': false, 'codigo': response.statusCode, "data": ""};
    } else {
      loads.cerrar();
        Future.delayed(new Duration(seconds: 1), () async {
        loads.Toast_Resull(1, "Ocurrió un error ");
      });
      return {'ok': false, 'codigo': response.statusCode, "data": ""};
    }
  }

     Future<Map<String, dynamic>>login_usuario1(
      {String email, String clave, String  uri, String deciveToken}) async {
    loads =  Loads(context);
    loads?.Carga("Verificando...");
    var url = "$UrlBase$uri";
    print('logeando');
    final authData = {
      'email': email,
      'password': clave
    };
    http.Response resp; //"/api/extension-login"
    try {
      resp = await http.post(  Uri.parse(url)   ,
          body: authData,
          headers: {"Content-Type": "application/x-www-form-urlencoded"});

      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        loads.cerrar();
        print(decodedResp["user"]);

        return {
          'ok': true,
          'codigo': resp.statusCode,
          "data": decodedResp["user"]
        };
      } else if (resp.statusCode >= 401) {
        loads.cerrar();
        loads.Toast_Resull(1, "Error al iniciar sesión, intenta nuevamente 401");
        print(resp.statusCode);
        return {'ok': false, 'codigo': resp.statusCode};
      }
    } catch (_) {

      print('WTF');
      loads.Toast_Resull(1, "Error al iniciar sesión, intenta nuevamente $_");
      loads.cerrar();
      return {
        'ok': false,
        'mensaje': "Error al iniciar sesión, intenta nuevamente"
      };
    }
  }

  //Buscar extensiones y administradores
  Future<Map<String, dynamic>> getData_admin(String url1) async {
    loads = new Loads(context);

    loads.Carga("Buscando...");
    bool conexion = await checkConnection();
    Map<String, dynamic> _re = {"data": null, "codigo": "100"};
    if (conexion) {
      var url = "$UrlBase$url1";
      http.Response response = await http.get(Uri.parse(url)   );
      print(url);
      if (response.statusCode <= 210) {
        loads.cerrar();
        var resBody = json.decode(response.body);
        print(resBody);

        _re = {"codigo": response.statusCode, "datos": resBody};
        new Future.delayed(new Duration(seconds: 1), () async {});
      } else if (response.statusCode == 401) {
        _re = {"data": response.statusCode};
      } else {
        loads.cerrar();
        _re = {"codigo": response.statusCode, "datos": null};
      }
    }

    return _re;
  }

  //Consultar datos metodo get
  Future<Map<String, dynamic>> getData(String url1) async {
    var url = "$UrlBase$url1";
    UserData userData = new UserData();
    userData = await obtenerDataUser();
    print(url);


    String token = userData?.apiToken;
    var jsonResponse;
    var conexion = await checkConnection();

 if (conexion ) {
      http.Response response = await http.get(Uri.parse(url)   , headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResp = jsonDecode(response.body);
        //loads.cerrar();
        jsonResponse = {
          "codigo": response.statusCode.toString(),
          "data": decodedResp["data"]
        };
      } else if (response.statusCode == 401) {
        Map<String, dynamic> decodedResp = jsonDecode(response.body);
        //  loads.cerrar();
        jsonResponse = {
          "codigo": response.statusCode.toString(),
          "data": decodedResp["message"]
        };
        sesion_expirada(500.0, context);
      } else {
        Map<String, dynamic> decodedResp = jsonDecode(response.body);
        jsonResponse = {
          "codigo":"600",
          "data": decodedResp["message"]
        };

        print(decodedResp["message"]);
      }
    }

    // print(response.statusCode);
    return jsonResponse;
  }



  // http://dev.phenlinea.com/api/stores
  Future<Map<String, dynamic>> recuperar_contrasena_inquilino(
      String phone, String id_extension) async {
    loads = new Loads(context);
    loads.Carga("Procesando.");

    var url = "$UrlBase/api/extensions/$id_extension/sendpassword";
    Map<String, dynamic> decodedResp = {'ok': false, 'codigo': "0"};
    final authData = {
      'phone': phone,
    };
    http.Response resp;
    try {
      resp = await http.post(
          Uri.parse(url)    ,
          body: authData,
          headers: {
            HttpHeaders.acceptHeader: "application/json",
          });
      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        loads.cerrar();
        loads.Toast_Resull(
            2, "Contraseña fue restaurada y enviada al teléfono seleccionado.");
        return {
          'ok': true,
          'codigo': resp.statusCode,
          "data": decodedResp["data"]
        };
      } else if (resp.statusCode > 300) {
        loads.cerrar();
        loads.Toast_Resull(1, "La operación ha fallado.");
        print(" desde error  ${resp.statusCode}");
        return {
          'ok': false,
          'codigo': resp.statusCode,
          "data": decodedResp["data"]
        };
      }
      print(resp.statusCode);
      print(resp.body);
    } catch (_) {

      loads.cerrar();
      loads.Toast_Resull(1, "La operación ha fallado.");
      return {'ok': false, 'codigo': resp?.statusCode};
    }
  }

//Registar Autorizados
  Future<Map<String, dynamic>> regsitarAutorizados(
      {String  name,
      String dni,
      String ur,
      String authorizedAt,
      String plate,int update}) async {

    UserData userData = new UserData();
    userData = await obtenerDataUser();


    String token = userData?.apiToken;
    loads = new Loads(context);
    loads.Carga("Procesando...");

    print('Enviando');
    final authData = {
      'name': name,
      'dni': dni,
      'authorized_at': authorizedAt,
      'plate': plate
    };
    final authData1 = {
      'name': name,
      'dni': dni,
      'authorized_at': authorizedAt,
      //'plate': plate,
      '_method': "PUT",
    };
    var url = "$UrlBase$ur";
    http.Response resp; //"/api/extension-login"
    try {
      resp = await http.post( Uri.parse(url)   , body:update==1? authData:authData1, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"

      });

      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        loads.cerrar();
        print(decodedResp["data"]);
        loads.Toast_Resull(2, update==2?"Autorización completada ":"El registro fue creado");
        return {
          'ok': true,
          'codigo': resp.statusCode,
          "data": decodedResp["user"]
        };
      } else if (resp.statusCode == 401) {
        loads.cerrar();
        loads.Toast_Resull(1, "Error ${resp.statusCode} ");
        print(resp.statusCode);
        return {'ok': false, 'codigo': resp.statusCode};
      }
    } catch (_) {
      print('WTF');
      loads.Toast_Resull(1, "Error");
      return {
        'ok': false,
        'mensaje': "Error al iniciar sesión, intenta nuevamente"
      };
    }
  }



  //checkins Autorizados

  Future<Map<String, dynamic>> checkinsAutorizados(
      {String data,String nameParam, String url }) async {

    UserData userData = new UserData();
    userData = await obtenerDataUser();


    String  token = userData.apiToken;
    loads = new Loads(context);
    loads.Carga("Procesando...");

    print('Autorizando');
    final authData = {
      nameParam: data
    };
    http.Response resp; //"/api/extension-login"
    try {
      resp = await http.post(Uri.parse("$UrlBase$url")      , body: authData, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"

      });

      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        loads?.cerrar();
        print(decodedResp["data"]);
        loads?.Toast_Resull(2, "Esta persona fue autorizada ");
        return {
          'ok': true,
          'codigo': resp.statusCode,
          "data": decodedResp["user"]
        };
      } else if (resp.statusCode == 401) {
        loads?.cerrar();
        loads?.Toast_Resull(1, "Error ${resp.statusCode} ");
        print(resp.statusCode);
        return {'ok': false, 'codigo': resp.statusCode};
      }
    } catch (_) {
      print('WTF');
      loads?.Toast_Resull(1, "Error");
      return {
        'ok': false,
        'mensaje': "Error al iniciar sesión, intenta nuevamente"
      };
    }
  }




  Future<Map<String, dynamic>> enivarNotificacion(
      {String data,String nameParam, String url }) async {

    UserData userData = new UserData();
    userData = await obtenerDataUser();


    String token = userData?.apiToken;
    loads = new Loads(context);
    loads?.Carga("Procesando...");

    print('Procesando');
    final authData = {
      nameParam: data
    };
    http.Response resp; //"/api/extension-login"
    try {
      resp = await http.post(Uri.parse("$UrlBase$url")    , body: authData, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $token"

      });

      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        loads?.cerrar();
        print(decodedResp["data"]);
        loads.Toast_Resull(2, "Notificación enviada ");
        return {
          'ok': true,
          'codigo': resp.statusCode,
          "data": decodedResp["user"]
        };
      } else if (resp.statusCode == 401) {
        loads.cerrar();
        loads.Toast_Resull(1, "Error ${resp.statusCode} ");
        print(resp.statusCode);
        return {'ok': false, 'codigo': resp.statusCode};
      }
      else if (resp.statusCode == 403) {
        loads.cerrar();
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        loads.Toast_Resull(1, "Error ${ decodedResp["data"]["message"]} ");

        print(resp.statusCode);
        return {'ok': false, 'codigo': resp.statusCode,
          "data": decodedResp["data"]};
      }
    } catch (_) {
      print('WTF');
      loads.Toast_Resull(1, "Error");
      return {
        'ok': false,
        'mensaje': "Error al iniciar sesión, intenta nuevamente"
      };
    }
  }


  //Consultar datos Qr
  Future<Map<String, dynamic>> getQR({String url}) async {

    UserData userData = new UserData();
    userData = await obtenerDataUser();

    print("iNICIANDO CONSULTA DEL QR");

    String token = userData?.apiToken;
    var jsonResponse;
    var conexion = await checkConnection();

    if (conexion ) {
      http.Response response = await http.get(Uri.parse( url )   , headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
      if (response.statusCode == 200) {
     //   Map<String, dynamic> decodedResp = jsonDecode(response.body);
        print(response.body);
        jsonResponse = {
          "codigo": response.statusCode.toString(),
          "data": response.body
        };
      } else if (response.statusCode == 401) {
        Map<String, dynamic> decodedResp = jsonDecode(response.body);
        //  loads.cerrar();
        jsonResponse = {
          "codigo": response.statusCode.toString(),
          "data": decodedResp["message"]
        };
        sesion_expirada(500.0, context);
      } else {
        Map<String, dynamic> decodedResp = jsonDecode(response.body);
        jsonResponse = {
          "codigo":"600",
          "data": decodedResp["message"]
        };

        print(decodedResp["message"]);
      }
    }

    // print(response.statusCode);
    return jsonResponse;
  }

}
