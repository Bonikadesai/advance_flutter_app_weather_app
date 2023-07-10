import 'package:flutter/cupertino.dart';
import 'package:weather_flutter_app/Modal/weather_modal.dart';

class SearchLocation {
  String location;
  Weather? weather;
  TextEditingController locationController;

  SearchLocation({
    required this.location,
    this.weather,
    required this.locationController,
  });
}
