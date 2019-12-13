import "package:flutter/material.dart";
import 'package:motorcity/screens/trucks.dart';
import 'package:motorcity/widgets/PendingCarsList.dart';
import '../providers/cars_model.dart';
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
  static Future<Null> _refreshPage(context) async {
    try {
      await Provider.of<CarsModel>(context).loadCars(force: true);
      //await Provider.of<CarsModel>(context).loadTruckRequests(force: true);
      //await Provider.of<CarsModel>(context).loadInventory(force: true);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1000), content: Text(e.toString())));
    }
    return;
  }

  int _currentPage = 0;

  final List<Widget> _pages = [PendingCarsList(), TrucksPage(), SearchCars()];

  List<MenuData> menuDataList;
  PageController _controller = PageController(initialPage: 0);

  checkIfAuthenticated() async {
    var userID = await FlutterKeychain.get(key: "userID");

    if (userID != null) {
      CarsModel.setUserID(userID);
      return true;
    } else
      return false;
  }

  void selectPage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void changeNavItem(index) {
    setState(() {
      _currentPage = index;
      _controller.animateToPage(index,
          curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 400));
    });
  }

  void initState() {
    super.initState();
    menuDataList = [
      new MenuData(Icons.settings, (context, menuData) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return SettingsPage();
          },
        ));
      }, labelText: 'Settings'),
      new MenuData(Icons.directions_car, (context, menuData) async {
        CarsModel.setSelectedServerPeugeot();
        _refreshPage(context);
        Scaffold.of(context).showSnackBar(new SnackBar(
            duration: Duration(milliseconds: 500),
            content: new Text('Peugeot Server Selected!')));
      }, labelText: 'Peugeot'),
      new MenuData(Icons.directions_car, (context, menuData) async {
        CarsModel.setSelectedServerMG();
        _refreshPage(context);
        Scaffold.of(context).showSnackBar(new SnackBar(
            duration: Duration(milliseconds: 500),
            content: new Text('MG Server Selected!')));
      }, labelText: 'MG'),
      new MenuData(Icons.lock_outline, (context, menuData) {
        CarsModel.logout();
        Navigator.pushReplacementNamed(context, '/login');
      }, labelText: 'logout')
    ];
  }

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      if (!success) {
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
          title: Text(
            "MotorCity",
            style: TextStyle(fontSize: 25),
          )),
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
                icon: new Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping), title: Text('Truck Req.')),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car), title: Text('Cars')),
          ]),
    );
  }
}
