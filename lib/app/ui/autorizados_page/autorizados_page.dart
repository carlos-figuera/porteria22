import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/ui/autorizados_page/widgets/scanQr_page.dart';
import 'package:porteria/app/ui/autorizados_page/widgets/verificacion_manual_page.dart';


class AutorizadosPage extends StatefulWidget {
  @override
  _AutorizadosPageState createState() => new _AutorizadosPageState();
}

class _AutorizadosPageState extends State<AutorizadosPage> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightPrimary,
            title: const Text(
              "Autorizados",
              style: TextStyle(fontSize: 20),
            ),
            titleSpacing: 0,
            centerTitle: true,
            leading: IconButton(
                icon: icon_back(),
                onPressed: () {
                  Navigator.pop(context);
                }),
            bottom: TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.qr_code_scanner),
                  text: "Verificar QR",
                ),
                Tab(
                  icon: Icon(Icons.edit_sharp),
                  text: "Verificacion Manual",
                ),
              ],
              onTap: (index) {},
              labelColor: Colors.white,
              indicatorWeight: 3,
              indicatorColor: Colors.white,
              labelPadding: EdgeInsets.zero,
            ),
          ),
          body: const TabBarView(
            children: [
              QRViewExample(),
              VerificacionManualPage(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),

      ),
    );

  }
}
