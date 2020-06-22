import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorcity/models/notification_handler.dart';
import 'package:motorcity/models/truckrequest.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:motorcity/providers/cars_model.dart';
import 'package:map_launcher/map_launcher.dart' as GM;
import 'package:shared_preferences/shared_preferences.dart';

GoogleMapController controller;
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
double fromLat = 0;
double fromLng = 0;
double toLat = 0;
double toLng = 0;
MarkerId fromMarkerID = MarkerId("from");
MarkerId toMarkerID = MarkerId("to");

class RequestInfo extends StatefulWidget {
  final TruckRequest req;
  final BuildContext context;

  RequestInfo({this.context, this.req});

  @override
  _RequestInfoState createState() => _RequestInfoState();
}

class _RequestInfoState extends State<RequestInfo> {
  void animateCamera() {
    double southWestLat = 100000;
    double southWestLng = 100000;
    double northEastLat = -100000;
    double northEastLng = -100000;

    markers.forEach((key, value) {
      double lat = value.position.latitude;
      if (lat != null && lat != 0) {
        if (lat < southWestLat) {
          southWestLat = lat;
        }
        if (lat > northEastLat) {
          northEastLat = lat;
        }
      }

      double lng = value.position.longitude;
      if (lng != null && lng != 0) {
        if (lng < southWestLng) {
          southWestLng = lng;
        }
        if (lng > northEastLng) {
          northEastLng = lng;
        }
      }
    });

    if (southWestLat != 100000 &&
        southWestLng != 100000 &&
        northEastLat != -100000 &&
        northEastLng != -100000) {
      LatLng southWestLatLng = LatLng(southWestLat, southWestLng);
      LatLng northEastLatLng = LatLng(northEastLat, northEastLng);
      LatLngBounds bound =
          LatLngBounds(southwest: southWestLatLng, northeast: northEastLatLng);
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
      controller.animateCamera(u2);
    }
  }

  void setMarkers() async {
    try {
      fromLat = widget.req.startLatt;
    } catch (e) {
      fromLat = 0;
    }

    try {
      fromLng = widget.req.startLong;
    } catch (e) {
      fromLng = 0;
    }
    String fromTitle = "";
    try {
      fromTitle = "from : ${widget.req.from}";
    } catch (e) {
      fromTitle = "";
    }
    LatLng fromPosition;
    try {
      fromPosition = LatLng(fromLat, fromLng);
    } catch (e) {
      fromPosition = LatLng(0, 0);
    }
    Marker markerFrom = Marker(
      markerId: fromMarkerID,
      position: fromPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: fromTitle,
      ),
    );

    try {
      toLat = widget.req.endLatt;
    } catch (e) {
      toLat = 0;
    }
    try {
      toLng = widget.req.endLong;
    } catch (e) {
      toLng = 0;
    }
    String toTitle = "";
    try {
      toTitle = "to : ${widget.req.to}";
    } catch (e) {
      toTitle = "";
    }
    LatLng toPosition;
    try {
      toPosition = LatLng(toLat, toLng);
    } catch (e) {
      toPosition = LatLng(0, 0);
    }
    Marker markerTo = Marker(
      markerId: toMarkerID,
      position: toPosition,
      infoWindow: InfoWindow(
        title: toTitle,
      ),
    );

