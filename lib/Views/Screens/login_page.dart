import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Modal/login_modal.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> loginPageKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordContoller = TextEditingController();
    String email = "";
    String Password = "";
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: loginPageKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image:
                              AssetImage("assets/image/weather-2021-12-07.png"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Your email id";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      email = val!;
                    },
                    decoration:
                        const InputDecoration(hintText: "Enter Your Email id"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordContoller,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Your Password";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      Password = val!;
                    },
                    decoration:
                        const InputDecoration(hintText: "Enter Your Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('forget_password_screen');
                    },
                    child: const Text(
                      "Forget Password ?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("isIntrovisited", true);

                        Navigator.of(context).pushNamed('home_page');
                        if (loginPageKey.currentState!.validate()) {
                          loginPageKey.currentState!.save();
                          login l1 = login(email: email, password: Password);
                        }
                      },
                      child: const Text(
                        "Log in",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('signup_screen');
                      },
                      child: const Text(
                        "Don't have an account? Sign-UP",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
