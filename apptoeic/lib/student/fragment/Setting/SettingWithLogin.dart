import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../provider/signin_provider.dart';
import '../../../utils/GetNewPassword/ConfirmPassword.dart';
import '../../../utils/Login/emailsender.dart';
import '../../../utils/constColor.dart';
import '../../../utils/next_screen.dart';
import '../../../utils/snack_bar.dart';
import 'ProfileCustome.dart';

class SettingWithLogin extends StatefulWidget {
  const SettingWithLogin({super.key});

  @override
  State<SettingWithLogin> createState() => _SettingWithLoginState();
}

class _SettingWithLoginState extends State<SettingWithLogin> {
  late SignInProvider sp;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildContent();
        } else {
          // Nếu đang load dữ liệu, có thể hiển thị một widget loading
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

  Future getData() async {
    sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreference();
  }

  Widget buildContent() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          right: MediaQuery.sizeOf(context).height * 0.01,
          left: MediaQuery.sizeOf(context).height * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage("${sp.imageUrl}"),
            radius: 50,
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          Text(
            "${sp.name}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
          ),
          InkWell(
            child: const SettingContainer(
              icon: Icons.account_circle,
              hint: 'Personal information',
            ),
            onTap: () {
              //nextScreen(context, const ProfileCustome());

              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileCustome()))
                  .then((value) => setState(() {}));
            },
          ),
          InkWell(
            child: const SettingContainer(
              icon: Icons.password_outlined,
              hint: 'Change Password',
            ),
            onTap: () {
              if (sp.provider == "GOOGLE" || sp.provider == "PHONE") {
                openSnackbar(context, "Change password is invalid", Colors.red);
              } else {
                String code = createCode();
                sendingmail(
                    name: sp.name.toString(),
                    email: sp.email.toString(),
                    subject: 'Change your password',
                    message: code);
                nextScreen(context,
                    ConfirmPassword(code: code, email: sp.email.toString()));
              }
            },
          ),
          InkWell(
            child: const SettingContainer(
              icon: Icons.feed_rounded,
              hint: 'Feedback & Support',
            ),
            onTap: () {},
          ),
          InkWell(
            child: const SettingContainer(
              icon: Icons.logout,
              hint: 'Logout',
            ),
            onTap: () async {
              await sp.userSignout();
              nextScreenReplace(context, const StudentMainPage());
            },
          ),
          Container(
            margin: EdgeInsets.only(
                right: MediaQuery.sizeOf(context).height * 0.02,
                left: MediaQuery.sizeOf(context).height * 0.02),
            height: MediaQuery.sizeOf(context).height * 0.09,
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
            )),
          )
          // Các phần còn lại của widget...
        ],
      ),
    );
  }
}
