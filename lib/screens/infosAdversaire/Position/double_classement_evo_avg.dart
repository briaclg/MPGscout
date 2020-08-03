import 'package:flutter/material.dart';
import 'package:mpgscout/screens/infosAdversaire/detail_adversaire.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ListeAvgEvo extends StatelessWidget{
  List<JoueurEvo> listForDisplayEvo = List<JoueurEvo>();
  List<PriceEvo> listForDisplayAvg = List<PriceEvo>();


  ListeAvgEvo({Key key, @required this.listForDisplayEvo, @required this.listForDisplayAvg,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        children: <Widget>[
          Text(
            "Evolution du prix max dans le temps",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Cliquez sur la courbe pour voir les détails",
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
      padding: EdgeInsets
          .only(
          top: 15.0),
      child: listForDisplayEvo
          .length > 1
          ? SfCartesianChart(
          tooltipBehavior: TooltipBehavior(
            // Enables the tooltip
              enable: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Container(
                    child: Text(
                        '${listForDisplayEvo[pointIndex]
                            .name} : ${listForDisplayEvo[pointIndex]
                            .price_paid.toString()}'
                    )
                );
              }

              ),

          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType
                .years,
            rangePadding: ChartRangePadding
                .round,
          ),
          primaryYAxis: NumericAxis(),
          legend: Legend(
            isVisible: true,
            position: LegendPosition
                .bottom,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <ChartSeries>[
            SplineSeries <JoueurEvo, DateTime>(
              name: "Prix Max dans le temps",
              animationDuration: 0,
              dataSource: listForDisplayEvo,
              splineType: SplineType.monotonic,
              enableTooltip: true,
              markerSettings: MarkerSettings(
              isVisible: true
              ),
              xValueMapper: (JoueurEvo data, _) => DateTime.parse(data.buying_date),
              yValueMapper: (JoueurEvo data, _) => data.price_paid,),

           /* SplineSeries <PriceEvo, DateTime>(
              name: "Prix Moyen dans le temps",
              animationDuration: 0,
              dataSource: listForDisplayAvg,
              splineType: SplineType.monotonic,
              enableTooltip: false,
              xValueMapper: (PriceEvo data, _) => DateTime.parse(data.date),
              yValueMapper: (PriceEvo data, _) => data.price,),*/
          ]


      )
          : Container(),)
        ]);
  }





}