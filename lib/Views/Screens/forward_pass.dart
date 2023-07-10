import 'package:flutter/material.dart';

import '../../Modal/login_modal.dart';

class ForwardPass extends StatefulWidget {
  const ForwardPass({Key? key}) : super(key: key);

  @override
  State<ForwardPass> createState() => _ForwardPassState();
}

class _ForwardPassState extends State<ForwardPass> {
  final GlobalKey<FormState> forgetPassKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: forgetPassKey,
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
                      "Forget Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                    obscureText: true,
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
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (forgetPassKey.currentState!.validate()) {
                          forgetPassKey.currentState!.save();
                          forgetPassword f1 = forgetPassword(email: email);
                          Navigator.of(context).pushNamed('login_screen');
                        }
                      },
                      child: const Text(
                        "Submit",
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
                        "Back to Login",
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
