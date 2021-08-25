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
  // final int cloud;
  // final double uv;
  // final String backgroundImage;

  WeatherInfo({
    this.hourlyList,
    this.overviewList,
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
    String finalWeatherImage = imageStyle(json["current"]["condition"]["icon"]);

    Map<String, dynamic> overviewList = new Map<String, dynamic>();
    overviewList["morning"] = new Map.from(overviewBuilder(
      imageStyle(
          json["forecast"]["forecastday"][0]["hour"][7]["condition"]["icon"]),
      json["forecast"]["forecastday"][0]["hour"][7]["temp_c"],
      json["forecast"]["forecastday"][0]["hour"][7]["temp_f"],
      json["forecast"]["forecastday"][0]["hour"][7]["feelslike_c"],
      json["forecast"]["forecastday"][0]["hour"][7]["feelslike_f"],
    ));

    overviewList["afternoon"] = new Map.from(overviewBuilder(
      imageStyle(
          json["forecast"]["forecastday"][0]["hour"][12]["condition"]["icon"]),
      json["forecast"]["forecastday"][0]["hour"][12]["temp_c"],
      json["forecast"]["forecastday"][0]["hour"][12]["temp_f"],
      json["forecast"]["forecastday"][0]["hour"][12]["feelslike_c"],
      json["forecast"]["forecastday"][0]["hour"][12]["feelslike_f"],
    ));

    overviewList["evening"] = new Map.from(overviewBuilder(
      imageStyle(
          json["forecast"]["forecastday"][0]["hour"][17]["condition"]["icon"]),
      json["forecast"]["forecastday"][0]["hour"][17]["temp_c"],
      json["forecast"]["forecastday"][0]["hour"][17]["temp_f"],
      json["forecast"]["forecastday"][0]["hour"][17]["feelslike_c"],
      json["forecast"]["forecastday"][0]["hour"][17]["feelslike_f"],
    ));

    overviewList["overnight"] = new Map.from(overviewBuilder(
      imageStyle(
          json["forecast"]["forecastday"][1]["hour"][0]["condition"]["icon"]),
      json["forecast"]["forecastday"][1]["hour"][0]["temp_c"],
      json["forecast"]["forecastday"][1]["hour"][0]["temp_f"],
      json["forecast"]["forecastday"][1]["hour"][0]["feelslike_c"],
      json["forecast"]["forecastday"][1]["hour"][0]["feelslike_f"],
    ));

    var now = DateTime.now();
    int currentHour = int.parse(DateFormat('HH').format(now));
    Map<String, dynamic> hourlyList = new Map<String, dynamic>();
    for (var i = currentHour; i <= 23; i++) {
      DateTime indexTempDate =
          DateTime.parse("2012-02-27 ${i.toString()}:00:00");
      String time = DateFormat('j').format(indexTempDate);
      time = time.replaceAll(" ", "");
      // print(hour12);
      hourlyList[time.toLowerCase()] = new Map.from(overviewBuilder(
        imageStyle(
            json["forecast"]["forecastday"][0]["hour"][i]["condition"]["icon"]),
        json["forecast"]["forecastday"][0]["hour"][i]["temp_c"],
        json["forecast"]["forecastday"][0]["hour"][i]["temp_f"],
        json["forecast"]["forecastday"][0]["hour"][i]["feelslike_c"],
        json["forecast"]["forecastday"][0]["hour"][i]["feelslike_f"],
      ));
    }

    hourlyList["12am"] = new Map.from(overviewBuilder(
      imageStyle(
          json["forecast"]["forecastday"][1]["hour"][0]["condition"]["icon"]),
      json["forecast"]["forecastday"][1]["hour"][0]["temp_c"],
      json["forecast"]["forecastday"][1]["hour"][0]["temp_f"],
      json["forecast"]["forecastday"][1]["hour"][0]["feelslike_c"],
      json["forecast"]["forecastday"][1]["hour"][0]["feelslike_f"],
    ));

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
      maxTemp_c: json["forecast"]["forecastday"][0]["day"]["maxtemp_c"],
      maxTemp_f: json["forecast"]["forecastday"][0]["day"]["maxtemp_f"],
      minTemp_c: json["forecast"]["forecastday"][0]["day"]["mintemp_c"],
      minTemp_f: json["forecast"]["forecastday"][0]["day"]["mintemp_f"],
      sunrise: json["forecast"]["forecastday"][0]["astro"]["sunrise"],
      sunset: json["forecast"]["forecastday"][0]["astro"]["sunset"],
      moonPhase: json["forecast"]["forecastday"][0]["astro"]["moon_phase"],
      hourlyList: hourlyList,
    );
  }
}
