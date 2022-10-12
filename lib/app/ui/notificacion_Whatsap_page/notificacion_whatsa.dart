import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'widgets/body_notificacion_whatsapp.dart';

class NotificacionWhatsappPage extends StatefulWidget {
  @override
  _NotificacionWhatsappPageState createState() => new _NotificacionWhatsappPageState();
}

class _NotificacionWhatsappPageState extends State<NotificacionWhatsappPage> {
  Solicitudes_http solicitudes_http;
  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);

  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  Widget texto_sub(String texto, double tamano) {
    return Text(
      texto,
      softWrap: true,
      style: TextStyle(fontSize: tamano, fontWeight: FontWeight.w600),
      textAlign: TextAlign.justify,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    const screenPortrait = Orientation.portrait;
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: lightPrimary,
        title: const Text(
          "Notificaciones",
          style: TextStyle(fontSize: 20),
        ),
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
            icon: icon_back(),
            onPressed: () {
              Navigator.pop(context);
            }),

      ),
      body:const BodyNotificacionaWhatsa(),
    );

  }
}
