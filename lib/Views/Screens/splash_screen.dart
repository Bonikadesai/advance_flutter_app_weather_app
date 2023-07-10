import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(
          seconds: 4,
        ), () {
      Navigator.of(context).pushReplacementNamed('login_screen');
      // (visited)
      //     ? Navigator.of(context).pushReplacementNamed('home_page')
      //     : Navigator.of(context).pushReplacementNamed('login_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("assets/image/weather-2021-12-07.png"),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Weather App",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
