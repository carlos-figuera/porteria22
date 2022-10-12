
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:porteria/Util/Const.dart';

class Formularios {
  BuildContext context;

  Formularios({this.context});
//Mantener la pantalla solo en vertical

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty)
      return "Requerido*";
    else if (!regex.hasMatch(value))
      return "Ingresa un correo valido.";
    else
      return null;
  }

  fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget campo_Texto(
      {FocusNode currentFocus,
      FocusNode nextFocus,
      String nombre,
      TextEditingController nombreController,
      bool fina,
      bool numeros,
        Function(String number)onChangeText
      }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1,horizontal:1 ),

        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: onChangeText,
          decoration: InputDecoration(
              labelText: nombre,


              border:bordeBoton  ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Requerido*';
            }

            return null;
          },
          textInputAction:
              fina == true ? TextInputAction.done : TextInputAction.next,
          controller: nombreController,
          keyboardType:
              numeros == true ? TextInputType.number : TextInputType.text,
        ),
      ),
    );
  }

  Widget campoTextoOpcional(
      {FocusNode currentFocus,
        FocusNode nextFocus,
        String nombre,
        TextEditingController nombreController,
        bool fina,
        bool numeros}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))),

          textInputAction:
          fina == true ? TextInputAction.done : TextInputAction.next,
          controller: nombreController,
          keyboardType:
          numeros == true ? TextInputType.number : TextInputType.text,
        ),
      ),
    );
  }
  Widget campoTextoMul(
      {FocusNode currentFocus,
        FocusNode nextFocus,
        String nombre,
        TextEditingController nombreController,
        bool fina,
        bool numeros}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Requerido*';
            }

            return null;
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,
              alignLabelWithHint: true,

              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))),

          textInputAction:
          fina == true ? TextInputAction.done : TextInputAction.next,
          maxLines:15,
          controller: nombreController,
          keyboardType:
          numeros == true ? TextInputType.number : TextInputType.text,
        ),
      ),
    );
  }

  Widget campo_Texto_limit(
      {FocusNode currentFocus,
      FocusNode nextFocus,
      String nombre,
      TextEditingController nombreController,
      bool fina,
      bool numeros,
      int limit}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,
              border:
              bordeBoton),
          maxLength: 10,
          validator: (value) {
            if (value.isEmpty) {
              return 'Requerido*';
            } else if (value.length < 10) {
              return 'El telefono debe 10 caracteres';
            }

            return null;
          },
          textInputAction:
              fina == true ? TextInputAction.done : TextInputAction.next,
          controller: nombreController,
          keyboardType:
              numeros == true ? TextInputType.number : TextInputType.text,
        ),
      ),
      flex: 1,
    );
  }



  Widget campo_correo(
      {FocusNode currentFocus,
      FocusNode nextFocus,
      String nombre,
      TextEditingController nombreController,
      int flex}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1,horizontal:3 ),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,


              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          validator: (String value) {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);

            if (value.isEmpty)
              return "Requerido*";
            else if (!regex.hasMatch(value))
              return "Ingresa un correo valido.";
            else
              return null;
          },
          textInputAction: TextInputAction.next,
          controller: nombreController,
          keyboardType: TextInputType.emailAddress,
        ),
      ),
      flex: flex,
    );
  }

  Limpiar_textField(
      {TextEditingController nombreController1,
      TextEditingController nombreController2,
      TextEditingController nombreController3,
      TextEditingController nombreController4,
      TextEditingController nombreController5,
      TextEditingController nombreController6,
      TextEditingController nombreController7}) {
    nombreController1 != null ? nombreController1.clear() : null;
    nombreController2 != null ? nombreController2.clear() : null;
    nombreController3 != null ? nombreController3.clear() : null;
    nombreController4 != null ? nombreController4.clear() : null;
    nombreController5 != null ? nombreController5.clear() : null;
    nombreController6 != null ? nombreController6.clear() : null;
    nombreController7 != null ? nombreController7.clear() : null;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          width: 1.0,
        color: Colors.grey
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(10.0) //                 <--- border radius here
      ),
    );
  }
}
