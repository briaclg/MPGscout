

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

import 'accueil_ligue_perso.dart';

class SelectLiguePerso extends StatefulWidget{
  @override
  _SelectLiguePersoState createState() => _SelectLiguePersoState();
}

class _SelectLiguePersoState extends State<SelectLiguePerso>{

  List<Adversaire> _list = List<Adversaire>();
  List<Adversaire> _listForDisplay = List<Adversaire>();
  int nombreSelection = 0;


  @override
  void initState() {
    super.initState();
    populateAdversaire();
    setState(() {
      _listForDisplay = _list;
    });
  }

  //Va permettre d'avoir une liste
  void populateAdversaire(){
    _list = listeAdversaire();
  }


  List<Adversaire> listeAdversaire() {
    Map<String, dynamic> map = json.decode(globals.dataframeAccueil);
    var dataframeAccueil = json.decode(globals.dataframeAccueil);
    List<Adversaire> adversaires = [];
    int i = 0;

    final keys = map.keys;
    for (var u in keys){
      Adversaire adversaire = Adversaire(i, dataframeAccueil[u]["id"], dataframeAccueil[u]["name"],dataframeAccueil[u]["ligue"], false);
      adversaires.add(adversaire);
      i = i+1;
    }
    return adversaires;
  }

  @override
  Widget build(BuildContext){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: 40),
                  SizedBox(height: 16),
                  Text("Ligue  Personnalisée", style: kHeadingextStyle),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/logo/person.svg"),
                      SizedBox(width: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _list.length.toString() +  " joueurs",
                              style: TextStyle(
                                fontSize: 14,
                                color: kBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/logo/search2.svg"),
                      SizedBox(width: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Recomposez vos ligues \n"
                                  "ou formez en des nouvelles",
                              style: TextStyle(
                                fontSize: 14,
                                color: kBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/logo/business2.svg",width: 25,
                        height: 25,),
                      SizedBox(width: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Obtenez des stats détaillées",
                              style: TextStyle(
                                fontSize: 14,
                                color: kBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Expanded(
              child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40)),
                            child: Container(

                              color:Colors.white,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return index == 0 ? _searchBar() : _getListItemTile(
                                      index - 1);
                                },

                                itemCount: _listForDisplay.length + 1,
                              ),
                            )),
                        Positioned(
                          child: FloatingActionButton.extended(

                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: nombreSelection > 0 ? null: 0,
                              ),
                              label: Text((() {
                                if (nombreSelection > 0) {
                                  return "Ligue de " + nombreSelection.toString();
                                }
                                return "Sélectionnez des joueurs";
                              })()),
                              onPressed: () {
                                if (nombreSelection > 0) {
                                  List<joueurChoisi> joueursChoisis = [];
                                  for (var u in _list) {
                                    if (u.isSelected) {
                                      joueursChoisis.add(joueurChoisi(u.id));
                                    }
                                  }
                                  String jsonJoueurs = jsonEncode(joueursChoisis);
                                  globals.selectJoueurs = jsonJoueurs;
                                  globals.dataFrameLiguePerso = '';
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) => AccueilLiguePerso()
                                  ));
                                }
                              }
                          ),
                          top: -10,
                          right: 30,
                        )
                      ])

            ),
          ],
        ),
      ),
    );
  }

  // Faire une recherche
  _searchBar(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Cherchez par ligue ou nom"
        ),
        onChanged: (text){
          text = text.toLowerCase();
          int i = 0;
          setState(() {
            _listForDisplay = _list.where((Adversaire){
              var adversaireName = Adversaire.name.toLowerCase();
              var adversaireLigue = Adversaire.ligue.toLowerCase();
              return adversaireName.contains(text) || adversaireLigue.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _getListItemTile(index) {
    return GestureDetector(
      onTap: () {

        //Permet d'obtenir l'index de la liste(et non celle qui apparaît) qui deviendra selectionné
        List<Adversaire> findIndex = _list.where((adversaire) {
          var adversaireId = adversaire.id;
          return adversaireId.contains(_listForDisplay[index].id);
        }).toList();

        setState(() {
          _list[findIndex[0].index].isSelected =
          !_list[findIndex[0].index].isSelected;
        });

        //Permet d'obtenir le nombre de séléctionné
        int getLength = _list.where((note) {
          var noteTitle = note.isSelected;
          return noteTitle == true;
        }).length;

        setState(() {
          nombreSelection = getLength;
        });
      },

      child: Card(
        color: _listForDisplay[index].isSelected ? Colors.red[100] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _listForDisplay[index].name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _listForDisplay[index].ligue,
                  style: TextStyle(
                      color: Colors.grey.shade600
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }



}

class Adversaire{
  final int index;
  final String id;
  final String name;
  final String ligue;
  bool isSelected;
  Adversaire(this.index, this.id, this.name, this.ligue, this.isSelected);
}

class joueurChoisi {
  String id;

  joueurChoisi(this.id);

  Map toJson() =>
      {
        'joueur': id
      };
}