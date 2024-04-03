import 'package:apptoeic/utils/constColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/signin_provider.dart';
import '../../../utils/config.dart';
import '../../../utils/next_screen.dart';
import '../../../utils/snack_bar.dart';
import '../Home/Practice/Test/FrameListQuestion.dart';

class TestType extends StatefulWidget {
  const TestType({super.key, required this.level});

  final level;

  @override
  State<TestType> createState() => _TestTypeState();
}

class _TestTypeState extends State<TestType> {
  String title = 'TOEIC LISTENING & READING Fulltest | ';

  List<String> level = ['300-500', '500-700', '700-900'];
  Map<int, List<String>> lstTestLevel = {};

  bool isLogin = false;

  void checkLogin() async {
    final sp = context.read<SignInProvider>();
    await sp.checkSignInUser();
    isLogin = sp.isSignedIn;
  }

  Future getData() async {
    await widget.level == 1
        ? title = '${title}300-500'
        : (widget.level == 2
            ? title = '${title}500-700'
            : title = '${title}700-900');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('testLevel')
        .where('level', isEqualTo: widget.level)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        lstTestLevel.addAll({
          i: [querySnapshot.docs[i]['id'], querySnapshot.docs[i]['title']]
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              //color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.205 *
                  (lstTestLevel.length / 4).ceil(),
              //làm tròn đến số nguyên gần nhất. VD: 3.1 => 4
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.06,
                0,
                MediaQuery.of(context).size.width * 0.06,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      //top: MediaQuery.sizeOf(context).height * 0.025,
                      bottom: MediaQuery.sizeOf(context).height * 0.025,
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: darkblue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.blue,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *
                        0.15 *
                        (lstTestLevel.length / 4).ceil(),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lstTestLevel.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 27,
                                childAspectRatio: 1 / 1.8,
                                mainAxisSpacing: 0),
                        itemBuilder: (BuildContext builder, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  isLogin
                                      ? nextScreen(
                                          context,
                                          FrameListQuestion(
                                            numberQuestion: 10,
                                            isTest: true,
                                            type:
                                                'Exam ${index + 1} | ${level[widget.level - 1]}',
                                            itemCategoryId: lstTestLevel[index]
                                                ?[0],
                                          ))
                                      : openSnackbar(context,
                                          'Please login first', Colors.red);
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              )
                                            ]),
                                      ),
                                      Positioned(
                                        child: Image.asset(
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  4.6,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.05,
                                          widget.level == 1
                                              ? Config.itemTextType1
                                              : (widget.level == 2
                                                  ? Config.itemTextType2
                                                  : Config.itemTextType3),
                                        ),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.01,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  lstTestLevel[index]![1],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: darkblue,
                strokeWidth: 5,
              ),
            );
          }
        });
  }
}
