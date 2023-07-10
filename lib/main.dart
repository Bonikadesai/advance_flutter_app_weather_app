import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_flutter_app/Provider/weather_provider.dart';

import 'Modal/theme_modal.dart';
import 'Provider/connect_provider.dart';
import 'Provider/ios_provider.dart';
import 'Provider/theme_provider.dart';
import 'Views/Screens/cupertino_screen.dart';
import 'Views/Screens/forward_pass.dart';
import 'Views/Screens/home_page.dart';
import 'Views/Screens/login_page.dart';
import 'Views/Screens/signup_page.dart';
import 'Views/Screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();

  bool visited = pref.getBool("isIntrovisited") ?? false;
  bool isThemeDark = pref.getBool("isthemeDark") ?? false;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ConnectProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(
          themeModel: ThemeModel(isDark: isThemeDark),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => WeatherProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => IosProvider(),
      ),
    ],
    child: Consumer<IosProvider>(
      builder: (context, value, _) => (value.isIos == false)
          ? MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.light(
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
              ),
              initialRoute: (visited) ? 'home_page' : '/',
              routes: {
                '/': (context) => const SplashScreen(),
                'login_screen': (context) => const LoginPage(),
                'signup_screen': (context) => const SignupPage(),
                'forget_password_screen': (context) => const ForwardPass(),
                'home_page': (context) => const HomePage(),
              },
            )
          : CupertinoApp(
              debugShowCheckedModeBanner: false,
              // theme: (Provider.of<ThemeProvider>(context).themeModel.isDark)
              //     ? CupertinoColors.black
              //     : CupertinoColors.white,
              home: CupertinoScreen(),
            ),
    ),

    // builder: (context, _) => MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     useMaterial3: true,
    //     colorScheme: ColorScheme.light(
    //       brightness: Brightness.light,
    //     ),
    //   ),
    //   darkTheme: ThemeData(
    //     useMaterial3: true,
    //   ),
    //   initialRoute: (visited) ? 'home_page' : '/',
    //   routes: {
    //     '/': (context) => const SplashScreen(),
    //     'login_screen': (context) => const LoginPage(),
    //     'signup_screen': (context) => const SignupPage(),
    //     'forget_password_screen': (context) => const ForwardPass(),
    //     'home_page': (context) => const HomePage(),
    //   },
    // ),
  ));
}
