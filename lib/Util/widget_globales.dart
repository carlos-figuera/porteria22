import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';




import 'Const.dart';
import 'Offline.dart';

TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
TextStyle Titulo = TextStyle(fontWeight: FontWeight.w800, fontSize: 18);
Widget widget_Cargando() {
  return Center(
    child: new CircularProgressIndicator(
      backgroundColor: Colors.blue,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  );
}

Widget imagen_cache_plantilla({String url, double h, double w}) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => Center(child: widget_Cargando()),
    errorWidget: (context, url, error) => Icon(Icons.error),
    fit: BoxFit.cover,
  );
}






Widget icon_drawer(String path) {
  // "assets/icon_svgs/cartelera.svg",

  final Widget svgIcon = SvgPicture.asset(
      path,
     // color: Colors.black12,
      semanticsLabel: 'A red up arrow',
 fit: BoxFit.contain,
    height: 100,
  );
  return ExcludeSemantics(
    child: svgIcon,


  );
}
Widget cardNoti({IconData ico, String  title="", double h}) {
  return Card(
    elevation: 10,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Stack(
              children: [
                Icon(
                  ico,
                  color: Button,
                  size: h * 0.15,
                ),
               /* Positioned(
                  child:verNotifi? CircleAvatar(
                      child: Text("1",style: TextStyle(color: Colors.white),),
                      backgroundColor: Colors.red,
                      radius: 15):SizedBox(),right: 10,top: 10,)*/
              ],
            ),
          ),
          flex: flex_img,
        ),
        SizedBox(height: marginTop_nombre),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: fon_nombre),
            textAlign: TextAlign.center,
          ),
          flex: flex_nombre,
        )
      ],
    ),
  );
}
Widget card_home({String  assetImg="", String  title=""}) {
  return Card(
    elevation: 10,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: icon_drawer(assetImg),
          ),
          flex: flex_img,
        ),
        SizedBox(height: marginCard),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: fon_nombre),
            textAlign: TextAlign.center,
          ),
          flex: flex_nombre,
        )
      ],
    ),
  );
}

Widget icon_back() {
  // "assets/icon_svgs/cartelera.svg",
  return Icon(Icons.home);
}

Widget sesion_expirada(double alto, BuildContext context) {
  return Container(
    height: 100,
    padding:
        EdgeInsets.symmetric(vertical: alto * 0.3, horizontal: alto * 0.05),
    child: Card(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "La sesión de autenticación ha expirado.Vueva a iniciar sesión.",
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          )),
          ExcludeSemantics(
              child: FlatButton(
            onPressed: () {
              guardarDataUser(dataUser: null);
              Navigator.pushReplacementNamed(context, "login_inquilino");
            },
            child: Text("Aceptar"),
            color: Colors.blue,
            textColor: Colors.white,
          ))
        ],
      ),
      elevation: 5,
    ),
  );
}
