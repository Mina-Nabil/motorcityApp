import 'dart:convert';
import 'package:flutter/cupertino.dart';
import './car.dart';
import './location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_keychain/flutter_keychain.dart';
import "package:shared_preferences/shared_preferences.dart";

class CarsModel extends ChangeNotifier{

  static final String _mgKey = 'mg';
  static final String _pgKey = 'pg';
  static final String _selectedKey = 'selected';

  static String mgServerIP ;
  static String peugeotServerIP ;

  static String mgServer      ;
  //static final String peugeotServer  = "http://192.168.1.202/motorcity/api/";
  static String peugeotServer  ;

  static String selectedURL  ;

  static String userID ;

  List<Car> pendingCars = [];
  List<Car> inventoryCars = [];
  List<Location> locations = [];

  String _pendingURL  = 'pending' ;
  String _inventoryURL  = 'inventory' ;
  String _locationURL    = 'locations';
  String _loginURL    = 'driverLogin';

  CarsModel() {
    
    loadCars();
    loadInventory();
    loadLocations();

  }

  void loadCars() async {
    try{
      if(selectedURL == null) await initServers();
    pendingCars = [];
    notifyListeners();
    String apiURL = selectedURL + _pendingURL;
    final response = await http.get(apiURL);
    if(response.statusCode == 200){
      Iterable l = json.decode(response.body);
      
      this.pendingCars = l.where((car) {
        return (car['Car']['INVT_ID'] != null);
      }).map((car)  {
          Car tmpCar = Car.fromJson(car['Car']);
          var tmpDate = car['Salesdata']['SALS_ET_DATE'];
          tmpCar.setDate(tmpDate);
          
        return tmpCar;
      }).toList();
      
      notifyListeners();

    }
    } catch(e){

      print("Exception catched: " + e.toString());
      
    }
  }

  void loadInventory() async {
    try {
      if(selectedURL == null) await initServers();
      inventoryCars = [];
      notifyListeners();
      String apiURL = selectedURL + _inventoryURL;
      final response = await http.get(apiURL);
      if(response.statusCode == 200){
        Iterable l = json.decode(response.body);
        
        this.inventoryCars = l.map((carJson)  {
          Car car = Car.fromJson(carJson);
          return car;
        }).toList();

        notifyListeners();

    }
    } catch(e){

    }
  }

  void loadLocations() async {
    try{
      if(selectedURL == null) await initServers();
      locations = [];
      notifyListeners();
      String apiURL = selectedURL + _locationURL;
      
      final response = await http.get(apiURL);
      if(response.statusCode == 200){
        Iterable l = json.decode(response.body);
        
        this.locations = l.map((locJson)  {
          Location loc = Location(id: int.parse(locJson['LOCT_ID']), name: locJson['LOCT_NAME']);
          return loc;
        }).toList();

        notifyListeners();
      
      }
    } catch(e){

    }
  }

  static void initServers() async {

    if(selectedURL == null) {

    final prefs = await SharedPreferences.getInstance();

    mgServerIP        = prefs.getString(_mgKey) ?? "3.121.234.234";
    peugeotServerIP   = prefs.getString(_pgKey) ?? "192.168.1.202";

    mgServer       = "http://" + mgServerIP + "/motorcity/api/";
    peugeotServer  = "http://" + peugeotServerIP + "/motorcity/api/";

    selectedURL       = prefs.getString(_selectedKey) ?? peugeotServer;

    }

  }

  static void setServersIP (peugeotIP, mgIP) async {

    mgServerIP = mgIP;
    peugeotServerIP = peugeotIP;
    final prefs = await SharedPreferences.getInstance();

    mgServer       = "http://" + mgServerIP + "/motorcity/api/";
    peugeotServer  = "http://" + peugeotServerIP + "/motorcity/api/";


    prefs.setString(_mgKey, mgIP);
    prefs.setString(_pgKey, peugeotIP);

  }

  static void setSelectedServerMG({bool refreshCars=false}) async {
    selectedURL = mgServer;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_selectedKey, selectedURL);
  }

  static void setSelectedServerPeugeot({bool refreshCars=false}) async {
    selectedURL = peugeotServer;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_selectedKey, selectedURL);
  }

  static void setUserID(String id){
    userID = id;
  }

  Future<bool> login({String user, String password}) async {
    try {
      final response = await http.post(selectedURL + _loginURL, body: {"DRVRName": user, "DRVRPass": password});
    if(response.statusCode == 200){
      var id = jsonDecode(response.body)['DRVR_ID'];
      if(id != null ){
        await FlutterKeychain.put(key: "userID", value: id);
        await FlutterKeychain.put(key: "userName", value: user);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_selectedKey, selectedURL);
        userID = id;
        return true;
      } else 
      return false;        
    }
    else 
      return false;
    } catch(e){
      return false;
    }
  
  }

  static void logout() async {
    FlutterKeychain.clear();
  }




}


