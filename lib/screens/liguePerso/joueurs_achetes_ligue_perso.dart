import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

import 'detail_joueur.dart';

class JoueursAchetesLiguePerso extends StatefulWidget{
  @override
  _JoueursAchetesLiguePersoState createState() => _JoueursAchetesLiguePersoState();
}

class _JoueursAchetesLiguePersoState extends State<JoueursAchetesLiguePerso>{

  int _active = 0;
  int _sel = 0;
  var _controller = TextEditingController();
  List<Joueurs> _list = List<Joueurs>();
  List<Joueurs> _listPasAchetes = List<Joueurs>();
  List<Joueurs> _listForDisplay = List<Joueurs>();


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
    _listPasAchetes = listeAdversairePasAchetes();

  }

  List<Joueurs> listeAdversaire() {
    Map<String, dynamic> map = json.decode(globals.dataFrameLiguePerso)['ligue_personnalise'];
    var dataframeJoueursAchetes = json.decode(globals.dataFrameLiguePerso)['ligue_personnalise'];
    List<Joueurs> joueursAchetes = [];
    int i = 0;
    final keys = map.keys;
    for (var u in keys){
      String prixMax ='';
      String prixMoyen ='';
      String prixMin ='';
      String nombreDeSelection ='';
      if (dataframeJoueursAchetes[u].containsKey("prix_max")){
        prixMax = dataframeJoueursAchetes[u]["prix_max"];
      }
      if (dataframeJoueursAchetes[u].containsKey("prix_moyen")){
        prixMoyen = dataframeJoueursAchetes[u]["prix_moyen"];
      }
      if (dataframeJoueursAchetes[u].containsKey("prix_min")){
        prixMin = dataframeJoueursAchetes[u]["prix_min"];
      }
      if (dataframeJoueursAchetes[u].containsKey("nombre_de_selection")){
        nombreDeSelection = dataframeJoueursAchetes[u]["nombre_de_selection"];
      }

      Joueurs joueur = Joueurs(i, dataframeJoueursAchetes[u]["name"], dataframeJoueursAchetes[u]["club"],
          prixMoyen, nombreDeSelection,
          prixMax, prixMin);

      if (prixMax.length > 0){
        joueursAchetes.add(joueur);
        i = i+1;
      }

    }
    return joueursAchetes;
  }

  List<Joueurs> listeAdversairePasAchetes() {
    Map<String, dynamic> map = json.decode(globals.dataFrameLiguePerso)['ligue_personnalise'];
    var dataframeJoueursPasAchetes = json.decode(globals.dataFrameLiguePerso)['ligue_personnalise'];
    List<Joueurs> joueursPasAchetes = [];
    int i = 0;
    final keys = map.keys;
    for (var u in keys){
      String prix ='';

      if (dataframeJoueursPasAchetes[u].containsKey("price_paid") && dataframeJoueursPasAchetes[u]["price_paid"] != null){
        prix = dataframeJoueursPasAchetes[u]["price_paid"];
      }
      Joueurs joueurPasAchete = Joueurs(i, dataframeJoueursPasAchetes[u]["name"], dataframeJoueursPasAchetes[u]["club"],
          '0', '0',
          prix, '0');
      if (prix.length > 0){
        joueursPasAchetes.add(joueurPasAchete);
        i = i+1;
      }
    }
    return joueursPasAchetes;
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
              "Classement des joueurs",
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
                      DropdownButton(
                        value: _active,
                        underline: Container(),
                        onChanged: (i) {
                          setState(() {
                            _active = i;
                          });
                          if (_active == 1){
                            setState(() {
                              _listForDisplay = _listPasAchetes;
                            });
                            _controller.clear();
                          }else{
                            setState(() {
                              _listForDisplay = _list;
                            });
                            _controller.clear();
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text("Joueurs achetés"),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Text("Joueurs libres"),
                            value: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(

                     child: ListView.builder(
                    itemCount: _listForDisplay.length+1,
                    itemBuilder:(context, index){
                    return index == 0 ? _searchBar() : _getListItemTile(index-1);
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
  }


// Faire une recherche
  _searchBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: "Search..."
            ),
            onChanged: (text) {
              text = text.toLowerCase();
              int i = 0;
              // Si joueur libre, search bar sur les pas achetés
              if (_active == 1) {
                setState(() {
                  _listForDisplay = _listPasAchetes.where((Joueurs) {
                    var joueurName = Joueurs.name.toLowerCase();
                    return joueurName.contains(text);
                  }).toList();
                });
              } else {
                setState(() {
                  _listForDisplay = _list.where((Joueurs) {
                    var joueurName = Joueurs.name.toLowerCase();
                    return joueurName.contains(text);
                  }).toList();
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
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
                            "Max",
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
                            "Name",
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
                            "Moy",
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
                            "Min",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        )),
                    new Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            _triColonne(_sel);
                          },
                          child: Stack(
                              children: <Widget>[
                                Center(child: Text(
                                  "Sel",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                )),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.unfold_more,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                )


                              ]),
                        )),
                  ]
              )
          ),
        ),
      ],
    );
  }

  _triColonne(int Col){
    setState(() {
      if (Col == 2){
        _listForDisplay.sort((a, b) => int.parse(b.prix_max).compareTo(int.parse(a.prix_max)));
        _sel = 0;
      }
      if (Col == 1){
        _listForDisplay.sort((a, b) => int.parse(a.nombre_de_selection).compareTo(int.parse(b.nombre_de_selection)));
        _sel = 2;
      }
      if (Col == 0){
        _listForDisplay.sort((a, b) => int.parse(b.nombre_de_selection).compareTo(int.parse(a.nombre_de_selection)));
        _sel = 1;
      }

print(Col);
    });
  }


  // Organisation de la liste
  _getListItemTile(index) {
    return GestureDetector(
      onTap: () {
        if (_active == 0) {
          //Permet d'obtenir l'index de la liste(et non celle qui apparaît) qui deviendra selectionné
          List<Joueurs> findIndex = _list.where((joueur) {
            var adversaireId = joueur.name;
            return adversaireId.contains(_listForDisplay[index].name);
          }).toList();
          globals.detailJoueur = findIndex[0].name;
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => DetailsJoueurLiguePerso()
          ));
        }
      },
      child: Card(
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
                        _listForDisplay[index].prix_max,
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
                          _listForDisplay[index].club,
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
                        _listForDisplay[index].prix_moyen,
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
                        _listForDisplay[index].prix_min,
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
                        _listForDisplay[index].nombre_de_selection,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

class Joueurs{
  final int index;
  final String prix_max;
  final String prix_moyen;
  final String prix_min;
  final String name;
  final String club;
  final String nombre_de_selection;
  Joueurs(this.index, this.name, this.club, this.prix_moyen, this.nombre_de_selection, this.prix_max, this.prix_min);
}

