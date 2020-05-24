import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mpgscout/screens/liguePerso/infosMercato/resultat_mercato.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;

class SelectMercato extends StatefulWidget{
  @override
  _SelectMercatoState createState() => _SelectMercatoState();
}

class _SelectMercatoState extends State<SelectMercato>{

  RangeValues valuesMoyenne = RangeValues(0, 10);
  RangeLabels labelsMoyenne = RangeLabels('1', '10');
  RangeValues valuesTitu = RangeValues(0, 100);
  RangeLabels labelsTitu = RangeLabels('0', '100');
  RangeValues valuesPrix = RangeValues(0, 60);
  RangeLabels labelsPrix = RangeLabels('0', '60');
  String moyenne_minimum = '0.0';
  String moyenne_maximum = '10.0';
  String titu_minimum = '0';
  String titu_maximum = '100';
  int but = 0;
  String prix_minimum = '0';
  String prix_maximum = '60';
  String valuePoste = 'Tous';
  int indexPoste = 0 ;


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
                  Text("Affine ton Mercato", style: kHeadingextStyle),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/logo/person.svg"),
                      SizedBox(width: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Trouve des joueurs selon tes critères",
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
                              text: "Trouve les meilleurs ratio prix/but",
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
                              text: "Obtiens des stats détaillées",
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
                            width: MediaQuery.of(context)
                                .size.width ,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 40),
                                  Center(
                                      child: Text(
                                        'Poste',
                                      )
                                  ),
                                  SizedBox(height: 10),
                                  choixPoste(),
                                  SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      'Note moyenne',
                                    )
                                  ),
                                  rowSliderMoyenne(0,10),
                                  Center(
                                      child: Text(
                                        'Titularisation moyenne',
                                      )
                                  ),
                                  rowSliderTitu(0, 100),
                                  Center(
                                      child: Text(
                                        'Minimum de buts',
                                      )
                                  ),
                                  rowSliderBut(),
                                  Center(
                                      child: Text(
                                        'Prix',
                                      )
                                  ),
                                  rowSliderPrix(0,60)
                                ]
                            ),
                          )),
                      Positioned(
                        child: FloatingActionButton.extended(

                            icon: Icon(
                              Icons.arrow_forward_ios,
                            ),
                            label: Text((() {
                              return "Lancez la recherche";
                            })()),
                            onPressed: () {
                              Map<String, dynamic> payload = {
                                'email': globals.email,
                                'password': globals.password,
                                'position': indexPoste,
                                'moyenne_min':double.parse(moyenne_minimum),
                                'moyenne_max':double.parse(moyenne_maximum),
                                'titu_min':double.parse(titu_minimum)/100,
                                'titu_max':double.parse(titu_maximum)/100,
                                'but':but,
                                'quotation_min':double.parse(prix_minimum),
                                'quotation_max':double.parse(prix_maximum),
                                'trier_par':'quotation'
                              };
                              globals.mercato = jsonEncode(payload);
                              Navigator.push(context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          ResultatMercato()
                                  ));
                            }
                        ),
                        top: -20,
                        right: 30,
                      )
                    ])

            ),
          ],
        ),
      ),
    );
  }

  int findIndex(String position){
    if (position == 'Tous'){
      return 0;
    }
    if (position == 'Gardien'){
      return 1;
    }
    if (position == 'Defenseur'){
      return 2;
    }
    if (position == 'Milieu'){
      return 3;
    }
    if (position == 'Attaquant'){
      return 4;
    }
  }
  choixPoste(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Color(0xFFE5E5E5),
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20),
          Expanded(
            child: DropdownButton(
              isExpanded: true,
              underline: SizedBox(),
              icon: SvgPicture.asset("assets/logo/dropdown.svg"),
              value: valuePoste,
              items: [
                'Tous',
                'Gardien',
                'Defenseur',
                'Milieu',
                'Attaquant',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  valuePoste = value;
                  indexPoste = findIndex(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

rowSliderMoyenne(double min, double max){
    return Row(
        mainAxisAlignment: MainAxisAlignment
            .center,
        children: <Widget>[
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .09,
                  child: Text(moyenne_minimum))
              ]),
          Container(
              width: MediaQuery.of(context).size.width * .7,
              child: RangeSlider(
                min: min,
                max: max,
                values: valuesMoyenne,
                labels: labelsMoyenne,
                onChanged: (value) {
                  setState(() {
                    valuesMoyenne = value;
                    moyenne_minimum = value.start.toStringAsFixed(2);
                    moyenne_maximum = value.end.toStringAsFixed(2);
                    labelsMoyenne =
                        RangeLabels(value.start.toString(), value.end.toString());
                  });
                },
              )),
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .1,
                  child: Text(moyenne_maximum))
              ]),
        ]
    );
}

  rowSliderTitu(double min, double max){
    return Row(
        mainAxisAlignment: MainAxisAlignment
            .center,
        children: <Widget>[
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .09,
                  child: Text(titu_minimum + ' %'))
              ]),
          Container(
              width: MediaQuery.of(context).size.width * .7,
              child: RangeSlider(
                min: min,
                max: max,
                values: valuesTitu,
                labels: labelsTitu,
                onChanged: (value) {
                  setState(() {
                    valuesTitu = value;
                    titu_minimum = value.start.toStringAsFixed(0);
                    titu_maximum = value.end.toStringAsFixed(0);
                    labelsTitu =
                        RangeLabels(value.start.toString(), value.end.toString());
                  });
                },
              )),
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .1,
                  child: Text(titu_maximum + ' %'))
              ]),
        ]
    );
  }

  rowSliderBut(){
    return Row(
        mainAxisAlignment: MainAxisAlignment
            .center,
        children: <Widget>[
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .09,
                  child: Text(but.toString()))
              ]),
          Container(
              width: MediaQuery.of(context).size.width * .7,
              child: Slider(
                min: 0,
                max: 30,
                value: but.toDouble(),
                onChanged: (double newValue) {
                  setState(() {
                    but = newValue.round();
                  });
                },
              )),
          Wrap(
              direction: Axis.vertical,
              children:
              [
                Container(
                  width: MediaQuery.of(context).size.width * .1,
                  child: Text(''))
              ])
        ]
    );
  }

  rowSliderPrix(double min, double max){
    return Row(
        mainAxisAlignment: MainAxisAlignment
            .center,
        children: <Widget>[
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .09,
                  child: Text(prix_minimum))
              ]),
          Container(
              width: MediaQuery.of(context).size.width * .7,
              child: RangeSlider(
                min: min,
                max: max,
                values: valuesPrix,
                labels: labelsPrix,
                onChanged: (value) {
                  setState(() {
                    valuesPrix = value;
                    prix_minimum = value.start.toStringAsFixed(0);
                    prix_maximum = value.end.toStringAsFixed(0);
                    labelsTitu =
                        RangeLabels(value.start.toString(), value.end.toString());
                  });
                },
              )),
          Wrap(
              direction: Axis.vertical,
              children:
              [Container(
                  width: MediaQuery.of(context).size.width * .1,
                  child: Text(prix_maximum))
              ]),
        ]
    );
  }
}