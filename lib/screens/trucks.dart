import 'package:flutter/material.dart';
import 'package:motorcity/widgets/request.dart';
import 'package:motorcity/providers/cars_model.dart';
import 'package:provider/provider.dart';

class TrucksPage extends StatefulWidget {
  @override
  _TrucksPageState createState() => _TrucksPageState();
}

class _TrucksPageState extends State<TrucksPage> {
  bool _isLoading = true;

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<CarsModel>(context).loadTruckRequests();
      _isLoading = false;
    });
    super.initState();
  }

  Future<Null> _refreshPage(context) async {
    await Provider.of<CarsModel>(context).loadTruckRequests(force: true);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _refreshPage(context),
        child: (_isLoading)
            ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children : [CircularProgressIndicator()
              ])
            : Container(
                child: ListView(
                    children: Provider.of<CarsModel>(context)
                        .requests
                        .map((requestaya) {
                return RequestItem(requestaya);
              }).toList())));
  }
}
