import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

class DetailsJoueurLiguePerso extends StatefulWidget{
  @override
  _DetailsJoueurLiguePersoState createState() => _DetailsJoueurLiguePersoState();
}

class _DetailsJoueurLiguePersoState extends State<DetailsJoueurLiguePerso>{

  List<Historique> _listForDisplay = List<Historique>();
  List<HistoriqueData> _listForData = List<HistoriqueData>();
  List<CamembertData> _listForCamembert = List<CamembertData>();
  String nomJoueur = '';

  Future<String> _getDetailsJoueur() async {


    String url = 'https://mpgtest.herokuapp.com/api/detail_joueur';

    Map<String, dynamic> payload = {
      'dataframe': jsonDecode(globals.dataframe),
      'name_of_joueur': globals.detailJoueur,
      'joueur': jsonDecode(globals.selectJoueurs)
    };
    String json = jsonEncode(payload);

    Response response = await post(
        url, headers: {"Content-Type": "application/json"}, body: json);

    List<Historique> list = listeDetailJoueur(response.body);
    _listForDisplay = list;
    return response.body;
  }

  List<Historique> listeDetailJoueur(String detailJoueurDataFrame) {

    List details = json.decode(detailJoueurDataFrame);
    nomJoueur = details[0]["fullname"];

    List<Historique> detailJoueur = [];
    List<HistoriqueData> detailJoueurData = [];
    List detailJoueurCamembert =[];

    int i = 0;
    for (int a = 0; a < details.length; a=a+1) {

      Map<String, dynamic> dataframeDetailJoueur = details[a];

      //On remplit une liste pour l'historique
      Historique unDetail = Historique(i, dataframeDetailJoueur["adversaire"], dataframeDetailJoueur["position"],
          dataframeDetailJoueur["fullname"], dataframeDetailJoueur["joueur_obtenu"],
        dataframeDetailJoueur["club"], dataframeDetailJoueur["price_paid"],
          dataframeDetailJoueur["buying_date"], dataframeDetailJoueur["leagueName"],
        dataframeDetailJoueur["tour_mercato"]
        );
      detailJoueur.add(unDetail);
      i = i+1;

      //On remplit une liste pour le graphe spline
      if (dataframeDetailJoueur["joueur_obtenu"] == 1) {
        HistoriqueData unDetailData = HistoriqueData(dataframeDetailJoueur["adversaire"],
          dataframeDetailJoueur["price_paid"],
            dataframeDetailJoueur["buying_date"],
        );
        detailJoueurData.add(unDetailData);
      }

      //On remplit une liste pour le camembert
      detailJoueurCamembert.add(dataframeDetailJoueur["adversaire"]);
    }

    _remplirCamembert(detailJoueurCamembert);
    _listForData = detailJoueurData.reversed.toList();
    print(_listForData);
    return detailJoueur;
  }

