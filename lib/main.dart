import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:porteria/app/ui/apartamentos_page/apartamentos_page.dart';
import 'package:porteria/app/ui/registrar_novedad_page/registrar_novedad_page.dart';
import 'package:porteria/app/ui/visitas_page/visitas_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/modelos/model_user.dart';
import 'Util/Offline.dart';
import 'app/ui/Login/Login_inquilino.dart';
import 'app/ui/home_page/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(

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



      ),
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

    userData = await obtenerDataUser();

    timer = Timer.periodic(const Duration(seconds: 2), (Timer _) {
      if (kDebugMode) {
        print("tiempo $_start");
      }

   getSession();
    });
  }

  Future getSession() async {
// Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
/*
// Save an integer value to 'counter' key.
    await prefs.setInt('counter', 10);
// Save an boolean value to 'repeat' key.
    await prefs.setBool('repeat', true);
// Save an double value to 'decimal' key.
    await prefs.setDouble('decimal', 1.5);
// Save an String value to 'action' key.
    await prefs.setString('action', 'Start');
// Save an list of strings to 'items' key.
    await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);*/
// Create storage

    final storage =   FlutterSecureStorage();


// Read all values
  //  Map<String, String> allValues = await storage.readAll();

// Delete value
 //   await storage.delete(key: "Home");

// Delete all
  //  await storage.deleteAll();

// Write value
 //   await storage.write(key: "Home", value: "gardado ffffff");

    try {
      if (kDebugMode) {
        print( userData  );
      }
      if (userData != null) {
        if (userData?.apiToken != null) {
          Navigator.pushReplacementNamed(context, "Home");
        }
      } else {

        if (kDebugMode) {
          print(" no tiene usuario"  );
        }
        Navigator.pushReplacementNamed(context, "login_inquilino");
      }
    } catch (e) {
      if (kDebugMode) {
        print("cach"  );
      }
     Navigator.pushReplacementNamed(context, "login_inquilino");
    }
  }
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    getSession();
  }

  Future redirecionTapNotificacion() async {

    getSession();

  }
  Future onSelectNotification(String payload) async {
    redirecionTapNotificacion();
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
