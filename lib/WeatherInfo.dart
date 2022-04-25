import 'dart:math';

import 'package:intl/intl.dart';
import 'package:weather_app/main.dart';

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
  final Map<String, dynamic> overviewList;
  final Map<String, dynamic> hourlyList;
  final String chanceWeatherCondition;
  final String chanceImage;
  // final int cloud;
  // final double uv;
  // final String backgroundImage;

  WeatherInfo({
    this.hourlyList,
    this.overviewList,
    this.locationTitle,
    this.weatherCondition,
    this.chanceWeatherCondition,
    this.chanceImage,
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
    String imageChanceMethod(int rain, int snow) {
      if (rain > snow) {
        return "/weather/64x64/chance/rain.png";
      } else if (snow > rain) {
        return "/weather/64x64/chance/snow.png";
      } else {
        return "/weather/64x64/chance/rain.png";
      }
    }

    // log(json["location"]["name"].toString());
    String finalWeatherImage = imageStyle(json["current"]["condition"]["icon"]);
    Map<String, dynamic> overviewList = new Map<String, dynamic>();
    Map<String, dynamic> hourlyList = new Map<String, dynamic>();
    String finalChanceWeather;
    try {
      int rainChance =
          json["forecast"]["forecastday"][0]["day"]["daily_chance_of_rain"];
      int snowChance =
          json["forecast"]["forecastday"][0]["day"]["daily_chance_of_snow"];

      if (rainChance > snowChance) {
        finalChanceWeather = "Chance of Rain: $rainChance%";
      } else if (rainChance < snowChance) {
        finalChanceWeather = "Chance of Snow: $snowChance%";
      } else {
        finalChanceWeather = "No rain/snow today";
      }

      imageChanceMethod(
          json["forecast"]["forecastday"][0]["hour"][7]["chance_of_rain"],
          json["forecast"]["forecastday"][0]["hour"][7]["chance_of_snow"]);

      overviewList["morning"] = new Map.from(overviewBuilder(
        imageStyle(
            json["forecast"]["forecastday"][0]["hour"][7]["condition"]["icon"]),
        json["forecast"]["forecastday"][0]["hour"][7]["temp_c"],
        json["forecast"]["forecastday"][0]["hour"][7]["temp_f"],
        json["forecast"]["forecastday"][0]["hour"][7]["feelslike_c"],
        json["forecast"]["forecastday"][0]["hour"][7]["feelslike_f"],
        imageChanceMethod(
            json["forecast"]["forecastday"][0]["hour"][7]["chance_of_rain"],
            json["forecast"]["forecastday"][0]["hour"][7]["chance_of_snow"]),
        max(json["forecast"]["forecastday"][0]["hour"][7]["chance_of_rain"],
            json["forecast"]["forecastday"][0]["hour"][7]["chance_of_snow"]),
      ));

      overviewList["afternoon"] = new Map.from(overviewBuilder(
        imageStyle(json["forecast"]["forecastday"][0]["hour"][12]["condition"]
            ["icon"]),
        json["forecast"]["forecastday"][0]["hour"][12]["temp_c"],
        json["forecast"]["forecastday"][0]["hour"][12]["temp_f"],
        json["forecast"]["forecastday"][0]["hour"][12]["feelslike_c"],
        json["forecast"]["forecastday"][0]["hour"][12]["feelslike_f"],
        imageChanceMethod(
            json["forecast"]["forecastday"][0]["hour"][12]["chance_of_rain"],
            json["forecast"]["forecastday"][0]["hour"][12]["chance_of_snow"]),
        max(json["forecast"]["forecastday"][0]["hour"][12]["chance_of_rain"],
            json["forecast"]["forecastday"][0]["hour"][12]["chance_of_snow"]),
      ));

      overviewList["evening"] = new Map.from(overviewBuilder(
        imageStyle(json["forecast"]["forecastday"][0]["hour"][17]["condition"]
            ["icon"]),
        json["forecast"]["forecastday"][0]["hour"][17]["temp_c"],
        json["forecast"]["forecastday"][0]["hour"][17]["temp_f"],
        json["forecast"]["forecastday"][0]["hour"][17]["feelslike_c"],
        json["forecast"]["forecastday"][0]["hour"][17]["feelslike_f"],
        imageChanceMethod(
            json["forecast"]["forecastday"][0]["hour"][17]["chance_of_rain"],
            json["forecast"]["forecastday"][0]["hour"][17]["chance_of_snow"]),
        max(json["forecast"]["forecastday"][0]["hour"][17]["chance_of_rain"],
            json["forecast"]["forecastday"][0]["hour"][17]["chance_of_snow"]),
      ));

      overviewList["overnight"] = new Map.from(overviewBuilder(
        imageStyle(
            json["forecast"]["forecastday"][1]["hour"][0]["condition"]["icon"]),
        json["forecast"]["forecastday"][1]["hour"][0]["temp_c"],
        json["forecast"]["forecastday"][1]["hour"][0]["temp_f"],
        json["forecast"]["forecastday"][1]["hour"][0]["feelslike_c"],
        json["forecast"]["forecastday"][1]["hour"][0]["feelslike_f"],
        imageChanceMethod(
            json["forecast"]["forecastday"][1]["hour"][0]["chance_of_rain"],
            json["forecast"]["forecastday"][1]["hour"][0]["chance_of_snow"]),
        max(json["forecast"]["forecastday"][1]["hour"][0]["chance_of_rain"],
            json["forecast"]["forecastday"][1]["hour"][0]["chance_of_snow"]),
      ));

      var now = DateTime.now();
      int currentHour = int.parse(DateFormat('HH').format(now));

      for (var i = currentHour; i <= 23; i++) {
        DateTime indexTempDate;
        if (i <= 9) {
          indexTempDate = DateTime.parse("2012-02-27 0${i.toString()}:00:00");
        } else {
          indexTempDate = DateTime.parse("2012-02-27 ${i.toString()}:00:00");
        }

        String time = DateFormat('j').format(indexTempDate);
        time = time.replaceAll(" ", "");
        // print(hour12);
        hourlyList[time.toLowerCase()] = new Map.from(overviewBuilder(
          imageStyle(json["forecast"]["forecastday"][0]["hour"][i]["condition"]
              ["icon"]),
          json["forecast"]["forecastday"][0]["hour"][i]["temp_c"],
          json["forecast"]["forecastday"][0]["hour"][i]["temp_f"],
          json["forecast"]["forecastday"][0]["hour"][i]["feelslike_c"],
          json["forecast"]["forecastday"][0]["hour"][i]["feelslike_f"],
          imageChanceMethod(
              json["forecast"]["forecastday"][0]["hour"][i]["chance_of_rain"],
              json["forecast"]["forecastday"][0]["hour"][i]["chance_of_snow"]),
          max(json["forecast"]["forecastday"][0]["hour"][i]["chance_of_rain"],
              json["forecast"]["forecastday"][0]["hour"][i]["chance_of_snow"]),
        ));
      }

      hourlyList["12am"] = new Map.from(overviewBuilder(
        imageStyle(
            json["forecast"]["forecastday"][1]["hour"][0]["condition"]["icon"]),
        json["forecast"]["forecastday"][1]["hour"][0]["temp_c"],
        json["forecast"]["forecastday"][1]["hour"][0]["temp_f"],
        json["forecast"]["forecastday"][1]["hour"][0]["feelslike_c"],
        json["forecast"]["forecastday"][1]["hour"][0]["feelslike_f"],
        imageChanceMethod(
            json["forecast"]["forecastday"][1]["hour"][0]["chance_of_rain"],
            json["forecast"]["forecastday"][1]["hour"][0]["chance_of_snow"]),
        max(json["forecast"]["forecastday"][1]["hour"][0]["chance_of_rain"],
            json["forecast"]["forecastday"][1]["hour"][0]["chance_of_snow"]),
      ));

      print(overviewList);
    } catch (e) {
      overviewList["morning"] = new Map.from(overviewBuilder(
          "/weather/64x64/error/error.png",
          0,
          0,
          0,
          0,
          "/weather/64x64/error/error.png",
          0));
      overviewList["afternoon"] = new Map.from(overviewBuilder(
          "/weather/64x64/error/error.png",
          0,
          0,
          0,
          0,
          "/weather/64x64/error/error.png",
          0));
      overviewList["evening"] = new Map.from(overviewBuilder(
          "/weather/64x64/error/error.png",
          0,
          0,
          0,
          0,
          "/weather/64x64/error/error.png",
          0));
      overviewList["overnight"] = new Map.from(overviewBuilder(
          "/weather/64x64/error/error.png",
          0,
          0,
          0,
          0,
          "/weather/64x64/error/error.png",
          0));
      hourlyList["No Info"] = new Map.from(overviewBuilder(
          "/weather/64x64/error/error.png",
          0,
          0,
          0,
          0,
          "/weather/64x64/error/error.png",
          0));
      finalChanceWeather = "No information";
    }
    double maxTemp_c, maxTemp_f, minTemp_c, minTemp_f;
    String sunrise, sunset, moonPhase;
    try {
      maxTemp_c = json["forecast"]["forecastday"][0]["day"]["maxtemp_c"];
      maxTemp_f = json["forecast"]["forecastday"][0]["day"]["maxtemp_f"];
      minTemp_c = json["forecast"]["forecastday"][0]["day"]["mintemp_c"];
      minTemp_f = json["forecast"]["forecastday"][0]["day"]["mintemp_f"];
      sunrise = json["forecast"]["forecastday"][0]["astro"]["sunrise"];
      sunset = json["forecast"]["forecastday"][0]["astro"]["sunset"];
      moonPhase = json["forecast"]["forecastday"][0]["astro"]["moon_phase"];
    } catch (e) {
      maxTemp_c = 0;
      maxTemp_f = 0;
      minTemp_c = 0;
      minTemp_f = 0;
      sunrise = "";
      sunset = "";
      moonPhase = "";
    }

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
      overviewList: overviewList,
      visibility: json["current"]["vis_km"],
      maxTemp_c: maxTemp_c,
      maxTemp_f: maxTemp_f,
      minTemp_c: minTemp_c,
      minTemp_f: minTemp_f,
      sunrise: sunrise,
      sunset: sunset,
      moonPhase: moonPhase,
      hourlyList: hourlyList,
      chanceWeatherCondition: finalChanceWeather,
    );
  }
}
