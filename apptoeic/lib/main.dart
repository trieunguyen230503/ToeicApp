import 'package:apptoeic/provider/internet_provider.dart';
import 'package:apptoeic/provider/signin_provider.dart';
import 'package:apptoeic/splashscreen.dart';
import 'package:apptoeic/student/fragment/Home/ScanText/ScanPage.dart';
import 'package:apptoeic/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:apptoeic/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAZ0oFqwT0ih6fPuZAUOig54DCgm0wqpIg",
          appId: "1:737044940192:android:d310c3099c2acb13b510c5",
          messagingSenderId: "737044940192",
          projectId: "apptoeic-a4ce0"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider( // cung cấp nhiều provider
      providers: [
        //Mỗi provider con có thể cung cấp một đối tượng riêng để sử dụng trong cả ứng dụng
        //Cho phép tổ chức và quản lý việc cung cấp dữ liệu trong cả ứng dụng
        ChangeNotifierProvider(create: (context) => SignInProvider()), //Tạo ra instance và duy trì trong suốt vòng đời của ứng dụng
        ChangeNotifierProvider(create: (context) => InternetProvider())
      ],
      child: MaterialApp(
        routes: {
          'scanPage' : (context) => const ScanPage()
        },
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: lightMode,
        darkTheme: darkMode,
      ),
    );
  }
}
