import 'package:apptoeic/utils/Login/LoginPage.dart';
import 'package:apptoeic/utils/config.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';

import '../../../utils/Register/Register.dart';

class OpResLogin extends StatefulWidget {
  const OpResLogin({super.key});

  @override
  State<OpResLogin> createState() => _OpResLoginState();
}

class _OpResLoginState extends State<OpResLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Image.asset(Config.logo),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: darkblue,
                    onPrimary: darkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    )),
                onPressed: () {
                  nextScreen(context, const Login());
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Màu nền của nút
                    onPrimary: Colors.white, // Màu chữ của nút
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(color: darkblue, width: 2)),
                  ),
                  onPressed: () {
                    nextScreen(context, const Register());
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkblue),
                  )))
        ],
      ),
    );
  }
}
