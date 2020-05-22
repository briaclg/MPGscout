import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/screens/infosAdversaire/General/classement_equipe_prefere.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;
import 'package:syncfusion_flutter_charts/charts.dart';

import 'General/classement_joueur_prefere.dart';
import 'General/classement_plus_cher.dart';
import 'General/classement_temps.dart';
import 'General/prix_par_position.dart';
import 'Position/classement_evo_prix.dart';
import 'Position/double_classement_evo_avg.dart';


class DetailsAdversaire extends StatefulWidget{
  @override
  _DetailsAdversaireState createState() => _DetailsAdversaireState();
}

class _DetailsAdversaireState extends State<DetailsAdversaire>{

  // Général
  List<Ranking> _listForRanking = List<Ranking>();
  List<JoueurCher> _listForCher = List<JoueurCher>();
  List<Prefere> _listForEquipe = List<Prefere>();
  List<Prefere> _listForJoueur = List<Prefere>();
  List<Money> _listForMoney = List<Money>();
  String percentSucess;

  //Gardien
  String prixGardien;
  List<JoueurCher> _listGardienCher = List<JoueurCher>();
  List<JoueurEvo> _listGardienEvo = List<JoueurEvo>();

  //Défenseur
  String prixDef;
  List<JoueurCher> _listDefCher = List<JoueurCher>();
  List<JoueurEvo> _listDefEvo = List<JoueurEvo>();
  List<PriceEvo> _listDefAvg = List<PriceEvo>();

  //Défenseur
  String prixMil;
  List<JoueurCher> _listMilCher = List<JoueurCher>();
  List<JoueurEvo> _listMilEvo = List<JoueurEvo>();
  List<PriceEvo> _listMilAvg = List<PriceEvo>();

  //Défenseur
  String prixAtt;
  List<JoueurCher> _listAttCher = List<JoueurCher>();
  List<JoueurEvo> _listAttEvo = List<JoueurEvo>();
  List<PriceEvo> _listAttAvg = List<PriceEvo>();

  Future<String> _getDetailAdversaire() async {
    print('detail_adversaire');
    if (globals.dataframeAdversaire == '') {
      String url = 'https://mpgtest.herokuapp.com/api_deux/get_detail_adversaire';
      Map<String, dynamic> payload = {
        'dataframe': jsonDecode(globals.dataframe),
        'userId': globals.detailAdversaire
      };
      String json = jsonEncode(payload);
      Response response = await post(url,
          headers: {"Content-Type": "application/json"}, body: json);


      Stopwatch stopwatch = new Stopwatch()..start();
      globals.dataframeAdversaire = response.body;
      listeRanking(response.body);
      listeJoueurCher(response.body);
      listeEquipePrefere(response.body);
      listeJoueurPrefere(response.body);
      percentSucesses(response.body);
      moneyPosition(response.body);
      listeGardien(response.body);



      //Def
      prixDef = positionPaid(response.body, "defenseur");
      _listDefCher = listePositionCher(response.body, "defenseur");
      _listDefEvo = listePosition(response.body, "defenseur");
      _listDefAvg = listePositionAvg(response.body, "defenseur");

      //Mil
      prixMil = positionPaid(response.body, "milieu");
      _listMilCher = listePositionCher(response.body, "milieu");
      _listMilEvo = listePosition(response.body, "milieu");
      _listMilAvg = listePositionAvg(response.body, "milieu");

      //Att
      prixAtt = positionPaid(response.body, "attaquant");
      _listAttCher = listePositionCher(response.body, "attaquant");
      _listAttEvo = listePosition(response.body, "attaquant");
      _listAttAvg = listePositionAvg(response.body, "attaquant");


      print('doSomething() executed in ${stopwatch.elapsed}');


      return response.body;
    } else {
      return globals.dataframeAdversaire;
    }
  }


  percentSucesses(String dataframeAdversaire) {
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    percentSucess = details["general"]["avg_success"].toStringAsFixed(2);
  }

  moneyPosition(String dataframeAdversaire){
    List<Money> detailMoneyData = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    Map<String, dynamic> map = details["general"]["prix_moy"];
    for (var post in map.keys){
      Money unDetail = Money(position(double.parse(post)), double.parse(map[post].toStringAsFixed(2)));
      detailMoneyData.add(unDetail);
    }
    _listForMoney = detailMoneyData;

  }


  listeRanking(String dataframeAdversaire) {

    List<Ranking> detailJoueurData = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    List<dynamic> map  = details["general"]["evo_ranking"];
    for (int i = 0; i < map.length; i=i+1) {

      Map<String, dynamic> dataframeDetailAdversaire = map[i];
      Ranking unDetail = Ranking(dataframeDetailAdversaire["ligue"], dataframeDetailAdversaire["ranking"],
        dataframeDetailAdversaire["date"]);
      detailJoueurData.add(unDetail);
    }

    _listForRanking = detailJoueurData;
  }

