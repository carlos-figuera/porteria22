import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Solicitudes_http.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/widget_globales.dart';
import 'package:porteria/app/modelos/M_apartamento.dart';
import 'package:porteria/app/ui/apartamentos_page/widgets/autorizados_page.dart';
import 'package:porteria/app/ui/apartamentos_page/widgets/residentes_page.dart';
import 'package:searchfield/searchfield.dart';
class ApartamentosPage extends StatefulWidget {
  @override
  _ApartamentosPageState createState() => new _ApartamentosPageState();
}

class _ApartamentosPageState extends State<ApartamentosPage>
    with SingleTickerProviderStateMixin {
  Solicitudes_http solicitudes_http;
  TabController _controller;
  int _selectedIndex = 0;
  List<MApartameto> _listApartademntos = [];
  TextEditingController _buscarApartamentoController = new TextEditingController();
  List<DropdownMenuItem> lisDropApartamentos = [];
  MApartameto  _curretApartamento;
  List<String> listaApartamentosS = [];
  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);
    _controller?.addListener(() {
      setState(() {
        _selectedIndex = _controller .index   ;
      });
    });
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    getApartamentos();
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  getApartamentos() async {
    print(" getApartamentos desde pagina principal");
    var snapshot = await solicitudes_http?.getData("/api/apartments");
    if (snapshot != null) {
      if (snapshot["codigo"] == "200") {
        var data1 = snapshot["data"] as List;

        _listApartademntos =
            data1.map((model) => MApartameto.fromJson(model)).toList();
        print(data1);
        lisDropApartamentos = _listApartademntos
            .map((item) => DropdownMenuItem(
                  child: Text(item.name),
                  value: item,
                ))
            .toList();

        _listApartademntos.forEach((apa) async {
          listaApartamentosS.add(apa.name);
          print("Desde hasData  ${apa.name} ");
        });

        setState(() {});
      } else {
        setState(() {});
      }
    }
  }

  Widget listaApartamentos() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;

    return ClipRRect(
      child: Container(
        color: Colors.white60,
        height: screenOri == screenPortrait
            ? screenHeight * 0.085
            : screenHeight * 1.35,
        padding: EdgeInsets.only(top: 2),
        child: DropdownButtonFormField(
          items: lisDropApartamentos,
          validator: (value) {
            if (value == null) {
              return 'Requerido';
            }
            return null;
          },
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 10, left: 4),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText:
                _curretApartamento != null ? "Selecciona tu apartamento" : "",
          ),
          alignment: Alignment.center,
          value: _curretApartamento,
          onChanged: (newValue) {
            _curretApartamento = null;
            if (newValue == null) {
            } else {
              _curretApartamento = newValue;
            }

            print("xxxxxxxxxxxxx");
            _controller?.animateTo(0);
            _controller?.notifyListeners();
          },
          hint: Text("Selecciona tu apartamento"),
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }

  Widget buscardorh() {
    return Container(
        color: Colors.white,
        child: SearchField(
          suggestions: listaApartamentosS,
          hint: 'Selecciona un apartamento',
          searchStyle: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.8),
          ),
          validator: (x) {
            if (x.length == 0) {
              _curretApartamento = null;
              setState(() {});
              return null;
            }
            print(x);
            if (!listaApartamentosS.contains(x) || x.isEmpty) {
              return 'Dato no valido, Selecciona un valor';
            }

            return null;
          },
          controller: _buscarApartamentoController,
          searchInputDecoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                icon: Icon(_curretApartamento!=null?Icons.delete:Icons.search_sharp),
                onPressed: () {
                  _buscarApartamentoController.clear();
                  _curretApartamento = null;
                  setState(() {});
                },
              )),
          maxSuggestionsInViewPort: 3,
          itemHeight: 40,

          onTap: (x) {
            FocusScope.of(context).requestFocus(new FocusNode());
            print(x);

            _buscarApartamentoController.text = x;
            _listApartademntos.forEach((apa) async {
              if (apa.name.trim() == _buscarApartamentoController.text.trim()) {
                print(apa.name);

                _curretApartamento = apa;
              }
            });
            setState(() {});
          },
        ));
  }

  Widget textoItems({String name="", String  texto=""}) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
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
                  textAlign: TextAlign.justify,
                )),
                ExcludeSemantics(
                    child: Text(
                  texto,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: fontpParrafo,
                      fontWeight: FontWeight.w600,
                      color: textoSecundario),
                  textAlign: TextAlign.right,
                )),
              ],
            )));
  }

  Widget Resume_page({MApartameto listApartamentos, Size  screenSize}) {
    return Container(
        height: 100,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(screenSize?.height * 0.02),
            child: Column(
              children: <Widget>[
                // listaApartamentos(),
                buscardorh(),


                SizedBox(height:screenSize?.height * 0.08 ,),
                textoItems(
                    name: "Parqueaderos:",
                    texto: listApartamentos?.parkingNumbersStr),
                textoItems(name: "Cuadro util:", texto: " No"),
                textoItems(
                    name: "Numero de Mascotas:",
                    texto: listApartamentos?.petsCount),
                textoItems(name: "Placa:", texto: listApartamentos?.plates),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        ));
  }

  Widget sinSeleccion({Size screenSize}) {
    return Container(
        height: screenSize.height * 0.3,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(screenSize.height * 0.02),
            child: Column(
              children: <Widget>[
                // listaApartamentos(),

                buscardorh(),
                Text(
                  "Debe seleccionar un apartamento, si la lista esta vacía. Presiona el botón para actualizar",
                  softWrap: true,
                  style: TextStyle(
                      fontSize: fontsubTitulo,
                      fontWeight: FontWeight.w800,
                      color: textoSecundario),
                  textAlign: TextAlign.center,
                ),
                Container(
                    height: screenSize.height * 0.1,
                    width: screenSize.width * 0.5,
                    padding: EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        getApartamentos();
                      },
                      icon: Icon(
                        Icons.update,
                        size: 30,
                        color: colorButton,
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(5),
                        enableFeedback: true,
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          )),
                          //  alignment:Alignment.centerLeft
                        ),
                      ),
                      label: Text(
                        "Actualizar lista",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ));
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: lightPrimary,
          title: Text(
            "Apartamentos",
            style: TextStyle(fontSize: 20),
          ),
          titleSpacing: 0,
          centerTitle: true,
          toolbarHeight: screenHeight * 0.13,
          leading: IconButton(
              icon: icon_back(),
              onPressed: () {
                Navigator.pop(context);
              }),
          bottom: TabBar(
            controller: _controller,
            tabs: [
              Tab(
                icon: Icon(Icons.receipt),
                text: "Resumen",
              ),
              Tab(
                icon: Icon(Icons.person_rounded),
                text: "Residentes",
              ),
              Tab(
                icon: Icon(Icons.security),
                text: "Autorizados",
              ),
            ],
            onTap: (index) {},
            labelColor: Colors.white,
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.zero,
          ),
          actions: [
            SizedBox(
              width: screenWidth * 0.11,
            )
          ],
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            _curretApartamento != null
                ? Resume_page(
                    listApartamentos: _curretApartamento,
                    screenSize: screenSize)
                : sinSeleccion(screenSize: screenSize),
            _curretApartamento != null
                ? ResidenteslPage(listApartamentos: _curretApartamento)
                : sinSeleccion(screenSize: screenSize),
            _curretApartamento != null
                ? AutorizadosPage(
                    listApartamentos: _curretApartamento,
                  )
                : sinSeleccion(screenSize: screenSize)
          ],
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
