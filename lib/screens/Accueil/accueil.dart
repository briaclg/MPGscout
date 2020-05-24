import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/screens/Accueil/widgets/categories_card.dart';
import 'package:mpgscout/screens/Accueil/widgets/classement_temps_accueil.dart';

import 'package:moving_average/moving_average.dart';
import 'package:mpgscout/screens/infosAdversaire/accueil_infos_adversaire.dart';
import 'package:mpgscout/screens/liguePerso/infosMercato/accueil_mercato.dart';
import 'package:mpgscout/screens/liguePerso/select_ligue_perso.dart';

import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

import 'widgets/info_card.dart';


class Accueil extends StatefulWidget{
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  List<Ranking> _listForRanking = List<Ranking>();
  String percentSucess;
  String JoueurCher;
  String CherPrix;
  String Equipe;
  String avgRanking;

  Future<String> _manageData() async {
    if (globals.dataframe == ''){
      var returnAllData = await _allData(globals.email, globals.password);
      var returnAccueil = await _getAccueil(returnAllData);
      await _getStats(returnAccueil);

      return returnAccueil;
    }else{
      return(globals.dataframe);
    }
  }

  _allData(String email, String password) async {
    String url = 'https://mpgtest.herokuapp.com/api/list';
    print(email);
    print(password);
    Map<String, dynamic> payload = {
      'email': email,
      'password': password
    };
    String json = jsonEncode(payload);
    Response response = await post(url, body: json);
    globals.dataframe = response.body;

    return response.body;
  }

  Future<String> _getAccueil(String dataframe) async {
    print('accueil');
    String url = 'https://mpgtest.herokuapp.com/api/accueil';
    Map<String, dynamic> payload = {
      'dataframe': jsonDecode(dataframe),
      'userId': globals.userId
    };
    String json = jsonEncode(payload);
    Response response = await post(url, body: json);
    var returGetAccueil = jsonDecode(response.body);

    globals.dataframeAccueil = jsonEncode(returGetAccueil["adversaire"]);
    return response.body;
  }

// Permet d'avoir l'évol du classement moyen
  _getStats(String dataframeAdversaire) {


    List<int> listPosition = [];
    Map<String, dynamic> details = jsonDecode(dataframeAdversaire)["user"];
    List<dynamic> mapRanking  = details["general"]["evo_ranking"];

    // On obtient le classement moyen
    for (int i = 0; i < mapRanking.length; i=i+1) {

      Map<String, dynamic> dataframeDetailAdversaire = mapRanking[i];

      listPosition.add(dataframeDetailAdversaire["ranking"]);
    }

    avgRanking = average(listPosition).toStringAsFixed(2);

    // Average success
    percentSucess = (details["general"]["avg_success"]*100).toStringAsFixed(2) + '%';

    // Joueur le plus cher
    List<dynamic> mapCher = details["general"]["joueur_les_plus_cher"];
    for (int i = 0; i < mapCher.length; i=i+1) {

      Map<String, dynamic> dataframeDetailAdversaire = mapCher[i];
      JoueurCher = dataframeDetailAdversaire["name"];
      CherPrix = dataframeDetailAdversaire["price_paid"].toString();
      break;
    }

    // Equipe pref
    Map<String, dynamic> mapEquipe = details["general"]["equipe_prefere"];
    var keys = mapEquipe.keys;
    for (var equipe in keys){
      Equipe = equipe;
      break;
    }
  }


  // Permet d'avoir l'évol du classement moyen
  _getRanking(String dataframeAdversaire) {

    List<Ranking> detailJoueurData = [];
    List<int> listPosition = [];
    Map<String, dynamic> details = jsonDecode(dataframeAdversaire)["user"];
    Map<String, dynamic> map = details["general"]["monthly_average"];
    double classement;
    var keys = map.keys;
    for (var ranking in keys){

      // On vérifie que le classment soit pas un int
      if (map[ranking].runtimeType == int){
        classement = map[ranking].toDouble();
      }else{
        classement = map[ranking];
      };
      Ranking unDetail = Ranking('', classement,
          ranking);
      detailJoueurData.add(unDetail);
    }
    return detailJoueurData;

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(

        body: Container(
            child: FutureBuilder(
                future: _manageData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //Chargement
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

                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),),
                                  SizedBox(height: 15,),
                                  Text("Récupération de tes données",
                                      style: TextStyle(
                                          color: Color(0xffFEFDFE),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))
                                ]
                            )
                        ),
                      ],
                    );
                  }
                  return Scaffold(
                      body: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                                flex: 2,
                                child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40),
                                      ),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 35, 20, 16),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(
                                                "Salut " + globals.user + ',',
                                                  style: TextStyle(
                                                          color: Color(0xffFEFDFE),
                                                          fontSize: 28,
                                                          fontWeight: FontWeight.w600)
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                "Voici quelques unes de tes stats à Mon Petit Gazon ",
                                                style:TextStyle(
                                                        color: Color(0xffF5F4F6),
                                                        fontSize: 12,
                                                        ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Wrap(
                                                runSpacing: 20,
                                                spacing: 20,
                                                children: <Widget>[
                                                  InfoCard(
                                                    title: "Classement",
                                                    effectedNum: avgRanking,
                                                    ImageD: "assets/logo/medal.svg",
                                                    press: () {},
                                                  ),
                                                  InfoCard(
                                                    title: "Réussite d'achat",
                                                    effectedNum: percentSucess,
                                                    ImageD: "assets/logo/football-tv.svg",
                                                    press: () {},
                                                  ),
                                                  InfoCard(
                                                    title: "Joueur le + cher",
                                                    effectedNum: JoueurCher,
                                                    ImageD: "assets/logo/tshirt.svg",
                                                    press: () {},
                                                  ),
                                                  InfoCard(
                                                    title: "Equipe préférée",
                                                    effectedNum: Equipe,
                                                    ImageD: "assets/logo/club.svg",
                                                    press: () {},
                                                  ),
                                                ],
                                              ),
                                            ])))),
                            Container(
                                height: MediaQuery.of(context).size.height*0.6,
                                child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        SizedBox(height: 5),
                                        Text(
                                            "Catégories",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)
                                        ),
                                        SizedBox(height: 25),
                                        AccountCard(name: 'Ligue Personnalisée',
                                        id: 'Choisis plusieurs de tes adversaires et découvre leurs stats communes',
                                        ImageD: "assets/logo/liste_perso.png",
                                        route: SelectLiguePerso(),),

                                        SizedBox(height: 10),
                                        AccountCard(name: 'Adversaire',
                                          id: 'Obtiens tous les renseignements possibles sur tes adversaires',
                                          ImageD: "assets/logo/espion.png",
                                          route: AccueilInfosAdversaire(),),

                                        SizedBox(height: 10),

                                        AccountCard(name: 'Mercato',
                                          id: 'Optimise ta recherche de joueur pour construire ton équipe',
                                          ImageD: "assets/logo/pepite.png",
                                          route: SelectMercato(),)
                                      ]),)))
                          ])
                  );
                })));
  }

}

class Ranking{
  final String ligue;
  final String date;
  final double ranking;

  Ranking(this.ligue, this.ranking, this.date);

}

num average(List<int> nums){
  return nums.reduce((int a, int b) => a + b) / nums.length;
}

