import 'package:motorcity/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:motorcity/providers/cars_model.dart';
import 'package:motorcity/screens/home.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

Future<bool> checkIfAuthenticated(context) async {
  try {
    var userID = await FlutterKeychain.get(key: "userID");
    if (userID != null) {
      Provider.of<CarsModel>(context).setUserID(userID);
      return true;
    } else
      return false;
  } catch (e) {
    return false;
  }
}

Future<void> main() async {

  runApp(ChangeNotifierProvider(
    builder: (context) => CarsModel(),
    child: MotorCityApp(),
  ));

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'NotoSerif'),
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage()
        },
        home: LandingPage()
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated(context).then((success) {
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
