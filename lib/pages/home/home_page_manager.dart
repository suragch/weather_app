import 'package:flutter/foundation.dart';
import 'package:weather_app/services/local_storage.dart';
import 'package:weather_app/services/service_locator.dart';
import 'package:weather_app/services/web_api.dart';

class HomePageManager {
  HomePageManager({WebApi? webApi, LocalStorage? storage}) {
    _webApi = webApi ?? getIt<WebApi>();
    _storage = storage ?? getIt<LocalStorage>();
  }

  late WebApi _webApi;
  late LocalStorage _storage;

  final loadingNotifier = ValueNotifier<LoadingStatus>(const Loading());
  final temperatureNotifier = ValueNotifier<String>('');
  final buttonNotifier = ValueNotifier<String>('°C');

  late int _temperature;

  Future<void> loadWeather() async {
    loadingNotifier.value = const Loading();
    final isCelsius = _storage.isCelsius;
    buttonNotifier.value = (isCelsius) ? '°C' : '°F';
    try {
      final weather = await _webApi.getWeather(
        longitude: 106.9057,
        latitude: 47.8864,
      );
      _temperature = weather.temperature;
      final temperature =
          (isCelsius) ? _temperature : _convertToFahrenheit(_temperature);
      temperatureNotifier.value = '$temperature°';
      loadingNotifier.value = LoadingSuccess(
        weather: weather.description,
      );
    } catch (e) {
      print(e);
      loadingNotifier.value = const LoadingError(
        'There was an error loading the weather.',
      );
    }
  }

  int _convertToFahrenheit(int celsius) {
    return (celsius * 9 / 5 + 32).toInt();
  }

  void convertTemperature() {
    final isCelsius = !_storage.isCelsius;
    _storage.saveIsCelsius(isCelsius);
    final temperature =
        (isCelsius) ? _temperature : _convertToFahrenheit(_temperature);
    temperatureNotifier.value = '$temperature°';
    buttonNotifier.value = (isCelsius) ? '°C' : '°F';
  }
}

sealed class LoadingStatus {
  const LoadingStatus();
}

class Loading extends LoadingStatus {
  const Loading();
}

class LoadingError extends LoadingStatus {
  const LoadingError(this.message);
  final String message;
}

class LoadingSuccess extends LoadingStatus {
  const LoadingSuccess({
    required this.weather,
  });
  final String weather;
}
