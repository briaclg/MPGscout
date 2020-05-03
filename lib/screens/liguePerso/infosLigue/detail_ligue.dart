import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;
import 'package:syncfusion_flutter_charts/charts.dart';

import 'detail_ligue.dart';

class DetailsLigueLiguePerso extends StatefulWidget{
  @override
  _DetailsLigueLiguePersoState createState() => _DetailsLigueLiguePersoState();
}

class _DetailsLigueLiguePersoState extends State<DetailsLigueLiguePerso>{
List<DropdownMenuItem<String>> _dropdownMenuItem;
List<MoneyPosition> moneyForData = List<MoneyPosition>();
List<Joueur> _listForDisplay = List<Joueur>();
List<dynamic> _mercatoLigue = List();
String _selectedAdversaire = "";

  @override
  void initState() {
    detailLigue();
    super.initState();

  }

  detailLigue() {
    List<dynamic> map = json.decode(globals.dataFrameLiguePerso)['ligue_detail'];
    Map<String, dynamic> ligue;
    String nom = globals.detailLigue;

    // On récupère le mercato ligue de la ligue qui correspond à celle demandée
    for (var i=0; i< map.length; i++) {
      Map<String, dynamic> ligues  = map[i];
      if (ligues["nom_ligue"] == nom){
        ligue = ligues;
        break;
      }}

    //On met le mercato qui nous intéresse dans une variable
    List<dynamic> mercatoLigue = ligue["mercato_ligue"];
    _mercatoLigue = mercatoLigue;



    // On récupère les adversaires possibles
    setState(() {
      _dropdownMenuItem = buildDropDownMenuItem(mercatoLigue);
      _selectedAdversaire = _dropdownMenuItem[0].value;
      _listForDisplay = buildListJoueurs(mercatoLigue);
      moneyForData = moneyPosition(_listForDisplay);
    });



  }

  // Avoir l'argent par poste
  List<MoneyPosition> moneyPosition(List<Joueur> listJoueur){
    List<dynamic> adversaireJoueurs = List();
    List<MoneyPosition> money = List<MoneyPosition>();

    int prix = 0;
    int nombre = 0;
    for (var i = 0; i < listJoueur.length; i++) {
      // Si le joueur suivant est au même poste on additione le prix, sinon on crée un objet poste + prix
      if (listJoueur[i].joueur_obtenu == 1) {
        if (i + 1 < listJoueur.length &&
            listJoueur[i].position == listJoueur[i + 1].position) {
          prix = listJoueur[i].price_paid + prix;
          nombre++;
        } else {
          prix = listJoueur[i].price_paid + prix;
          nombre++;
          MoneyPosition unPoste = MoneyPosition(
              position(listJoueur[i].position), prix, nombre
          );
          prix = 0;
          nombre = 0;
          money.add(unPoste);
        }
      }
    }

    return money;
  }

