
import 'package:flutter/material.dart';

import '../GameLogic/battle.dart';
import '../Model/weather.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather? weather;
  final Function(Weather) onUpdateWeather;

  const WeatherDisplay({Key? key, required this.weather, required this.onUpdateWeather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Current Weather: ${weather?.toString().split('.').last ?? 'None'}',
          style: TextStyle(fontSize: 20),
        ),
        Wrap(
          spacing: 8.0,
          children: Weather.values.map((w) {
            return ElevatedButton(
              onPressed: () => onUpdateWeather(w),
              child: Text(w.toString().split('.').last),
            );
          }).toList(),
        ),
      ],
    );
  }
}
