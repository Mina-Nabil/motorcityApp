import 'package:flutter/material.dart';
import 'package:motorcity/providers/cars_model.dart';
import 'package:provider/provider.dart';
import 'package:motorcity/widgets/caritem.dart';

class PendingCarsList extends StatefulWidget {
  @override
  _PendingCarsListState createState() => _PendingCarsListState();
}

class _PendingCarsListState extends State<PendingCarsList> {
  bool _isLoading = true;

  Future<Null> _refreshCars(context) async {
    Provider.of<CarsModel>(context).loadCars(force: true);
    return;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<CarsModel>(context).loadCars();
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final carsData = Provider.of<CarsModel>(context);

    return RefreshIndicator(
      child: Container(
          child: (_isLoading)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[CircularProgressIndicator()],
                )
              : ListView(
                  children: carsData.pendingCars.map((car) {
                  return CarItem(car);
                }).toList())),
      onRefresh: () => _refreshCars(context),
    );
  }
}
