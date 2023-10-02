import 'dart:async';
import 'package:flutter/material.dart';
import 'package:porteria/app/modelos/model_user.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Offline.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/ui/apartamentos_page/apartamentos_page.dart';
import 'package:porteria/app/ui/autorizados_page/autorizados_page.dart';
import 'package:porteria/app/ui/home_page/Drawer.dart';
import 'package:porteria/app/ui/home_page/ayuda.dart';
import 'package:porteria/app/ui/notificacion_Whatsap_page/notificacion_whatsa.dart';
import 'package:porteria/app/ui/notificacion_page/placa_notificacion.dart';
import 'package:porteria/app/ui/placas_page/placa_page.dart';
import 'package:porteria/app/ui/registrar_novedad_page/registrar_novedad_page.dart';
import 'package:porteria/app/ui/visitas_page/visitas_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String nombreUnidad="";
  ScrollController _controller;

  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

  int padding_logo = 5;
  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    nombreUnida();
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  void dispose() {
    super.dispose();
  }


  nombreUnida()
  async {
    UserData userData =   UserData();
    userData = await obtenerDataUser();

    nombreUnidad=userData.name ?? "";
    Future.delayed( const Duration(seconds:2 ),);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(1),
          child: Text("$nombreUnidad",style: TextStyle(fontSize:fontTitulo ),),
        ),
        centerTitle: true,
        backgroundColor: lightPrimary,

      //  leading:const Icon(Icons.clear,size:1 ,) ,
      ),
     drawer:Drawer_admin() ,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  left: true,
                  top: true,
                  right: true,
                  bottom: true,
                  minimum: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  child: Container(
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.85
                          : MediaQuery.of(context).size.height * 1.8,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      child: Column(
                        children: <Widget>[

                          Expanded(
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                    child: GestureDetector(
                                      child: cardNoti(
                                          ico:Icons.headset_mic ,
                                          title: "Novedades",h: screenHeight),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrarNovedadPage()));
                                      },
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      child: cardNoti(
                                          ico:Icons.transfer_within_a_station_outlined ,
                                          title: "Visitas",h: screenHeight),
                                      onTap: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VisitasPage()));
                                      },
                                    )),

                               /* Expanded(
                                    child: GestureDetector(
                                      child: cardNoti(
                                          ico:Icons.sms_sharp ,
                                          title: "Notificaciones",h: screenHeight),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificaciobPage()));
                                      },
                                    )),*/

                             /*  Expanded(
                                    child: GestureDetector(
                                      child: cardNoti(
                                          ico:Icons.notification_add ,
                                          title: "Notificaciones",h: screenHeight),
                                      onTap: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NotificacionWhatsappPage()));
                                      },
                                    )),*/

                               
                               Expanded(child: SizedBox())

                                
                              ],
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[

                               /* Expanded(
                                    child: GestureDetector(
                                      child: cardNoti(
                                          ico:Icons.notification_add ,
                                          title: "Notificaciones",h: screenHeight),
                                      onTap: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NotificacionWhatsappPage()));
                                      },
                                    )),*/
                                Expanded(
                                    child: GestureDetector(
                                      child: Container(),
                                      onTap: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    cuenta_page()));
                                      },
                                    )),

                                Expanded(
                                    child: GestureDetector(
                                      child: Container(),
                                      onTap: () {

                                      },
                                    )),

                              ],
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                    child: GestureDetector(
                                      child: Container(),
                                      onTap: () {

                                      },
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      child: Container(),
                                      onTap: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    cuenta_page()));
                                      },
                                    )),

                                Expanded(
                                    child: GestureDetector(
                                      child: Container(),
                                      onTap: () {

                                      },
                                    )),

                              ],
                            ),
                            flex: 4,
                          ),
                          //Fila comunicacion 1
                       /*   Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                      child:cardNoti(
                                          ico:Icons.https ,
                                          title: "Autorizados",h: screenHeight),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AutorizadosPage()));

                                      },
                                    )),

                                Expanded(
                                    child: GestureDetector(
                                  child: cardNoti(
                                      ico:Icons.transfer_within_a_station_outlined ,
                                      title: "Visitas",h: screenHeight),
                                  onTap: () {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VisitasPage()));
                                  },
                                )),

                                Expanded(
                                    child: GestureDetector(
                                  child: cardNoti(
                                      ico:Icons.meeting_room ,
                                      title: "Apartamentos",h: screenHeight),
                                  onTap: () {

                                  /*  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrarNovedadPage()));*/
                                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApartamentosPage()));
                                  },
                                )),
                              ],
                            ),
                            flex: 4,
                          ),

                          //Fila comunicacion 2
                          Expanded(
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                    child: GestureDetector(
                                  child: cardNoti(
                                      ico:Icons.headset_mic ,
                                      title: "Novedades",h: screenHeight),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrarNovedadPage()));
                                  },
                                )),
                                Expanded(
                                    child: GestureDetector(
                                      child:cardNoti(
                                          ico:Icons.directions_car ,
                                          title: "Placas",h: screenHeight),
                                      onTap: () {
                                        // Ver_menos();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlacasPage()));
                                      },
                                    )),

                                Expanded(
                                    child: GestureDetector(
                                      child: cardNoti(
                                          ico:Icons.sms_sharp ,
                                          title: "Notificaciones",h: screenHeight),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificaciobPage()));
                                      },
                                    )),



                              ],
                            ),
                            flex: 4,
                          ),


                          //Fila comunicacion 3
                          Expanded(
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                    child: GestureDetector(
                                      child:  cardNoti(
                                          ico:Icons.logout ,
                                          title: "Salir",h: screenHeight),
                                      onTap: () {

                                        guardarDataUser(dataUser: null);
                                        Navigator.pushReplacementNamed(context, "login_inquilino");
                                      },
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(),
                                  onTap: () {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                cuenta_page()));
                                  },
                                )),

                                Expanded(
                                    child: GestureDetector(
                                      child: Container(),
                                      onTap: () {

                                      },
                                    )),

                              ],
                            ),
                            flex: 4,
                          ),*/
                        ],
                      )),
                ),
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
