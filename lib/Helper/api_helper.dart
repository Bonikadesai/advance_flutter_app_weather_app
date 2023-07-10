import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_flutter_app/Modal/weather_modal.dart';

class APIHelper {
  APIHelper._();

  static APIHelper apiHelper = APIHelper._();

  Future<Weather?> fetchWeatherDetails(String search) async {
    String hostName = "https://api.weatherapi.com";
    String ApiKey = "64e0a836332243598af131715230607";
    String Url = "$hostName/v1/forecast.json?key=$ApiKey&q=$search&aqi=no";

    http.Response response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      Map decodedData = jsonDecode(response.body);

      Weather weatherData = Weather.formMap(data: decodedData);

      return weatherData;
    }
    return null;
  }
}