 listeJoueurCher(String dataframeAdversaire) {

   List<JoueurCher> detailJoueurCherData = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    List<dynamic> map = details["general"]["joueur_les_plus_cher"];
    for (int i = 0; i < map.length; i=i+1) {

      Map<String, dynamic> dataframeDetailAdversaire = map[i];
      JoueurCher unDetail = JoueurCher(dataframeDetailAdversaire["name"], dataframeDetailAdversaire["price_paid"],
          dataframeDetailAdversaire["leagueName"], dataframeDetailAdversaire["buying_date"]);
      detailJoueurCherData.add(unDetail);
    }
   _listForCher = detailJoueurCherData;

  }

  listeEquipePrefere(String dataframeAdversaire) {

    List<Prefere> detailEquipePrefereData = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    Map<String, dynamic> map = details["general"]["equipe_prefere"];
    var keys = map.keys;
    for (var equipe in keys){
      Prefere unDetail = Prefere(equipe, map[equipe]);
      detailEquipePrefereData.add(unDetail);
    }
    _listForEquipe = detailEquipePrefereData;


  }

  listeJoueurPrefere(String dataframeAdversaire) {

    List<Prefere> detailJoueurPrefereData = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    Map<String, dynamic> map = details["general"]["joueur_prefere"];
    var keys = map.keys;
    for (var joueur in keys){
      Prefere unDetail = Prefere(joueur, map[joueur]);
      detailJoueurPrefereData.add(unDetail);
    }
    _listForJoueur = detailJoueurPrefereData;
  }

  listeGardien(String dataframeAdversaire){

    List<JoueurCher> detailJoueurCherData = [];
    List<JoueurEvo> detailJoueurCherEvo = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    prixGardien = details["gardien"]["avg_price_paid"].toStringAsFixed(2);


    List<dynamic> map = details["gardien"]["joueur_les_plus_cher"];
    for (int i = 0; i < map.length; i=i+1) {
      Map<String, dynamic> dataframeDetailAdversaire = map[i];
      JoueurCher unDetail = JoueurCher(dataframeDetailAdversaire["name"], dataframeDetailAdversaire["price_paid"],
          dataframeDetailAdversaire["leagueName"], dataframeDetailAdversaire["buying_date"]);
      detailJoueurCherData.add(unDetail);
    }
    _listGardienCher = detailJoueurCherData;

    List<dynamic> mapEvo = details["gardien"]["evo_price"];
    for (int i = 0; i < mapEvo.length; i=i+1) {

      Map<String, dynamic> dataframeDetailEvo = mapEvo[i];

      JoueurEvo unDetail = JoueurEvo(dataframeDetailEvo["name"], dataframeDetailEvo["price"],
          dataframeDetailEvo["ligue"], dataframeDetailEvo["date"]);
      detailJoueurCherEvo.add(unDetail);
    }
    _listGardienEvo = detailJoueurCherEvo;

  }

  positionPaid(String dataframeAdversaire, String post) {
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    return details[post]["avg_price_paid"].toStringAsFixed(2);
  }

  listePosition(String dataframeAdversaire,String post){

    List<JoueurEvo> detailPositionEvo = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    List<dynamic> mapEvo = details[post]["evo_price_max"];
    for (int i = 0; i < mapEvo.length; i=i+1) {

      Map<String, dynamic> dataframeDetailEvo = mapEvo[i];

      JoueurEvo unDetail = JoueurEvo(dataframeDetailEvo["name"], dataframeDetailEvo["price"],
          dataframeDetailEvo["ligue"], dataframeDetailEvo["date"]);
      detailPositionEvo.add(unDetail);
    }
    return detailPositionEvo;
  }

