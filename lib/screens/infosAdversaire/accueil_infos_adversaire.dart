import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

import 'detail_adversaire.dart';

class AccueilInfosAdversaire extends StatefulWidget{
  @override
  _AccueilInfosAdversaireState createState() => _AccueilInfosAdversaireState();
}

class _AccueilInfosAdversaireState extends State<AccueilInfosAdversaire>{
  List<Adversaire> _list = List<Adversaire>();
  List<Adversaire> _listForDisplay = List<Adversaire>();



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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Infos par Adversaire",
              style: Theme
                  .of(context)
                  .textTheme
                  .display1
                  .apply(
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
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return index == 0 ? _searchBar() : _getListItemTile(
                            index - 1);
                      },

                      itemCount: _listForDisplay.length + 1,

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
  // Organisation de la liste
  _getListItemTile(index) {
    return GestureDetector(
        onTap: () {
          List<Adversaire> findIndex = _listForDisplay.where((adversaire) {
            var adversaireId = adversaire.id;
            return adversaireId.contains(_listForDisplay[index].id);
          }).toList();
          print(findIndex[0].name);
          globals.detailAdversaire = findIndex[0].id;
          globals.nameAdversaire = findIndex[0].name;
          globals.dataframeAdversaire = '';
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => DetailsAdversaire()
          ));
        },

        child: Container(
            height: 150.0,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: new Stack(
                children: <Widget>[
                  Container(
                      height: 145.0,
                      margin: new EdgeInsets.only(left: 46.0),
                      decoration: new BoxDecoration(
                        color: Colors.lightBlue,
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
                      child: planetCardContent(index)
                  ),
                  Container(
                    margin: new EdgeInsets.symmetric(
                        vertical: 16.0
                    ),
                    alignment: FractionalOffset.centerLeft,
                    child: new Image(
                      image: new AssetImage("assets/logo/mpg.png"),
                      height: 92.0,
                      width: 92.0,
                    ),
                  ),


                ]))
    );
  }

  planetCardContent(index) {
    return Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 1.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(_listForDisplay[index].name,style: headerTextStyle,
          ),
          new Container(height: 10.0),
          new Container(
            child: Text(_listForDisplay[index].ligue.length > 35 ?  ligueLong(_listForDisplay[index].ligue):
            _listForDisplay[index].ligue,
                style: subHeadTextStyle
            ),
          ),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)
          ),
          SizedBox(height: 2,),

        ],
      ),
    );
  }


String ligueLong(String ligues){
  var listLigue = [] ;
  String ligueFinal = '';
  listLigue= ligues.split(",");
  for (var i = 0; i < listLigue.length; i++) {
    ligueFinal = ligueFinal + listLigue[i] + ', ';
    if (ligueFinal.length > 50){
      break;
    }
  }
  return (ligueFinal + '...');
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
      fontSize: 17.0,
      fontWeight: FontWeight.w600
  );

  TextStyle subHeadTextStyle =  regularTextStyle.copyWith(
      fontSize: 9.0
  );

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