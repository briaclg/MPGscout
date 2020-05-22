import 'package:flutter/material.dart';
import 'package:mpgscout/screens/infosAdversaire/detail_adversaire.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ListeRankingTime extends StatelessWidget{
  List<Ranking> listForDisplay = List<Ranking>();


  ListeRankingTime({Key key, @required this.listForDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      children: <Widget>[
        Text(
          "Evolution du classement dans le temps",
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
              ),
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType
                    .years,
                rangePadding: ChartRangePadding
                    .round,
              ),
              primaryYAxis: NumericAxis(
                  isInversed: true,
                  minimum: 0,
                  maximum: 10),
              legend: Legend(
                isVisible: true,
                position: LegendPosition
                    .bottom,
              ),
              series: <
                  ChartSeries>[
                SplineSeries <
                    Ranking,
                    DateTime>(
                  name: "Classement dans le temps",
                  animationDuration: 4000,
                  dataSource: listForDisplay,
                  splineType: SplineType
                      .monotonic,
                  enableTooltip: true,
                  xValueMapper: (Ranking data,
                      _) =>
                      DateTime
                          .parse(
                          data
                              .date),
                  yValueMapper: (Ranking data,
                      _) =>
                  data
                      .ranking,)
              ]
          )
              : Container(),)

      ]);
  }





}