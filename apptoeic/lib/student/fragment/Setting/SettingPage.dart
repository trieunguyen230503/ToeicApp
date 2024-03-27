import 'package:apptoeic/student/fragment/Setting/SettingWithLogin.dart';
import 'package:apptoeic/student/fragment/Setting/SetttingWOLogin.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/signin_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool checklogin = false;

  Future<bool> Check() async {
    final sp = context.read<SignInProvider>();
    await sp.checkSignInUser();
    print(sp.isSignedIn);
    return sp.isSignedIn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: Check(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          checklogin = snapshot.data ?? false;
          return checklogin == true
              ? const SettingWithLogin()
              : const OpResLogin();
        } else {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: darkblue,
              strokeWidth: 5,
            ),
          );
        }
      },
    );
  }
}