    setState(() {
      try {
        markers[fromMarkerID] = markerFrom;
      } catch (e) {}
      try {
        markers[toMarkerID] = markerTo;
      } catch (e) {}

      try {
        animateCamera();
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    double textFont = ((MediaQuery.of(context).size.height) > 800) ? 20 : 14;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "MotorCity",
        style: TextStyle(fontSize: 25),
      )),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text("Request #${widget.req.id}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
              Divider(),
              Container(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 220,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(30.0355, 31.2230),
                    zoom: 14.4746,
                  ),
                  mapType: MapType.normal,
                  onMapCreated: (googleMapController) {
                    controller = googleMapController;
                    setMarkers();
                  },
                  markers: Set<Marker>.of(markers.values),
                  myLocationButtonEnabled: false,
                ),
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.date_range,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Date",
                          style: TextStyle(
                            fontSize: textFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${widget.req.reqDate}",
                          style: TextStyle(
                            fontSize: textFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Driver",
                          style: TextStyle(
                            fontSize: textFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${widget.req.driverName}",
                          style: TextStyle(
                            fontSize: textFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.directions_car,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Model",
                          style: TextStyle(
                            fontSize: textFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${widget.req.model}",
                          style: TextStyle(
                            fontSize: textFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.fingerprint,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Chassis",
                          style: TextStyle(
                            fontSize: textFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${widget.req.chassis}",
                          style: TextStyle(
                            fontSize: textFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.straighten),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Distance",
                          style: TextStyle(
                            fontSize: textFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${widget.req.km}",
                          style: TextStyle(
                            fontSize: textFont,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.location_on),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "From : ${widget.req.from}",
                          style: TextStyle(fontSize: textFont),
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DialogButton(
                          child: Text(
                            "Go To",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => _launchMap(
                            widget.req.startLatt,
                            widget.req.startLong,
                            widget.req.from,
                            widget.req.from,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.location_on),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "To : ${widget.req.to}",
                          style: TextStyle(fontSize: textFont),
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DialogButton(
                          child: Text(
                            "Go To",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => _launchMap(
                            widget.req.endLatt,
                            widget.req.endLong,
                            widget.req.to,
                            widget.req.to,
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: _requestButtonsBar(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchMap(double lat, double lng, String title, String desc) async {
    if (Platform.isAndroid) {
      if (await GM.MapLauncher.isMapAvailable(GM.MapType.google)) {
        await GM.MapLauncher.launchMap(
          mapType: GM.MapType.google,
          coords: GM.Coords(lat, lng),
          title: title,
          description: desc,
        );
      }
    } else if (Platform.isIOS) {
      if (await GM.MapLauncher.isMapAvailable(GM.MapType.apple)) {
        await GM.MapLauncher.launchMap(
          mapType: GM.MapType.apple,
          coords: GM.Coords(lat, lng),
          title: title,
          description: desc,
        );
      }
    }
  }

  _requestButtonsBar() {
    if (widget.req.status == '1') {
      return DialogButton(
        child: Text(
          "Accept",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => acceptRequest(context),
        color: Colors.cyan[300],
        //gradient: LinearGradient(colors: [Colors.cyan, Colors.cyan[100]])
      );
    } else if (widget.req.status == '2') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: DialogButton(
                child: Text(
                  "Complete",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => completeRequest(context) ,
                color: Colors.green[300],
                //gradient: LinearGradient(colors: [Colors.cyan, Colors.cyan[100]])
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: DialogButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => cancelRequest(context),
                color: Colors.red[300],
                //gradient: LinearGradient(colors: [Colors.cyan, Colors.cyan[100]])
              ),
            ),
          )
        ],
      );
    } else {
      return null;
    }
  }

  final askAlertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );

  final minorAlertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );

  final cancelAlertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );

  Future<void> cancelRequest(context) async {
    Navigator.pop(context);
    try {
      bool res = await Provider.of<CarsModel>(context)
          .cancelTruckRequest(widget.req.id);
      (res) ? _showConfirmed() : _showFailed();
    } catch (e) {
      _showFailed();
      return false;
    }
    FirebaseNotifications.sendNotifications(
      "Request #${widget.req.id} Completed",
      "${widget.req.driverName} has completed request #${widget.req.id}",
    );
  }

  void _showConfirmed() {
    Alert(
        context: widget.context,
        style: minorAlertStyle,
        image: Image.asset("assets/checked.png"),
        title: "Confirmed, please refresh",
        buttons: [
          DialogButton(
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {Navigator.pop(widget.context)},
            color: Colors.green,
          )
        ]).show();
  }

  void _showFailed() {
    Alert(
        context: widget.context,
        style: minorAlertStyle,
        image: Image.asset("assets/cancel.png"),
        title: "Request Failed",
        desc: "Please check server connection & try again!",
        buttons: [
          DialogButton(
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {Navigator.pop(widget.context)},
            color: Colors.red[150],
          )
        ]).show();
  }

  Future<void> acceptRequest(context) async {
    Navigator.pop(context);
    try {
      bool res = await Provider.of<CarsModel>(context)
          .acceptTruckRequest(widget.req.id);
      (res) ? _showConfirmed() : _showFailed();
    } catch (e) {
      _showFailed();
      return false;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userName");
    FirebaseNotifications.sendNotifications(
      "Request #${widget.req.id} Accepted",
      "$username has accepted request #${widget.req.id}",
    );
  }

    Future<void> completeRequest(context) async {
    Navigator.pop(context);
    try {
      bool res = await Provider.of<CarsModel>(context).completeTruckRequest(widget.req.id);
      (res) ? _showConfirmed() : _showFailed();
    } catch (e) {
      _showFailed();
      return false;
    }
  }

}
