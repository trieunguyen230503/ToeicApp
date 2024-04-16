import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../provider/internet_provider.dart';
import '../../provider/signin_provider.dart';
import '../Button.dart';
import '../config.dart';
import '../next_screen.dart';
import '../snack_bar.dart';

class RenewPassword extends StatefulWidget {
  final String email;

  const RenewPassword({required this.email});

  @override
  State<RenewPassword> createState() => _RenewPasswordState();
}

class _RenewPasswordState extends State<RenewPassword> {
  final password = TextEditingController();
  final confirmpassword = TextEditingController();

  bool enable = true;

  final renewPassowrd = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            // Đổi icon về
            onPressed: () {
              // Xử lý khi người dùng nhấn vào icon trở về
            },
          ),
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'RENEW PASSWORD',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  inputDecorationPassword(
                    passwordHint: 'Password',
                    passwordController: password,
                    enable: enable,
                    orientation: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputDecorationPassword(
                    passwordHint: 'Confirm',
                    passwordController: confirmpassword,
                    enable: enable,
                    orientation: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonRounded(context, renewPassowrd, darkblue,
                      FontAwesomeIcons.check, 'Renew Password', updateData, 1),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentMainPage()));
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: const Text('Return Home page ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  inputDecorationPassword(
                    passwordHint: 'Password',
                    passwordController: password,
                    enable: enable,
                    orientation: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputDecorationPassword(
                    passwordHint: 'Confirm',
                    passwordController: confirmpassword,
                    enable: enable,
                    orientation: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buttonRounded(context, renewPassowrd, darkblue,
                      FontAwesomeIcons.check, 'Renew Password', updateData, 2),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentMainPage()));
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: const Text('Return Home page ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }

  void updateData() async {
    setState(() {
      enable = false;
    });

    if (confirmpassword.text == password.text) {
      if (confirmpassword.text.length > 8) {
        final sp = context.read<SignInProvider>();
        final ip = context.read<InternetProvider>();
        await ip.checkInternetConnection();
        sp.updateForgetPass(widget.email, password.text.toString());
        openSnackbar(context, "Successful", Colors.green);
        renewPassowrd.success();
        nextScreenReplace(context, StudentMainPage());
      } else {
        openSnackbar(context, "Password must be 8 character", Colors.red);
        renewPassowrd.reset();
      }
    } else {
      openSnackbar(context, "Password doesn't match", Colors.red);
      renewPassowrd.reset();
    }

    setState(() {
      enable = true;
    });
  }
}
