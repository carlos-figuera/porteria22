import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/ui/placas_page/widgets/consultar_por_placa_page.dart';


class PlacasPage extends StatefulWidget {
  @override
  _PlacasPageState createState() => new _PlacasPageState();
}

class _PlacasPageState extends State<PlacasPage> {
  Solicitudes_http solicitudes_http;
  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightPrimary,
        title: Text(
          "Placas",
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
      body: ConsulatarPorPlacaPage(),
    );

  }
}
