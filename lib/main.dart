import 'dart:async';
import 'package:eyro_toast/eyro_toast.dart';
import 'package:flutter/material.dart';
import 'package:porteria/app/ui/apartamentos_page/apartamentos_page.dart';
import 'package:porteria/app/ui/registrar_novedad_page/registrar_novedad_page.dart';
import 'package:porteria/app/ui/visitas_page/visitas_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/modelos/model_user.dart';
import 'Util/Offline.dart';
import 'app/ui/Login/Login_inquilino.dart';
import 'app/ui/home_page/Home.dart';

void main() {
  EyroToastSetup.shared.navigatorKey = GlobalKey<NavigatorState>();
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: EyroToastSetup.shared.navigatorKey,
      title: 'Control de Porterias',
      theme: ThemeData(),
      initialRoute: "splash",
      routes: {
        "splash": (BuildContext context) => Splash(),
        "login_inquilino": (BuildContext context) => LoginPage(),
        "Home": (BuildContext context) => Home(),
        "VisitasPage": (BuildContext context) => VisitasPage(),
        "ApartamentosPage": (BuildContext context) => ApartamentosPage(),
        "RegistrarNovedadPage": (BuildContext context) => RegistrarNovedadPage(),
      },
      debugShowCheckedModeBanner: false,



    );
  }
}

class Splash extends StatefulWidget {
  Splash({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  UserData userData = new UserData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Timer timer;
  final int _start = 20;
  Future<void> startTimer() async {
    userData = await obtenerDataUser();
    timer = Timer.periodic(Duration(seconds: 2), (Timer _) {
      print("tiempo $_start");

   obtenerSesion();
    });
  }

  Future obtenerSesion() async {
    try {

      if (userData != null) {
        if (userData?.apiToken != null) {
          Navigator.pushReplacementNamed(context, "Home");
        }
      } else {

        print(" no tiene usuario"  );
        Navigator.pushReplacementNamed(context, "login_inquilino");
      }
    } catch (e) {
      print("cach"  );
     Navigator.pushReplacementNamed(context, "login_inquilino");
    }
  }
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    obtenerSesion();
  }

  Future Redirecion_clik_notificacion() async {

    obtenerSesion();

  }
  Future onSelectNotification(String payload) async {
    Redirecion_clik_notificacion();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            color:Colors.grey[100],
            /* decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("asset/fondo_ios.jpg"))),*/
            child: Center(
              child: Image.asset(
                "assets/Logo.png",
                fit: BoxFit.contain,
                height: screenHeight * 0.3,
                width: screenHeight * 0.3,
              ),
            )));
  }
}
