import 'package:get/get.dart';

enum Weather {
  intenseSun,
  rain,
  hail,
  sandstorm,
  none
}

class WeatherState {
  Rx<Weather> w = Weather.none.obs;

  void updateWeather(Weather nw) {
    w.value = nw;
  }

  Weather getWeather() {
    return w.value;
  }
}
