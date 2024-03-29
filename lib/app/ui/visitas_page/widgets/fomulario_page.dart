import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/modelos/MVisitas.dart';
import 'package:porteria/app/modelos/MVisitor.dart';

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

import '../../../modelos/M_apartamento.dart';

class FormularioPageVisita extends StatefulWidget {
  @override
  _FormularioPageVisitaState createState() => _FormularioPageVisitaState();
}

class _FormularioPageVisitaState extends State<FormularioPageVisita> {
  List<MVisitas> _listVisitas;
  bool fotoEncontrada=false;
  String  urlFoto="";
  double alto = 1;
  bool checkedValue = false;
  bool newApt = false;
  List<DropdownMenuItem> lis_Extensiones = [];
  MApartameto _curretExtension;
  List<MApartameto> _listApartamentos = [];
  List<String> listaApartamentos = [];
  Solicitudes_http solicitudes_http;
  final _formKey = GlobalKey<FormState>();
  Formularios formularios;
  TextEditingController _nombreController = TextEditingController();
  final TextEditingController _nombreAptController = TextEditingController();
  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _telefononController = TextEditingController();
  TextEditingController _placaController = TextEditingController();
  final TextEditingController _nombreEmController = TextEditingController();
  final TextEditingController _arlController = TextEditingController();
  final TextEditingController _epsController = TextEditingController();


  final FocusNode _cedula = FocusNode();
  final FocusNode _nombre = FocusNode();
  final FocusNode _nombreApt = FocusNode();
  final FocusNode _telefono = FocusNode();
  final FocusNode _placa = FocusNode();
  final FocusNode _nombreEm = FocusNode();
  final FocusNode _arl = FocusNode();
  final FocusNode _eps = FocusNode();
  final FocusNode _falso = FocusNode();
  Visitors visitor=Visitors( id: 0,phone: "",name: "",type: "",arl: "",arlEps: "", company: "",eps: "",picture: "",plate: "",  dni:"") ;


  File _image;
  var _radioGroupValue = '1';

  Future getImage(int tipo) async {
    final ImagePicker _picker = ImagePicker();

    var image = await _picker.pickImage(
        source: tipo == 1 ? ImageSource.gallery : ImageSource.camera);

    _image = File(image.path);
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

  List<String> datoss = ["Primer", "segundo"];

  getApartamentos() async {
    var snapshot = await solicitudes_http.getData("/api/apartments");
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;

        _listApartamentos =
            data1.map((model) => MApartameto.fromJson(model)).toList();
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
        setState(() {});
      }
    }
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
        _listVisitas.sort((a, b) => a.id.compareTo(b.id));


