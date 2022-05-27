import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:porteria/Util/Const.dart';
import 'package:porteria/Util/Load.dart';
import 'package:porteria/Util/Solicitudes_http.dart';

import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';
class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}



class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool statusCamara = true;
  bool errorScan = true;
  bool esValido = false;
  BuildContext contex;
  Solicitudes_http    solicitudes_http;
  Loads loads;
  Map <dynamic, dynamic> decodedResp ;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }

    controller.resumeCamera();
  }


  @override
  void initState() {
    super.initState();
    solicitudes_http = new Solicitudes_http(context);
    loads=  Loads(context);

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;

    contex = context;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          decodedResp == null
              ? ExcludeSemantics(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(2),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await controller?.toggleFlash();
                                    setState(() {});
                                  },
                                  child: FutureBuilder(
                                    future: controller?.getFlashStatus(),
                                    builder: (context, snapshot) {
                                      return snapshot.data == false
                                          ? Icon(Icons.flash_off)
                                          : Icon(Icons.flash_on);
                                    },
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.all(2),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await controller?.flipCamera();
                                    setState(() {});
                                  },
                                  child: FutureBuilder(
                                    future: controller?.getCameraInfo(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        print(
                                            "  data camara ${snapshot.data.toString()}");
                                        return snapshot.data ==
                                                CameraFacing.front
                                            ? Icon(Icons.camera_front)
                                            : Icon(Icons.camera);
                                      } else {
                                        return Text('loading');
                                      }
                                    },
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      statusCamara ? Colors.grey : colorButton),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  enableFeedback: true,
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                      Radius.circular(1.0),
                                    )),
                                    //  alignment:Alignment.centerLeft
                                  ),
                                ),
                                onPressed: () async {
                                  statusCamara = !statusCamara;
                                  print(controller?.getFlashStatus());
                                  await controller?.pauseCamera();
                                  setState(() {});
                                },
                                child: Icon(Icons.pause),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      statusCamara ? colorButton : Colors.grey),
                                  elevation:
                                      MaterialStateProperty.all<double>(5),
                                  enableFeedback: true,
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                      Radius.circular(1.0),
                                    )),
                                    //  alignment:Alignment.centerLeft
                                  ),
                                ),
                                onPressed: () async {
                                  statusCamara = !statusCamara;

                                  print(controller?.getFlashStatus());
                                  await controller?.resumeCamera();

                                  setState(() {});
                                },
                                child: Icon(Icons.play_circle_fill),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          decodedResp != null
              ? Container(
                  // color: Colors.green,
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  child: Column(
                    children: [
                      textoItems(
                          name: "Nombre", texto: decodedResp["n"]??""  ),
                      textoItems(name: "Cedula", texto:  decodedResp["d"] ??"" ),
                      textoItems(name: "Fecha", texto: decodedResp["auT"]??"" ),
                      textoItems(name: "Es valido", texto:esValido? "Si":"no"),
                      textoItems(name: "Apartamento", texto:decodedResp["extN"]??""),
                      Container(
                          height: screenHeight * 0.09,
                          width: screenWidth,
                          padding: EdgeInsets.only(
                              bottom: screenHeight * 0.01,
                              top: screenHeight * 0.01),
                          child: Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  disabledColor: Colors.grey,
                                  shape: bordeBoton,
                                  minWidth: screenWidth * 0.4,
                                  child: Row(
                                    children: const <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      // Icon(Icons.cloud_upload)
                                    ],
                                  ),
                                  color: disableButton,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    reiniciarScaner();

                                  },
                                ),
                                flex: 2,
                              ),
                              SizedBox(width:  screenWidth * 0.02,),
                              Expanded(
                                child: MaterialButton(
                                  disabledColor: Colors.grey,
                                  shape: bordeBoton,
                                  minWidth: screenWidth * 0.4,
                                  child: Row(
                                    children: const <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Finalizar',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      // Icon(Icons.cloud_upload)
                                    ],
                                  ),
                                  color: colorButton,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setNotificacion(
                                        namePara: "name",
                                        dat: "1000",
                                        ur: "/api/notifyDelivery");
                                  },
                                ),
                                flex: 2,
                              )
                            ],
                          )),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  Widget textoItems({String name, String texto}) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  name,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: fontpParrafo,
                      fontWeight: FontWeight.w800,
                      color: textoGeneral),
                  textAlign: TextAlign.left,
                )),
                ExcludeSemantics(
                    child: Text(
                  texto,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: fontpParrafo,
                      fontWeight: FontWeight.w600,
                      color:esValido?Colors.green:textoSecundario),
                  textAlign: TextAlign.right,
                )),
              ],
            )));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(()   {
        result = scanData;
        if(scanData!=null)
        {

          controller.pauseCamera();

        //print("RESULTADO CONSULTA DEL QR" +decodedResp["name"].toString()  );
          Vibration.vibrate();
          try{
            //decodedResp =jsonDecode(result.code.toString());
            print("RESULTADO CONSULTA DEL QR " + result.code.toString());
            String da = result.code.toString();
            decodedResp = json.decode(da);
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('yyyy-MM-dd').format(now);
            DateTime ahora = DateTime.parse(formattedDate) ;

            DateTime authorizedAt = DateTime.parse(decodedResp["auT"] );

            print( decodedResp["auT"]);


            if(authorizedAt.difference(ahora).inDays>=0)
            {
              esValido= true;
            } else if(authorizedAt.isAfter(ahora))
            {
              esValido= true;
            }
          }
          catch(e){
            errorScan? loads.Toast_Resull(1, "Sucedio un Error   "):null;
            errorScan=false;

             Future.delayed(Duration(seconds:4 ),(){
               reiniciarScaner();
             });
          }

        }
      });
    });
  }

  setNotificacion({String namePara, String dat, String ur}) async {
    Solicitudes_http solicitudes_http = new Solicitudes_http(context);
    var snapshot = await solicitudes_http.enivarNotificacion(
        nameParam: namePara, data: dat, url: ur);
    if (snapshot != null) {
      if (snapshot["codigo"] == 200) {
         reiniciarScaner();

        print(" Vefiticacion finalizada ");
      } else {
        print("Desde QR SCAN ${snapshot["codigo"]} ");

        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void reiniciarScaner()
  {
    result = null;
    decodedResp= null;
    controller?.pauseCamera();
    controller?.resumeCamera();
    errorScan=true;
    esValido=false;
    setState(() {});
  }
}
