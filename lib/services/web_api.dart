import 'dart:convert';
import 'package:http/http.dart';
import 'package:weather_app/models/weather.dart';

// 1
abstract interface class WebApi {
  Future<Weather> getWeather({
    // 2
    required double latitude,
    required double longitude,
  });
}

// 3
class FccApi implements WebApi {
  @override
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse('https://fcc-weather-api.glitch.me/api/current'
        '?lat=$latitude&lon=$longitude');
    final result = await get(url);
    final jsonString = result.body;
    final jsonMap = jsonDecode(jsonString);
    final temperature = jsonMap['main']['temp'] as double;
    final weather = jsonMap['weather'][0]['main'] as String;
    print(jsonMap);
    return Weather(
      temperature: temperature.toInt(),
      description: weather,
    );
  }
}
