import 'package:flutter/material.dart';
import 'package:mpgscout/screens/infosAdversaire/detail_adversaire.dart';



class ListeJoueurCher extends StatelessWidget{
  List<JoueurCher> listForDisplay = List<JoueurCher>();


  ListeJoueurCher({Key key, @required this.listForDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Wrap(
        children: <Widget>[
          Text(
            "Classement des achats les plus chers",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Seuls les joueurs achetés au premier tour",
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
          color: listForDisplay[index].joueur_obtenu > 0 ? Colors.green.withOpacity(0.4): Color(0xffFD2E2E).withOpacity(0.4),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                      flex:1,
                      child: Container(
                        alignment: Alignment.center,
                        child : Text(
                          listForDisplay[index].price_paid.toString(),
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
                          listForDisplay[index].name,
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      )),

                  new Expanded( flex:1,
                    child :Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              listForDisplay[index].leagueName,
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              listForDisplay[index].buying_date,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade600
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),

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
                          "Ligue",
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

