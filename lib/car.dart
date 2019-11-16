import 'package:motorcity/location.dart';

class Car {

  final String chassis;
  final String color;
  final String id;
  String date;
  final String location;
  final String loctID;
  final String brand;
  final String model;
  final String colorCode;
  String imageURL;

  Car({this.id, this.chassis, this.color, this.date, this.location, this.brand, this.model, this.colorCode, this.loctID}){
    if(brand=='Peugeot'){
      imageURL = "assets/peugeot.png";
    } else if (brand=='MG'){
      imageURL = "assets/mg.png";
    }
  }

  Car.fromJson(Map<String, dynamic> json):
    this.id       = json['INVT_ID'],
    this.chassis = json['INVT_CHSS'],
    this.color = json['INVT_COLR'],
    this.loctID = json['INVT_LOCT_ID'],
    this.location = json['LOCT_NAME'],
    this.brand    = json['BRND_NAME'],
    this.colorCode = json['INVT_COLR_CODE'],
    this.model = json['MODL_NAME'] + ' ' + json['MODL_CATG'] + ' ' + json['MODL_YEAR']{

      if(brand=='Peugeot'){
      imageURL = "assets/peugeot.png";
    } else if (brand=='MG'){
      imageURL = "assets/mg.png";
    }
    }

    void setDate(String date){
      this.date=date;   
    }
  

}