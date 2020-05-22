import 'package:flutter/material.dart';
import 'package:mpgscout/screens/infosAdversaire/detail_adversaire.dart';

class ListeJoueurPrefere extends StatelessWidget{
  List<Prefere> listForDisplay = List<Prefere>();


  ListeJoueurPrefere({Key key, @required this.listForDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        children: <Widget>[
          Text(
            "Classement des joueurs préférées",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Les joueurs non obtenus sont comptabilisés",
            style: TextStyle(
              fontSize: 11,
            ),
          ),
          SizedBox(height: 30,),
          _headbar(),
          ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 15),
            itemCount: listForDisplay.length,
            itemBuilder: (context, index) {
              return getListItemTile(index);
            },
          )
        ]);
  }

  getListItemTile(index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                    flex:1,
                    child: Container(
                      alignment: Alignment.center,
                      child : Text(
                        listForDisplay[index].name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                new Expanded(
                    flex:1,
                    child: Container(
                      alignment: Alignment.center,
                      child : Text(
                        listForDisplay[index].nombre.toString(),
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    )),
              ]
          )
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
              color: Colors.black12.withOpacity(0.1),

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
                          "Joueur",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                  new Expanded(flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Nombre",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      )),
                ]
            )));
  }

}