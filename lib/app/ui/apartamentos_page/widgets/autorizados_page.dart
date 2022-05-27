import 'package:flutter/material.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/app/modelos/M_apartamento.dart';
import 'package:intl/intl.dart';
class AutorizadosPage extends StatefulWidget {
  MApartameto  listApartamentos;
  AutorizadosPage({ this.listApartamentos });

  @override
  _AutorizadosPageState createState() => _AutorizadosPageState();
}

class _AutorizadosPageState extends State<AutorizadosPage> {
   MApartameto  _listApa;

  Solicitudes_http solicitudes_http;
  bool _carga = false;
  TextEditingController _buscarController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _listApa=widget.listApartamentos;
  }

  Widget textoItems({String name, String texto}) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      name,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: fontpParrafo,
                          fontWeight: FontWeight.w800,
                          color: textoGeneral),
                      textAlign: TextAlign.right,
                    )),
                Expanded(
                    child: Text(
                      texto,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: fontpParrafo,
                          fontWeight: FontWeight.w600,
                          color: textoSecundario),
                      textAlign: TextAlign.left,
                    )),
              ],
            )));
  }




  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return  Container(
            height: screenHeight,
            child: Column(
              children: [
                SizedBox(
                  height: 3,
                ),
                ExcludeSemantics(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: TextFormField(
                      onChanged: (dato) {
                        if (dato.length > 0) {
                          _listApa.visitors.forEach((lisau) async {
                            if (lisau.name.toLowerCase().contains(dato)) {
                              print(lisau.name);
                            } else {
                              lisau.estado = 0;
                            }
                          });
                          setState(() {});
                        } else {
                          _listApa.visitors.forEach((lisau) async {
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
                        itemCount: _listApa.residents.length,
                        padding: EdgeInsets.all(2.0),
                        itemBuilder: (context, position) {
                          Color colorCheck = Colors.grey;
                          _listApa.residents.sort((b, a) => a.id.compareTo(b.id));

                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd HH:MM').format(now);

                          return _listApa.residents[position].estado == 1
                              ? Container(
                                  height: screenHeight * 0.2,
                                  child:  Card(
                                    margin: EdgeInsets.all(5.0),
                                    elevation: 5,
                                    child:Padding(
                                      padding: EdgeInsets.all(padingCard),
                                      child: Column(
                                        children: <Widget>[
                                          textoItems(
                                              name: "Nombre:",
                                              texto: " Jose Perez "),
                                          textoItems(
                                              name: "Edad:", texto: " 21 "),
                                          textoItems(
                                              name: "Propietario:",
                                              texto: " SI "),
                                          textoItems(
                                              name: "Residente:",
                                              texto: " No "),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox();
                        }))
              ],
            ));
  }
}
