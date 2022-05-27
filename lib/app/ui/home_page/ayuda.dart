import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/widget_globales.dart';

class cuenta_page extends StatefulWidget {
  @override
  cuenta_pageState createState() => new cuenta_pageState();
}

class cuenta_pageState extends State<cuenta_page> with WidgetsBindingObserver {
  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  TextStyle Titulo = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  List<String> _opcionesMenu = [
    "Mi cuenta",
    "Horario",
    "Galeria del Local",
    "Califica la App",
    "Compartir"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _opcionesMenu = new List();
    //  getProduct();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("Current state = $state");

    switch (state.index) {
      case 0: // resumed

        break;
      case 1: // inactive

        break;
    }
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Mi Cuenta",
          ),
          backgroundColor: lightPrimary,
          centerTitle: true,
          leading: IconButton(
              icon: icon_back(),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: WillPopScope(
          onWillPop: () => _willPopCallback(),
          child: Container(
            // color: Constants.bodyColorGerente,
            child: ListView(
              //padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: <Widget>[
                      ExcludeSemantics(
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                          size: screenHeight * 0.05,
                        ),
                      ),
                      ExcludeSemantics(
                        child: Text(" Salir"),
                      )
                    ],
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer

                    guardarDataUser(null);
                    Navigator.pushReplacementNamed(context, "login_inquilino");

                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                /* ListTile(
                  title: Item_listView("Datos de la Empresa", Icons.domain),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "Perfil_empresa");
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
             ListTile(
                  title: Item_listView("Configurar Horario", Icons.timer),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "horario_empresa");
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  title: Item_listView("Galeria del Local", Icons.image),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "galeria_empresa");
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  title: Item_listView("Califica la App", Icons.star),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Share.share('Calificar', subject: "one@101grados.com");
                  },
                ),
                ListTile(
                  title: Item_listView("Compartir el App", Icons.share),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Share.share('Calificar', subject: "one@101grados.com");
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  title: Item_listView("Ayuda", Icons.help),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "Perfil_empresa");
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),*/
              ],
            ),
          ),
        ));
  }
}
