import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/modelos/M_apartamento.dart';
import 'package:porteria/app/modelos/M_extensiones.dart';
import 'package:dio/src/response.dart' as repp;
import 'package:dio/src/multipart_file.dart' as s_archivo;
import 'package:searchfield/searchfield.dart';

import '../../../modelos/model_user.dart';

class BodyNotificacionaWhatsa extends StatefulWidget {
  const BodyNotificacionaWhatsa({Key key}) : super(key: key);

  @override
  _BodyNotificacionaWhatsaState createState() =>
      _BodyNotificacionaWhatsaState();
}

class _BodyNotificacionaWhatsaState extends State<BodyNotificacionaWhatsa> {
  List<MApartameto> _listApa;
  final storage = FirebaseStorage.instance;
  Solicitudes_http solicitudes_http;
  bool _carga = false;

  double alto = 0.3;
  String selectApt;

  bool checkedValue = false;
  bool newApt = false;
  List<DropdownMenuItem> lis_Extensiones = [];
  MExtensiones curretExtension = MExtensiones(
      id: 0, name: "", email: "", ownerPhone: "", password: "", phones: []);

  List<MExtensiones> _listApartamentos = [];
  List<String> listaApartamentos = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _buscarApartamentoController =
      TextEditingController(text: "");

  File _image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    var image = await _picker.pickImage(source: ImageSource.camera);

    _image = File(image.path);
    _image.length().then((len) {
      print("TAMANO foto camara 1  $len");
    });
    setState(() {});
  }

  List<String> datoss = ["Primer", "segundo"];

  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    _listApa = [];
    getApartamentos();
  }

  Widget textoItems({String texto, double tamano, Color colo}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Text(
          texto,
          softWrap: true,
          style: TextStyle(
              fontSize: tamano, fontWeight: FontWeight.w600, color: colo),
          textAlign: TextAlign.left,
        ));
  }

  notifyDelivery() async {
    UserData userData = UserData();
    userData = await obtenerDataUser();
    Loads loads = new Loads(context);
    loads.Carga("Procesando...");

    userData = await obtenerDataUser();
       print(    solicitudes_http.UrlBase +
           "/api/extensions/${selectApt}/delivery");
    String token = userData.apiToken;

    FormData formData = FormData.fromMap({
      "media": _image != null
          ? s_archivo.MultipartFile.fromFileSync(_image.path,
              filename: "foto1.png")
          : null
    });

    repp.Response response;
    Dio dio = Dio();
    try {
      response = await dio.post(
        solicitudes_http.UrlBase +
            "/api/extensions/${selectApt}/delivery",
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

      if (response.statusCode == 200) {
        loads.cerrar();

        print("Desde respuest 200 " + response.toString());
        //Limpiar la panatalla
        _image = null;

        selectApt = null;
        newApt = false;
        checkedValue = false;
        loads.Toast_Resull(2, "La operación fue procesada con éxito.");
        _buscarApartamentoController.clear();
        setState(() {});
      } else if (response.statusCode >= 400) {
        loads.cerrar();
        print("Desde respuest 200 " + response.statusCode.toString());
        loads.Toast_Resull(1, "La operación ha fallado.");
      }
    } catch (error) {
      loads.cerrar();
      loads.Toast_Resull(1, "La operación ha fallado.");
    }
  }

  getApartamentos() async {
    var snapshot = await solicitudes_http.getData("/api/extensions");
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;

        _listApartamentos =
            data1.map((model) => MExtensiones.fromJson(model)).toList();

        print(data1);
        lis_Extensiones = _listApartamentos
            .map((item) => DropdownMenuItem(
                  child: Text(item.name),
                  value: item,
                ))
            .toList();

        _listApartamentos.forEach((apa) async {
          listaApartamentos.add(apa.name);
          print("Desde hasData  ${apa.name} ");
        });

        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    }
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
                child: Container(
                    height: screenHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        //Notificaciones SMS
                        const SizedBox(
                          height: 15,
                        ),

                        SizedBox(
                          child: Visibility(
                            visible: true,
                            child: SearchField(
                              suggestions: listaApartamentos,
                              hint: 'Selecciona un apartamento',
                              searchStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              validator: (x) {
                                if (x.length == 0) {
                                  curretExtension = null;
                                  return null;
                                }
                                print(x);
                                if (!listaApartamentos.contains(x) ||
                                    x.isEmpty) {
                                  return 'Dato no valido, Selecciona un valor';
                                }

                                return null;
                              },
                              hasOverlay: true,
                              controller: _buscarApartamentoController,
                              searchInputDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  suffixIcon: const Icon(Icons.search_sharp)),
                              maxSuggestionsInViewPort: 10,
                              itemHeight: 40,
                              onTap: (x) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                print(x);

                                _listApartamentos.forEach((apa) async {
                                  if (apa.name ==
                                      _buscarApartamentoController.text) {
                                    curretExtension = apa;
                                    selectApt = curretExtension.id.toString();
                                    checkedValue = true;
                                  }
                                });

                                print(" ${curretExtension.name}");

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Visibility(
                            visible: checkedValue,
                            child: Container(
                              child: Column(children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Extensión seleccionada",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                               /* Container(
                                  height: screenHeight * 0.1,
                                  width: screenWidth,
                                  //   color: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(children: [
                                    ExcludeSemantics(
                                        child: Text(
                                      "${curretExtension.name}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900),
                                    )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount:
                                              curretExtension.phones.length,
                                          reverse: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          itemBuilder: (context, position) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                child: const Icon(Icons.call),
                                                radius: screenHeight * 0.03,
                                              ),
                                            );
                                          }),
                                    )
                                  ]),
                                ),*/

                                //foto del visitante
                                Container(
                                    height: screenHeight * 0.3,
                                    width: screenWidth * 0.95,
                                    padding: const EdgeInsets.only(top: 5),
                                    child: _image != null
                                        ? Stack(
                                            children: [
                                              Container(
                                                  width: screenWidth * 0.95,
                                                  child: Image.file(
                                                    _image,
                                                    fit: BoxFit.fill,
                                                  )),
                                              Positioned(
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: screenWidth * 0.085,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        getImage();
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .add_a_photo_rounded,
                                                        size:
                                                            screenWidth * 0.07,
                                                        color: colorButton,
                                                      )),
                                                ),
                                                bottom: 5,
                                                right: 5,
                                              ),
                                            ],
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              getImage();
                                            },
                                            icon: Icon(
                                              Icons.add_a_photo_rounded,
                                              size: screenWidth * 0.3,
                                              color: colorButton,
                                            ))),
                              ]),
                              height: screenHeight * 0.42,
                              width: double.infinity,
                            )),

                        // Boton enviar
                        Container(
                            height: screenHeight * 0.08,
                            width: screenWidth,
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: MaterialButton(
                              disabledColor: Colors.grey,
                              shape: bordeBoton,
                              child: Row(
                                children: const <Widget>[
                                  Expanded(
                                    child: Text(
                                      'ENVIAR NOTIFICACIÓN',
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
                                Loads loads =   Loads(context);
                                if (selectApt != null) {
                                  notifyDelivery();
                                } else {
                                  loads.Toast_Resull(
                                      1, " Debes seleccionar una extensión.");
                                }
                              },
                            )),
                      ],
                    ))));
  }
}