  _remplirCamembert(List elements){
    List<CamembertData> detailCamembertData = [];
    var map = Map();
    elements.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    });

    CamembertData unDetailCamembert;
    var i=0;
    for (MapEntry e in map.entries) {
      unDetailCamembert = CamembertData(e.key,e.value);
      detailCamembertData.add(unDetailCamembert);
    }
    _listForCamembert = detailCamembertData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF398AE5),
      appBar: AppBar(
        backgroundColor: Color(0xFF398AE5),
        elevation: 0.0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getDetailsJoueur(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading ..."),
                  ),
                );
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Détails sur " + nomJoueur,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35.0),
                                topRight: Radius.circular(35.0),
                              ),
                            ),
                            child: DefaultTabController(
                                length: 2, child: Scaffold(
                                appBar: TabBar(
                                  unselectedLabelColor: Color(0xFF398AE5),
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFF398AE5),
                                  ),
                                  tabs: [
                                    Tab(text: "Statistiques",),
                                    Tab(text: "Historique",),
                                  ]
                                ),
                                  body: TabBarView(
                                    children: <Widget>[
                                    new LayoutBuilder(
                                      builder:
                                          (BuildContext context,
                                          BoxConstraints viewportConstraints) {
                                        return SingleChildScrollView(
                                            child: ConstrainedBox(
                                                constraints:
                                                BoxConstraints(
                                                    minHeight: viewportConstraints
                                                        .maxHeight),
                                                child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.only(top:15.0),
                                                        child: _listForData.length > 1 ? SfCartesianChart(
                                                            title: ChartTitle(
                                                              text: "Evolution du prix",
                                                            ),
                                                            tooltipBehavior: TooltipBehavior(
                                                              // Enables the tooltip
                                                              enable: true,
                                                            ),
                                                            primaryXAxis: DateTimeAxis(
                                                              intervalType: DateTimeIntervalType.years,
                                                              rangePadding: ChartRangePadding.round,
                                                            ),
                                                            primaryYAxis: NumericAxis(),
                                                            legend: Legend(
                                                              isVisible: true,
                                                              position: LegendPosition.bottom,
                                                            ),
                                                            series: <ChartSeries>[
                                                              SplineSeries <HistoriqueData, DateTime>(
                                                                name: "Prix dans le temps",
                                                                animationDuration: 4000,
                                                                dataSource: _listForData,
                                                                splineType: SplineType.monotonic,
                                                                enableTooltip: true,
                                                                xValueMapper: (HistoriqueData data, _) => DateTime.parse(data.buying_date),
                                                                yValueMapper: (HistoriqueData data, _) => data.price_paid,)
                                                            ]
                                                        ):Container(),
                                                      ),
                                                      Container(
                                                          height: 450,
                                                          child: SfCircularChart(
                                                            title: ChartTitle(
                                                              text: "Sélection par joueur",
                                                            ),
                                                              legend: Legend(
                                                                isVisible: true,
                                                                overflowMode: LegendItemOverflowMode.wrap,
                                                              ),
                                                              series: <PieSeries>[
                                                                PieSeries<CamembertData, String>(
                                                                    dataSource: _listForCamembert,
                                                                    xValueMapper: (CamembertData data, _) => data.adversaire,
                                                                    yValueMapper: (CamembertData data, _) => data.nombreAchat,
                                                                  dataLabelSettings: DataLabelSettings(
                                                                    isVisible: true,
                                                                  )
                                                                )
                                                              ]))
                                      ])));}),
                                      new LayoutBuilder(
                                          builder:
                                              (BuildContext context,
                                              BoxConstraints viewportConstraints) {
                                            return SingleChildScrollView(
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                                                    child: Column(
                                                        children: <Widget>[
                                                          _headbar(),
                                                          Container(
                                                              child: ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                padding: EdgeInsets.only(top: 15),
                                                                itemCount: _listForDisplay.length,
                                                                itemBuilder: (context, index) {
                                                                  return getListItemTile(index);
                                                                },
                                                              ))
                                                        ])));
                                          }),
                                ],
                              ),
                            )
                            )
                        ))
                  ]);
            }
        ),
      ),
    );
  }


  Widget _headbar() {
    return Padding(
        padding: const EdgeInsets.only(
            top: 15.0, left: 5.0, right: 5.0),
        child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Prix",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                  new Expanded(flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Nom",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                  new Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Ligue",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                  new Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Tour",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      )),

                ]
            )));
  }

  getListItemTile(index) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 1,
        color: _listForDisplay[index].joueur_obtenu > 0 ? Colors.green.withOpacity(0.6): Colors.white,
        child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                      flex:1,
                      child: Container(
                        alignment: Alignment.center,
                        child : Text(
                          _listForDisplay[index].price_paid.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  new Expanded( flex:2,
                    child :Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              _listForDisplay[index].adversaire,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              _listForDisplay[index].buying_date,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade600
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  new Expanded(
                      flex:1,
                      child: Container(
                        alignment: Alignment.center,
                        child : Text(
                          _listForDisplay[index].leagueName,
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      )),
                  new Expanded(
                      flex:1,
                      child: Container(
                        alignment: Alignment.center,
                        child : Text(
                          _listForDisplay[index].tour_mercato.toString(),
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      )),

                ]
            )
        ),
      ),
    );
  }

}
class Historique{
  final int index;
  final String adversaire;
  final int position;
  final String fullname;
  final int joueur_obtenu;
  final String club;
  final int price_paid;
  final String buying_date;
  final String leagueName;
  final int tour_mercato;

  Historique(this.index, this.adversaire, this.position, this.fullname, this.joueur_obtenu, this.club,
      this.price_paid, this.buying_date, this.leagueName, this.tour_mercato);
}

class HistoriqueData{
  String adversaire;
  int price_paid;
  String buying_date;
  HistoriqueData(this.adversaire, this.price_paid, this.buying_date);
}

class CamembertData{
  String adversaire;
  int nombreAchat;

  CamembertData(this.adversaire, this.nombreAchat);
}

