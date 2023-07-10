import 'package:flutter/cupertino.dart';
import 'package:weather_flutter_app/Modal/weather_modal.dart';

import '../Helper/api_helper.dart';
import '../Modal/serch_location.dart';

class WeatherProvider extends ChangeNotifier {
  SearchLocation searchLocation = SearchLocation(
    location: "Surat",
    locationController: TextEditingController(),
  );

  searchWeather(String location) {
    searchLocation.location = location;
    notifyListeners();
  }

  Future<Weather?>? weatherData(String location) async {
    searchLocation.weather =
        (await APIHelper.apiHelper.fetchWeatherDetails(location));
    return searchLocation.weather;
  }
}
