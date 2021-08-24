import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:weather_app/WeatherDetails.dart';
import 'package:weather_app/WeatherInfo.dart';
import 'package:weather_app/WeatherInfoCard.dart';
import 'package:weather_app/constant.dart';
import 'package:weather_app/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<WeatherInfo> weatherInformation;
  var now = new DateTime.now();
  var formatter = new DateFormat('MMMM dd');
  PermissionStatus result;
  String get formattedDate => formatter.format(now);
  @override
  void initState() {
    super.initState();
    getLocation();
    weatherInformation = fetchWeather("forecast.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<WeatherInfo>(
          future: weatherInformation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/clear2.jpg",
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      Container(
                        color: Color.fromRGBO(255, 255, 255, 0.03),
                      ),
                      Positioned(
                        top: 43,
                        left: 10,
                        child: Image.network(
                          "https://img.icons8.com/ios-glyphs/30/ffffff/menu--v1.png",
                          filterQuality: FilterQuality.high,
                          scale: 1.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: 40,
                          right: 10,
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.network(
                                "https://img.icons8.com/pastel-glyph/64/ffffff/search--v1.png",
                                filterQuality: FilterQuality.high,
                                scale: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 80),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "${snapshot.data.locationTitle}",
                              style: kTitleTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "Today, $formattedDate",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Container(
                                width: 330,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 40),
                                      child: Image.asset(
                                        "assets${snapshot.data.weatherImage}",
                                        scale: 0.8,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: Text(
                                        "${snapshot.data.temp_c.toInt()}",
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "°c",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 35),
                                      child: Column(
                                        children: [
                                          Text(
                                            "⋀ ${snapshot.data.maxTemp_c.toInt()}°   ⋁ ${snapshot.data.minTemp_c.toInt()}°",
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Feels like: ${snapshot.data.feelLike_c.toInt()}°",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "${snapshot.data.weatherCondition}",
                              style: kTitleTextStyle.copyWith(fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            FractionallySizedBox(
                              widthFactor: 0.90,
                              child: Container(
                                width: (double.infinity),
                                padding: EdgeInsets.only(
                                    left: 20, top: 20, right: 20, bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xAA1C3343),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     offset: Offset(0, 35),
                                  //     blurRadius: 30,
                                  //     color: kShadowColor,
                                  //   ),
                                  // ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        WeatherDetails(
                                          iconImage: "assets/icons/wind.png",
                                          iconTitle: "Wind",
                                          iconText:
                                              "${snapshot.data.windDirection} ${snapshot.data.windSpeed.toInt()} km/h",
                                        ),
                                        WeatherDetails(
                                          iconImage:
                                              "assets/icons/humidity.png",
                                          iconTitle: "Humidity",
                                          iconText:
                                              "${snapshot.data.humidity}%",
                                        ),
                                        WeatherDetails(
                                          iconImage: "assets/icons/vision.png",
                                          iconTitle: "Visibility",
                                          iconText:
                                              "${snapshot.data.visibility.toInt()} km/h",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        WeatherDetails(
                                          iconImage: "assets/icons/sunrise.png",
                                          iconTitle: "Sunrise",
                                          iconText: "${snapshot.data.sunrise}",
                                        ),
                                        WeatherDetails(
                                          iconImage: "assets/icons/sunset.png",
                                          iconTitle: "Sunset",
                                          iconText: "${snapshot.data.sunset}",
                                        ),
                                        WeatherDetails(
                                          iconImage:
                                              "assets/icons/moon_phase.png",
                                          iconTitle: "Moon Phase",
                                          iconText:
                                              "${snapshot.data.moonPhase}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 60),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                color: Color(0xFF1C3343),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Overview",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFFBFC6CE),
                                        ),
                                      ),
                                      Text(
                                        "See More",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF98C8EC),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        top: 10,
                                        right: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0x30D9D9D9),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          WeatherInfoCard(
                                            stateText: "Morning",
                                            image:
                                                "assets${snapshot.data.overviewList["morning"]["weatherImage"]}",
                                            temp:
                                                "${snapshot.data.overviewList["morning"]["temp_c"].toInt()}°",
                                            feels:
                                                "Feels ${snapshot.data.overviewList["morning"]["feels_c"].toInt()}°",
                                          ),
                                          WeatherInfoCard(
                                            stateText: "Afternoon",
                                            image:
                                                "assets${snapshot.data.overviewList["afternoon"]["weatherImage"]}",
                                            temp:
                                                "${snapshot.data.overviewList["afternoon"]["temp_c"].toInt()}°",
                                            feels:
                                                "Feels ${snapshot.data.overviewList["afternoon"]["feels_c"].toInt()}°",
                                          ),
                                          WeatherInfoCard(
                                            stateText: "Evening",
                                            image:
                                                "assets${snapshot.data.overviewList["evening"]["weatherImage"]}",
                                            temp:
                                                "${snapshot.data.overviewList["evening"]["temp_c"].toInt()}°",
                                            feels:
                                                "Feels ${snapshot.data.overviewList["evening"]["feels_c"].toInt()}°",
                                          ),
                                          WeatherInfoCard(
                                            stateText: "Overnight",
                                            image:
                                                "assets${snapshot.data.overviewList["overnight"]["weatherImage"]}",
                                            temp:
                                                "${snapshot.data.overviewList["overnight"]["temp_c"].toInt()}°",
                                            feels:
                                                "Feels ${snapshot.data.overviewList["overnight"]["feels_c"].toInt()}°",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Hourly",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFFBFC6CE),
                                        ),
                                      ),
                                      Text(
                                        "See More",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF98C8EC),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0x30D9D9D9),
                                    ),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: snapshot.data.hourlyList.entries
                                          .map<Widget>((list) {
                                        return Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                WeatherInfoCard(
                                                  stateText:
                                                      list.key.toString(),
                                                  image:
                                                      "assets${list.value["weatherImage"].toString()}",
                                                  temp:
                                                      "${list.value["temp_c"].toInt()}°",
                                                  feels:
                                                      "Feels ${list.value["feels_c"].toInt()}°",
                                                ),
                                              ],
                                            ),
                                            // Text(list.value["weatherImage"]
                                            //     .toString()),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
