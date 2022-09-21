
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:progress_dialog/progress_dialog.dart';

class Loads {
  BuildContext context;
  Loads(BuildContext context) {
    this.context = context;
  }

  ProgressDialog  pr;

  Carga(String Mensage) async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr .style(
        message: Mensage,
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.bounceIn,
        progressTextStyle: TextStyle(color: Colors.deepPurple),
        progress: 100.0,
        messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
          fontWeight: FontWeight.w600,
        ));
    await pr .show();
  }

  cerrar() {
    pr .hide().then((isHidden) {
      print(isHidden);
    });
  }

  //Parametros
  //Color= 1 es para un mensaje de exito
  //Color= 2 es para un mensaje de  error
  // Mensaje:  depende del caso
  Toast_Resull(int Color, String Mensage) async {

      showToast(
        "$Mensage",
        duration: const Duration(seconds: 4),
        position: ToastPosition.center,
       textPadding:const EdgeInsets.symmetric(
         horizontal: 16,
         vertical: 12,
       ),
        backgroundColor: Colors.grey[100]   ,

        textAlign: TextAlign.center,
        radius: 3.0,
        textStyle: TextStyle(fontSize: 30.0, color:Color==1?  Colors.red:Colors.green ,),
      );
  }
}
