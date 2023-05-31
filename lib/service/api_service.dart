import 'package:http/http.dart' as http;
import '../const/strings.dart';
import '../models/current_weather_model.dart';
import '../models/hourly_weather_model.dart';

getCurrentWeather(lat, long) async {
  var link =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var data = currentWeatherDataFromJson(response.body.toString());
    return data;
  }
}

getHourlyWeather(lat, long) async {
  var hourlylink =
      "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
  var response = await http.get(Uri.parse(hourlylink));
  if (response.statusCode == 200) {
    var dataa = hourlyWeatherDataFromJson(response.body.toString());
    return dataa;
  }
}
