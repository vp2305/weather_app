import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:weather_app/constant.dart";

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
  final int humidity;
  final double feelLike_c;
  final double feelLike_f;
  final double temp_c;
  final double temp_f;
  final double windSpeed;
  final int windDeg;
  final String windDirection;
  final double visibility;
  final String weatherImage;
  final int cloud;
  final double uv;
  final String backgroundImage;

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
    this.cloud,
    this.uv,
    this.backgroundImage,
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
      cloud: json["current"]["cloud"],
      uv: json["current"]["uv"],
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
          body1: TextStyle(color: Colors.black),
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
                      color: Color.fromRGBO(255, 255, 255, 0.13),
                    ),
                    Center(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 80),
                        child: Column(
                          children: <Widget>[
                            Text("${snapshot.data.weatherCondition}",
                                style: kTitleTextStyle.copyWith(
                                    color: Colors.white)),
                            Text(
                              "${snapshot.data.temp_c.toInt()}°",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
