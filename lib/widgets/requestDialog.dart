import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:motorcity/providers/cars_model.dart';

class RequestDialog {
  var _reqId;

  var context;

  RequestDialog(this.context, this._reqId);

  final askAlertStyle = AlertStyle(
    animationType: AnimationType.shrink,
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

  Future<void> acceptRequest(context) async {
    Navigator.pop(context);
    try {
      bool res = await Provider.of<CarsModel>(context).acceptTruckRequest(_reqId);
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
        title: "Accept Request?",
        buttons: [
          DialogButton(
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => acceptRequest(context),
            color: Colors.cyan[150],
            //gradient: LinearGradient(colors: [Colors.cyan, Colors.cyan[100]])
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
              //gradient: LinearGradient(colors: [Colors.green])
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
            //gradient: LinearGradient(colors: [Colors.red, Colors.red[100]])
          )
        ]).show();
  }
}

//<div>Icons made by <a href="https://www.flaticon.com/authors/pixel-buddha" title="Pixel Buddha">Pixel Buddha</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
