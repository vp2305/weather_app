import "package:flutter/material.dart";

class WeatherDetails extends StatelessWidget {
  final String iconImage;
  final String iconTitle;
  final String iconText;
  const WeatherDetails({
    Key key,
    this.iconImage,
    this.iconTitle,
    this.iconText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 35,
          width: 80,
          child: Image.asset(
            iconImage,
            scale: 1.8,
          ),
        ),
        SizedBox(height: 5),
        Text(
          iconTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Container(
          width: 85,
          child: Text(
            iconText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
