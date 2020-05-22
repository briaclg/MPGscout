import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/category_card.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;
import 'package:mpgscout/utilities/griddashboard.dart';

import 'infosAdversaire/accueil_infos_adversaire.dart';
import 'liguePerso/infosMercato/accueil_mercato.dart';
import 'liguePerso/select_ligue_perso.dart';

class Accueil extends StatefulWidget{
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  Future<String> _manageData() async {
    if (globals.dataframe == ''){
      var returnAllData = await _allData(globals.email, globals.password);
      var returnAccueil = await _getAccueil(returnAllData);
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
                          child: Center(child: Text("Loading ...")),
                        ),
                      ],
                    );
                  }
                  return Scaffold(
                    body: Stack(
                      children: <Widget>[
                        Container(
                          // Here the height of the container is 45% of our total height
                          height: size.height * .45,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 52,
                                    width: 52,

                                  ),
                                ),
                                Text(
                                  "Bienvenue \n" + globals.user,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(fontWeight: FontWeight.w900),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: .85,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    children: <Widget>[
                                      CategoryCard(
                                        title: "Ligue Personnalisé",
                                        svgSrc: "assets/logo/checklist.svg",
                                        press: () {
                                          Navigator.push(
                                              context, new MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectLiguePerso()
                                          ));
                                        },
                                      ),
                                      CategoryCard(
                                        title: "Adversaire",
                                        svgSrc: "assets/logo/reward.svg",
                                        press: () {
                                          Navigator.push(
                                              context, new MaterialPageRoute(
                                              builder: (context) =>
                                                  AccueilInfosAdversaire()
                                          ));
                                        },
                                      ),
                                      CategoryCard(
                                        title: "Mercato",
                                        svgSrc: "assets/logo/ecommerce.svg",
                                        press: () {
                                          Navigator.push(
                                              context, new MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectMercato()
                                          ));
                                        },
                                      ),
                                      CategoryCard(
                                        title: "Statistiques",
                                        svgSrc: "assets/logo/business.svg",
                                        press: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })));
  }

}



