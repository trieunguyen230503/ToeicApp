import 'package:apptoeic/model/Question.dart';
import 'package:apptoeic/provider/signin_provider.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Result/ShowAnswers.dart';
import 'package:apptoeic/utils/config.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  const Result(
      {super.key,
      required this.answerList,
      required this.type,
      required this.lstQuestion});

  final answerList;
  final lstQuestion;
  final type;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> with AutomaticKeepAliveClientMixin {
  int numberCorrectAnswer = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberCorrectAnswer = countCorrectAnswer();
    print(numberCorrectAnswer);
  }

  Future saveHistory() async {
    final sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreference();

    final DocumentReference history =
        FirebaseFirestore.instance.collection("history").doc();

    await history.set({
      'historyId': history.id,
      'type': widget.type.toString().toLowerCase(),
      'numberQuestion': widget.answerList.length,
      'date': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      'rate': double.parse(
          (numberCorrectAnswer * 100 / widget.answerList.length)
              .toStringAsFixed(2)),
      'uid': sp.uid,
    });

    for (int i = 0; i < widget.lstQuestion.length; i++) {
      final DocumentReference historyDetail =
          FirebaseFirestore.instance.collection('historyDetail').doc();

      await historyDetail.set({
        'historyDetailId': historyDetail.id,
        'questionId': widget.lstQuestion[i]?.id,
        'correctAnswer': widget.answerList[i][0],
        'actualAnswer': widget.answerList[i][1], //Đây là map<int,List<int>>
        'historyId': history.id,
      });
      print(historyDetail.id);
    }
  }

  int countCorrectAnswer() {
    return widget.answerList.values.where((list) => list[0] == list[1]).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkblue,
          title: const Text(
            'Result',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder(
            future: saveHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return OrientationBuilder(builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.05,
                          ),
                          SizedBox(
                            //color: Colors.red,
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            child: Image.asset(
                              Config.logo,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: 'Training ',
                                  ),
                                  TextSpan(
                                      text: widget.type,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline)),
                                ]),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.02,
                          ),
                          const Text(
                            'Accomplished!',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.02,
                          ),
                          Container(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              height: MediaQuery.sizeOf(context).height * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.25),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.06,
                                    right:
                                        MediaQuery.sizeOf(context).width * 0.01,
                                    top: MediaQuery.sizeOf(context).height *
                                        0.03,
                                    bottom: MediaQuery.sizeOf(context).height *
                                        0.03),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                            children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Result:  ',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic)),
                                          TextSpan(
                                            text: '${numberCorrectAnswer}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          TextSpan(
                                            text:
                                                '/${widget.answerList.length}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )
                                        ])),
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.02,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                            children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Your correct rate:  ',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic)),
                                          TextSpan(
                                              text:
                                                  '${double.parse((numberCorrectAnswer * 100 / widget.answerList.length).toStringAsFixed(2))}%',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ))
                                        ]))
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.03,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: darkblue,
                                  fixedSize: Size(
                                      MediaQuery.sizeOf(context).width * 0.5,
                                      MediaQuery.sizeOf(context).height * 0.07),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: () {
                                nextScreen(
                                    context,
                                    ShowAnswers(
                                      answerList: widget.answerList,
                                      lstQuestion: widget.lstQuestion,
                                    ));
                              },
                              child: const Text(
                                'View the answers',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ))
                        ],
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                            ),
                            SizedBox(
                              //color: Colors.red,
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: MediaQuery.sizeOf(context).height * 0.3,
                              child: Image.asset(
                                Config.logo,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Training ',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline)),
                                    TextSpan(
                                        text: widget.type,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                249, 192, 52, 1))),
                                  ]),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02,
                            ),
                            const Text(
                              'Accomplished!',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.02,
                            ),
                            Container(
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                height: MediaQuery.sizeOf(context).height * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.sizeOf(context).width *
                                          0.06,
                                      right: MediaQuery.sizeOf(context).width *
                                          0.01,
                                      top: MediaQuery.sizeOf(context).height *
                                          0.03,
                                      bottom:
                                          MediaQuery.sizeOf(context).height *
                                              0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Result:  ',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            TextSpan(
                                              text: '${numberCorrectAnswer}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            TextSpan(
                                              text:
                                                  '/${widget.answerList.length}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          ])),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Your correct rate:  ',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            TextSpan(
                                                text:
                                                    '${double.parse((numberCorrectAnswer * 100 / widget.answerList.length).toStringAsFixed(2))}%',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ))
                                          ]))
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.03,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: darkblue,
                                    fixedSize: Size(
                                        MediaQuery.sizeOf(context).width * 0.25,
                                        MediaQuery.sizeOf(context).height *
                                            0.15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () {
                                  nextScreen(
                                      context,
                                      ShowAnswers(
                                        answerList: widget.answerList,
                                        lstQuestion: widget.lstQuestion,
                                      ));
                                },
                                child: const Text(
                                  'View the answers',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                });
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: darkblue,
                    strokeWidth: 5,
                  ),
                );
              }
            }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
