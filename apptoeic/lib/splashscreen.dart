import 'dart:async';

import 'package:apptoeic/admin/AdminMainPage.dart';
import 'package:apptoeic/provider/signin_provider.dart';
import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/config.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? checkLogin;

  @override
  void initState() {
    // TODO: implement initState

    Timer(const Duration(seconds: 3), () {
      final sp = context.read<SignInProvider>();
      sp.getDataFromSharedPreference();

      nextScreenReplace(context, const StudentMainPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            color: darkblue,
            child: Center(
                child: Image.asset(
              Config.logo,
              width: MediaQuery.sizeOf(context).height * 0.5,
              height: MediaQuery.sizeOf(context).height * 0.5,
            ))));
  }
}
