import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Otros_widgets
{
  BuildContext context;
  Otros_widgets({this.context});

String url_foto_defaul="https://firebasestorage.googleapis.com/v0/b/candy-disco.appspot.com/o/imagenes%2F2020-04-18%2000%3A36%3A15.162965.jpg?alt=media&token=d849c09f-4917-4613-8cc4-3e9623ad7c28";

  Widget foto_categoria( File _image, String urlFoto,double width ) {
    return GestureDetector(
      child: new Container(
        child: _image == null
            ? CachedNetworkImage(
          imageUrl:urlFoto==null? url_foto_defaul: urlFoto,
          fit: BoxFit.fill,
          width: width,
          placeholder:
              (context, url) =>
              Center(
                child:
                new CircularProgressIndicator(
                  backgroundColor:
                  Colors.white,
                ),
              ),
          errorWidget:
              (context, url, error) =>
              Icon(Icons.error),
        )
            : Image.file(
          _image,
          fit: BoxFit.fill,
          width: width,
        ),
      ),
      onTap: () {
        // _Dialo_seleccion_foto(1);
      },
    );
  }




  /*Future getImage2(int tipo) async {
    var image = await im.ImagePicker.pickImage(source: im.ImageSource.camera);
    setState(() {
      if (tipo == 1) {
        _image = image;

        _image.length().then((len) {
          print("TAMANO foto camara 1  $len");
          tamano = len;
          _verificar_imagen=false;
          setState(() {});
        });
      }
    });
  }

  Future getImage2_Galery(int tipo) async {
    var image = await im.ImagePicker.pickImage(source: im.ImageSource.gallery);

    setState(() {
      if (tipo == 1) {
        _image = image;
        _image.length().then((len) {
          print("TAMANO galeria camara 1 $len");
          tamano = len;
          _verificar_imagen=false;
          setState(() {});
        });
      }
    });
  }*/

}