        if(mounted)
        {
          setState(() {});
        }
      } else {

        setState(() {});
      }
    }
  }
  getVisitor({   String dni}) async {
    var snapshot = await solicitudes_http.getVisitor(url1: "/api/visitors?dni=$dni");

    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"]  ;
        visitor =Visitors.fromJson(data1) ;
        print("Desde hasData  ${snapshot["data"]} ");

        if(mounted)
        {
          setState(() {});
        }
        if(dni==visitor.dni)
        {


          if(visitor.dni.isNotEmpty)
          {
            print("${visitor.name}  ${visitor.dni}     ");


            _nombreController.text=visitor.name;
            _telefononController.text=visitor.phone;
            _cedulaController.text=visitor.dni;
            _nombreEmController.text=visitor.company.toString();
            _placaController.text=visitor.plate;
            fotoEncontrada=true;
            urlFoto=visitor.picture;
            //  _image=null;
            setState(() {

            });
          }




        } else{
          //_nombreController.text="";
          //  _telefononController.text="";
          //  _cedulaController.text="";
          //  _nombreEmController.text="";
          // _placaController.text="";
          // fotoEncontrada=false;

          setState(() {

          });

        }

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
    return Container(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                  height: screenOri == screenPortrait
                      ? screenHeight * 0.47
                      : screenHeight * 0.47,
                  margin: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[

                        const SizedBox(height : 15,),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    formularios.campo_Texto(
                                        currentFocus: _nombreApt,
                                        nextFocus: _cedula,
                                        nombreController: _nombreAptController,
                                        nombre: "Numero de Apartamento "),

                                    //dni
                                    formularios.campo_Texto(
                                        currentFocus: _cedula,
                                        nextFocus: _nombre,
                                        nombreController: _cedulaController,
                                        numeros: true,
                                         onChangeText:(dni)
                                         {
                                           print("$dni     ");


                                           getVisitor(dni: dni);

                                         } ,
                                        nombre: "Cedula"),


                                    const SizedBox(height : 15,),
                                    formularios.campo_Texto(
                                        currentFocus: _nombre,
                                        nextFocus: _telefono,
                                        nombreController: _nombreController,
                                        nombre: "Nombre "),
                                    const SizedBox(height : 15,),
                                    //Teléfono
                                    formularios.campo_Texto_limit(
                                        currentFocus: _telefono,
                                        nextFocus: _placa,
                                        nombreController: _telefononController,
                                        nombre: "Teléfono",
                                        numeros: true,
                                        limit: 10,
                                        fina: true),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                         fotoEncontrada?   Container(

                             width: screenWidth *0.36,
                                // height: 150,
                                child: Column(children: [

                                  Expanded(
                                    child: ClipRRect(
                                      child:urlFoto==""?Image.asset("assets/cuenta.png") :imagen_cache_plantilla(url:urlFoto)          ,
                                      borderRadius:
                                      const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                  ),

                                  Container(
                                      height: screenHeight * 0.078,
                                      width: screenWidth *0.35,
                                      padding: const EdgeInsets.only( top: 6,bottom: 20),
                                      child: MaterialButton(
                                        shape: bordeBoton,
                                        child: const Text(
                                          'Limpiar',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                        color: disableButton,
                                        textColor: Colors.white,
                                        onPressed: () {
                                           _nombreController.text="";
                                            _telefononController.text="";
                                           _cedulaController.text="";
                                           _nombreEmController.text="";
                                            _placaController.text="";
                                            fotoEncontrada=false;
                                            visitor.id=0;
                                            _nombreAptController.clear();
                                           _image=null;
                                            setState(() {

                                            });
                                        },
                                      )),
                                ],  )
                              ):SizedBox(),


                             // imagenVisiter( urlFoto: urlFoto,imagen:_image,h: screenHeight,onSelectPhoto: _Dialo_seleccion_foto   )

                            ],
                          ),
                        ),


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
                  height: _radioGroupValue == "1"
                      ? screenHeight * 0.12
                      : screenHeight * 0.35,
                  width: screenWidth * 0.9,
                  child: Column(
                    children: [
                      Visibility(
                        visible: _radioGroupValue == "1" ? false : true,
                        child: Expanded(
                          child: Row(
                            children: <Widget>[
                              formularios.campo_Texto(
                                  currentFocus: _nombreEm,
                                  nextFocus: _arl,
                                  nombreController: _nombreEmController,
                                  nombre: "Nombre "),
                            ],
                          ),
                        ),
                      ),

                      Visibility(
                        visible: _radioGroupValue == "1" ? false : true,
                        child: Expanded(
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
                        ),
                      ),

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
                _image != null
                      ? Container(
                      width: screenWidth * 0.9,
                      height:screenHeight * 0.3 ,
                      padding:EdgeInsets.symmetric(horizontal:screenWidth * 0.05 ) ,
                      child: Image.file(
                        _image,
                        fit: BoxFit.contain,
                      ))
                      :SizedBox() ,

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
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                        //  alignment:Alignment.centerLeft
                      ),
                    ),
                    label: Text(
                      _image != null ? "Foto adjuntada" : "Foto del visitante",
                      style: TextStyle(
                          color: _image != null ? Colors.green : Colors.grey),
                    ),
                  )),

              const SizedBox(
                height: 10,
              ),
              //Botn guardar
              Container(
                  height: screenHeight * 0.09,
                  width: screenWidth,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: MaterialButton(
                    shape: bordeBoton,
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    color: colorButton,
                    textColor: Colors.white,
                    onPressed: () {
                      Loads loads = new Loads(context);
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
    UserData userData = UserData();
    userData = await obtenerDataUser();
    Loads loads = new Loads(context);
    loads.Carga("Procesando...");

    userData = await obtenerDataUser();
    print(userData.apiToken);
    String token = userData.apiToken;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:MM').format(now);


    FormData formData = FormData.fromMap({
      "name": _nombreController.text,
       "dni":  _cedulaController.text ,
      "phone": _telefononController.text,
      "checkin": formattedDate,
      "plate": _placaController.text,
      "type": _radioGroupValue == "1" ? "singular" : "company",
      "company": _radioGroupValue == "1" ? "" : _nombreEmController.text,
      "arl": _radioGroupValue == "1" ? "" : _arlController.text,
      "eps": _radioGroupValue == "1" ? "" : _epsController.text,
      "extension_name": _nombreAptController.text,
      "admin_id": userData.adminId,
      "picture": _image != null
          ? s_archivo.MultipartFile.fromFileSync(_image.path,
              filename: "foto1.png")
          : null,

    });
    FormData formDataWithVisitor = FormData.fromMap({
      "name": _nombreController.text,
      "dni":  _cedulaController.text ,
      "phone": _telefononController.text,
      "checkin": formattedDate,
      "plate": _placaController.text,
      "type": _radioGroupValue == "1" ? "singular" : "company",
      "company": _radioGroupValue == "1" ? "" : _nombreEmController.text,
      "arl": _radioGroupValue == "1" ? "" : _arlController.text,
      "eps": _radioGroupValue == "1" ? "" : _epsController.text,
      "extension_name": _nombreAptController.text,
      "admin_id": userData.adminId,
      "picture": _image != null
          ? s_archivo.MultipartFile.fromFileSync(_image.path,
          filename: "foto1.png")
          : null,
      "visitor_id":visitor.id

    });
    repp.Response response;
    Dio dio = Dio();
    try {
      response = await dio.post(
        solicitudes_http.UrlBase + "/api/visits",
        data: fotoEncontrada?formDataWithVisitor :  formData,
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
            nombreController2: _cedulaController,
            nombreController3: _telefononController,
            nombreController4: _placaController,
            nombreController5: _nombreEmController,
            nombreController6: _arlController,
            nombreController7: _epsController);
        _nombreAptController.clear();
        newApt = false;
        checkedValue = false;
        fotoEncontrada=false;
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

    gettData();
  }

  @override
  void initState() {
    super.initState();
    solicitudes_http = Solicitudes_http(context);
    formularios = Formularios(context: context);
    solicitudes_http = Solicitudes_http(context);
    _cedulaController = TextEditingController(text: "");
    _telefononController = TextEditingController(text: "");
    _placaController = TextEditingController(text: "");
    _nombreController = TextEditingController(text: "");
    getApartamentos();
    gettData();
  }

  @override
  void dispose() {


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Containerregistrar();
  }
}
