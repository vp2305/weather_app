import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/HomePage.dart';
import 'package:weather_app/WeatherInfo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:geocoder/geocoder.dart';

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

PermissionStatus _status;
double longitude;
double latitude;
Future<WeatherInfo> fetchWeather(endpoint, locality) async {
  final url =
      "https://weatherapi-com.p.rapidapi.com/$endpoint?rapidapi-key=1590330967msh62afc187728aecfp13b12ajsnf89c270e216f&q=$locality&days=3";
  final response = await http.get(Uri.parse(url));
  print(response.statusCode);
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

Future<WeatherInfo> getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  longitude = position.longitude;
  latitude = position.latitude;

  final coordinates = new Coordinates(latitude, longitude);
  var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var location = addresses.first;
  var locality = location.locality;
  print(_status);
  Future<WeatherInfo> weatherInformation =
      fetchWeather("forecast.json", locality);
  return weatherInformation;
}

String imageStyle(image) {
  String finalImage = image.replaceAll("//cdn.weatherapi.com", "");
  return finalImage;
}

Map<String, dynamic> overviewBuilder(String image, double temp_c, double temp_f,
    double feels_c, double feels_f, String chanceImage, int chancePercentage) {
  var overviewList = new Map<String, dynamic>();
  overviewList['weatherImage'] = image;
  overviewList['temp_c'] = temp_c;
  overviewList['temp_f'] = temp_f;
  overviewList['feels_c'] = feels_c;
  overviewList['feels_f'] = feels_f;
  overviewList['chanceImage'] = chanceImage;
  overviewList['chancePercentage'] = chancePercentage;
  return overviewList;
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
    LocationPermissions()
        .checkPermissionStatus(level: LocationPermissionLevel.locationWhenInUse)
        .then(_updateStatus);
  }

  Future<Null> refreshApp() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      LocationPermissions()
          .checkPermissionStatus(
              level: LocationPermissionLevel.locationWhenInUse)
          .then(_updateStatus);
    });
    return null;
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
          bodyText1: TextStyle(color: Colors.white),
        ),
      ),
      home: RefreshIndicator(
        onRefresh: refreshApp,
        child: HomePage(),
      ),
    );
  }

  void _updateStatus(PermissionStatus status) {
    if (_status != PermissionStatus.granted) {
      LocationPermissions()
          .requestPermissions(
              permissionLevel: LocationPermissionLevel.locationWhenInUse)
          .then((value) => refreshApp());
    }
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }
}
