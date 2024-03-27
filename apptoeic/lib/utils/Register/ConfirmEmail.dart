import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/Button.dart';
import 'package:apptoeic/utils/config.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../provider/signin_provider.dart';
import '../Login/LoginPage.dart';
import '../next_screen.dart';
import '../snack_bar.dart';

class ConfirmEmail extends StatefulWidget {
  final String code;
  final String email;
  final String name;
  final String phone;
  final String password;
  final String dob;

  ConfirmEmail(
      {required this.code,
      required this.email,
      required this.name,
      required this.phone,
      required this.password,
      required this.dob});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  final codeconfirm = TextEditingController();
  final confirmController = RoundedLoadingButtonController();

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
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(
          height: 80,
        ),
        Image.asset(
          Config.logo,
          width: 150,
          height: 150,
        ),
        const SizedBox(
          height: 80,
        ),
        inputDecoration(
          hint: 'Enter your Code sent',
          inputcontroller: codeconfirm,
        ),
        const SizedBox(
          height: 20,
        ),
        buttonRounded(context, confirmController, darkblue,
            FontAwesomeIcons.check, 'Confirm Code', handleCode),
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
                  color: darkblue,
                  decoration: TextDecoration.underline,
                )),
          ),
        ),
      ]),
    );
  }

  Future handleCode() async {
    if (widget.code == codeconfirm.text) {
      final sp = context.read<SignInProvider>();
      sp.CreateNewAccount(
          widget.email, widget.name, widget.password, widget.phone, widget.dob);
      sp.saveDataToFirestore();
      openSnackbar(context, "Successful", Colors.green);
      confirmController.success();
      nextScreenReplace(context, const Login());
    } else {
      openSnackbar(context, "Code is not correct", Colors.red);
      confirmController.reset();
    }
  }
}
