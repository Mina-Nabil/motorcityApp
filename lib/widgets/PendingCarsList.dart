import 'package:flutter/material.dart';
import 'package:motorcity/providers/cars_model.dart';
import 'package:provider/provider.dart';
import 'package:motorcity/widgets/caritem.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PendingCarsList extends StatefulWidget {
  @override
  _PendingCarsListState createState() => _PendingCarsListState();
}

class _PendingCarsListState extends State<PendingCarsList> {
  bool _isLoading = true;

  void showServerFailedDialog(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: "Server connection failed.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  Future<Null> _refreshCars(context) async {
    try {
      await Provider.of<CarsModel>(context).loadCars(force: true);
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      showServerFailedDialog(context);
      Scaffold.of(context).showSnackBar(new SnackBar(
          duration: Duration(milliseconds: 500),
          content: new Text(e.toString())));
    }
    return;
  }

  @override
  void initState() {
    final scaffo = Scaffold.of(context);
    Future.delayed(Duration.zero).then((_) async {
      try {
        await Provider.of<CarsModel>(context).loadCars(ignoreEmpty: true);
        _isLoading = false;
      } catch (e) {
        _isLoading = false;
        showServerFailedDialog(context);
        scaffo.showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          content: Text(e.toString()),
        ));
      }
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
              : (carsData.pendingCars.length != 0)
                  ? ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: carsData.pendingCars.map((car) {
                        return CarItem(car);
                      }).toList())
                  : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height-80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              flex: 8,
                              child: Opacity(
                                opacity: 0.2,
                                child: Image.asset("assets/noCars.png"),
                              ),
                            ),
                            Flexible(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: Opacity(
                                      opacity: 0.4,
                                      child: Text("...no cars...")),
                                ))
                          ],
                        ),
                      ),
                    )),
      onRefresh: () => _refreshCars(context),
    );
  }
}
