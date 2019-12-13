import 'package:motorcity/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:motorcity/providers/cars_model.dart';
import 'package:motorcity/screens/home.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

checkIfAuthenticated() async {
  var userID = await FlutterKeychain.get(key: "userID");
  if (userID != null) {
    CarsModel.setUserID(userID);
    return true;
  } else
    return false;
}

Future<void> main() async {
  checkIfAuthenticated().then((success) {
    if (success) {
      runApp(ChangeNotifierProvider(
          builder: (context) => CarsModel(), child: MotorCityApp()));
    } else {
      runApp(ChangeNotifierProvider(
        builder: (context) => CarsModel(),
        child: MaterialApp(home: LoginPage(), routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage()
        }),
      ));
    }
  });
}

class MotorCityApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MotorCityAppState();
  }
}

class _MotorCityAppState extends State<MotorCityApp> {
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NotoSerif'),
    routes: {
      '/': (context) => LandingPage(),
      '/login': (context) => LoginPage(),
      '/home': (context) => HomePage()
    });
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
