import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpgscout/screens/accueil.dart';
import 'package:mpgscout/screens/liguePerso/infosLigue/accueil_une_ligue.dart';
import 'package:mpgscout/screens/liguePerso/joueurs_achetes_ligue_perso.dart';
import 'package:mpgscout/screens/liguePerso/select_ligue_perso.dart';
import 'package:mpgscout/screens/login_screen.dart';



class GridDashBoardLiguePerso extends StatelessWidget{
  //Ligue Perso
  //Mercato
  // Adversaire
  Item item1 = new Item(
      title: "Joueurs achetés",
      subtitle: "Classment des joueurs achetés",
      route: JoueursAchetesLiguePerso(),
  );

  Item item2 = new Item(
      title: "Infos sur une ligue",
      subtitle: "Infos détaillés de chaque ligue",
      route: AccueilUneLigue(),
  );

  Item item3 = new Item(
      title: "Infos Générales",
      subtitle: "Infos détaillées globales",
      route: LoginScreen(),
  );




  @override
  Widget build(BuildContext context) {
    List<Item> myList = [item1, item2, item3];
    var color = 0xFF1976D2;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => data.route
                  ));
                },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(color), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Color(0x8AFFFFFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ),
            );
          }).toList()),
    );
  }
}

class Item{
  String title;
  String subtitle;
  final route;
  Item({this.title, this.subtitle, this.route});
}