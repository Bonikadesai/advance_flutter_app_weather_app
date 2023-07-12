import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_flutter_app/Provider/ios_provider.dart';

import '../../Modal/weather_modal.dart';
import '../../Provider/connect_provider.dart';
import '../../Provider/theme_provider.dart';
import '../../Provider/weather_provider.dart';

class CupertinoScreen extends StatefulWidget {
  const CupertinoScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoScreen> createState() => _CupertinoScreenState();
}

class _CupertinoScreenState extends State<CupertinoScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).changeTheme();
          },
          child: const Icon(
            CupertinoIcons.sun_min,
          ),
        ),
        trailing: CupertinoSwitch(
          value: Provider.of<IosProvider>(context, listen: true).isIos,
          onChanged: (val) {
            Provider.of<IosProvider>(context, listen: false)
                .changePlatform(val);
          },
        ),
      ),
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  controller: Provider.of<WeatherProvider>(context)
                      .searchLocation
                      .locationController,
                  onSubmitted: (val) {
                    if (val.isNotEmpty) {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .searchWeather(val);
                      Provider.of<WeatherProvider>(context, listen: false)
                          .searchLocation
                          .locationController
                          .clear();
                    } else {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .searchWeather(Provider.of<WeatherProvider>(context,
                                  listen: false)
                              .searchLocation
                              .location);
                    }
                  },
                  prefix: const Icon(CupertinoIcons.search),
                  placeholder: "Search location",
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (Provider.of<ThemeProvider>(context)
                              .themeModel
                              .isDark)
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                    ),
                  ),
                ),
              ),
              if (Provider.of<ConnectProvider>(context)
                      .connectModel
                      .connectStatus ==
                  "Waiting")
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/image/dog-removebg-preview.png"),
                      ),
                    ),
                  ),
                )
              else
                FutureBuilder(
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
                      if ((data == null)) {
                        return const Center(
                          child: Text("No Data Available.."),
                        );
                      } else {
                        return Stack(
                          children: [
                            Container(
                              height: 1025,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (Provider.of<ThemeProvider>(context)
                                          .themeModel
                                          .isDark)
                                      ? const AssetImage(
                                          "assets/image/weather dark mode.jpg")
                                      : const AssetImage(
                                          "assets/image/weather light mode.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: CupertinoScrollbar(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            data.name,
                                            style: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.w500,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${data.temp_c}°",
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w500,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                          Text(
                                            data.condition,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        child: Row(children: [
                                          Container(
                                            height: 250,
                                            width: 360,
                                            decoration: BoxDecoration(
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? CupertinoColors.black
                                                          .withOpacity(0.4)
                                                      : CupertinoColors.white
                                                          .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.watch_later,
                                                        color: (Provider.of<
                                                                        ThemeProvider>(
                                                                    context)
                                                                .themeModel
                                                                .isDark)
                                                            ? CupertinoColors
                                                                .white
                                                            : CupertinoColors
                                                                .black,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "24-hour forecast",
                                                        style: TextStyle(
                                                          fontSize: 18,
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
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 60,
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                        data.hour.length,
                                                        (index) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 28),
                                                          child: Column(
                                                            children: [
                                                              (data.hour[DateTime.now().hour]['time']
                                                                              .split("${DateTime.now().day}")[
                                                                          1] ==
                                                                      data.hour[
                                                                              index]
                                                                              [
                                                                              'time']
                                                                          .split(
                                                                              "${DateTime.now().day}")[1])
                                                                  ? Text(
                                                                      "Now",
                                                                      style:
                                                                          TextStyle(
                                                                        color: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                                                                            ? CupertinoColors.white
                                                                            : CupertinoColors.black,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      data.hour[
                                                                              index]
                                                                              [
                                                                              'time']
                                                                          .split(
                                                                              "${DateTime.now().day}")[1],
                                                                      style:
                                                                          TextStyle(
                                                                        color: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                                                                            ? CupertinoColors.white
                                                                            : CupertinoColors.black,
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Image.network(
                                                                "http:${data.hour[index]['condition']['icon']}",
                                                                height: 40,
                                                                width: 40,
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "${data.hour[index]['temp_c']}°",
                                                                style:
                                                                    TextStyle(
                                                                  color: (Provider.of<ThemeProvider>(
                                                                              context)
                                                                          .themeModel
                                                                          .isDark)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 18,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Weather details",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: (Provider.of<ThemeProvider>(
                                                      context)
                                                  .themeModel
                                                  .isDark)
                                              ? CupertinoColors.white
                                              : CupertinoColors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //west
                                          Container(
                                            height: 100,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? CupertinoColors.black
                                                          .withOpacity(0.4)
                                                      : CupertinoColors.white
                                                          .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Southwest",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? CupertinoColors
                                                              .white
                                                          : CupertinoColors
                                                              .black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "10.0km/h",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: (Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .themeModel
                                                              .isDark)
                                                          ? Colors.grey
                                                          : CupertinoColors
                                                              .darkBackgroundGray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //sunrise nd sunset
                                          Container(
                                            height: 100,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? CupertinoColors.black
                                                          .withOpacity(0.4)
                                                      : CupertinoColors.white
                                                          .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Sunrise",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: (Provider.of<
                                                                              ThemeProvider>(
                                                                          context)
                                                                      .themeModel
                                                                      .isDark)
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black54,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
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
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Sunset",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: (Provider.of<
                                                                              ThemeProvider>(
                                                                          context)
                                                                      .themeModel
                                                                      .isDark)
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black54,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
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
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? CupertinoColors.black
                                                          .withOpacity(0.4)
                                                      : CupertinoColors.white
                                                          .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //sw wind
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "SW wind",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${data.wind_kph}",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "km/h",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: (Provider.of<
                                                                    ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.grey
                                                        : CupertinoColors.white,
                                                  ),
                                                  //humidity
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Humidity",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${data.humidity} %",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: (Provider.of<
                                                                    ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.grey
                                                        : CupertinoColors.white,
                                                  ),
                                                  //Real feel
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Real Feel",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${data.feelslike_c}°",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 18,
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
                                            height: 200,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? CupertinoColors.black
                                                          .withOpacity(0.4)
                                                      : CupertinoColors.white
                                                          .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //Uv
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "UV",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${data.uv} ",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: (Provider.of<
                                                                    ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.grey
                                                        : CupertinoColors.white,
                                                  ),
                                                  //pressure
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Pressure",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.grey
                                                                : Colors
                                                                    .black54,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
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
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          "mbar",
                                                          style: TextStyle(
                                                            color: (Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .themeModel
                                                                    .isDark)
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: (Provider.of<
                                                                    ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? Colors.grey
                                                        : CupertinoColors.white,
                                                  ),
                                                  //visibility
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Visibility",
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${data.vis_km}",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "km",
                                                        style: TextStyle(
                                                          color: (Provider.of<
                                                                          ThemeProvider>(
                                                                      context)
                                                                  .themeModel
                                                                  .isDark)
                                                              ? CupertinoColors
                                                                  .white
                                                              : Colors.black,
                                                          fontSize: 16,
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
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        height: 80,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (Provider.of<ThemeProvider>(
                                                      context)
                                                  .themeModel
                                                  .isDark)
                                              ? CupertinoColors.black
                                                  .withOpacity(0.4)
                                              : CupertinoColors.white
                                                  .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.energy_savings_leaf,
                                                color:
                                                    (Provider.of<ThemeProvider>(
                                                                context)
                                                            .themeModel
                                                            .isDark)
                                                        ? CupertinoColors.white
                                                        : CupertinoColors.black,
                                              ),
                                              Text(
                                                "AQI 50",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: (Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : CupertinoColors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 50,
                                              ),
                                              Text(
                                                "Full air quality forecast",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: (Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : CupertinoColors
                                                          .darkBackgroundGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
