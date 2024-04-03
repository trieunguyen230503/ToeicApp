import 'package:apptoeic/student/fragment/Home/Item/History.dart';
import 'package:apptoeic/student/fragment/Home/Item/ItemHomePage.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Test/CategoryPractice.dart';
import 'package:apptoeic/utils/config.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic/student/fragment/Home/Item/Slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> lstTag = ['Training', 'Advanced Tool'];

  List<String> lstTitle1 = [
    'Reading',
    'Listening',
    'History',
    'Vocabulary',
  ];

  List<String> lstTitle2 = [
    'Translator',
  ];

  List<String> lstImageTraning = [
    Config.itemHomePage1,
    Config.itemHomePage2,
    Config.itemHomePage3,
    Config.itemHomePage4,
  ];

  List<String> lstImageEP = [
    Config.itemHomePage5,
  ];

  List<Widget> lstWiget1 = [
    CategoryTest(
      title: 'READING',
      imageTitle: Config.itemHomePage1,
    ),
    CategoryTest(
      title: 'LISTENING',
      imageTitle: Config.itemHomePage2,
    ),
    const History(),
    CategoryTest(
      title: 'LISTENING',
      imageTitle: Config.itemHomePage3,
    )
  ];

  List<Widget> lstWiget2 = [
    CategoryTest(
      title: 'TRANSLATOR',
      imageTitle: Config.itemHomePage4,
    )
  ];

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
              lstWiget: lstWiget1,
            ),
            ItemHomePage(
              title: lstTag[1],
              lstImg: lstImageEP,
              lstHeadline: lstTitle2,
              lstWiget: lstWiget2,
            )
          ],
        ),
      ),
    ));
  }
}
