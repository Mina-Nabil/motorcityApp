import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cars_model.dart';
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
      new MenuData(
        Icons.directions_car, (context, menuData) {
        Provider.of<CarsModel>(context).setSelectedServerPeugeot();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('Peugeot Server Selected!'), duration: Duration(milliseconds: 300)));
      },labelText: 'Peugeot'),
      new MenuData(Icons.directions_car, (context, menuData) {
        Provider.of<CarsModel>(context).setSelectedServerMG();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('MG Server Selected!'), duration: Duration(milliseconds: 300)));
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

  var newLogin = Builder(
        builder: (context) => Container(
            color: Color.fromRGBO(0,46,72,0.5),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Hero(
                    tag: 'hero',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 48.0,
                      child: Image.asset('assets/Motorcity-Logo-wht-blue2.png'),
                    ),
                  ),
                  SizedBox(height: 48.0),
                  TextFormField(
                    controller: LoginPage._user,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    autofocus: false,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white54),
                      hoverColor: Colors.blue,
                      hintText: 'Username',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: LoginPage._pass,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white54),
                      hoverColor: Colors.blue,
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () => checkUser(context),
                      padding: EdgeInsets.all(12),
                      color: Color.fromRGBO(0,46,72,1),
                      child:
                          Text('Log In', style: TextStyle(fontSize: 18,color: Colors.white)),
                    ),
                  )
                ],
              ),
            )));

    // TODO: implement build
    return  Scaffold(
            floatingActionButton: new FabMenu(
                          menus: menuDataList,
                          maskColor: Colors.black,
                        ),
            floatingActionButtonLocation: fabMenuLocation,
            body: newLogin
      );
    
  }
}