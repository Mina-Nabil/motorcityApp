import "package:flutter/material.dart";
import "package:material_search/material_search.dart";
import 'package:motorcity/move.dart';
import "package:provider/provider.dart";
import "./cars_model.dart";
import "./car.dart";


class SearchCars extends StatefulWidget {

  CarsModel cars ;

  SearchCars(this.cars);

  @override
  _SearchCarsState createState() => _SearchCarsState(cars);
}

class _SearchCarsState extends State<SearchCars> {

  CarsModel carsModel;

  _SearchCarsState(this.carsModel);

  Map<int, Car> cars = new Map<int, Car>() ;


   Future<Null> _refreshPage() async{
    carsModel.loadInventory();
    carsModel.loadCars();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
          onRefresh: _refreshPage,
          child: Container(
          child: Consumer<CarsModel>(

            builder: (context, carsModel, child){
              carsModel.inventoryCars.forEach((car) => cars[int.parse(car.id)]=car );
          
              return MaterialSearch<String>(
                limit: 1000,
                placeholder: "Search..",
                results: carsModel.inventoryCars.map( 
                  (car) =>  MaterialSearchResult<String>(
                      text: car.chassis,
                      value: car.id+'%'+car.chassis
                      )).toList(),
                  filter: (dynamic value, String criteria) {
                    return value.toLowerCase().trim()
                    .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
                },
                onSelect: (dynamic value) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)  {
                      int id = int.parse(value.split('%')[0]);
                      return MovePage(car: cars[id]);
                      },
                  )
                ),
              );
            },   
          ),
        ),
    );
    }
}