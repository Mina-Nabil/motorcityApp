import 'dart:convert';

import "package:flutter/material.dart";
import 'package:motorcity/cars_model.dart';
import 'package:motorcity/home.dart';
import 'package:provider/provider.dart';
import "./car.dart";
import "./location.dart";
import "package:http/http.dart" as http;

class MovePage extends StatefulWidget {

  final Car car;

  MovePage({this.car}) ;

  @override
  _MovePageState createState() => _MovePageState(car);
}

class _MovePageState extends State<MovePage> {

  _MovePageState(this.car);

  Car car;

  int _selectedDrop=6;

  TextEditingController _commentController = new TextEditingController();
  TextEditingController _kmController = new TextEditingController();

  void onDropChange(int value){
    setState(() {
      _selectedDrop=value;
    });
  }

  Future<Null> submitForm() async {

    String startLoct = this.car.loctID;
    String endLoct = _selectedDrop.toString();
    String km = _kmController.text;
    String comment = _commentController.text;
    String driverID = CarsModel.userID;
    DateTime tmp = DateTime.now();
    String date = tmp.year.toString() + "-" + tmp.month.toString() + '-' + tmp.day.toString();

    final response = await http.post(CarsModel.selectedURL + "submit/move", 
    body: {
      "DriverID" : driverID,
      "startLocation" : startLoct,
      "endLocation"   : endLoct,
      "InventoryID"   : car.id,
      "KMs"           : km,
      "Date"           : date,
      "Comment"       : comment
      });

    if(response.statusCode == 200){
      print(response.body);
      String result = jsonDecode(response.body)['result'];
      if(result.compareTo("Failed")==0){
        _showFailed(context);
      } else {         
        _showSuccess(context);  
      }
     
    }
                    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title:  Text("MotorCity",
                      style: TextStyle(fontSize: 25),
                      )
              ),
            body: SingleChildScrollView(
                child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                  child: Form(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Car Info:", 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23
                               )),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            children: <Widget>[
                              Text("Model:  ",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(widget.car.brand + " " + widget.car.model, 
                               style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            children: <Widget>[
                              Text("Color:  ",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(widget.car.color + " / " + widget.car.colorCode, 
                               style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            children: <Widget>[
                              Text("Chassis:  ",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(widget.car.chassis, 
                               style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            children: <Widget>[
                              Text("Location:  ",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(widget.car.location, 
                               style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic)
                              ),
                            ],
                          ),
                        ),

                        Divider(),

                        Text("Submit Move:", 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23
                        )),

                        Consumer<CarsModel>( 
                          builder: (context, carModel, child) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(7),
                            child: DropdownButton<int>(
                              isExpanded: true,
                              items: carModel.locations.map((Location loc) {
                                return DropdownMenuItem<int>(
                                  value: loc.id,
                                  child: Container(child:Text(loc.name), width: 200),
                                );
                              }).toList(),
                              onChanged: onDropChange,
                              value: _selectedDrop,
                             ),
                          );
                          } 
                        ),

                        Container(
                          padding: EdgeInsets.all(7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                            Text("KMs: ",
                                style: TextStyle(fontSize: 20)),
                            TextField(
                              controller: _kmController,
                            )
                          ],),
                        ),

                        Container(
                          padding: EdgeInsets.all(7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                            Text("Add Comment: ",
                                style: TextStyle(fontSize: 20)),
                            TextField(
                              controller: _commentController,
                              minLines: 4,
                              maxLines: 5,
                            )
                          ],),
                        ),

                        Container(
                          
                          padding: EdgeInsets.all(7),
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text("Submit", 
                                      style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white) 
                                  ),
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
            children: [new Text("Move Saved!")]
            ),
          
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePage()
                )
              );
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
            children: [new Text("Move Failed!")]
            ),
          content: Container(
            child: Text("Please try again")
            ),
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
}