import 'package:apptoeic/admin/AdminMainPage.dart';
import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/Button.dart';
import 'package:apptoeic/utils/Login/LoginByPhoneNumber.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../provider/internet_provider.dart';
import '../../provider/signin_provider.dart';
import '../GetNewPassword/ForgetPassword.dart';
import '../Register/Register.dart';
import '../config.dart';
import '../next_screen.dart';
import '../snack_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool enable = true;

  final userName = TextEditingController();
  final password = TextEditingController();
  final otpCodeController = TextEditingController();

  late SharedPreferences logindata;
  final _scaffoldKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController loginController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  String pss = "test";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    check();
  }

  void check() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            // Đổi icon về
            onPressed: () {
              // Xử lý khi người dùng nhấn vào icon trở về
              Navigator.pop(context);
            },
          ),
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Form(
                        key: _scaffoldKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(Config.logo),
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            inputDecoration(
                              hint: 'Enter your email',
                              inputcontroller: userName,
                              enable: enable,
                              orientation: 1,
                            ),
                            inputDecorationPassword(
                              passwordHint: "Password",
                              passwordController: password,
                              enable: enable,
                              orientation: 1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            buttonRounded(context, loginController, darkblue,
                                Icons.login, 'Login', login, 1),
                            const SizedBox(
                              height: 20,
                            ),
                            buttonRounded(
                                context,
                                googleController,
                                Colors.red,
                                FontAwesomeIcons.google,
                                'Sign in with google',
                                handleGoogle,
                                1),
                            const SizedBox(
                              height: 20,
                            ),
                            buttonRounded(
                                context,
                                phoneController,
                                Colors.black,
                                FontAwesomeIcons.phone,
                                'Sign in with phone number',
                                nextScrenLoginByPhoneNumber,
                                1),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, const ForgetPassword());
                              },
                              child: Text('I forgot my password',
                                  style:
                                      TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.outline)),
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, const Register());
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Don\'t have an account? ',
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                      Text('Sign up',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.primary)),
                                    ]),
                              ),
                            ),
                          ],
                        ))));
          } else {
            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Form(
                        key: _scaffoldKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(Config.logo),
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            inputDecoration(
                              hint: 'Enter your email',
                              inputcontroller: userName,
                              enable: enable,
                              orientation: 2,
                            ),
                            inputDecorationPassword(
                              passwordHint: "Password",
                              passwordController: password,
                              enable: enable,
                              orientation: 2,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            buttonRounded(context, loginController, darkblue,
                                Icons.login, 'Login', login, 2),
                            const SizedBox(
                              height: 20,
                            ),
                            buttonRounded(
                                context,
                                googleController,
                                Colors.red,
                                FontAwesomeIcons.google,
                                'Sign in with google',
                                handleGoogle,
                                2),
                            const SizedBox(
                              height: 20,
                            ),
                            buttonRounded(
                                context,
                                phoneController,
                                Colors.black,
                                FontAwesomeIcons.phone,
                                'Sign in with phone number',
                                nextScrenLoginByPhoneNumber,
                                2),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, const ForgetPassword());
                              },
                              child: const Text('I forgot my password',
                                  style:
                                      TextStyle(fontSize: 15, color: darkblue)),
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, const Register());
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Don\'t have an account? ',
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                      Text('Sign up',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: darkblue)),
                                    ]),
                              ),
                            ),
                          ],
                        ))));
          }
        }));
  }

  void nextScrenLoginByPhoneNumber() {
    nextScreen(context, const LoginByPhoneNumber());
    phoneController.reset();
  }

  Future login() async {
    setState(() {
      enable = false;
    });
    if (userName.text.isNotEmpty) {
      String email = userName.text.toString().trim();
      String password1 = password.text.toString().trim();
      // gọi hàm checkLogin bên database.dart với tham số vào là username và password
      final sp = context.read<SignInProvider>();
      final ip = context.read<InternetProvider>();
      await ip.checkInternetConnection();

      sp.checkEmailLogin(email, password1).then((value) async {
        if (value == true) {
          await sp
              .saveDataToSharedPreferences()
              .then((value) => sp.setSignIn().then((value) => {
                    loginController.success(),
                    handleAfterSingIn(),
                  }));
        } else {
          openSnackbar(context, "Your information is not correct", Colors.red);
          loginController.reset();
        }
      });
    } else {
      openSnackbar(context, 'Please fill full of information', Colors.red);
      loginController.reset();
    }

    setState(() {
      enable = true;
    });
  }

  //handling google signin in
  Future handleGoogle() async {
    final sp = context.read<SignInProvider>();
    //internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.red),
                googleController.reset(),
                sp.hasError = false
              }
            else
              {
                //checkking whether user exist or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    //user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) => {
                              googleController.success(),
                              handleAfterSingIn(),
                            })));
                  } else {
                    //user doesn't exist
                    sp.saveDataToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSingIn();
                            })));
                  }
                }),
              }
          });
    }
  }

  void handleAfterSingIn() async {
    Future.delayed(const Duration(microseconds: 1000)).then((value) {
      nextScreenReplace(context, const StudentMainPage());
    });
  }
}
