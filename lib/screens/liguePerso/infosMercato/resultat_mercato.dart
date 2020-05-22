import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/counter.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;
import 'package:mpgscout/utilities/griddashboardligueperso.dart';



class ResultatMercato extends StatefulWidget {
  @override
  _ResultatMercatoState createState() => _ResultatMercatoState();
}

class _ResultatMercatoState extends State<ResultatMercato> {
  List<Joueur> _listForDisplay = List<Joueur>();
  bool sort = false;

  Future<String> _getAccueilLiguePerso() async {
      String url = 'https://mpgtest.herokuapp.com/api/prepare_mercato';
      Response response = await post(url,
          headers: {"Content-Type": "application/json"}, body: globals.mercato);

      _listForDisplay = buildListJoueur(response.body);

      print(_listForDisplay);
      return response.body;
  }



  List<Joueur> buildListJoueur(String listeJoueurs){
  List details = json.decode(listeJoueurs);
  List<Joueur> detailJoueur = [];


  for (int i = 0; i < details.length; i=i+1) {

    Map<String, dynamic> dataframeDetailJoueur = details[i];
    Joueur unDetail = Joueur(dataframeDetailJoueur['name'], dataframeDetailJoueur['position'],
        dataframeDetailJoueur['moyenne'],dataframeDetailJoueur['titu'],dataframeDetailJoueur['but'],
        dataframeDetailJoueur['quotation']);

    detailJoueur.add(unDetail);
  }
  return detailJoueur;
}

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _listForDisplay.sort((a, b) => a.name.compareTo(b.name));
      } else {
        _listForDisplay.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: FutureBuilder(
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
                backgroundColor: Color(0xFF398AE5),
                appBar: AppBar(
                  backgroundColor: Color(0xFF398AE5),
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(color: Colors.white),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Résultats de la recherche",
                        style: Theme.of(context).textTheme.display1.apply(
                          color: Colors.white,
                          fontWeightDelta: 2,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                              ],
                            ),
                            _headbar(),
                            SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _listForDisplay.length,
                                itemBuilder: (context, index) {
                                  return getListItemTile(index);
                                },

                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
String Position(int post){
    if (post == 1){
      return 'Gardien';
    }
    if (post == 2){
      return 'Défenseur';
    }
    if (post == 3){
      return 'Milieu';
    }
    if (post == 4){
      return 'Attaquant';
    }
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
                          "Moy.",
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
                          "Titu.",
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
                          "But",
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
                          _listForDisplay[index].quotation.toString(),
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
                              _listForDisplay[index].name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              Position(_listForDisplay[index].position),
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
                          _listForDisplay[index].moyenne.toString(),
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
                          (_listForDisplay[index].titu*100).toStringAsFixed(1)+ " %",
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
                          _listForDisplay[index].but.toString(),
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

class Joueur{
  final String name;
  final int position;
  final double moyenne;
  final double titu;
  final int but;
  final int quotation;

  Joueur(this.name, this.position, this.moyenne, this.titu, this.but, this.quotation);

}


