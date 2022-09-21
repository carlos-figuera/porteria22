import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:dio/src/response.dart' as repp;
import 'package:porteria/app/modelos/M_apartamento.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class VerificacionManualPage extends StatefulWidget {
  const VerificacionManualPage({Key key}) : super(key: key);

  @override
  _VerificacionManualPageState createState() => _VerificacionManualPageState();
}

class _VerificacionManualPageState extends State<VerificacionManualPage> {
  List<MApartameto> _lisApatamentos;
  Solicitudes_http solicitudes_http;
  bool _carga = true;
  TextEditingController _buscarApartamentoController = TextEditingController();
  TextEditingController _buscarAutoriadoController = TextEditingController();
  bool verificaAutorizado = false;
  List<String> listaApartamentos = [];
  List<Visitor> listaAutoriados = [];
  MApartameto dataAparatmento;
  Visitor dataVisitantes;

  bool esValido = false;
  String formattedDate;

  @override
  void initState() {
    super.initState();
    solicitudes_http = Solicitudes_http(context);
    gettData();
  }

  Widget textoItems({String name, String texto}) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  name,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: fontpParrafo,
                      fontWeight: FontWeight.w800,
                      color: textoGeneral),
                  textAlign: TextAlign.left,
                )),
                ExcludeSemantics(
                    child: Text(
                  texto,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: fontpParrafo,
                      fontWeight: FontWeight.w600,
                      color:esValido?Colors.green:textoSecundario),
                  textAlign: TextAlign.right,
                )),
              ],
            )));
  }

  gettData() async {
    UserData userData = UserData();
    userData = await obtenerDataUser();

    print(userData.apiToken);
    var snapshot = await solicitudes_http.getData("/api/apartments");
    _lisApatamentos = [];
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;
        _lisApatamentos =
            data1.map((model) => MApartameto.fromJson(model)).toList();
        _lisApatamentos.forEach((apa) async {
          listaApartamentos.add(apa.name);
          print("Desde hasData  ${apa.name} ");
        });
        print("Desde hasData  ${snapshot["data"]} ");
        print("Desde hasData  ${snapshot["codigo"]} ");
        print("Desde hasData  ${_lisApatamentos.length} ");
        _carga = false;
        setState(() {});
      } else {
        _carga = false;
        setState(() {});
      }
    }
  }

  finalizarVisitas() async {
    Loads loads = new Loads(context);
    loads.Carga("Procesando...");
    UserData userData = UserData();
    userData = await obtenerDataUser();
    print(userData.apiToken);
    String token = userData.apiToken;

    FormData formData = FormData.fromMap({});

    repp.Response response;
    Dio dio = Dio();
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

  reiciarBusqueda({int tipo}) {
    dataAparatmento = null;
    if (tipo == 1) {
      listaApartamentos.clear();
      _buscarApartamentoController.text = "";
      _buscarAutoriadoController.clear();
      dataVisitantes = null;

      _lisApatamentos.forEach((apa) async {
        listaApartamentos.add(apa.name);
        print("Desde hasData  ${apa.name} ");
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return _carga
        ? widget_Cargando()
        : SingleChildScrollView(
            child: SafeArea(
                left: true,
                top: true,
                right: true,
                bottom: true,
                minimum: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                child: SizedBox(
                    height: screenHeight * 0.8,
                    child: Form(
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            ExcludeSemantics(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SearchField(
                                  suggestions: listaApartamentos,
                                  hint: 'Selecciona un apartamento',
                                  searchStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  validator: (x) {
                                    if (x.length == 0) {
                                      return null;
                                    }

                                    if (!listaApartamentos.contains(x) ||
                                        x.isEmpty) {
                                      return 'Selecciona un valor';
                                    }
                                    return null;
                                  },
                                  controller: _buscarApartamentoController,
                                  searchInputDecoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      suffixIcon: dataAparatmento == null
                                          ? const Icon(Icons.search_sharp)
                                          : IconButton(
                                              onPressed: () {
                                                reiciarBusqueda(tipo: 1);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))),
                                  maxSuggestionsInViewPort: 5,
                                  itemHeight: 40,

                                ),
                              ),
                            ),
                            dataAparatmento != null
                                ? Container(
                                    height: screenHeight * 0.6,
                                    child: Column(
                                      children: [
                                        // BUSCADOR
                                        ExcludeSemantics(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextFormField(
                                              onChanged: (dato) {
                                                print(dato);

                                                if (dato.isNotEmpty) {
                                                  dataAparatmento.visitors
                                                      .forEach((lisau) async {
                                                    if (lisau.dni
                                                        .toLowerCase()
                                                        .contains(dato)) {
                                                      lisau.estado = 1;
                                                    } else {
                                                      lisau.estado = 0;
                                                      setState(() {});
                                                    }
                                                  });
                                                  setState(() {});
                                                } else {
                                                  dataAparatmento.visitors
                                                      .forEach((lisau) async {
                                                    lisau.estado = 1;
                                                  });
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                    Icons.search_sharp,
                                                    color: colorButton,
                                                  ),
                                                  labelText:
                                                      "Ingresa la cedula",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),

                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),

                                        //lISTA DE VISITANTES
                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: dataAparatmento.visitors.length,
                                                scrollDirection:Axis.horizontal ,
                                                padding: const EdgeInsets.all(2.0),
                                                itemBuilder: (context, position) {
                                                  dataAparatmento.visitors.sort((b, a) => a.id.compareTo(b.id));
                                                  dataVisitantes = dataAparatmento.visitors[position];
                                                  DateTime now = DateTime.now();
                                                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                                  DateTime ahora = DateTime.parse(formattedDate) ;

                                                  DateTime authorizedAt = DateTime.parse(dataVisitantes.authorizedAt );

                                                  print( dataVisitantes.authorizedAt);


                                                  if(authorizedAt.difference(ahora).inDays>=0)
                                                  {
                                                    esValido= true;
                                                  } else if(authorizedAt.isAfter(ahora))
                                                  {
                                                    esValido= true;
                                                  }

                                                  return dataVisitantes.estado == 1
                                                      ? SizedBox(
                                                          height: screenHeight * 0.26,
                                                           width : screenWidth * 0.96,
                                                          child: Stack(
                                                            children: [
                                                              Card(
                                                                margin:
                                                                    const EdgeInsets.all(5.0),
                                                                elevation: 5,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    //foto del visitante
                                                                    /*ExcludeSemantics(
                                                            child: ClipRRect(
                                                              child: Image.network(
                                                                dataVisitantes.qr.url,
                                                                fit: BoxFit.fill,
                                                                width: screenHeight * 0.15,
                                                                height: screenHeight * 0.25,
                                                              ),
                                                              borderRadius:
                                                                const BorderRadius.all(
                                                                Radius.circular(5),
                                                              ),
                                                            ),
                                                          ),*/
                                                                    const SizedBox(
                                                                      width: 3,
                                                                    ),

                                                                    //Datos del visitante

                                                                    Container(
                                                                      height: screenHeight * 0.3,
                                                                      width: screenWidth * 0.9,
                                                                      padding:EdgeInsets.all(10) ,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          textoItems(
                                                                              name: "Nombre",
                                                                              texto: dataVisitantes.name),
                                                                          textoItems(
                                                                              name: "Cedula",
                                                                              texto: dataVisitantes.dni),

                                                                          textoItems(
                                                                              name: "Fecha",
                                                                              texto: dataVisitantes.authorizedAt.toString()),
                                                                          textoItems(
                                                                              name: "Es valido",
                                                                              texto: esValido ? "Si" : "no"),
                                                                          Container(
                                                                              height: screenHeight * 0.09,
                                                                              width: screenWidth,
                                                                              padding: EdgeInsets.only(bottom: screenHeight * 0.01, top: screenHeight * 0.02),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: MaterialButton(
                                                                                      disabledColor: Colors.grey,
                                                                                      shape: bordeBoton,
                                                                                      minWidth: screenWidth * 0.4,
                                                                                      child: Row(
                                                                                        children: const <Widget>[
                                                                                          Expanded(
                                                                                            child: Text(
                                                                                              'Finalizar Visita',
                                                                                              style: TextStyle(fontSize: 18),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ),
                                                                                          // Icon(Icons.cloud_upload)
                                                                                        ],
                                                                                      ),
                                                                                      color: colorButton,
                                                                                      textColor: Colors.white,
                                                                                      onPressed: () {
                                                                                        reiciarBusqueda(tipo: 1);
                                                                                      },
                                                                                    ),
                                                                                    flex: 2,
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ],
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                }))
                                      ],
                                    ))
                                : const SizedBox()
                          ],
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction))));
  }
}
