import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart';
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

  void track() {
    print("opened");
    var location = new Location();
    location.changeSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 1000,
        distanceFilter: 0);
    location.onLocationChanged().listen((LocationData currentLocation) {
      print("change");
      print("Lat : ${currentLocation.latitude}");
      print("Lng : ${currentLocation.longitude}");
    });
  }

  void trackUser() async {
    print("STARTING LOCATION SERVICE");
    var location = Location();
    location.changeSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 1000,
        distanceFilter: 0);
    // if (!await location.hasPermission()) {
    //   await location.requestPermission();
    // }
  PermissionStatus permission =
      await LocationPermissions().requestPermissions();

      if(permission != PermissionStatus.granted)
      {
        ///error
      }

      ServiceStatus serviceStatus = await LocationPermissions().checkServiceStatus();
      if(serviceStatus == ServiceStatus.disabled)
      {
        bool enableService = await location.requestService();
        print(enableService);
      }

    try {
        location.onLocationChanged().listen((LocationData currentLocation) {
        print(currentLocation.latitude);
        print(currentLocation.longitude);
      });
    } on PlatformException {
      location = null;
    }
    // ServiceStatus serviceStatus =
    //     await LocationPermissions().checkServiceStatus();
    // print("$serviceStatus");

    // if (serviceStatus == ServiceStatus.disabled) {
    //   bool isOpened = await LocationPermissions().openAppSettings();
    // }
  }



  void initState() {
    super.initState();
    trackUser();
    menuDataList = [
      new MenuData(Icons.settings, (context, menuData) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return SettingsPage();
          },
        ));
      }, labelText: 'Settings'),
      new MenuData(Icons.directions_car, (context, menuData) async {
        Provider.of<CarsModel>(context).setSelectedServerPeugeot();
        _refreshPage(context);
        Scaffold.of(context).showSnackBar(new SnackBar(
            duration: Duration(milliseconds: 500),
            content: new Text('Peugeot Server Selected!')));
      }, labelText: 'Peugeot'),
      new MenuData(Icons.directions_car, (context, menuData) async {
        Provider.of<CarsModel>(context).setSelectedServerMG();
        _refreshPage(context);
        Scaffold.of(context).showSnackBar(new SnackBar(
            duration: Duration(milliseconds: 500),
            content: new Text('MG Server Selected!')));
      }, labelText: 'MG'),
      new MenuData(Icons.lock_outline, (context, menuData) {
        Provider.of<CarsModel>(context).logout();
        Navigator.pushReplacementNamed(context, '/login');
      }, labelText: 'logout')
    ];
  }

  @override
  Widget build(BuildContext context) {
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
