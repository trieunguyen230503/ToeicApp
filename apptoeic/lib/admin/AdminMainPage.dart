import 'package:apptoeic/provider/signin_provider.dart';
import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text('Admin nè')),
            ElevatedButton(
                onPressed: () async {
                  await sp.userSignout();
                  nextScreenReplace(context, const StudentMainPage());
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
