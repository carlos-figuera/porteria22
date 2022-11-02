import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
    fit: BoxFit.fill,
  );}


Widget imagenVisiter({String urlFoto,File imagen,double h,   Function onSelectPhoto, Function onCleatForm  }) {
  return Container(
      width: 150,
      // height: 150,
      child: Column(children: [
        
         Visibility(
           visible:(urlFoto=="" && imagen==null )?true:false,
             child: GestureDetector(
               onTap:onSelectPhoto ,
               child: Icon(
                 Icons.add_a_photo_rounded,
                 size: h * 0.15,
           color: colorButton,),
             )
         ),
        Visibility(
            visible:(urlFoto=="")?false:true,
            child:  Expanded(
              child: ClipRRect(
                child:urlFoto==""?Image.asset("assets/cuenta.png") :imagen_cache_plantilla(url:urlFoto)          ,
                borderRadius:
                const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
        ),

        Visibility(
          visible:(  imagen!=null )?true:false,
          child:  Expanded(
            child: ClipRRect(
              child: Image.file(imagen,fit: BoxFit.fitWidth,)          ,
              borderRadius:
              const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        ),

        Visibility(
          visible:(urlFoto=="" && imagen==null )?false:true,
          child: Container(
              height: h*0.078,
              width: 140,
              padding: const EdgeInsets.only( top: 6,bottom: 2),
              child:Row(children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor:disableButton ,
                    radius:h*0.09 ,
                    child: IconButton(
                      onPressed: () {
                        //OnPressed Logic
                      },

                      icon:   const Icon(Icons.delete,color:Colors.white  ),


                    ),
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                    backgroundColor:colorButton ,
                    radius:h*0.09 ,
                    child: IconButton(
                      onPressed: onSelectPhoto,

                      icon:   const Icon(Icons.add_a_photo_rounded,color:Colors.white  ),


                    ),
                  ),
                ),
              ],

               mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
              ) ),
        ),
      ],  )
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
            padding: const EdgeInsets.only(top: 5),
            child: Stack(
              children: [
                Icon(
                  ico,
                  color: Button,
                  size: h * 0.13,
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
        const SizedBox(height: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: fon_nombre,fontWeight:FontWeight.w700 ),
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
              child: TextButton(
            onPressed: () {
              guardarDataUser(dataUser: null);
              Navigator.pushReplacementNamed(context, "login_inquilino");
            },
            child: const Text("Aceptar"),


           // color: Colors.blue,
            //textColor: Colors.white,
          ))
        ],
      ),
      elevation: 5,
    ),
  );
}
