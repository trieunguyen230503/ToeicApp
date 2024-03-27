import 'package:apptoeic/student/fragment/Home/ItemHomePage.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic/student/fragment/Home/Slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> lstTag = ['Training', 'Exam Preparation'];

  List<String> lstTitle1 = [
    'Reading',
    'Listening',
    'Pratice Test',
    'Vocabulary',
  ];

  List<String> lstTitle2 = [
    'Trial Exam',
    'History',
  ];

  List<String> lstImageTraning = [
    'assets/apptoeic/icon/icon_listening.png',
    'assets/apptoeic/icon/icon_reading.png',
    'assets/apptoeic/icon/listening_reading.png',
    'assets/apptoeic/icon/vocab.png',
  ];

  List<String> lstImageEP = [
    'assets/apptoeic/icon/listening_reading.png',
    'assets/apptoeic/icon/icon_reading.png',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: backGroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SliderImage(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.04,
            ),
            ItemHomePage(
              title: lstTag[0],
              lstImg: lstImageTraning,
              lstHeadline: lstTitle1,
            ),
            ItemHomePage(
              title: lstTag[1],
              lstImg: lstImageEP,
              lstHeadline: lstTitle2,
            )
          ],
        ),
      ),
    ));
  }
}
