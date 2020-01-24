import 'dart:convert';

import "package:flutter/material.dart";
import 'package:motorcity/providers/cars_model.dart';
import 'package:motorcity/screens/home.dart';
import 'package:provider/provider.dart';
import "package:motorcity/models/car.dart";
import "package:motorcity/models/location.dart";

class MovePage extends StatefulWidget {
  final Car car;

  MovePage({this.car});

  @override
  _MovePageState createState() => _MovePageState(car);
}

class _MovePageState extends State<MovePage> {
  _MovePageState(this.car);

  Car car;

  int _selectedDrop = 6;

  TextEditingController _commentController = new TextEditingController();
  TextEditingController _kmController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    Future.delayed(Duration.zero).then(
        (_) => Provider.of<CarsModel>(context, listen: false).loadLocations());
    super.initState();
  }

  void onDropChange(int value) {
    setState(() {
      _selectedDrop = value;
    });
  }

  Future<Null> submitForm() async {
    if (_formKey.currentState.validate()) {
      String startLoct = this.car.loctID;
      String endLoct = _selectedDrop.toString();
      String km = _kmController.text;
      String comment = _commentController.text;
      String driverID = CarsModel.userID;
      DateTime tmp = DateTime.now();
      String date = tmp.year.toString() +
          "-" +
          tmp.month.toString() +
          '-' +
          tmp.day.toString();

      bool res = await Provider.of<CarsModel>(context).moveCar(
          startLoct: startLoct,
          endLoct: endLoct,
          km: km,
          comment: comment,
          driverID: driverID,
          carID: car.id,
          date: date);

      if (res) {
        _showSuccess(context);
      } else {
        _showFailed(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Car Info:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                Divider(),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Text("Model:  ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(widget.car.brand + " " + widget.car.model,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Text("Color:  ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(widget.car.color + " / " + widget.car.colorCode,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Text("Chassis:  ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(widget.car.chassis,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: <Widget>[
                      Text("Location:  ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(widget.car.location,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                Divider(),
                Text("Submit Move:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(7),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    items: Provider.of<CarsModel>(context)
                        .locations
                        .map((Location loc) {
                      return DropdownMenuItem<int>(
                        value: loc.id,
                        child: Container(child: Text(loc.name), width: 200),
                      );
                    }).toList(),
                    onChanged: onDropChange,
                    value: _selectedDrop,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("KMs: ", style: TextStyle(fontSize: 20)),
                      TextFormField(
                          controller: _kmController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter number of KM';
                            } else if(!isNumeric(value)){
                              return 'Please enter a valid number';
                            }
                            return null;
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Add Comment: ", style: TextStyle(fontSize: 20)),
                      TextField(
                        controller: _commentController,
                        minLines: 4,
                        maxLines: 5,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text("Submit",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    onPressed: submitForm,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccess(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [new Text("Move Saved!")]),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailed(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [new Text("Move Failed!")]),
          content: Container(child: Text("Please try again")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  try{
    return double.parse(s) is double ;
  } catch(e){
    return false;
  }
  
}
}
