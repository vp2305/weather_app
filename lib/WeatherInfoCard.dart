import "package:flutter/material.dart";

class WeatherInfoCard extends StatelessWidget {
  final String stateText;
  final String image;
  final String temp;
  final String feels;
  final String chanceImage;
  final String chancePercentage;
  const WeatherInfoCard({
    Key key,
    this.stateText,
    this.image,
    this.temp,
    this.feels,
    this.chanceImage,
    this.chancePercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: <Widget>[
          Text(
            stateText,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 5),
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            feels,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFFD3D5D7),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                child: Image.asset(
                  chanceImage,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                chancePercentage,
                style: TextStyle(
                  color: Color(0xFFD3D5D7),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
