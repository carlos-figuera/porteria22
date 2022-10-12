import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porteria/app/modelos/Mautorizados.dart';
import 'package:porteria/app/modelos/Mplacas.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/modelos/M_apartamento.dart';
import 'package:intl/intl.dart';

class NotificacionSmsPage extends StatefulWidget {
  const NotificacionSmsPage({Key key}) : super(key: key);

  @override
  _NotificacionSmsPageState createState() => _NotificacionSmsPageState();
}

class _NotificacionSmsPageState extends State<NotificacionSmsPage> {
  List<MApartameto> _listApa;

  Solicitudes_http solicitudes_http;
  bool _carga = true;
  TextEditingController _buscarController = new TextEditingController();
  var _radioGroupValue = '3';
double alto=0.3;
String selectApt;
  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    _listApa = new List();
     getData();
  }

  Widget textoItems({String texto, double tamano, Color colo}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Text(
          texto,
          softWrap: true,
          style: TextStyle(
              fontSize: tamano, fontWeight: FontWeight.w900, color: colo),
          textAlign: TextAlign.left,
        ));
  }

  getData() async {
    var snapshot = await solicitudes_http.getData("/api/apartments");
    _listApa = new List();
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;
        _listApa = data1.map((model) => MApartameto.fromJson(model)).toList();
        print("Desde hasData  ${snapshot["data"]} ");
        print("Desde hasData  ${snapshot["codigo"]} ");
        print("Desde hasData  ${_listApa.length} ");
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

  setNotificacion({String namePara ,String dat ,String ur }) async {
    var snapshot = await solicitudes_http.enivarNotificacion(nameParam:namePara  ,data: dat,url:ur );
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"];
        setState(() {});

      } else {
        _carga = false;
        print("Desde enviar notificacion  ${snapshot["codigo"]} ");
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
        :  SingleChildScrollView(
        child: SafeArea(
            left: true,
            top: true,
            right: true,
            bottom: true,
            minimum: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
            child:     Container(
            height: screenHeight,
            child: Column(
              children: [
                //Notificaciones SMS

                Container(
                    height: screenHeight * (_radioGroupValue=="3"?0.42:0.3),
                    width: screenWidth,
                    child: Padding(
                      padding: EdgeInsets.all(screenHeight * 0.01),
                      child: Column(
                        children: [
                       /*   Container(
                              height: screenHeight * 0.08,
                              width: screenWidth * 1,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: RadioListTile(
                                        title: Text('Servivio'),
                                        value: '1',
                                        groupValue: _radioGroupValue,
                                        contentPadding: EdgeInsets.all(0),

                                        onChanged: (value) {
                                          setState(() {
                                            _radioGroupValue = value;
                                          });
                                        },
                                        isThreeLine: false,
                                      ),flex: 2,),
                                  Expanded(
                                      child: RadioListTile(
                                        title: Text('Administración'),
                                        value: '2',
                                        groupValue: _radioGroupValue,
                                        contentPadding: EdgeInsets.all(0),
                                        onChanged: (value) {
                                          setState(() {
                                            _radioGroupValue = value;
                                          });
                                        },
                                      ),flex:3,
                                  ),
                                ],
                              )),*/
                          Expanded(
                              child: RadioListTile(
                                title: Text('Notificar Encomienda'),
                                value: '3',
                                groupValue: _radioGroupValue,
                                contentPadding: EdgeInsets.all(0),
                                onChanged: (value) {
                                  setState(() {
                                    _radioGroupValue = value;
                                  });
                                },
                              )),



                          //Apartamentos
                          _radioGroupValue=="3"? Container(
                              height: screenHeight * 0.22,
                              child: Column(
                                children: [

                                  ExcludeSemantics(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: TextFormField(
                                        onChanged: (dato) {
                                          if (dato.length > 0) {
                                            _listApa.forEach((lisau) async {
                                              if (lisau.name.toLowerCase().contains(dato)) {
                                                print(lisau.name);

                                              } else {
                                                lisau.estado = 0;
                                              }
                                            });
                                            setState(() {});
                                          } else {
                                            _listApa.forEach((lisau) async {
                                              lisau.estado = 1;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.search_sharp,
                                              color: colorButton,
                                            ),
                                            labelText: "Selecciona o busca un apartamento",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10))),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Requerido*';
                                          }
                                          return null;
                                        },
                                        textInputAction: TextInputAction.done,
                                        controller: _buscarController,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: screenHeight * 0.1,
                                      width: screenWidth,
                                      child: ListView.builder(
                                          itemCount: _listApa.length,
                                          padding: const EdgeInsets.all(5.0),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, position) {
                                            _listApa.sort((b, a) => a.id.compareTo(b.id));
                                            return   _listApa[position].estado==1
                                                ? Container(
                                              height: screenHeight * 0.23,
                                              width: screenWidth * 0.4,
                                              child:GestureDetector(child: Card(
                                                margin: const EdgeInsets.all(5.0),
                                                elevation: 5,
                                                shape:selectApt==_listApa[position].name? bordeBotonApatamento:bordeBoton ,
                                                child: Center(
                                                    child: textoItems(
                                                        texto:
                                                        "${_listApa[position].name}",
                                                        tamano: 18,
                                                        colo: Colors.black54)),
                                              ) ,onTap: (){
                                                selectApt=_listApa[position].name;
                                                setState(() {
                                                });
                                              },),
                                            )
                                                : SizedBox();
                                          })),
                                ],
                              )):Container(),


                           // Boton enviar
                          Container(
                              height: screenHeight * 0.08,
                              width: screenWidth,
                              padding:
                              EdgeInsets.only(top: screenHeight * 0.01),
                              child: MaterialButton(
                                disabledColor: Colors.grey,
                                shape: bordeBoton,
                                child: Row(
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                        'ENVIAR SMS',
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // Icon(Icons.cloud_upload)
                                  ],
                                ),
                                color: colorButton,
                                textColor: Colors.white,
                                onPressed: () async {

                                  if(_radioGroupValue=="1")
                                  {
                                    setNotificacion(namePara:"type",dat:"services",ur:"/api/notifyGlobal"    );
                                  } else  if(_radioGroupValue=="2")
                                  {
                                    setNotificacion(namePara:"type",dat:"admin",ur:"/api/notifyGlobal"    );
                                  } else  if(_radioGroupValue=="3")
                                  {


                                    if(selectApt!=null)
                                    {
                                      setNotificacion(namePara:"name",dat:selectApt,ur:"/api/notifyDelivery"    );
                                    }else
                                      {
                                        Loads loads=new Loads(context);
                                        loads.Toast_Resull(1, " Selecciona un apartamento");
                                      }

                                  }


                                },
                              )),
                        ],
                      ),
                    )),
              ],
            ))));
  }
}
