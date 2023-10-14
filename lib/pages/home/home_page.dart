import 'package:flutter/material.dart';
import 'package:weather_app/pages/home/home_page_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final manager = HomePageManager();

  @override
  void initState() {
    super.initState();
    manager.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ValueListenableBuilder<LoadingStatus>(
          valueListenable: manager.loadingNotifier,
          builder: (context, loadingStatus, child) {
            switch (loadingStatus) {
              case Loading():
                return const CircularProgressIndicator();
              case LoadingError():
                return ErrorWidget(
                  errorMessage: loadingStatus.message,
                  onRetry: manager.loadWeather,
                );
              case LoadingSuccess():
                return WeatherWidget(
                  manager: manager,
                  weather: loadingStatus.weather,
                );
            }
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });
  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        TextButton(
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.manager,
    required this.weather,
  });
  final HomePageManager manager;
  final String weather;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: manager.convertTemperature,
              child: ValueListenableBuilder<String>(
                valueListenable: manager.buttonNotifier,
                builder: (context, buttonText, child) {
                  return Text(
                    buttonText,
                    style: textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: manager.temperatureNotifier,
                builder: (context, temperature, child) {
                  return Text(
                    temperature,
                    style: const TextStyle(fontSize: 56),
                  );
                },
              ),
              Text(
                weather,
                style: textTheme.headlineMedium,
              ),
              Text(
                'Ulaanbaatar',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
