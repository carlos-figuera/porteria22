import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Solicitudes_http.dart';

class Recuperar_contrasena extends StatefulWidget {
  List<dynamic> list_number;
  String id_extensiom;
  Recuperar_contrasena(this.list_number, this.id_extensiom);
  @override
  Recuperar_contrasenaState createState() => Recuperar_contrasenaState();
}

class Recuperar_contrasenaState extends State<Recuperar_contrasena> {
  // TODO: Add text editing controllers (101)
  String _curretPhone;
  String id_extensiom;
  Solicitudes_http solicitudes_http;
  List<dynamic> list_number;
  Loads loads;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loads = new Loads(context);
    list_number = new List();
    list_number = widget.list_number;
    id_extensiom = widget.id_extensiom;
    solicitudes_http = new Solicitudes_http(context);
  }

  Future Recuperar_contasena(String phone, String id_extension) async {
    print(phone);
    print(id_extension);
    if (_curretPhone != null) {
      var data = await solicitudes_http.recuperar_contrasena_inquilino(
          phone, id_extension);

      if (data != null) {
        print(data["ok"]);
        if (data["ok"]) {
          _curretPhone = null;
          //list_number = widget.list_number;
          new Future.delayed(new Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, "login_inquilino");
          });

          setState(() {});
        }
      }
    } else {
      loads.Toast_Resull(1, "Debes seleccionar un número de teléfono.");
    }
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    Orientation screenOri = MediaQuery.of(context).orientation;
    double scrreH = MediaQuery.of(context).size.height;
    double scrreW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightPrimary,
        brightness: Brightness.dark,
        title: Text("Restaurar Contraseña"),
        centerTitle: true,
      ),
      body: Stack(
       // overflow: Overflow.clip,
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: scrreW,
              height: screenOri == Orientation.portrait
                  ? scrreH * 0.6
                  : scrreH * 1.3,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    ExcludeSemantics(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Selecciona el número donde recibirás la contraseña.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: ListView.builder(
                            itemCount: list_number.length,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (context, position) {
                              String number = list_number[position];
                              String number_for =
                                  number.replaceRange(3, 8, '*****');
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Padding(
                                    child: AutoSizeText(
                                      number_for,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      softWrap: true,
                                      maxFontSize: 15,
                                      minFontSize: 13,
                                      textAlign: TextAlign.justify,
                                      wrapWords: true,
                                    ),
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  leading: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                  trailing: Icon(
                                    Icons.check_circle,
                                    color: _curretPhone == list_number[position]
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onTap: () {
                                    {
                                      _curretPhone =
                                          list_number[position].toString();
                                      setState(() {});
                                      //  launchURL(_listFactura[position].url);
                                    }
                                  },
                                ),
                              );
                            }),
                      ),
                      flex: 2,
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40.0,
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Cartelera()));

                        Recuperar_contasena(_curretPhone, widget.id_extensiom);
                      },
                      color: Colors.lightBlueAccent,
                      child: Text('Confirmar',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
