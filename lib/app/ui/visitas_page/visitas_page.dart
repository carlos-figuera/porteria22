import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/ui/visitas_page/widgets/fomulario_page.dart';
import 'package:porteria/app/ui/visitas_page/widgets/histarial_page.dart';


class VisitasPage extends StatefulWidget {
  @override
  _VisitasPageState createState() => new _VisitasPageState();
}

class _VisitasPageState extends State<VisitasPage> {
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
    final screenPortrait = Orientation.portrait;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightPrimary,
            title: Text(
              "Visitas",
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
              tabs: [
                Tab(
                  icon: Icon(Icons.person_add_alt_1_sharp),
                  text: "Registrar",
                ),
                Tab(
                  icon: Icon(Icons.library_books_sharp),
                  text: "Historial",
                ),
              ],
              onTap: (index) {},
              labelColor: Colors.white,
              indicatorWeight: 3,
              indicatorColor: Colors.white,
              labelPadding: EdgeInsets.zero,
            ),
          ),
          body: TabBarView(
            children: [
              FormularioPageVisita(),
              HistorialPage(),
            ],
          ),
        ),
      ),
    );

  }
}
