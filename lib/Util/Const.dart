import 'package:flutter/material.dart';
String appName = "Phenlinea";
Color lightPrimary = Color(0xff5798D3);
Color darkPrimary = Colors.blue;

Color Button = Color(0xff5798D3);





//Colors for theme
Color barra = Color(0xff5798D3);
Color colorTextBoton = Colors.white;
Color colorButton  = Color(0xff5798D3);
Color disableButton = Color(0xffD4434B);
Color textoGeneral = Color(0xff5798D7);
Color textoSecundario = Colors.black54;


Color divisor_off = Colors.grey;
Color divisor_onn = Colors.green;

// Carculadora

double font_number = 18;
double elevacion_number = 5;
Color color_number = Color(0xff000000);

//Fuentes
double fontTitulo = 24;
double fontsubTitulo = 20;
double fontpParrafo = 16;

double marginCard = 5.5;
double padingCard = 10;

var s_titulo =
    TextStyle(fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w400);

var s_subtitulo = TextStyle(
    fontSize: 15.0, color: Colors.black87, fontWeight: FontWeight.w400);



Widget cargando = Center(
  child: new CircularProgressIndicator(
    backgroundColor: Colors.deepPurple,
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
  ),
);

double fon_title = 17;
double fon_nombre = 14;
int flex_img = 9;
double marginTop_img = 5;
int flex_nombre = 6;
double marginTop_nombre = 5.5;
double fon_title_barra = 18;
double fon_title_sec = 14;

TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 13);
TextStyle Titulo = TextStyle(fontWeight: FontWeight.w800, fontSize: 24);


ShapeBorder  bordeBoton= OutlineInputBorder(
borderRadius:
BorderRadius.all(Radius.circular(10)),
borderSide:
BorderSide(color: Colors.transparent));


ShapeBorder  bordeBotonApatamento= OutlineInputBorder(
    borderRadius:
    BorderRadius.all(Radius.circular(15)),
    borderSide:
    BorderSide(color: Colors.green,width:5, ));


//Gradiente

// static Color Gra1= Color(0xffA0157C);
Color Gra1 = Color(0xff6A1254);
Color Gra2 = Color(0xff520D3F);
Color Gra3 = Color(0xff551043);
LinearGradient gradiente = new LinearGradient(
    colors: [Gra1, Gra2, Gra3],
    stops: [0.3, 0.6, 0.9],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter);
