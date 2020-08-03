import 'package:flutter/material.dart';
import 'package:mpgscout/screens/infosAdversaire/detail_adversaire.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ListeEvoTime extends StatelessWidget{
  List<JoueurEvo> listForDisplay = List<JoueurEvo>();


  ListeEvoTime({Key key, @required this.listForDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        children: <Widget>[
          Text(
            "Evolution du titulaire dans le temps",
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
            child: listForDisplay
                .length > 1
                ? SfCartesianChart(
                tooltipBehavior: TooltipBehavior(
                  // Enables the tooltip
                    enable: true,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      return Container(
                          child: Text(
                              '${listForDisplay[pointIndex]
                                  .name} : ${listForDisplay[pointIndex]
                                  .price_paid.toString()}'
                          )
                      );
                    }),
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
                ),
                series: <
                    ChartSeries>[
                  SplineSeries <
                      JoueurEvo,
                      DateTime>(
                    name: "Prix dans le temps",
                    animationDuration: 0,
                    dataSource: listForDisplay,
                    splineType: SplineType
                        .monotonic,
                    markerSettings: MarkerSettings(
                        isVisible: true
                    ),
                    enableTooltip: true,
                    xValueMapper: (JoueurEvo data,
                        _) =>
                        DateTime
                            .parse(
                            data
                                .buying_date),
                    yValueMapper: (JoueurEvo data,
                        _) =>
                    data
                        .price_paid,)
                ]
            )
                : Container(),
          )
        ]);
  }





}