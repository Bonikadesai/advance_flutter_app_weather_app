import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Modal/login_modal.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> signUpPageKey = GlobalKey<FormState>();
  TextEditingController nameContoller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordContoller = TextEditingController();
  String name = "";
  String email = "";
  String Password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: signUpPageKey,
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
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: nameContoller,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Your name";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      name = val!;
                    },
                    decoration:
                        const InputDecoration(hintText: "Enter Your Name"),
                  ),
                  const SizedBox(
                    height: 15,
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
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setBool("isIntrovisited", true);
                        Navigator.of(context).pushNamed('home_page');
                        if (signUpPageKey.currentState!.validate()) {
                          signUpPageKey.currentState!.save();
                          signUp S1 = signUp(
                            name: name,
                            email: email,
                            Password: Password,
                          );
                        }
                      },
                      child: const Text(
                        "Register",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('login_screen');
                      },
                      child: const Text(
                        "Already have an account ? Login",
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
