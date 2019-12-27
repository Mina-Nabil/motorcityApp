import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:motorcity/providers/cars_model.dart';

class InProgressDialog {
  var _reqId;

  var context;

  InProgressDialog(this.context, this._reqId);

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

  Future<void> completeRequest(context) async {
    Navigator.pop(context);
    try {
      bool res = await Provider.of<CarsModel>(context).completeTruckRequest(_reqId);
      (res) ? _showConfirmed() : _showFailed();
    } catch (e) {
      _showFailed();
      return false;
    }
  }

  void showCancelConfirm(context){
    Navigator.pop(context);
    Alert(
        context: context,
        style: cancelAlertStyle,
        image: Image.asset("assets/cancel.png"),
        title: "Are you sure you want to cancel?",
        buttons: [
          DialogButton(
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => cancelRequest(context),
            color: Colors.red[300],
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.cyan[300],
          )
        ]).show();
  }

  Future<void> cancelRequest(context) async {
    Navigator.pop(context);
    try {
      bool res = await Provider.of<CarsModel>(context).cancelTruckRequest(_reqId);
      (res) ? _showConfirmed() : _showFailed();
    } catch (e) {
      _showFailed();
      return false;
    }
  }

  void show() {
    Alert(
        context: context,
        style: askAlertStyle,
        image: Image.asset("assets/question.png"),
        title: "Complete/Cancel Request?",
        buttons: [
          DialogButton(
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => completeRequest(context),
            color: Colors.green[300],
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => showCancelConfirm(context),
            color: Colors.red[300],
          )
        ]).show();
  }

  void _showConfirmed() {
    
    Alert(
        context: context,
        style: minorAlertStyle,
        image: Image.asset("assets/checked.png"),
        title: "Confirmed, please refresh",
        buttons: [
          DialogButton(
              child: Text(
                "Back",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => {Navigator.pop(context)},
              color: Colors.green,
              )
        ]).show();
  }

  void _showFailed() {
    Alert(
        context: context,
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
            onPressed: () => {Navigator.pop(context)},
            color: Colors.red[150],
          )
        ]).show();
  }
}

//<div>Icons made by <a href="https://www.flaticon.com/authors/pixel-buddha" title="Pixel Buddha">Pixel Buddha</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
