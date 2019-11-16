import 'package:flutter/material.dart';
import './cars_model.dart';
import "package:fab_menu/fab_menu.dart";
import "./settings.dart";

class LoginPage extends StatefulWidget {

  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username ;

  String password ;

   List<MenuData> menuDataList;

    void initState(){
    super.initState();
    menuDataList = [
      new MenuData(Icons.settings, (context, menuData) {
        Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)  {
                      return SettingsPage();
                      },
            )
        );
      },labelText: 'Settings'),
      new MenuData(Icons.directions_car, (context, menuData) {
        CarsModel.setSelectedServerPeugeot();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('Peugeot Server Selected!')));
      },labelText: 'Peugeot'),
      new MenuData(Icons.directions_car, (context, menuData) {
        CarsModel.setSelectedServerMG();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('MG Server Selected!')));
      },labelText: 'MG')
    ];
  }

  @override 
  Widget build(BuildContext context) {

    

    void _showLoginFailed(context2) {

     Scaffold.of(context2).showSnackBar(
            new SnackBar(content: new Text('Invalid Data! Please check User/Pass and selected Server')));
  }

    checkUser(context2){
    this.username = LoginPage._user.text;
    this.password = LoginPage._pass.text;

    CarsModel().login(user: username, password: password).then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showLoginFailed(context2);
      }
    });
      
  }

    // TODO: implement build
    return Scaffold(
            floatingActionButton: new FabMenu(
                          menus: menuDataList,
                          maskColor: Colors.black,
                        ),
            floatingActionButtonLocation: fabMenuLocation,
            body: Container(
              padding: EdgeInsets.only(right: 80, left: 80),
              color: Colors.white,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              Image.asset('assets/Motorcity_Logo.png'),

              TextField(
                controller: LoginPage._user,
                autofocus: true,
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: TextField(
                  controller: LoginPage._pass,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onSubmitted: null,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

               Container(
                 
                width: double.infinity,
                child: Builder(
                  builder: (context2) => RaisedButton(
                  color: Colors.blue,
                  child: Text("Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    ),
                  ),
                  onPressed: () => checkUser(context2),
                ),
              )
             )
            ],
          )
        )
      );
    
  }
}