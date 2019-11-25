import "package:flutter/material.dart";
import "package:material_search/material_search.dart";
import 'package:motorcity/screens/move.dart';
import "package:provider/provider.dart";
import "package:motorcity/providers/cars_model.dart";
import "package:motorcity/models/car.dart";

class SearchCars extends StatefulWidget {
  SearchCars();

  @override
  _SearchCarsState createState() => _SearchCarsState();
}

class _SearchCarsState extends State<SearchCars> {
  _SearchCarsState();

  Map<int, Car> cars = new Map<int, Car>();

  Future<Null> _refreshPage(context) async {
    await Provider.of<CarsModel>(context).loadInventory(force: true);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<CarsModel>(context).loadInventory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final carsModel = Provider.of<CarsModel>(context);
    return RefreshIndicator(
      onRefresh: () => _refreshPage(context),
      child: Container(
        child: MaterialSearch<String>(
          limit: 1000,
          placeholder: "Search..",
          results: carsModel.inventoryCars
              .map((car) => MaterialSearchResult<String>(
                  text: car.chassis, value: car.id + '%' + car.chassis))
              .toList(),
          filter: (dynamic value, String criteria) {
            return value
                .toLowerCase()
                .trim()
                .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
          },
          onSelect: (dynamic value) =>
              Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              int id = int.parse(value.split('%')[0]);
              Car tmp = carsModel.getCarById(id.toString());
              return MovePage(car: tmp);
            },
          )),
        ),
      ),
    );
  }
}
