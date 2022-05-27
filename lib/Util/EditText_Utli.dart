
import 'package:flutter/material.dart';

class EditText_U {
  BuildContext  context;
  EditText_U(BuildContext  context  ) {
    this.context = context;
  }


  fieldFocusChange( FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context ).requestFocus(nextFocus);
  }

  String   validateEmail(String value) {
    Pattern  pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp  regex = RegExp(pattern);

    if (value?.isEmpty)
      return  "Requerido*"  ;
    else if (!regex.hasMatch(value ))
      return  "Ingresa un correo valido."  ;
    else
      return null;
  }
}
