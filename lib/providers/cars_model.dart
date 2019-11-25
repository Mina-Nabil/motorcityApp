import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:motorcity/models/car.dart';
import 'package:motorcity/models/location.dart';
import 'package:motorcity/models/truckrequest.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_keychain/flutter_keychain.dart';
import "package:shared_preferences/shared_preferences.dart";

class CarsModel with ChangeNotifier {
  static final String _mgKey = 'mg';
  static final String _pgKey = 'pg';
  static final String _selectedKey = 'selected';

  static String mgServerIP;
  static String peugeotServerIP;

  static String mgServer;
  //static final String peugeotServer  = "http://192.168.1.202/motorcity/api/";
  static String peugeotServer;
  static String selectedURL;

  static String userID;

  final String _pendingURL = 'pending';
  final String _inventoryURL = 'inventory';
  final String _locationURL = 'locations';
  final String _requestsURL = 'requests';
  final String _loginURL = 'driverLogin';

  List<Car> _pendingCars = [];
  List<Car> _inventoryCars = [];
  List<Location> _locations = [];
  List<TruckRequest> _requests = [];

  List<Car> get pendingCars {
    return [..._pendingCars];
  }

  List<Car> get inventoryCars {
    return [..._inventoryCars];
  }

  List<Location> get locations {
    return [..._locations];
  }

  List<TruckRequest> get requests {
    return [..._requests];
  }

  Future<void> loadCars({bool force=false}) async {
    if(_inventoryCars.length > 0 && !force) {
      notifyListeners();
      return ;
    }

    try {
      if (selectedURL == null) await initServers();
      _pendingCars = [];
      notifyListeners();
      String apiURL = selectedURL + _pendingURL;
      final response = await http.get(apiURL);
      if (response.statusCode == 200) {
        Iterable l = json.decode(cleanResponse(response.body));

        l.where((car) {
          return (car['Car']['INVT_ID'] != null);
        }).forEach((car) {
          Car tmpCar = Car.fromJson(car['Car']);
          var tmpDate = car['Salesdata']['SALS_ET_DATE'];
          tmpCar.setDate(tmpDate);

          _pendingCars.add(tmpCar);
        });
    
        notifyListeners();
      }
    } catch (e) {
      print("Exception catched: " + e.toString());
    }
  }

  Future<void> loadInventory({bool force=false}) async {

    if(_inventoryCars.length > 0 && !force) {
      notifyListeners();
      return;
    }

    try {
      if (selectedURL == null) await initServers();
      _inventoryCars = [];
      String apiURL = selectedURL + _inventoryURL;
      final response = await http.get(apiURL);
      if (response.statusCode == 200) {
        Iterable l = json.decode(cleanResponse(response.body));

        this._inventoryCars = l.map((carJson) {
          Car car = Car.fromJson(carJson);
          return car;
        }).toList();

        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> loadLocations({bool force=false}) async {

    if(_locations.length > 0 && !force) {
      notifyListeners();
      return;
    }

    try {
      if (selectedURL == null) await initServers();
      _locations = [];

      String apiURL = selectedURL + _locationURL;

      final response = await http.get(apiURL);
      if (response.statusCode == 200) {
        Iterable l = json.decode(cleanResponse(response.body));

        this._locations = l.map((locJson) {
          Location loc = Location(
              id: int.parse(locJson['LOCT_ID']), name: locJson['LOCT_NAME']);
          return loc;
        }).toList();

        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> loadTruckRequests({bool force = false}) async {

    if(_requests.length > 0 && !force) {
      notifyListeners();
      return;
      }

    try {
      if (selectedURL == null) await initServers();
      _requests = [];
      notifyListeners();
      String apiURL = selectedURL + _requestsURL;
      final response = await http.get(apiURL);
      if (response.statusCode == 200) {
        Iterable l = json.decode(cleanResponse(response.body));

        this._requests = l.map((requestaya) {
          return TruckRequest(
              id: requestaya['TKRQ_ID'],
              chassis: requestaya['TKRQ_CHSS'],
              from: requestaya['TKRQ_STRT_LOC'],
              to: requestaya['TKRQ_END_LOC'],
              km: requestaya['TKRQ_KM'],
              model: requestaya['TRMD_NAME'],
              reqDate: requestaya['TKRQ_INSR_DATE'],
              startDate: requestaya['TKRQ_STRT_DATE'],
              status: requestaya['TKRQ_STTS'],
              comment: requestaya['TKRQ_CMNT']);
        }).toList();
       
        notifyListeners();
      }
    } catch (e) {

    }
  }

  static Future<void> initServers() async {
    if (selectedURL == null) {
      final prefs = await SharedPreferences.getInstance();

      mgServerIP = prefs.getString(_mgKey) ?? "3.121.234.234";
      peugeotServerIP = prefs.getString(_pgKey) ?? "192.168.1.202";

      mgServer = "http://" + mgServerIP + "/motorcity/api/";
      peugeotServer = "http://" + peugeotServerIP + "/motorcity/api/";

      selectedURL = prefs.getString(_selectedKey) ?? peugeotServer;
    }
  }

  static void setServersIP(peugeotIP, mgIP) async {
    mgServerIP = mgIP;
    peugeotServerIP = peugeotIP;
    final prefs = await SharedPreferences.getInstance();

    mgServer = "http://" + mgServerIP + "/motorcity/api/";
    peugeotServer = "http://" + peugeotServerIP + "/motorcity/api/";

    prefs.setString(_mgKey, mgIP);
    prefs.setString(_pgKey, peugeotIP);
  }

  static void setSelectedServerMG({bool refreshCars = false}) async {
    selectedURL = mgServer;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_selectedKey, selectedURL);
  }

  static void setSelectedServerPeugeot({bool refreshCars = false}) async {
    selectedURL = peugeotServer;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_selectedKey, selectedURL);
  }

  static void setUserID(String id) {
    userID = id;
  }

  Future<bool> login({String user, String password}) async {
    try {
      final response = await http.post(selectedURL + _loginURL,
          body: {"DRVRName": user, "DRVRPass": password});
      if (response.statusCode == 200) {
        var id = jsonDecode(response.body)['DRVR_ID'];
        if (id != null) {
          await FlutterKeychain.put(key: "userID", value: id);
          await FlutterKeychain.put(key: "userName", value: user);
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(_selectedKey, selectedURL);
          userID = id;
          return true;
        } else
          return false;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  static void logout() async {
    FlutterKeychain.clear();
  }

  Car getCarById(String id){

    return _inventoryCars.singleWhere( (car) => car.id == id );
  }

  String cleanResponse(json) {
    int shitIndex = json.indexOf("<script");
    String properResponse;
    if (shitIndex > 0)
      properResponse = json.substring(0, shitIndex);
    else
      properResponse = json;

    return properResponse;
  }
}
