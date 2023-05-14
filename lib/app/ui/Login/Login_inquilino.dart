import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/EditText_Utli.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/componentes/formularios/fomulario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: Add text editing controllers (101)
  final TextEditingController _emailController =   TextEditingController();
  final  TextEditingController _passwordController =   TextEditingController();
  Formularios _formularios;
  final bool _lights = false;
  Loads loads;
  EditText_U editText_U;

  //Datos usuario
  //porteriaprueba@phenlinea.com
  //123456

  UserData userData =   UserData();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _clave = FocusNode();
  final FocusNode _email = FocusNode();
  final FocusNode _fake = FocusNode();
  Solicitudes_http solicitudesHttp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formularios =   Formularios(context: context);
    //_emailController.text = "porteriaprueba@phenlinea.com";
  //  _passwordController   .text = "123456";
     _emailController.text = "";
       _passwordController   .text = "";
    solicitudesHttp =   Solicitudes_http(context);
    editText_U =   EditText_U(context);
    loads =   Loads(context);
    // ObtenerSesion();
    datassss();

  }

  datassss() async {

    final storage =   FlutterSecureStorage();

// Read value
    String value = await storage.read(key: "Home");
    print("value  $value ");

  }

 login() async {
   if (_formKey.currentState.validate()) {
      print(_passwordController.text);
      var dm = await solicitudesHttp.login_usuario1(
          email: _emailController.text,
          clave: _passwordController.text,
          uri:   "/api/porteria-login",
          deciveToken: "");
      if (dm != null) {
        if (dm["ok"] == true) {
          print("Codigo respuesta ${dm["data"]}");

          Map<String, dynamic> decodedResp = dm["data"];
          guardarDataUser(dataUser:jsonEncode(decodedResp) );
          UserData userData =  UserData();
          // userData = await obtenerDataUser();
            // print("Codigo respuesta ${userData.apiToken}");

          // Navigator.pop(context);
          Navigator.pushReplacementNamed(context, "Home");
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Cartelera( )));

        }
      }
      setState(() {});
    }
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    Orientation screenOri = MediaQuery.of(context).orientation;
    double scrreH = MediaQuery.of(context).size.height;
    double scrreW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.blue,
            brightness: Brightness.dark,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 1,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          )),
      body: WillPopScope(
        onWillPop: () => _willPopCallback(),
        child:    SingleChildScrollView(
          child: Container(
            width: scrreW,
            height: screenOri == Orientation.portrait
                ? scrreH * 0.7
                : scrreH * 1.3,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:Container(

             // color: Colors.black54,
              child:  Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                          child: Text(
                            "Iniciar Sesión",
                            style: TextStyle(fontSize: 45, color: lightPrimary),
                          )),
                      flex: 3,
                    ),
                    _formularios.campo_correo(
                        currentFocus: _email,
                        nextFocus: _clave,
                        nombreController: _emailController,
                        flex:1 ,
                        nombre: ' Ingresa tu correo'),
                    const SizedBox(
                      height: 10,
                    ),
                    _formularios.campo_Texto(
                        currentFocus: _clave,
                        nextFocus: _fake,
                        nombreController: _passwordController,
                        nombre: ' Ingresa tu contraseña',
                        fina: true),

                    //Boton ingresas

                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: scrreH * 0.08,
                      onPressed: () async {
                     login();


                      },
                      shape: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          borderSide:
                          BorderSide(color: Colors.transparent)),
                      color: lightPrimary,
                      child: const Text('Ingresar',
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                mainAxisAlignment:MainAxisAlignment.spaceAround ,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
