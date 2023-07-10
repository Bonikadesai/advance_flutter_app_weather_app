import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Modal/weather_modal.dart';
import '../../Provider/connect_provider.dart';
import '../../Provider/ios_provider.dart';
import '../../Provider/theme_provider.dart';
import '../../Provider/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ConnectProvider>(context, listen: false).checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Image(
              image: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                  ? AssetImage("assets/image/weather dark mode.jpg")
                  : AssetImage("assets/image/weather light mode.jpg"),
              fit: BoxFit.fitWidth,
            ),
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0.5),
            actions: [
              Switch(
                  value: Provider.of<IosProvider>(context, listen: true).isIos,
                  onChanged: (val) {
                    Provider.of<IosProvider>(context, listen: false)
                        .changePlatform(val);
                  }),
            ],
          ),
          body: ((Provider.of<ConnectProvider>(context)
                      .connectModel
                      .connectStatus ==
                  "Waiting"))
              ? Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/image/dog-removebg-preview.png"),
                      ),
                    ),
                  ),
                )
              : FutureBuilder(
                  future: Provider.of<WeatherProvider>(context, listen: false)
                      .weatherData((Provider.of<WeatherProvider>(context)
                          .searchLocation
                          .location)),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error : ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      Weather? data = snapshot.data;
                      return (data == null)
                          ? const Center(
                              child: Text("No Data Available.."),
                            )
                          : Stack(
                              children: [
                                Container(
                                  height: _height,
                                  width: _width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: (Provider.of<ThemeProvider>(
                                                  context)
                                              .themeModel
                                              .isDark)
                                          ? AssetImage(
                                              "assets/image/weather dark mode.jpg")
                                          : AssetImage(
                                              "assets/image/weather light mode.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        TextField(
                                          controller:
                                              Provider.of<WeatherProvider>(
                                                      context)
                                                  .searchLocation
                                                  .locationController,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            labelText: "Search location",
                                            suffixIconColor: Colors.white,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                Provider.of<WeatherProvider>(
                                                        context,
                                                        listen: false)
                                                    .searchLocation
                                                    .locationController
                                                    .clear();
                                              },
                                              icon: const Icon(Icons.cancel),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          onSubmitted: (val) {
                                            if (val.isNotEmpty) {
                                              Provider.of<WeatherProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchWeather(val);
                                              Provider.of<WeatherProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchLocation
                                                  .locationController
                                                  .clear();
                                            } else {
                                              Provider.of<WeatherProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchWeather(Provider.of<
                                                              WeatherProvider>(
                                                          context,
                                                          listen: false)
                                                      .searchLocation
                                                      .location);
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.name,
                                                  style: TextStyle(
                                                    fontSize: _height * 0.04,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: _height * 0.005,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.white
                                                            : Colors.black,
                                                        Icons.location_on),
                                                    SizedBox(
                                                      width: _width * 0.02,
                                                    ),
                                                    Text(
                                                      "Lat :  ${data.lat} °",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.018,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: _width * 0.08,
                                                    ),
                                                    Text(
                                                      "Lon :  ${data.lon} °",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.018,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: false)
                                                    .changeTheme();
                                              },
                                              icon: (Provider.of<ThemeProvider>(
                                                          context)
                                                      .themeModel
                                                      .isDark)
                                                  ? const Icon(
                                                      Icons.dark_mode,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      Icons.light_mode,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _height * 0.1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          textBaseline: TextBaseline.alphabetic,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          children: [
                                            Text(
                                              "${data.temp_c}°",
                                              style: TextStyle(
                                                fontSize: _height * 0.08,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              data.condition,
                                              style: TextStyle(
                                                fontSize: _height * 0.025,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: List.generate(
                                              data.hour.length,
                                              (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 28),
                                                child: Column(
                                                  children: [
                                                    (data.hour[DateTime.now()
                                                                            .hour]
                                                                        ['time']
                                                                    .split(
                                                                        "${DateTime.now().day}")[
                                                                1] ==
                                                            data.hour[index]
                                                                    ['time']
                                                                .split(
                                                                    "${DateTime.now().day}")[1])
                                                        ? Text(
                                                            "Now",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  _height *
                                                                      0.022,
                                                            ),
                                                          )
                                                        : Text(
                                                            data.hour[index]
                                                                    ['time']
                                                                .split(
                                                                    "${DateTime.now().day}")[1],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  _height *
                                                                      0.022,
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: _height * 0.01,
                                                    ),
                                                    Image.network(
                                                      "http:${data.hour[index]['condition']['icon']}",
                                                      height: _height * 0.05,
                                                      width: _height * 0.05,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.01,
                                                    ),
                                                    Text(
                                                      "${data.hour[index]['temp_c']}°",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            _height * 0.022,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.05,
                                        ),
                                        Text(
                                          "Weather details",
                                          style: TextStyle(
                                            fontSize: _height * 0.02,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: _height * 0.18,
                                              width: _width * 0.45,
                                              decoration: BoxDecoration(
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _height * 0.02),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.thermostat,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "Feels Like",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${data.feelslike_c}",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.025,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.01,
                                                        ),
                                                        Text(
                                                          "°",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: _height * 0.18,
                                              width: _width * 0.45,
                                              decoration: BoxDecoration(
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _height * 0.02),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.air,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "SW wind",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Row(
                                                      textBaseline: TextBaseline
                                                          .ideographic,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      children: [
                                                        Text(
                                                          "${data.wind_kph}",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.025,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.01,
                                                        ),
                                                        Text(
                                                          "km/h",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _height * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: _height * 0.18,
                                              width: _width * 0.45,
                                              decoration: BoxDecoration(
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _height * 0.02),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.water_drop,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "Humidity",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Row(
                                                      textBaseline: TextBaseline
                                                          .ideographic,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      children: [
                                                        Text(
                                                          "${data.humidity}",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.025,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.01,
                                                        ),
                                                        Text(
                                                          "%",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: _height * 0.18,
                                              width: _width * 0.45,
                                              decoration: BoxDecoration(
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _height * 0.02),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.light_mode_outlined,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "UV",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Row(
                                                      textBaseline: TextBaseline
                                                          .ideographic,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      children: [
                                                        Text(
                                                          "${data.uv}",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.025,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.01,
                                                        ),
                                                        Text(
                                                          "Strong",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _height * 0.02,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: _height * 0.18,
                                              width: _width * 0.45,
                                              decoration: BoxDecoration(
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _height * 0.02),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.visibility,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "Visibility",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Row(
                                                      textBaseline: TextBaseline
                                                          .ideographic,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      children: [
                                                        Text(
                                                          "${data.vis_km}",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.025,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.01,
                                                        ),
                                                        Text(
                                                          "km",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: _height * 0.18,
                                              width: _width * 0.45,
                                              decoration: BoxDecoration(
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _height * 0.02),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.wind_power,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "Air pressure",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Row(
                                                      textBaseline: TextBaseline
                                                          .ideographic,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      children: [
                                                        Text(
                                                          "${data.pressure_mb}",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.025,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: _width * 0.01,
                                                        ),
                                                        Text(
                                                          "hPa",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize:
                                                                _height * 0.018,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: _height * 0.02,
                                        ),
                                        Container(
                                          height: _height * 0.18,
                                          width: _width,
                                          decoration: BoxDecoration(
                                            color: (Provider.of<ThemeProvider>(
                                                        context)
                                                    .themeModel
                                                    .isDark)
                                                ? Colors.black.withOpacity(0.4)
                                                : Colors.white.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(
                                                _height * 0.02),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.light_mode_outlined,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "Sunrise",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Text(
                                                      data.sunrise,
                                                      style: TextStyle(
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize:
                                                            _height * 0.024,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      Icons.dark_mode_outlined,
                                                      size: _height * 0.04,
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.03,
                                                    ),
                                                    Text(
                                                      "Sunset",
                                                      style: TextStyle(
                                                        fontSize:
                                                            _height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.grey
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: _height * 0.003,
                                                    ),
                                                    Text(
                                                      data.sunset,
                                                      style: TextStyle(
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize:
                                                            _height * 0.024,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
