import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/counter.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;
import 'package:mpgscout/utilities/griddashboardligueperso.dart';

import 'infosLigue/accueil_une_ligue.dart';
import 'joueurs_achetes_ligue_perso.dart';

class AccueilLiguePerso extends StatefulWidget {
  @override
  _AccueilLiguePersoState createState() => _AccueilLiguePersoState();
}

class _AccueilLiguePersoState extends State<AccueilLiguePerso> {
  List<Joueurs> _list = List<Joueurs>();
  List<Ligue> _listForDisplay = List<Ligue>();

  Future<String> _getAccueilLiguePerso() async {
    print('ligue_perso_general');
    if (globals.dataFrameLiguePerso == '') {
      String url = 'https://mpgtest.herokuapp.com/api_deux/ligue_perso_general';
      Map<String, dynamic> payload = {
        'dataframe': jsonDecode(globals.dataframe),
        'joueur': jsonDecode(globals.selectJoueurs)
      };
      String json = jsonEncode(payload);
      Response response = await post(url,
          headers: {"Content-Type": "application/json"}, body: json);

      globals.dataFrameLiguePerso = response.body;
      Map<String, dynamic> map = jsonDecode(response.body)['ligue_personnalise'];
      List<dynamic> mapLigue = jsonDecode(response.body)['list_of_ligue'];


      _list = listeAdversaire(map, response.body);
      _listForDisplay = listeLigue(mapLigue);

      return response.body;
    } else {
      return globals.dataFrameLiguePerso;
    }
  }

  List<Joueurs> listeAdversaire(Map<String, dynamic> map, String dataframe) {

    var dataframeJoueursAchetes = json.decode(dataframe)['ligue_personnalise'];
    List<Joueurs> joueursAchetes = [];
    int i = 0;
    final keys = map.keys;
    for (var u in keys){
      i++;
      Joueurs joueur = Joueurs(dataframeJoueursAchetes[u]["prix_max"], dataframeJoueursAchetes[u]["name"], dataframeJoueursAchetes[u]["club"],
          );
      joueursAchetes.add(joueur);
      if (i == 4){
        break;
      }
    }
    return joueursAchetes;
  }


  List<Ligue> listeLigue(List<dynamic> mapLigue) {
    List<Ligue> _listLigue = [];
    for (var i=0; i< mapLigue.length; i++) {
      Map<String, dynamic> ligues  = mapLigue[i];
      String premier = "";
      if (ligues['premier'] != null){
        premier = ligues['premier'];
      }

      print(ligues['nom_ligue']);
      print(ligues['date_ligue']);
      String date = "";
      int month = DateTime.parse(ligues['date_ligue']).month;
      int year = DateTime.parse(ligues['date_ligue']).year;
      if (month > 6){
        date = year.toString()  + " - " + (year + 1).toString();
      }else{
        date = (year - 1).toString() + " - " + year.toString() ;
      }
      print(date);
      Ligue ligue = Ligue(ligues['nom_ligue'], ligues['nombre_joueur'], date, premier);
      _listLigue.add(ligue);
    }
    return _listLigue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getAccueilLiguePerso(),
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
                  child: Center(child: Text("Loading ...")),
                ),
              ],
            );
          }
          //Affichage
          return Scaffold(
              body: LayoutBuilder(
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
                                //
                                ClipPath(
                                    clipper: MyClipper(),
                                    child: Container(
                                      height: 250,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color(0xFF3383CD),
                                              Color(0xFF11249F)
                                            ]),
                                        image: DecorationImage(

                                          image: AssetImage(
                                              "assets/logo/trophy.png"),
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: 40,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Ligue Personnalisé",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: "Joueurs achetés\n",
                                                        style: kTitleTextstyle
                                                    ),
                                                    TextSpan(
                                                        text: "Classement",
                                                        style: TextStyle(
                                                          color: kTextLightColor,)
                                                    ),
                                                  ]
                                              )
                                          ),
                                          Spacer(),
                                          InkWell(
                                            child: new Text(
                                              'Voir les détails',
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          JoueursAchetesLiguePerso()
                                                  ));
                                            },
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 30,
                                              color: kShadowColor,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            Counter(
                                              color: kRecovercolor,
                                              club: _list[1].club,
                                              number: int.parse(
                                                  _list[0].prix_max),
                                              size: 25,
                                              title: _list[0].name,
                                            ),
                                            Counter(
                                              color: kInfectedColor,
                                              club: _list[1].club,
                                              number: int.parse(
                                                  _list[1].prix_max),
                                              size: 20,
                                              title: _list[1].name,
                                            ),
                                            Counter(
                                              color: kDeathColor,
                                              club: _list[1].club,
                                              size: 15,
                                              number: int.parse(
                                                  _list[2].prix_max),
                                              title: _list[2].name,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: "Ligues Communes\n",
                                                        style: kTitleTextstyle
                                                    ),
                                                    TextSpan(
                                                        text: "Historique",
                                                        style: TextStyle(
                                                          color: kTextLightColor,)
                                                    ),
                                                  ]
                                              )
                                          ),
                                          Spacer(),
                                          InkWell(
                                            child: new Text(
                                              'Voir les détails',
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccueilUneLigue()
                                                  ));
                                            },
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                          height: 150,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _listForDisplay.length,
                                            itemBuilder: (context, index) {
                                              return _getListItemTile(index);
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )));
                  }
              ));
        },
      ),
    );
  }


  // Organisation de la liste
  _getListItemTile(index) {
    return  Container(
            height: 140.0,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: new Stack(
                children: <Widget>[
                  Container(
                      height: 124.0,
                      decoration: new BoxDecoration(
                        color: Color(0xFF3383CD),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: new Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: ligueCardContent(index)
                  ),
                ]));
  }

  ligueCardContent(index) {
    return Container(
      margin: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: new Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(_listForDisplay[index].nomLigue,style: headerTextStyle,
          ),
          new Container(height: 10.0),
          new Text(_listForDisplay[index].dateLigue,
            style: subHeadTextStyle,
          ),
        ],
      ),
    );
  }




  static  TextStyle baseTextStyle = const TextStyle(
      fontFamily: 'Poppins'
  );

  static TextStyle regularTextStyle  =  baseTextStyle.copyWith(
      color: Colors.white,
      fontSize: 10.0,
      fontWeight: FontWeight.w400
  );

  TextStyle headerTextStyle  = baseTextStyle.copyWith(
      fontFamily: 'Poppins',
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );

  TextStyle subHeadTextStyle =  regularTextStyle.copyWith(
      fontSize: 12.0
  );







}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width/2, size.height,
        size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }


  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }}

  class Joueurs{
  final String prix_max;
  final String name;
  final String club;

  Joueurs(this.prix_max, this.name, this.club);

  }

class Ligue{
  final String nomLigue;
  final int nombreJoueur;
  final String dateLigue;
  final String premier;

  Ligue(this.nomLigue, this.nombreJoueur, this.dateLigue, this.premier);
}