  List<Joueur> buildListJoueurs(List<dynamic> mercatoLigue){
    List<dynamic> adversaireJoueurs = List();
    List<Joueur> joueur = List();
    String nom = _selectedAdversaire;

    print(nom);
    // On récupère la liste du mercato de l'adversaire sélectionné par l'utilisateur
    for (var i=0; i< mercatoLigue.length; i++) {
      Map<String, dynamic> mercatoAdversaires  = mercatoLigue[i];
      if (mercatoAdversaires["adversaire"] == nom){
        adversaireJoueurs = mercatoAdversaires["joueurs"];
        break;
      }}

    for (int i = 0; i < adversaireJoueurs.length; i++) {
      Map<String, dynamic> mercatoAdversaire = adversaireJoueurs[i];
      String position = "";

      Joueur unJoueur = Joueur(
          mercatoAdversaire["position"],mercatoAdversaire["fullname"],
        mercatoAdversaire["joueur_obtenu"],mercatoAdversaire["club"],
        mercatoAdversaire["price_paid"],mercatoAdversaire["tour_mercato"],
      );
      joueur.add(unJoueur);
    }

    return joueur;

  }

List<DropdownMenuItem<String>> buildDropDownMenuItem(List<dynamic> mercatoLigue){

    List<String> Adversaires = List();
    List<DropdownMenuItem<String>> items= List();
  for (var i=0; i< mercatoLigue.length; i++) {
    Map<String, dynamic> mercato = mercatoLigue[i];
    Adversaires.add(mercato["adversaire"]);
  }

  for (String adversaire in Adversaires){
    items.add(DropdownMenuItem(value: adversaire,
      child: Text(
        adversaire
      )
    ));
  }
  return items;
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Détails sur " + globals.detailLigue,
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
                                  Tab(text: "Historique",),
                                  Tab(text: "Statistiques",)
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
                                                        child: DropdownButton(
                                                          value: _selectedAdversaire,
                                                          items: _dropdownMenuItem,
                                                          onChanged: onChangeDropdownItem,
                                                        ),
                                                    ),
                                                    _headbar(),
                                                    Container(
                                                        child: ListView.separated(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          padding: EdgeInsets.only(top: 15),
                                                          itemCount: _listForDisplay.length,
                                                          separatorBuilder: (BuildContext context, int index) {
                                                            if ((_listForDisplay[index].position != _listForDisplay[index+1].position)) {
                                                              return Container(
                                                                child: _postBar(index+1)
                                                              );
                                                            }
                                                            return Container();
                                                          },
                                                          itemBuilder: (context, index) {
                                                            return getListItemTile(index);
                                                          },
                                                        ))
                                                  ])));
                                    }),
                                new LayoutBuilder(
                                    builder:
                                        (BuildContext context,
                                        BoxConstraints viewportConstraints) {
                                      return SingleChildScrollView(
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  minHeight: viewportConstraints
                                                      .maxHeight),
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: DropdownButton(
                                                        value: _selectedAdversaire,
                                                        items: _dropdownMenuItem,
                                                        onChanged: onChangeDropdownItem,
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 300,
                                                        child: SfCircularChart(
                                                            title: ChartTitle(
                                                              text: "Prix par poste",
                                                              alignment: ChartAlignment.near,
                                                            ),
                                                            legend: Legend(
                                                              isVisible: true,
                                                              overflowMode: LegendItemOverflowMode.wrap,
                                                            ),
                                                            series: <PieSeries>[
                                                              PieSeries<MoneyPosition, String>(
                                                                  dataSource: moneyForData,
                                                                  xValueMapper: (MoneyPosition data, _) => data.position,
                                                                  yValueMapper: (MoneyPosition data, _) => data.argent,
                                                                  dataLabelSettings: DataLabelSettings(
                                                                    isVisible: true,
                                                                  )
                                                              )
                                                            ])),
                                                    Container(
                                                        height: 300,
                                                        child: SfCircularChart(
                                                            title: ChartTitle(
                                                              text: "Nombre par poste",
                                                              alignment: ChartAlignment.near,
                                                            ),
                                                            legend: Legend(
                                                              isVisible: true,
                                                              overflowMode: LegendItemOverflowMode.wrap,
                                                            ),
                                                            series: <PieSeries>[
                                                              PieSeries<MoneyPosition, String>(
                                                                  dataSource: moneyForData,
                                                                  xValueMapper: (MoneyPosition data, _) => data.position,
                                                                  yValueMapper: (MoneyPosition data, _) => data.nombre,
                                                                  dataLabelSettings: DataLabelSettings(
                                                                    isVisible: true,
                                                                  )
                                                              )
                                                            ]))
                                                  ])));
                                    }),
                              ],
                            ),
                          )
                          )
                      ))
                ])
        ));
  }

onChangeDropdownItem(String selectedAdversaire){
    setState(() {
      _selectedAdversaire = selectedAdversaire;
      _listForDisplay = buildListJoueurs(_mercatoLigue);
      moneyForData = moneyPosition(_listForDisplay);
    });
}

getListItemTile(index) {
  return GestureDetector(
    onTap: () {},
    child: Card(
      elevation: 0,
      color: _listForDisplay[index].joueur_obtenu > 0 ? Colors.green.withOpacity(0.4): Color(0xffFD2E2E).withOpacity(0.4),
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
                            _listForDisplay[index].fullname,
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

Widget _postBar(index) {
  return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
      child: Container(
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0),
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
                        position(_listForDisplay[index].position),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    )),
              ]
          )));
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

class MoneyPosition {
  final String position;
  final int argent;
  final int nombre;

  MoneyPosition(this.position, this.argent, this.nombre);
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

