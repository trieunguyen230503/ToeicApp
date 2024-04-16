import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/Button.dart';
import 'package:apptoeic/utils/config.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:apptoeic/utils/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'RenewPassword.dart';

class ConfirmPassword extends StatefulWidget {
  final String code;
  final String email;

  ConfirmPassword({required this.code, required this.email});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final codeconfirm = TextEditingController();
  final confirmPasswordController = RoundedLoadingButtonController();
  bool enable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'CONFIRM CODE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                ),
                Image.asset(
                  Config.logo,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(
                  height: 50,
                ),
                inputDecoration(
                  hint: 'Enter your Code sent',
                  inputcontroller: codeconfirm,
                  enable: enable,
                  orientation: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                buttonRounded(context, confirmPasswordController, darkblue,
                    Icons.login, 'CONFIRM CODE', handleCode, 1),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudentMainPage()));
                    //Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: const Text('Return Home Page',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            );
          } else {
            return SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                ),
                Image.asset(
                  Config.logo,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(
                  height: 50,
                ),
                inputDecoration(
                  hint: 'Enter your Code sent',
                  inputcontroller: codeconfirm,
                  enable: enable,
                  orientation: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                buttonRounded(context, confirmPasswordController, darkblue,
                    Icons.login, 'CONFIRM CODE', handleCode, 2),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudentMainPage()));
                    //Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: const Text('Return Home Page',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            );
          }
        }));
  }

  Future handleCode() async {
    setState(() {
      enable = false;
    });

    if (widget.code == codeconfirm.text) {
      confirmPasswordController.success();
      nextScreenReplace(
          context,
          RenewPassword(
            email: widget.email,
          ));
    } else {
      openSnackbar(context, 'Code is not correct', Colors.red);
      confirmPasswordController.reset();
    }
    setState(() {
      enable = false;
    });
  }
}
