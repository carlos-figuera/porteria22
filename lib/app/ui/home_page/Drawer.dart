import 'package:flutter/material.dart';
import 'package:porteria/Util/Offline.dart';


class Drawer_admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Drawer_repartidorState();
}

class _Drawer_repartidorState extends State<Drawer_admin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget icon_drawer(String path) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ExcludeSemantics(
      child:SizedBox()
    );
  }

//  " Cartelera"
  Widget title_drawer(String title) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Padding(
        padding: EdgeInsets.only(left: 5),
        child: ExcludeSemantics(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color:Colors.grey[100],
            child: Container(
                height: MediaQuery.of(context).size.height * 0.38,
                width: MediaQuery.of(context).size.width,

                decoration:     const BoxDecoration(

                    image:   DecorationImage(
                        fit: BoxFit.contain,

                        image: AssetImage("assets/Logo.png"))),
                margin: const EdgeInsets.only( top: 50,left: 10,right: 10,bottom: 10 ),
                child: const Text("")),
          ),
      /*    ListTile(
            title: Row(
              children: <Widget>[
                icon_drawer("assets/icon_svgs/cartelera.svg"),
                title_drawer(" Cartelera")
              ],
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                icon_drawer("assets/icon_svgs/pqr2.svg"),
                title_drawer(" PQR")
              ],
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                icon_drawer("assets/icon_svgs/notificacion1.svg"),
                title_drawer(" Notificaciones")
              ],
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                icon_drawer("assets/icon_svgs/linkverde.svg"),
                title_drawer(" Link de pagos")
              ],
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                icon_drawer("assets/icon_svgs/manual2.svg"),
                title_drawer(" Manuales y documentos")
              ],
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),*/


          ListTile(
            title: Row(
              children: <Widget>[
                ExcludeSemantics(
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                    size: screenHeight * 0.05,
                  ),
                ),
                const ExcludeSemantics(
                  child: Text(" Salir"),
                )
              ],
            ),
            onTap: () {
              guardarDataUser(dataUser: null);
              Navigator.pushReplacementNamed(context, "login_inquilino");
            },
          ),
        ],
      ),

    );
  }
}
