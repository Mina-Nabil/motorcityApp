import "package:flutter/material.dart";
import './cars_model.dart';
import './caritem.dart';
import 'package:provider/provider.dart';
import './search.dart';
import 'package:fab_menu/fab_menu.dart';
import "package:flutter_keychain/flutter_keychain.dart";
import "./settings.dart";

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static CarsModel carModel;

  static Future<Null> _refreshPage() async{
    carModel.loadCars();
    carModel.loadInventory();
    carModel.loadLocations();
  }

  static final Widget home = RefreshIndicator (
                                  child: Container(
                                    child: Consumer<CarsModel>(
                                        builder: (context, cars, child){
                                          carModel = cars;  
                                                                   
                                          return  ListView(                 
                                        children: 
                                          carModel.pendingCars.map((car) {
                                            return CarItem(car);
                                          }).toList()
                                          );
                                        }    
                                    )
                                  ),
                                onRefresh: _refreshPage, 

                      );

  int _currentPage = 0;

  final List<Widget> _pages = [home, SearchCars(carModel)];
  List<MenuData> menuDataList;

  PageController _controller = PageController(initialPage: 0);

  checkIfAuthenticated() async {
     var userID = await FlutterKeychain.get(key: "userID");
       
    if(userID != null) {
      CarsModel.setUserID(userID);
      return true;
    }     
    else 
      return false;
}

  void selectPage(int index){
    setState(() {
      _currentPage = index;  
    });
  }

  void changeNavItem(index){
    setState(() {
      _currentPage = index;
      _controller.animateToPage(index, curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 400));
    });
  }

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
        _refreshPage();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('Peugeot Server Selected!')));
      },labelText: 'Peugeot'),
      new MenuData(Icons.directions_car, (context, menuData) {
        CarsModel.setSelectedServerMG();
        _refreshPage();
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text('MG Server Selected!')));
      },labelText: 'MG'),
      new MenuData(Icons.lock_outline, (context, menuData) {
        CarsModel.logout();
        Navigator.pushReplacementNamed(context, '/login');
      },labelText: 'logout')
    ];
  }
  

  @override
  Widget build(BuildContext context) {

    checkIfAuthenticated().then((success) {
      if (success) {
        
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
            floatingActionButton: new FabMenu(
                          menus: menuDataList,
                          maskColor: Colors.black,
                        ),
            floatingActionButtonLocation: fabMenuLocation,
                        
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title:  Text("MotorCity",
                      style: TextStyle(fontSize: 25),
                      )
                    ),
            body: PageView(
              children: _pages,
              controller: _controller,
              onPageChanged: selectPage,
            ),

            bottomNavigationBar: BottomNavigationBar(
              onTap: changeNavItem,
              currentIndex: _currentPage,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: Text('Home')
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car),
                  title: Text('Cars')
                )
              ]
            ),
          );
  }
}