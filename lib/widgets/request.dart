import 'package:motorcity/models/truckrequest.dart';

import 'package:flutter/material.dart';
import 'package:motorcity/widgets/requestDialog.dart';
import 'package:motorcity/widgets/InProgressDialog.dart';

class RequestItem extends StatelessWidget {
  TruckRequest req;

  RequestItem(this.req);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        margin: const EdgeInsets.all(5),
        color: (req.status == '1') ? Colors.green[100] : Colors.white,
        child: FlatButton(
            onPressed: () => {
                  if (req.status == '1')
                    RequestDialog(context, req.id).show()
                  else if (req.status == '2')
                    InProgressDialog(context, req.id).show()
                },
            child: Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(5),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: Image.asset((req.status == '1')
                      ? "assets/new.png"
                      : "assets/in-progress.png"),
                ),
                Flexible(
                  flex: 8,
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                         Flexible(
                           fit: FlexFit.loose,
                           flex: 6,
                         child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Request# ${req.id}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          )),
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 4,
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                'since ${req.reqDate}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 3,
                              child: Container(
                              padding: EdgeInsets.only(top: 5, left: 15),
                              child: Text(
                                'From: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            )),
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 7,
                                child: Text('${req.from}',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center))
                          ],
                     
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 15, top: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.loose,
                                  flex: 3,
                                  child: Text(
                                    'To: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  flex: 7,
                                    child: Text(
                                  ' ${req.to}',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ))
                              ],
                            ),
                          )),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[
                        Flexible(
                            fit: FlexFit.loose,
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 15, top: 5),
                              child: Text(
                                  "Car: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 8,
                          child:  Text(
                                '${req.chassis} - ${req.model}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ))
                      ]),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 8,
                          child: Container(
                            padding: EdgeInsets.only(left: 15, top: 5),
                            child: Text(
                              '${req.comment}',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15),
                            ),
                          ))
                    ],
                  ),
                ),
              ]),
            )));
  }
}
