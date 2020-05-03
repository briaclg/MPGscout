import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpgscout/screens/accueil.dart';
import 'package:mpgscout/screens/liguePerso/select_ligue_perso.dart';
import 'package:mpgscout/screens/login_screen.dart';



class GridDashBoard extends StatelessWidget{
  //Ligue Perso
  //Mercato
  // Adversaire
  Item item1 = new Item(
      title: "Ligue Personnalisée",
      subtitle: "Infos par ligue",
      img: "assets/logo/liste_perso.png",
      route: SelectLiguePerso(),
  );

  Item item2 = new Item(
      title: "Adversaires",
      subtitle: "Toutes les stats sur un adversaire",
      img: "assets/logo/espion.png",
      route: LoginScreen(),
  );

  Item item3 = new Item(
      title: "Mercato",
      subtitle: "Affiner sa recherche de joueurs",
      img: "assets/logo/pepite.png",
      route: LoginScreen(),
  );

  Item item4 = new Item(
      title: "Statistiques",
      subtitle: "Stats générales",
      img: "assets/logo/stat.png",
      route: LoginScreen(),
  );




  @override
  Widget build(BuildContext context) {
    List<Item> myList = [item1, item2, item3, item4];
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
                  Image.asset(
                    data.img,
                    width: 42,
                  ),
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
  String img;
  final route;
  Item({this.title, this.subtitle,  this.img, this.route});
}