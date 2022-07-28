import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porteria/app/modelos/M_apartamento.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/componentes/formularios/fomulario.dart';
import 'package:dio/src/response.dart' as repp;
import 'package:dio/src/multipart_file.dart' as s_archivo;
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class FormularioPageVisita extends StatefulWidget {
  @override
  _FormularioPageVisitaState createState() => _FormularioPageVisitaState();
}

class _FormularioPageVisitaState extends State<FormularioPageVisita> {
  double alto = 1;
  List<DropdownMenuItem> lis_Extensiones = [];
  MApartameto _curretExtension;
  List<MApartameto> _listApartamentos = [];
  List<String> listaApartamentos = [];
  Solicitudes_http solicitudes_http;
  final _formKey = GlobalKey<FormState>();
  Formularios formularios;
  TextEditingController _nombreController =   TextEditingController();
  TextEditingController _cedulaController =   TextEditingController();
  TextEditingController _TelefononController =   TextEditingController();
  TextEditingController _placaController =   TextEditingController();
  TextEditingController _nombreEmController =   TextEditingController();
  TextEditingController _arlController =   TextEditingController();
  TextEditingController _epsController =   TextEditingController();

  TextEditingController _buscarApartamentoController=   TextEditingController();
  final FocusNode _cedula = FocusNode();
  final FocusNode _nombre = FocusNode();
  final FocusNode _telefono = FocusNode();
  final FocusNode _placa = FocusNode();
  final FocusNode _nombreEm = FocusNode();
  final FocusNode _arl = FocusNode();
  final FocusNode _eps = FocusNode();
  final FocusNode _falso = FocusNode();

  File _image;
  var _radioGroupValue = '1';
  Future getImage(int tipo) async {
    var image = await ImagePicker.pickImage(
        source: tipo == 1 ? ImageSource.gallery : ImageSource.camera);
    _image = image;
    _image.length().then((len) {
      print("TAMANO foto camara 1  $len");
    });
    setState(() {});
  }

  Future<void> _Dialo_seleccion_foto() async {
    final screenSize = MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context1) {
        return AlertDialog(
          title: const Text('Seleciona un medio '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                botonFoto(
                    screenSize: screenSize,
                    name: "Tomar foto",
                    type: 2,
                    context: context1),
                const SizedBox(
                  width: 20,
                ),
                botonFoto(
                    screenSize: screenSize,
                    name: "Abrir la galeria",
                    type: 1,
                    context: context1),
              ],
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  getApartamentos() async {
    var snapshot = await solicitudes_http.getData("/api/apartments");
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;

        _listApartamentos = data1.map((model) => MApartameto.fromJson(model)).toList();
        print(data1);
        lis_Extensiones = _listApartamentos.map((item) => DropdownMenuItem(child: Text(item.name), value: item,)).toList();

        _listApartamentos.forEach((apa) async {
          listaApartamentos.add(apa.name);
          print("Desde hasData  ${apa.name} ");
        });


        setState(() {});
      } else {
        setState(() {});
      }
    }
  }

