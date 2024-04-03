import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/Button.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../provider/internet_provider.dart';
import '../../provider/signin_provider.dart';
import '../../utils/config.dart';
import '../Login/LoginPage.dart';
import '../Login/emailsender.dart';
import '../next_screen.dart';
import '../snack_bar.dart';
import 'ConfirmEmail.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RoundedLoadingButtonController registerController =
      RoundedLoadingButtonController();

  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final dob = TextEditingController();

  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final _scaffoldKey = GlobalKey<FormState>();

  String code = '';
  bool enable = true;

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
              Navigator.pop(context);
              // Xử lý khi người dùng nhấn vào icon trở về
            },
          ),
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'REGISTER',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.fromLTRB(
              0,
              MediaQuery.of(context).size.width * 0.09,
              0,
              MediaQuery.of(context).size.width * 0.09),
          child: Form(
            key: _scaffoldKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(Config.logo),
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                inputDecoration(
                  hint: 'Enter your email',
                  inputcontroller: email,
                  enable: enable,
                ),
                inputDecoration(
                  hint: 'Enter your name',
                  inputcontroller: name,
                  enable: enable,
                ),
                inputPhoneNumber(
                  hint: 'Enter your phone number',
                  phoneController: phone,
                  enable: enable,
                ),
                inputDOB(
                  hint: 'Date of birth',
                  dobController: dob,
                  enable: enable,
                ),
                inputDecorationPassword(
                  passwordHint: 'Password',
                  passwordController: password,
                  enable: enable,
                ),
                inputDecorationPassword(
                  passwordHint: 'Confirm Password',
                  passwordController: confirmpassword,
                  enable: enable,
                ),
                buttonRounded(context, registerController, darkblue,
                    FontAwesomeIcons.registered, 'Sign up', register),
                InkWell(
                  onTap: () {
                    nextScreen(context, const Login());
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          Text('Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: darkblue)),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Future register() async {
    setState(() {
      enable = false;
    });
    if (phone.text.isNotEmpty ||
        email.text.isNotEmpty ||
        name.text.isNotEmpty ||
        password.text.isNotEmpty ||
        confirmpassword.text.isNotEmpty) {
      if (email.text.contains("@gmail.com") ||
          email.text.contains("@st.huflit.edu.vn")) {
        if (phone.text.length == 9) {
          if (confirmpassword.text == password.text) {
            if (confirmpassword.text.length > 8) {
              final sp = context.read<SignInProvider>();
              final ip = context.read<InternetProvider>();
              await ip.checkInternetConnection();

              sp.checkEmailExists(email.text.toString()).then((value) async {
                if (value == true) {
                  //user exists
                  openSnackbar(context, "This email is used", Colors.red);
                  registerController.reset();
                } else {
                  //user doesn't exist
                  if (ip.hasInternet == false) {
                    openSnackbar(
                        context, "Check your internet connection", Colors.red);
                  } else {
                    if (_scaffoldKey.currentState!.validate()) {
                      code = createCode();
                      sendingmail(
                          name: name.text.toString().trim(),
                          email: email.text.toString().trim(),
                          subject: 'Your code to register new account',
                          message: code);
                      registerController.success();
                      //chuyển sang trang xác nhận email
                      checkEmaildata();
                    }
                  }
                }
              });
            } else {
              openSnackbar(context, 'Password more 8', Colors.red);
              registerController.reset();
            }
          } else {
            openSnackbar(
                context, 'Confirm password does not match', Colors.red);
            registerController.reset();
          }
        } else {
          openSnackbar(
              context, 'Your phone number must be 10 character', Colors.red);
          registerController.reset();
        }
      } else {
        openSnackbar(context, 'Please fill correct email format', Colors.red);
        registerController.reset();
      }
    } else {
      openSnackbar(context, 'Please fill full information', Colors.red);
      registerController.reset();
    }

    setState(() {
      enable = true;
    });
  }

  void checkEmaildata() {
    nextScreenReplace(
        context,
        ConfirmEmail(
          code: code,
          email: email.text.toString().trim(),
          name: name.text.toString().trim(),
          phone: phone.text.toString().trim(),
          password: password.text.toString().trim(),
          dob: dob.text,
        ));
  }

  void handleAfterSingIn() {
    Future.delayed(const Duration(microseconds: 1000)).then((value) {
      nextScreenReplace(context, const StudentMainPage());
    });
  }
}
