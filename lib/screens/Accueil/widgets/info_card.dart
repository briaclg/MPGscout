
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mpgscout/utilities/constants.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String effectedNum;
  final String ImageD;
  final Function press;
  const InfoCard({
    Key key,
    this.title,
    this.effectedNum,
    this.press,
    this.ImageD,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          children: <Widget>[
            Container(
            width: constraints.maxWidth / 2 - 10,
            height: 60,

            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: new Offset(0.0, 8.0),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 20,
                        width: 20,

                        child: SvgPicture.asset(
                          ImageD,
                          height: 15,
                          width: 15,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        title,
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: kTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: effectedNum,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]);
      },
    );
  }
}