import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

import 'detail_ligue.dart';

class AccueilUneLigue extends StatefulWidget{
  @override
  _AccueilUneLigueState createState() => _AccueilUneLigueState();
}

class _AccueilUneLigueState extends State<AccueilUneLigue>{
  List<Ligue> _listForDisplay = List<Ligue>();


  @override
  void initState() {
    super.initState();
    listeLigue();

  }


  listeLigue() {
    List<dynamic> map = json.decode(globals.dataFrameLiguePerso)['list_of_ligue'];

    List<Ligue> _listLigue = [];
    for (var i=0; i< map.length; i++) {
      Map<String, dynamic> ligues  = map[i];
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
    print(_listLigue);
    setState(() {
      _listForDisplay = _listLigue;
    });
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
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Infos par Ligue",
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
                      itemCount: _listForDisplay.length,
                      itemBuilder:(context, index){
                        return _getListItemTile(index);
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

  // Organisation de la liste
  _getListItemTile(index) {
    return GestureDetector(
        onTap: () {
          List<Ligue> findIndex = _listForDisplay.where((ligue) {
            var ligueId = ligue.nomLigue;
            return ligueId.contains(_listForDisplay[index].nomLigue);
          }).toList();
          globals.detailLigue = findIndex[0].nomLigue;
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => DetailsLigueLiguePerso()
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
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(_listForDisplay[index].nomLigue,style: headerTextStyle,
          ),
          new Container(height: 10.0),
          new Text(_listForDisplay[index].nombreJoueur.toString() + (_listForDisplay[index].nombreJoueur.toString() == "1" ? " joueur en commun":
          " joueurs en  commun"),
              style: subHeadTextStyle
          ),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)
          ),
          new Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              new Icon(Icons.date_range,
              size: 14,),
              new Container(width: 8.0),
              new Text(_listForDisplay[index].dateLigue,
                style: regularTextStyle,
              ),
              new Container(width: 24.0),
            ],
          ),
          SizedBox(height: 2,),
          _listForDisplay[index].premier != "" ? new Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                new Icon(Icons.stars, size: 14,),
                new Container(width: 8.0),
                new Text(_listForDisplay[index].premier,
                  style: regularTextStyle,
                )]): new Container(),
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

class Ligue{
  final String nomLigue;
  final int nombreJoueur;
  final String dateLigue;
  final String premier;

  Ligue(this.nomLigue, this.nombreJoueur, this.dateLigue, this.premier);
}