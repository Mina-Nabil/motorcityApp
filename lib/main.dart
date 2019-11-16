
import 'package:motorcity/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:motorcity/cars_model.dart';
import './Home.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

checkIfAuthenticated() async {
     var userID = await FlutterKeychain.get(key: "userID");
    if(userID != null) {
      CarsModel.setUserID(userID);
      return true;
    }  
    else 
      return false;
}

void main() {
  runApp(ChangeNotifierProvider(
    builder: (context) => CarsModel(),
    child: MotorCityApp()
    )
  );
}

class MotorCityApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MotorCityAppState();
  }

}

class _MotorCityAppState extends State<MotorCityApp> {

  Widget build(BuildContext context) {

    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage()
        }
    ); 
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
      )
    );
  }
}


