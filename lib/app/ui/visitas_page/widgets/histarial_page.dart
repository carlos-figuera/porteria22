import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:porteria/app/modelos/MVisitas.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:intl/intl.dart';
import 'package:dio/src/response.dart' as repp;
import 'package:dio/src/multipart_file.dart' as s_archivo;
import 'package:intl/intl.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({Key key}) : super(key: key);

  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<MVisitas> _listVisitas;

  Solicitudes_http solicitudes_http;
  bool _carga = true;
  TextEditingController _buscarController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    _listVisitas = new List();
    gettData();
  }

  Widget textoItems({String texto, double tamano, Color colo}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child:  Row(children: [


          Expanded(child: AutoSizeText(
            texto,
            maxLines: 2,
            maxFontSize:16 ,
            minFontSize: 14,
            overflow:TextOverflow.ellipsis ,
            softWrap: true,
            style: TextStyle(
                fontSize: tamano, fontWeight: FontWeight.w600, color: colo),
            textAlign: TextAlign.left,
          )  ) ,
        ],));
  }

  gettData() async {
    var snapshot = await solicitudes_http.getData("/api/visits");
    _listVisitas =   [];
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;
        _listVisitas = data1.map((model) => MVisitas.fromJson(model)).toList();
        print("Desde hasData  ${snapshot["data"]} ");
        print("Desde hasData  ${snapshot["codigo"]} ");
        print("Desde hasData  ${_listVisitas.length} ");
        _carga = false;
        if(mounted)
        {
          setState(() {});
        }
      } else {
        _carga = false;
        setState(() {});
      }
    }
  }

  finalizarVisitas() async {
    Loads loads = new Loads(context);
    loads.Carga("Procesando...");
    UserData userData = new UserData();
    userData = await obtenerDataUser();
    print(userData.apiToken);
    String token = userData.apiToken;

    FormData formData = new FormData.fromMap({});

    repp.Response response;
    Dio dio = new Dio();
    try {
      response = await dio.post(
        solicitudes_http.UrlBase + "/api/vis",
        data: await formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
        ),
        onSendProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
      );

      if (response.statusCode == 201) {
        loads.cerrar();

        print("Desde respuest 200 " + response.toString());
        loads.Toast_Resull(2, "La operación fue procesada con éxito.");
      } else if (response.statusCode >= 400) {
        loads.Toast_Resull(1, "La operación ha fallado.");
        loads.cerrar();
        print("Desde respuest 200 " + response.statusCode.toString());
      }
    } catch (error) {
      loads.cerrar();
      loads.Toast_Resull(1, "La operación ha fallado.");
      print("Desde error  " + error.toString());
    }
  }

  setNotificacion({String namePara, String dat, String ur}) async {
    var snapshot = await solicitudes_http.enivarNotificacion(
        nameParam: namePara, data: dat, url: ur);
    if (snapshot != null) {
      if (snapshot["codigo"] == 200) {
        var data1 = snapshot["data"];
        gettData();
        setState(() {});
      } else {
        print("Desde enviar notificacion  ${snapshot["codigo"]} ");
        setState(() {});
      }
    }
  }


  List<String> namApt=[];

String nameAtp({String dni })
{
  String n= "";
  if(dni.contains("#")){
    List<String> ff= dni.split("#") ;
     if(ff.length==0)
     {
       n= ff[0];
     } else{
       n= ff[1];
     }
  }
  return n;
}
  String DNIAtp({String dni })
  {
    String n= "";
    if(dni.contains("#")){
      List<String> ff= dni.split("#") ;
      n= ff[0];
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return _carga
        ? widget_Cargando()
        : Container(
            height: screenHeight,
            child: Column(
              children: [
                // BUSCADOR
                ExcludeSemantics(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (dato) {
                        if (dato.length > 0) {
                          _listVisitas.forEach((lisau) async {
                            if (lisau.name.toLowerCase().contains(dato)) {
                              print(lisau.name);
                            } else {
                              lisau.estado = 0;
                            }
                          });
                          setState(() {});
                        }else if (dato.isEmpty)   {
                          _listVisitas.forEach((lisau) async {
                            lisau.estado = 1;
                          });
                        }
                      },
                      onEditingComplete:(){
                        FocusScope.of(context).requestFocus(  FocusNode());
                      } ,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search_sharp,
                            color: colorButton,
                          ),
                          labelText: "Buscar",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Requerido*';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      controller: _buscarController,
                    ),
                  ),
                ),

                //lISTA DE VISITANTES
                Expanded(
                    child: ListView.builder(
                        itemCount: _listVisitas.length,
                        reverse: true,
                        padding: EdgeInsets.all(2.0),
                        itemBuilder: (context, position) {
                          Color colorCheck =
                              _listVisitas[position].checkout.isEmpty
                                  ? Colors.grey
                                  : Colors.green;
                          _listVisitas.sort((b, a) => a.id.compareTo(b.id));
                          var ahora = DateTime.now();
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd HH:MM').format(now);

                          print(_listVisitas[position].picture);
                          return _listVisitas[position].estado == 1
                              ? Container(
                                  height: screenHeight * 0.28,
                                  child: Stack(
                                    children: [
                                      Card(
                                        margin: EdgeInsets.all(5.0),
                                        elevation: 5,
                                        child: Row(
                                          children: <Widget>[
                                            //foto del visitante
                                           // assets/cuenta.png
                                            Container(
                                            width:screenWidth * 0.25,
                                            height: screenHeight* 0.25,
                                              child: ClipRRect(
                                                child:_listVisitas[position].picture==""?Image.asset("assets/cuenta.png") :imagen_cache_plantilla(url: _listVisitas[position].picture)          ,
                                                borderRadius:
                                                      const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),

                                            //Datos del visitante
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                          //  json["dni"].toString().split("#")[0]

                                                      child: textoItems(
                                                          texto:
                                                           "APTO :  ${_listVisitas[position].extension.name }  ${nameAtp(dni:_listVisitas[position].dni )}  "  ,
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  Expanded(
                                                      child: textoItems(
                                                          texto:
                                                              "Nombre : ${_listVisitas[position].name}",
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  Expanded(
                                                      child: textoItems(
                                                          texto:
                                                              "Cedula :    ${DNIAtp(dni:_listVisitas[position].dni)}  "  ,
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  Expanded(
                                                      child: textoItems(
                                                          texto:
                                                              "placa : ${_listVisitas[position].plate}",
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  Expanded(
                                                      child: textoItems(
                                                          texto:
                                                              "Empresa : ${_listVisitas[position].company}",
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  Expanded(
                                                      child: textoItems(
                                                          texto:
                                                              "EPS-ARL : ${_listVisitas[position].eps.toString().toUpperCase()} - ${_listVisitas[position].arl.toString().toUpperCase() } ",
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  ExcludeSemantics(
                                                      child: textoItems(
                                                          texto:
                                                              "Entrada: ${_listVisitas[position].checkin}",
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Expanded(
                                                      child: textoItems(
                                                          texto:
                                                              "Salida : ${_listVisitas[position].checkout}",
                                                          tamano: 14,
                                                          colo: Colors.black54)),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //Boton checking
                                      Positioned(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.check_circle,
                                            size: 35,
                                            color: colorCheck,
                                          ),
                                          onPressed: () {
                                            setNotificacion(
                                                namePara: "_method",
                                                dat: "PUT",
                                                ur: "/api/visits/" +
                                                    _listVisitas[position]
                                                        .id
                                                        .toString());
                                          },
                                        ),
                                        bottom: 2,
                                        right: 2,
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox();
                        }))
              ],
            ));
  }
}
