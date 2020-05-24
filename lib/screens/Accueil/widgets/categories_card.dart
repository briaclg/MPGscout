import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Color primaryColor = Color(0xff0074ff);

class AccountCard extends StatelessWidget {
  final String name;
  final String id;
  final String ImageD;
  final route;

  const AccountCard(
      {Key key, this.name, this.id, this.ImageD, this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.12,
      padding: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color:  primaryColor.withOpacity(0.5),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: new Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage(ImageD),
                    fit: BoxFit.fill,
                  )
              ),
            ),
          Container(
            width: MediaQuery.of(context).size.width*0.6,
              padding: const EdgeInsets.only(top:5.0, left: 7),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                    Text(
                      name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 2),
                    Text(
                      id,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ])),
            Row(

              children: <Widget>[

                new IconButton(
                  icon: new Icon(Icons.arrow_forward_ios,color: Colors.black45,),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => route
                  ));},
                )

              ],
            ),
          ],
        ),
    ),
    );
  }
}