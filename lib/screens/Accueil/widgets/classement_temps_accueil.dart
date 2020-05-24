import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../accueil.dart';

class ListeRankingTimeAccueil extends StatelessWidget{
  List<Ranking> listForDisplay = List<Ranking>();


  ListeRankingTimeAccueil({Key key, @required this.listForDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return new Wrap(
      children: <Widget>[
        Container(
            height: MediaQuery
                .of(context)
                .size
                .height*.3,

          child:  SfCartesianChart(
              plotAreaBorderWidth: 5,
              plotAreaBorderColor: Colors.blue,
              tooltipBehavior: TooltipBehavior(
                // Enables the tooltip
                enable: true,
                header: ''
              ),

              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType
                    .years,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                majorGridLines: MajorGridLines(
                  color: Colors.blue,
                ),
                majorTickLines: MajorTickLines(
                    color: Colors.blue
                ),
                  axisLine: AxisLine(
                      color: Colors.blue,
                  ),
                  labelStyle: ChartTextStyle(
                      color: Color(0xffF5F4F6),
                      fontWeight: FontWeight.w500
                  )
              ),
              primaryYAxis: NumericAxis(
                  isInversed: true,
                  isVisible: false,

                  minimum: 0,
                  maximum: 10),

              series: <ChartSeries>[
                SplineSeries <Ranking, DateTime>(
                  width: 2,
                  opacity: 1,
                  dataSource: listForDisplay,
                  color: Colors.white,

                  splineType: SplineType.natural,


                  xValueMapper: (Ranking data, _) => DateTime.parse(data.date),
                  yValueMapper: (Ranking data, _) =>
                  data.ranking,)
              ]
          )
              )

      ]);
  }





}