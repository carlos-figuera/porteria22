import 'package:flutter/material.dart';
String appName = "Phenlinea";
Color lightPrimary = const Color(0xff5798D3);
Color darkPrimary = Colors.blue;

Color Button = const Color(0xff5798D3);





//Colors for theme
Color barra = const Color(0xff5798D3);
Color colorTextBoton = Colors.white;
Color colorButton  = const Color(0xff5798D3);
Color disableButton = const Color(0xffD4434B);
Color textoGeneral = const Color(0xff5798D7);
Color textoSecundario = Colors.black54;


Color divisor_off = Colors.grey;
Color divisor_onn = Colors.green;

// Carculadora

double font_number = 18;
double elevacion_number = 5;
Color colorNumber = const Color(0xff000000);

//Fuentes
double fontTitulo = 24;
double fontsubTitulo = 20;
double fontpParrafo = 16;

double marginCard = 5.5;
double padingCard = 10;

var s_titulo =
    const TextStyle(fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w400);

var s_subtitulo = const TextStyle(
    fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.w400);



Widget cargando = const Center(
  child:   CircularProgressIndicator(
    backgroundColor: Colors.deepPurple,
    valueColor:   AlwaysStoppedAnimation<Color>(Colors.white),
  ),
);

double fon_title = 17;
double fon_nombre = 16;
int flex_img = 9;
double marginTop_img = 5;
int flex_nombre = 6;
double marginTop_nombre = 10;
double fon_title_barra = 18;
double fon_title_sec = 14;

TextStyle SubTitulo = const TextStyle(fontWeight: FontWeight.w600, fontSize: 13);
TextStyle Titulo = const TextStyle(fontWeight: FontWeight.w800, fontSize: 24);


ShapeBorder  bordeBoton= const OutlineInputBorder(
borderRadius:
BorderRadius.all(Radius.circular(10)),
borderSide:
BorderSide(color: Colors.transparent));


ShapeBorder  bordeBotonApatamento= const OutlineInputBorder(
    borderRadius:
    BorderRadius.all(Radius.circular(15)),
    borderSide:
    BorderSide(color: Colors.green,width:5, ));


//Gradiente

// static Color Gra1= Color(0xffA0157C);
Color Gra1 = const Color(0xff6A1254);
Color Gra2 = const Color(0xff520D3F);
Color Gra3 = const Color(0xff551043);
LinearGradient gradiente =   LinearGradient(
    colors: [Gra1, Gra2, Gra3],
    stops: [0.3, 0.6, 0.9],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter);