  listePositionCher(String dataframeAdversaire,String post){
    List<JoueurCher> detailPositionCherData = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);
    List<dynamic> map = details[post]["joueur_les_plus_cher"];
    for (int i = 0; i < map.length; i=i+1) {

      Map<String, dynamic> dataframeDetailAdversaire = map[i];
      JoueurCher unDetail = JoueurCher(dataframeDetailAdversaire["name"], dataframeDetailAdversaire["price_paid"],
          dataframeDetailAdversaire["leagueName"], dataframeDetailAdversaire["buying_date"]);
      detailPositionCherData.add(unDetail);
    }
    return detailPositionCherData;
  }


  listePositionAvg(String dataframeAdversaire,String post){

    List<PriceEvo> detailPrixEvo = [];
    Map<String, dynamic> details = json.decode(dataframeAdversaire);

    List<dynamic> mapEvo = details[post]["evo_price_avg"];
    for (int i = 0; i < mapEvo.length; i=i+1) {

      Map<String, dynamic> dataframeDetailEvo = mapEvo[i];

      PriceEvo unDetail = PriceEvo(double.parse(dataframeDetailEvo["price"].toStringAsFixed(2)),
          dataframeDetailEvo["ligue"], dataframeDetailEvo["date"]);
      detailPrixEvo.add(unDetail);
    }

    return detailPrixEvo;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getDetailAdversaire(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Wrap(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                  child: Center(child: Text("Loading ...")),
                ),
              ],
            );
          }
          return Scaffold(
              backgroundColor: Color(0xFF398AE5),
              appBar: AppBar(
                backgroundColor: Color(0xFF398AE5),
                elevation: 0.0,
                automaticallyImplyLeading: true,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              body: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Détails sur " + globals.nameAdversaire,
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
                                    length: 5, child: Scaffold(
                                  appBar: TabBar(
                                      isScrollable: true,
                                      unselectedLabelColor: Color(0xFF398AE5),
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0xFF398AE5),
                                      ),
                                      tabs: [
                                        TabNom('Général'),
                                        TabNom('Gardien'),
                                        TabNom('Défenseur'),
                                        TabNom('Milieu'),
                                        TabNom('Attaquant'),

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
                                                          SizedBox(height: 30,),
                                                          percentSucessString(),
                                                          SizedBox(height: 40,),
                                                          ListeRankingTime(listForDisplay: _listForRanking,),
                                                          SizedBox(height: 40,),
                                                          ListePrixPosition(listForDisplay: _listForMoney),
                                                          SizedBox(height: 40,),
                                                          ListeJoueurCher(
                                                              listForDisplay: _listForCher),
                                                          SizedBox(height: 40,),
                                                          ListeEquipePrefere(
                                                              listForDisplay: _listForEquipe),
                                                          SizedBox(height: 40,),
                                                          _listForJoueur.length > 0 ? ListeJoueurPrefere(
                                                              listForDisplay: _listForJoueur):Container(),

                                                        ])));
                                          }),
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
                                                          SizedBox(height: 30,),
                                                          PrixString(prixGardien),
                                                          SizedBox(height: 40,),
                                                          _listGardienEvo.length > 1 ? ListeEvoTime(listForDisplay: _listGardienEvo): Container(),
                                                          SizedBox(height: 40,),
                                                          ListeJoueurCher(
                                                              listForDisplay: _listGardienCher),
                                                        ])));
                                          }),
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
                                                          SizedBox(height: 30,),
                                                          PrixString(prixDef),
                                                          SizedBox(height: 40,),
                                                          ListeAvgEvo(listForDisplayEvo: _listDefEvo,listForDisplayAvg: _listDefAvg),
                                                          SizedBox(height: 40,),
                                                          ListeJoueurCher(
                                                              listForDisplay: _listDefCher),
                                                        ])));
                                          }),
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
                                                          SizedBox(height: 30,),
                                                          PrixString(prixMil),
                                                          SizedBox(height: 40,),
                                                          ListeAvgEvo(listForDisplayEvo: _listMilEvo,listForDisplayAvg: _listMilAvg),
                                                          SizedBox(height: 40,),
                                                          ListeJoueurCher(
                                                              listForDisplay: _listMilCher),
                                                        ])));
                                          }),
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
                                                          SizedBox(height: 30,),
                                                          PrixString(prixAtt),
                                                          SizedBox(height: 40,),
                                                          ListeAvgEvo(listForDisplayEvo: _listAttEvo,listForDisplayAvg: _listAttAvg),
                                                          SizedBox(height: 40,),
                                                          ListeJoueurCher(
                                                              listForDisplay: _listAttCher),
                                                        ])));
                                          }),

                                    ],
                                  ),
                                )
                                )
                            ))
                      ])
              ));
        },
      ),
    );
  }

  percentSucessString() {
    return new Wrap(
        children: <Widget>[
          Text(
            "Pourcentage de réussite au mercato",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Seul les premiers tours sont comptabilisés",
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: Text(
              (double.parse(percentSucess)*100).toString() + ' %',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  PrixString(String prix) {
    return new Wrap(
        children: <Widget>[
          Text(
            "Prix moyen",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: Text(
              prix,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  TabNom(String titre){
    return Tab(text: titre,);
  }

  String position(position){
    if (position == 1){
      return "Gardien";
    }
    if (position == 2){
      return "Défenseur";
    }
    if (position == 3){
      return "Milieu";
    }
    if (position == 4){
      return "Attaquant";
    }
  }

}



class Joueur{
  final int position;
  final String fullname;
  final int joueur_obtenu;
  final String club;
  final int price_paid;
  final int tour_mercato;

  Joueur(this.position, this.fullname, this.joueur_obtenu, this.club, this.price_paid, this.tour_mercato);

}
class Ranking{
  final String ligue;
  final String date;
  final int ranking;

  Ranking(this.ligue, this.ranking, this.date);

}

class JoueurCher{
  final String name;
  final int price_paid;
  final String leagueName;
  final String buying_date;

  JoueurCher(this.name, this.price_paid, this.leagueName, this.buying_date, );
}

class Prefere{
  final String name;
  final int nombre;

  Prefere(this.name, this.nombre);
}

class Money{
  final String position;
  final double prix;

  Money(this.position, this.prix);
}

class JoueurEvo{
  final String name;
  final int price_paid;
  final String leagueName;
  final String buying_date;

  JoueurEvo(this.name, this.price_paid, this.leagueName, this.buying_date, );
}

class PriceEvo{
  final double price;
  final String ligue;
  final String date;

  PriceEvo(this.price, this.ligue, this.date);
}


