import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/componentes/formularios/fomulario.dart';
import 'package:dio/src/response.dart' as repp;
import 'package:dio/src/multipart_file.dart' as s_archivo;
import 'package:intl/intl.dart';

class FormularioPageNovedad extends StatefulWidget {
  @override
  _FormularioPageNovedadState createState() => _FormularioPageNovedadState();
}

class _FormularioPageNovedadState extends State<FormularioPageNovedad> {
  List<DropdownMenuItem> lis_Extensiones = [];
  Solicitudes_http solicitudes_http;
  final _formKey = GlobalKey<FormState>();
  Formularios formularios;
  Loads loads;
  TextEditingController _descripcionController = new TextEditingController();
  final FocusNode _descripcion = FocusNode();
  final FocusNode _falso = FocusNode();

  File imageFile;
  File _image1;
  File _image2;
  File _image3;
  int fileIndex=1;
  Future getImage(int tipo) async {
    var image = await ImagePicker.pickImage(
        source: tipo == 1 ? ImageSource.gallery : ImageSource.camera);

    if(fileIndex==1)
    {
      _image1 = image;
      _image1.length().then((len) {
        print("TAMANO foto  $len");
      });
    }else if(fileIndex==2)
    {
      _image2 = image;
      _image2.length().then((len) {
        print("TAMANO foto   $len");
      });
    }else if(fileIndex==3)
    {
      _image3= image;
      _image3.length().then((len) {
        print("TAMANO foto   $len");
      });
    }


    setState(() {});
  }

  registrarNovedad() async {
    Loads loads =   Loads(context);
    loads.Carga("Procesando...");
    UserData userData = UserData();
    userData = await obtenerDataUser();
    print(userData.apiToken);
    String token = userData.apiToken;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:MM').format(now);

    FormData formData = FormData.fromMap({
      "description": _descripcionController.text,
      "picture1": _image1 != null
          ? s_archivo.MultipartFile.fromFileSync(_image1.path,
              filename: "foto1.png")
          : null,
      "picture2": _image2 != null
          ? s_archivo.MultipartFile.fromFileSync(_image2.path,
              filename: "foto2.png")
          : null,
      "picture3": _image3 != null
          ? s_archivo.MultipartFile.fromFileSync(_image3.path,
              filename: "foto3.png")
          : null,
    });

    repp.Response response;
    Dio dio =  Dio();
    try {
      response = await dio.post(
        solicitudes_http.UrlBase + "/api/novelties",
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
        _image1 = null;
        _image2 = null;
        _image3 = null;
        formularios.Limpiar_textField(
            nombreController1: _descripcionController);

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



  Widget Containerregistrar() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;

    return Container(
      color: Colors.white10,
      child: SingleChildScrollView(
        child: Container(
          height: screenOri == screenPortrait
              ? screenHeight * 0.77
              : screenHeight * 1.35,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                  height: screenOri == screenPortrait
                      ? screenHeight * 0.44
                      : screenHeight * 0.3,
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        //Descripcion
                        formularios.campoTextoMul(
                            currentFocus: _descripcion,
                            nextFocus: _falso,
                            nombreController: _descripcionController,
                            fina:true ,
                            nombre: "Descripcion"),
                      ],
                    ),
                  )),
              Container(
                  height: screenHeight * 0.17,
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.only(top: 1),
                  child: Row(
                    children: [
                      botonFoto(screen: screenSize, foto: _image1,fileInde: 1),
                      botonFoto(screen: screenSize, foto: _image2,fileInde: 2),
                      botonFoto(screen: screenSize, foto: _image3,fileInde: 3),
                    ],
                  )),
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
                            'Guardar',
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


                     if (_formKey.currentState.validate()) {
                        registrarNovedad();
                      }


                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget botonFoto({Size screen, File foto, int fileInde}) {
    return Container(
        height: screen.height * 0.2,
        width: screen.width * 0.28,
        padding: EdgeInsets.only(top: 10),
        child: GestureDetector(
          child: ClipRRect(
            child: foto != null
                ? Image.file(foto)
                :  Icon(
              Icons.add_a_photo,
              size: 40,
              color: Colors.grey,
            ),
            borderRadius: new BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          onTap: () {
            fileIndex=fileInde;
            _Dialo_seleccion_foto();
          },
        ));
  }

  Future<void> _Dialo_seleccion_foto() async {
    final screenSize = MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text('Seleciona un medio '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                botonMedioFoto(
                    screenSize: screenSize,
                    name: "Tomar foto",
                    type: 2,
                    context: context1),
                SizedBox(
                  width: 20,
                ),
                botonMedioFoto(
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

  Widget botonMedioFoto(
      {Size screenSize, String name, int type, BuildContext context}) {
    return Container(
        height: screenSize.height * 0.1,
        width: screenSize.width * 0.9,
        padding: EdgeInsets.only(top: 10),
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

  @override
  void initState() {
    super.initState();
 loads = new Loads(context);

    solicitudes_http = new Solicitudes_http(context);
    formularios = new Formularios(context: context);
    solicitudes_http = new Solicitudes_http(context);
    _descripcionController = new TextEditingController(text: "");

  }

  @override
  Widget build(BuildContext context) {
    return Containerregistrar();
  }
}
