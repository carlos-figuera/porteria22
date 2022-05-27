import 'package:eyro_toast/eyro_toast.dart';
import 'package:flutter/material.dart';

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
    await   showToaster(
        text: Mensage,

        duration: ToastDuration.long,
        gravity: ToastGravity.center,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
    backgroundColor: Colors.grey[100]   ,
    fontColor:Color==1?  Colors.red:Colors.green ,
    textAlign: TextAlign.center,

    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
    ),
    border: null,
    );

  }
}
