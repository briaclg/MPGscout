
import 'package:flutter/material.dart';

import 'constants.dart';

class Counter extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  final String club;
  final double size;
  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
    this.club,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top:6, left: 6, right: 6, bottom: 2),
          child: Container(
            child: Text(
              "$title",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        Text(club, style: TextStyle(
          fontSize: 8,
        )),
        SizedBox(height: 10),
        Text(
          "$number",
          style: TextStyle(
            fontSize: size,
            color: color,
          ),
        ),

      ],
    );
  }
}
