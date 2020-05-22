import 'package:flutter/material.dart';
import 'package:mpgscout/screens/infosAdversaire/detail_adversaire.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ListePrixPosition extends StatelessWidget{
  List<Money> listForDisplay = List<Money>();


  ListePrixPosition({Key key, @required this.listForDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        children: <Widget>[
          Text(
            "Prix moyen par poste",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30,),
          Container(
              height: 250,
              child: SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <PieSeries>[
                    PieSeries<Money, String>(
                        dataSource: listForDisplay,
                        xValueMapper: (Money data, _) => data.position,
                        yValueMapper: (Money data, _) => data.prix,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                        )
                    )
                  ]))
        ]);
  }





}