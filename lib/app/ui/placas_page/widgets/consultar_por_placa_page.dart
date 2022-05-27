import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/modelos/M_apartamento.dart';

class ConsulatarPorPlacaPage extends StatefulWidget {
  const ConsulatarPorPlacaPage({Key key}) : super(key: key);

  @override
  _ConsulatarPorPlacaPageState createState() => _ConsulatarPorPlacaPageState();
}

class _ConsulatarPorPlacaPageState extends State<ConsulatarPorPlacaPage> {

  List<MApartameto> _listApt;
  Solicitudes_http solicitudes_http;
  bool _carga = true;
  TextEditingController _buscarController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    _listApt = new List();
    gettData();
  }

  Widget textoItems({String apartamento,String placa, double tamano, Color colo}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(children: [
         Expanded(child:    Text(
          "Apt: " + apartamento,
           softWrap: true,
           style: TextStyle(
               fontSize: tamano, fontWeight: FontWeight.w600, color: colo),
           textAlign: TextAlign.left,
         ) ,),

          Expanded(child:    Text(
            "Placa: " + placa  ,
            softWrap: true,
            style: TextStyle(
                fontSize: tamano, fontWeight: FontWeight.w600, color: colo),
            textAlign: TextAlign.right,
          ) ,)

        ],));
  }

  gettData() async {
    var snapshot = await solicitudes_http.getData("/api/apartments");
    _listApt = new List();
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;
        _listApt = data1.map((model) => MApartameto.fromJson(model)).toList();
        print("Desde hasData  ${snapshot["data"]} ");
        print("Desde hasData  ${snapshot["codigo"]} ");
        print("Desde hasData  ${_listApt.length} ");
        _carga = false;

        setState(() {});


      } else {
        _carga = false;
        print("Desde cartelera  ${snapshot["codigo"]} ");
        print("Desde cartelera  ${snapshot.toString()} ");
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return _carga
        ? widget_Cargando()
        : SingleChildScrollView(
        child: SafeArea(
            left: true,
            top: true,
            right: true,
            bottom: true,
            minimum: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
            child:Container(
            height: screenHeight,
            child: Column(
              children: [
                //Notificaciones SMS
                Padding(
                  padding: EdgeInsets.only(top:screenHeight * 0.03,bottom:screenHeight * 0.03  ),
                  child: Text("Ingresa el numero de  placa",
                      style:
                      TextStyle(fontSize: fontTitulo, color: textoGeneral)),
                ),
                Container(
                    height: screenHeight * 0.72,
                    child: Column(
                      children: [
                        ExcludeSemantics(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              onChanged: (dato) {
                                if (dato.length > 0) {
                                  _listApt.forEach((lisau) async {
                                    if (lisau.plates.toLowerCase().contains(dato)) {
                                      print(lisau.plates);
                                      lisau.estado = 1;
                                    } else {
                                      lisau.estado = 0;
                                    }
                                  });
                                  setState(() {});
                                } else {
                                  _listApt.forEach((lisau) async {
                                    lisau.estado = 1;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.search_sharp,
                                    color: colorButton,
                                  ),
                                  labelText: "Buscar",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Requerido*';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              controller: _buscarController,
                            ),
                          ),
                        ),
                        Expanded(

                            child: ListView.builder(
                                itemCount: _listApt.length,
                                padding: EdgeInsets.all(2.0),
                                // scrollDirection: Axis.horizontal,
                                itemBuilder: (context, position) {
                                  _listApt.sort((b, a) => a.id.compareTo(b.id));
                                  return _listApt[position].estado == 1
                                      ? Container(
                                    height: screenHeight * 0.1,
                                    width: screenWidth * 0.4,
                                    child: Card(
                                      margin: EdgeInsets.all(5.0),
                                      elevation: 5,
                                      child: Center(
                                          child: textoItems(
                                             apartamento:_listApt[position].name ,placa:_listApt[position].plates,
                                              tamano: 19,
                                              colo: Colors.black54)),
                                    ),
                                  )
                                      : SizedBox();
                                }))
                      ],
                    )),





              ],
            ))));
  }
}
