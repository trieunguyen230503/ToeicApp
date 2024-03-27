import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/Button.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../provider/internet_provider.dart';
import '../../provider/signin_provider.dart';
import '../../utils/config.dart';
import '../Login/emailsender.dart';
import '../snack_bar.dart';
import 'ConfirmPassword.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final userName = TextEditingController();
  String code = '';
  final emailController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'ConfirmPass': (context) => ConfirmPassword(
              code: '',
              email: '',
            ),
      },
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            // Đổi icon về
            onPressed: () {
              Navigator.pop(context);
              // Xử lý khi người dùng nhấn vào icon trở về
            },
          ),
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'RECOVER YOUR PASSWORD',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 80,
            ),
            Image(
              image: AssetImage(Config.logo),
              height: 120,
              width: 120,
            ),
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.05,
                  right: MediaQuery.sizeOf(context).width * 0.05),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Enter the email ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                                'that you used when you signed up to recover your password.' +
                                    ' You will receive a '),
                        TextSpan(
                            text: 'password reset code',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ])),
            ),
            const SizedBox(
              height: 20,
            ),
            inputDecoration(
              hint: 'Enter your email',
              inputcontroller: userName,
            ),
            const SizedBox(
              height: 20,
            ),
            buttonRounded(context, emailController, darkblue, Icons.login,
                'Confirm', checkEmaildata),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentMainPage()));
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
        ),
      ),
    );
  }

  void checkEmaildata() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    sp.checkEmailExists(userName.text).then((value) async {
      if (value == true) {
        code = createCode();
        print(code);
        sendingmail(
            name: 'Trieu',
            email: userName.text.toString(),
            subject: 'Reset your password',
            message: code);
        emailController.success();
        nextScreenReplace(context,
            ConfirmPassword(code: code, email: userName.text.toString()));
      } else {
        emailController.reset();
        openSnackbar(context, "Doesn't exist this email", Colors.red);
      }
    });
  }
}