  Widget Containerregistrar() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    const screenPortrait = Orientation.portrait;
    return   Container(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                  height: screenOri == screenPortrait
                      ? screenHeight * 0.45
                      : screenHeight * 0.45,
                  margin: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[

                       Expanded(child:  SearchField(
                         suggestions: listaApartamentos,
                         hint: 'Selecciona un apartamento',
                         searchStyle: TextStyle(
                           fontSize: 14,
                           color: Colors.black.withOpacity(0.8),
                         ),
                         validator: (x) {
                           if (x.length == 0) {
                             _curretExtension=null;
                             return null;
                           }
                           print(x);
                           if (!listaApartamentos.contains(x) || x.isEmpty) {
                             return 'Dato no valido, Selecciona un valor';
                           }

                           return null;
                         },
                         controller:_buscarApartamentoController ,
                         searchInputDecoration: InputDecoration(
                             focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(
                                 color: Colors.black.withOpacity(0.8),

                               ),

                             ),
                             border: const OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(15)),
                               borderSide: BorderSide(color: Colors.red),
                             ),
                             suffixIcon: Icon(Icons.search_sharp)),


                         maxSuggestionsInViewPort: 10,

                         itemHeight: 40,
                         onTap: (x) {
                           FocusScope.of(context).requestFocus(  FocusNode());
                           print(x);


                           _listApartamentos.forEach((apa) async {
                             if (apa.name == _buscarApartamentoController.text) {
                               _curretExtension=apa;
                             }
                           });
                           setState(() {});
                         },
                       ), ),





                        //SizedBox(height: screenHeight *0.01,),
                        // nombre
                        formularios.campo_Texto(
                            currentFocus: _nombre,
                            nextFocus: _cedula,
                            nombreController: _nombreController,
                            nombre: "Nombre "),

                        //dni
                        formularios.campo_Texto(
                            currentFocus: _cedula,
                            nextFocus: _telefono,
                            nombreController: _cedulaController,
                            numeros: true,
                            nombre: "Cedula"),

                        //Teléfono
                        formularios.campo_Texto_limit(
                            currentFocus: _telefono,
                            nextFocus: _placa,
                            nombreController: _TelefononController,
                            nombre: "Teléfono",
                            numeros: true,
                            limit: 10,
                            fina: true),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                  )),

              SizedBox(
                  height: screenHeight * 0.1,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: RadioListTile(
                          title: const Text('Personal'),
                          contentPadding: EdgeInsets.zero,
                          value: '1',
                          groupValue: _radioGroupValue,
                          onChanged: (value) {
                            setState(() {
                              _radioGroupValue = value;
                            });
                          },
                        ),
                      ),
                      Flexible(
                          child: RadioListTile(
                        title: const Text('Empresa'),
                        value: '2',
                        contentPadding: EdgeInsets.zero,
                        groupValue: _radioGroupValue,
                        onChanged: (value) {
                          setState(() {
                            _radioGroupValue = value;
                          });
                        },
                      )),
                    ],
                  )),

              Container(
                 height:_radioGroupValue == "1"?screenHeight * 0.12 : screenHeight * 0.35,
                  width: screenWidth * 0.9,
                  child: Column(
                    children: [
                      Visibility(
                        visible:_radioGroupValue == "1"?false:true,
                        child:    Expanded(
                          child: Row(
                            children: <Widget>[
                              formularios.campo_Texto(
                                  currentFocus: _nombreEm,
                                  nextFocus: _arl,
                                  nombreController: _nombreEmController,
                                  nombre: "Nombre "),
                            ],
                          ),
                        ),  ),

                      Visibility(
                        visible:_radioGroupValue == "1"?false:true,
                        child:          Expanded(
                          child: Row(
                            children: <Widget>[
                              formularios.campo_Texto(
                                  currentFocus: _arl,
                                  nextFocus: _eps,
                                  nombreController: _arlController,
                                  nombre: "ARL "),
                              const SizedBox(
                                width: 5,
                              ),
                              formularios.campo_Texto(
                                  currentFocus: _eps,
                                  nextFocus: _falso,
                                  nombreController: _epsController,
                                  nombre: "EPS "),
                            ],
                          ),
                        ),  ),

                      // SizedBox(height: screenHeight * 0.015),


                      formularios.campo_Texto(
                          currentFocus: _placa,
                          nextFocus: _falso,
                          nombreController: _placaController,
                          fina: true,
                          nombre: "Placa ")
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  )),

              //foto del visitante
              Container(
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.8,
                  padding: const EdgeInsets.only(top: 5),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _Dialo_seleccion_foto();
                    },
                    icon: Icon(
                      Icons.add_a_photo,

                      color: _image != null ? Colors.green : Colors.grey,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(5),
                      enableFeedback: true,
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),)),
                        //  alignment:Alignment.centerLeft
                      ),
                    ),
                    label: Text(
                      _image != null ? "Foto adjuntada" : "Foto del visitante",
                      style: TextStyle(
                          color: _image != null ? Colors.green : Colors.grey),
                    ),
                  )),

              SizedBox( height: 10,),
              //Botn guardar
              Container(
                  height: screenHeight * 0.085,
                  width: screenWidth,
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: MaterialButton(

                    shape: bordeBoton,
                    child:const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    color: colorButton,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        registrarVisitas();
                      }
                    },
                  )),
            ],

          ),
        ),
      ),
    );
  }

  Widget botonFoto(
      {Size screenSize, String name, int type, BuildContext context}) {
    return Container(
        height: screenSize.height * 0.08,
        width: screenSize.width * 0.9,
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            getImage(type);
          },
          icon: Icon(
            type == 1 ? Icons.image : Icons.add_a_photo,
            size: 40,
            color: colorButton,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(5),
              alignment: Alignment.centerLeft),
          label: Text(
            name,
            style: TextStyle(color: colorButton),
          ),
        ));
  }

  registrarVisitas() async {
    Loads loads = new Loads(context);
    loads.Carga("Procesando...");
    UserData userData = new UserData();
    userData = await obtenerDataUser();
    print(userData.apiToken);
    String token = userData.apiToken;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:MM').format(now);

    FormData formData = new FormData.fromMap({
      "name": _nombreController.text,
      "dni": _cedulaController.text,
      "phone": _TelefononController.text,
      "checkin": formattedDate,
      "plate": _placaController.text,
      "type": _radioGroupValue == "1" ? "singular" : "company",
      "company": _radioGroupValue == "1" ? "" : _nombreEmController.text,
      "arl": _radioGroupValue == "1" ? "" : _arlController.text,
      "eps": _radioGroupValue == "1" ? "" : _epsController.text,
      "apartment": _curretExtension.name,
      "admin_id": _curretExtension.adminId,
      "picture":_image != null
          ? s_archivo.MultipartFile.fromFileSync(_image.path,
          filename: "foto1.png")
          : null
    });

    repp.Response response;
    Dio dio = new Dio();
    try {
      response = await dio.post(
        solicitudes_http.UrlBase + "/api/visits",
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
        //Limpiar la panatalla
        _image = null;
       formularios.Limpiar_textField(
            nombreController1: _nombreController,
            nombreController2: _cedulaController ,
            nombreController3: _TelefononController,
            nombreController4: _placaController,
         nombreController5: _nombreEmController,
         nombreController6: _arlController ,
         nombreController7: _epsController);


        loads.Toast_Resull(2, "La operación fue procesada con éxito.");

        setState(() {});
      } else if (response.statusCode >= 400) {
        loads.cerrar();
        print("Desde respuest 200 " + response.statusCode.toString());
        loads.Toast_Resull(1, "La operación ha fallado.");
      }
    } catch (error) {
      loads.Toast_Resull(1, "La operación ha fallado.");
    }
  }



  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    formularios = new Formularios(context: context);
    solicitudes_http = new Solicitudes_http(context);
    _cedulaController = new TextEditingController(text: "");
    _TelefononController = new TextEditingController(text: "");
    _placaController = new TextEditingController(text: "");
    _nombreController = new TextEditingController(text: "");
    getApartamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Containerregistrar();
  }
}
