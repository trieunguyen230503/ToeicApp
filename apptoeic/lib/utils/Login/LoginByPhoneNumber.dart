import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/internet_provider.dart';
import '../../provider/signin_provider.dart';
import '../Button.dart';
import '../config.dart';
import '../constColor.dart';
import '../constContainer.dart';
import '../next_screen.dart';
import '../snack_bar.dart';

class LoginByPhoneNumber extends StatefulWidget {
  const LoginByPhoneNumber({super.key});

  @override
  State<LoginByPhoneNumber> createState() => _LoginByPhoneNumberState();
}

class _LoginByPhoneNumberState extends State<LoginByPhoneNumber> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final phonenumer = TextEditingController();
  final otpCodeController = TextEditingController();

  late SharedPreferences logindata;

  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController confirmCode =
      RoundedLoadingButtonController();

  bool enable1 = true;
  bool enable2 = true;
  String IDverify = '';

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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(Config.logo),
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  width: MediaQuery.sizeOf(context).height * 0.2,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                ),
                inputPhoneNumber(
                  hint: 'Enter your phone number',
                  phoneController: phonenumer,
                  enable: enable1, orientation: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                buttonRounded(
                    context,
                    phoneController,
                    darkblue,
                    FontAwesomeIcons.phone,
                    'Sign in with phone number',
                    handlePhoneNumber,1),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future handlePhoneNumber() async {
    setState(() {
      enable1 = false;
    });
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackbar(context, 'Check your internet connection', Colors.red);
    } else {
      if (phonenumer.text.isNotEmpty) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+84${phonenumer.text.trim()}',
            //AuthCredential là một đối tượng đại diện cho thông tin xác thực được sử dụng để xác thực người dùng
            verificationCompleted: (AuthCredential credential) async {
              // Xác thực người dùng tự động nếu họ đã nhập mã OTP và được xác thực thành công
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              // Xử lý khi việc xác thực không thành công
              openSnackbar(context, e.toString(), Colors.red);
              phoneController.reset();
              setState(() {
                enable1 = true;
                enable2 = true;
              });
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              // Xử lý khi mã xác thực OTP đã được gửi thành công đến số điện thoại
              // Hiển thị giao diện để người dùng nhập mã OTP
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    //Gán vô để hàm handleSignIn dùng
                    IDverify = verificationId;
                    return AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      title: const Text(
                        'Enter Code',
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            enabled: enable2,
                            controller: otpCodeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6)
                            ],
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: darkblue),
                                ),
                                hintText: 'Your code',
                                prefixIcon: const Icon(Icons.phone_android),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide:
                                        const BorderSide(color: Colors.grey))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          buttonRounded(
                              context,
                              confirmCode,
                              darkblue,
                              FontAwesomeIcons.code,
                              'Confirm',
                              handleSignIn,1)
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verfication) {
              // Xử lý khi mã xác thực OTP tự động hết hạn
            });
      } else {
        openSnackbar(context, 'Please fill in your phone number', Colors);
        phoneController.reset();
      }
    }
  }

  Future handleSignIn() async {
    setState(() {
      enable1 = false;
    });
    final sp = context.read<SignInProvider>();

    final code = otpCodeController.text.trim();
    //việc xác thực đăng nhập bằng số điện thoại, nếu sai lập tức trả về
    //verificationFailed và không thực hiện các đoạn code phía dưới nữa

    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: IDverify, smsCode: code);

    //Kết quả trả về là một User object, đại diện cho người dùng đã đăng nhập thành công
    User user =
        (await FirebaseAuth.instance.signInWithCredential(authCredential))
            .user!;

    //Lưu vào firebase
    sp.phoneNumberUser(user);

    sp.checkUserExists().then((value) async {
      if (value == true) {
        //user exists
        await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
            .saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) => {
                  nextScreen(context, const StudentMainPage()),
                })));
      } else {
        //user doesn't exist
        sp.saveDataToFirestore().then((value) => sp
            .saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
                  nextScreen(context, const StudentMainPage());
                })));
      }
    });

    setState(() {
      enable1 = true;
      enable2 = true;
    });
  }
}
