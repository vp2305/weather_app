import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import "package:weather_app/constant.dart";
import "package:intl/intl.dart";

// https://flutter.dev/docs/cookbook/networking/fetch-data
// https://rapidapi.com/contextualwebsearch/api/web-search/

//https://stackoverflow.com/questions/58399539/get-json-data-from-rapid-api-in-flutter-dart
//https://www.weatherapi.com/docs/#weather-icons
//https://www.weatherapi.com/docs/weather_conditions.json
//https://weatherapi-com.p.rapidapi.com/forecast.json?rapidapi-key=1590330967msh62afc187728aecfp13b12ajsnf89c270e216f&q=%22Ajax%22
//https://rapidapi.com/weatherapi/api/weatherapi-com/

// Design
//https://dribbble.com/tags/weather_app
//https://www.google.com/search?q=weather+ui+design&client=firefox-b-d&sxsrf=ALeKk00IMPIPrRDx1LcyI3uXcIXRTS4POg:1629323554591&source=lnms&tbm=isch&sa=X&ved=2ahUKEwj338edx7vyAhVtkuAKHazBAREQ_AUoAXoECAEQAw&biw=1920&bih=994#imgrc=-1EXAkHWesfWQM

// Figma https://www.figma.com/file/Yly541dADDE1Gxqzg3wmma/Untitled?node-id=0%3A1

Future<WeatherInfo> fetchWeather(endpoint) async {
  final url =
      'https://weatherapi-com.p.rapidapi.com/$endpoint?rapidapi-key=1590330967msh62afc187728aecfp13b12ajsnf89c270e216f&q=Ajax';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return WeatherInfo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch weather information!');
  }
}

class WeatherInfo {
  final String locationTitle;
  final String weatherCondition;
  final String weatherImage;
  final double maxTemp_c;
  final double maxTemp_f;
  final double minTemp_c;
  final double minTemp_f;
  final double feelLike_c;
  final double feelLike_f;
  final double temp_c;
  final double temp_f;
  final double windSpeed;
  final int windDeg;
  final String windDirection;
  final int humidity;
  final double visibility;
  final String sunrise;
  final String sunset;
  final String moonPhase;
  // final int cloud;
  // final double uv;
  // final String backgroundImage;

  WeatherInfo({
    this.locationTitle,
    this.weatherCondition,
    this.humidity,
    this.feelLike_c,
    this.feelLike_f,
    this.temp_c,
    this.temp_f,
    this.windSpeed,
    this.windDeg,
    this.visibility,
    this.weatherImage,
    this.windDirection,
    // this.cloud,
    // this.uv,
    // this.backgroundImage,
    this.maxTemp_c,
    this.maxTemp_f,
    this.minTemp_c,
    this.minTemp_f,
    this.sunrise,
    this.sunset,
    this.moonPhase,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    // log(json["location"]["name"].toString());
    String weatherImg = json["current"]["condition"]["icon"];
    String finalWeatherImage =
        weatherImg.replaceAll("//cdn.weatherapi.com", "");

    return WeatherInfo(
      locationTitle: json["location"]["name"],
      weatherCondition: json["current"]["condition"]["text"],
      weatherImage: finalWeatherImage,
      humidity: json["current"]["humidity"],
      feelLike_c: json["current"]["feelslike_c"],
      feelLike_f: json["current"]["feelslike_f"],
      temp_c: json["current"]["temp_c"],
      temp_f: json["current"]["temp_f"],
      windSpeed: json["current"]["wind_kph"],
      windDeg: json["current"]["wind_degree"],
      windDirection: json["current"]["wind_dir"],
      // cloud: json["current"]["cloud"],
      // uv: json["current"]["uv"],
      visibility: json["current"]["vis_km"],
      maxTemp_c: json["forecast"]["forecastday"][0]["day"]["maxtemp_c"],
      maxTemp_f: json["forecast"]["forecastday"][0]["day"]["maxtemp_f"],
      minTemp_c: json["forecast"]["forecastday"][0]["day"]["mintemp_c"],
      minTemp_f: json["forecast"]["forecastday"][0]["day"]["mintemp_f"],
      sunrise: json["forecast"]["forecastday"][0]["astro"]["sunrise"],
      sunset: json["forecast"]["forecastday"][0]["astro"]["sunset"],
      moonPhase: json["forecast"]["forecastday"][0]["astro"]["moon_phase"],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Poppins",
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<WeatherInfo> weatherInformation;

  var now = new DateTime.now();
  var formatter = new DateFormat('MMMM dd');
  String get formattedDate => formatter.format(now);

  @override
  void initState() {
    super.initState();
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: 320,
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
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 20),
                              width: 320,
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
                                        iconImage: "assets/icons/humidity.png",
                                        iconTitle: "Humidity",
                                        iconText: "${snapshot.data.humidity}%",
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
                                        iconText: "${snapshot.data.moonPhase}",
                                      ),
                                    ],
                                  ),
                                ],
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
                                    children: [
                                      WeatherDetails(
                                        iconImage: "assets/icons/wind.png",
                                        iconTitle: "Wind",
                                        iconText:
                                            "${snapshot.data.windDirection} ${snapshot.data.windSpeed.toInt()} km/h",
                                      ),
                                      WeatherDetails(
                                        iconImage: "assets/icons/humidity.png",
                                        iconTitle: "Humidity",
                                        iconText: "${snapshot.data.humidity}%",
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
                                        iconText: "${snapshot.data.moonPhase}",
                                      ),
                                    ],
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
          width: 82,
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
          ),
        ),
        SizedBox(height: 2),
        Text(
          iconText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
