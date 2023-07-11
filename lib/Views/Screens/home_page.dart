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
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Image(
              image: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                  ? const AssetImage("assets/image/weather dark mode.jpg")
                  : const AssetImage("assets/image/weather light mode.jpg"),
              fit: BoxFit.fitWidth,
            ),
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0.5),
            leading: IconButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme();
              },
              icon: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                  ? const Icon(
                      Icons.dark_mode,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.light_mode,
                      color: Colors.white,
                    ),
            ),
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
                                  height: 800,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: (Provider.of<ThemeProvider>(
                                                  context)
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
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 10,
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
                                                color: Colors.white,
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
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              data.condition,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
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
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
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
                                                              ? Colors.white
                                                              : Colors.black,
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
                                                                : Colors
                                                                    .black54,
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
                                                                (data.hour[DateTime.now().hour]['time'].split("${DateTime.now().day}")[
                                                                            1] ==
                                                                        data.hour[index]['time']
                                                                            .split("${DateTime.now().day}")[1])
                                                                    ? Text(
                                                                        "Now",
                                                                        style:
                                                                            TextStyle(
                                                                          color: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        data.hour[index]['time']
                                                                            .split("${DateTime.now().day}")[1],
                                                                        style:
                                                                            TextStyle(
                                                                          color: (Provider.of<ThemeProvider>(context).themeModel.isDark)
                                                                              ? Colors.white
                                                                              : Colors.black,
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
                                                                    color: (Provider.of<ThemeProvider>(context)
                                                                            .themeModel
                                                                            .isDark)
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    fontSize:
                                                                        18,
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
                                                ? Colors.white
                                                : Colors.black,
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
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
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
                                                            ? Colors.white
                                                            : Colors.black,
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
                                                            : Colors.black54,
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
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
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
                                                                color: (Provider.of<ThemeProvider>(
                                                                            context)
                                                                        .themeModel
                                                                        .isDark)
                                                                    ? Colors
                                                                        .grey
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
                                                                color: (Provider.of<ThemeProvider>(
                                                                            context)
                                                                        .themeModel
                                                                        .isDark)
                                                                    ? Colors
                                                                        .white
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
                                                                color: (Provider.of<ThemeProvider>(
                                                                            context)
                                                                        .themeModel
                                                                        .isDark)
                                                                    ? Colors
                                                                        .grey
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
                                                                color: (Provider.of<ThemeProvider>(
                                                                            context)
                                                                        .themeModel
                                                                        .isDark)
                                                                    ? Colors
                                                                        .white
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
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
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
                                                                : Colors
                                                                    .black54,
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
                                                                ? Colors.white
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
                                                                ? Colors.white
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
                                                          : Colors.white,
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
                                                                : Colors
                                                                    .black54,
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
                                                                ? Colors.white
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
                                                          : Colors.white,
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
                                                                : Colors
                                                                    .black54,
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
                                                                ? Colors.white
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
                                                        ? Colors.black
                                                            .withOpacity(0.4)
                                                        : Colors.white
                                                            .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
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
                                                                : Colors
                                                                    .black54,
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
                                                                ? Colors.white
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
                                                          : Colors.white,
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
                                                            "${data.pressure_mb}",
                                                            style: TextStyle(
                                                              color: (Provider.of<
                                                                              ThemeProvider>(
                                                                          context)
                                                                      .themeModel
                                                                      .isDark)
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                                          : Colors.white,
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
                                                                : Colors
                                                                    .black54,
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
                                                                ? Colors.white
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
                                                                ? Colors.white
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
                                                ? Colors.black.withOpacity(0.4)
                                                : Colors.white.withOpacity(0.4),
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
                                                  color: (Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.white
                                                      : Colors.black,
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
                                                        : Colors.black,
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
                                                        : Colors.black54,
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
