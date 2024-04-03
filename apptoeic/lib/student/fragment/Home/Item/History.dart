import 'package:apptoeic/model/HistoryDetail.dart';
import 'package:apptoeic/model/Question.dart';
import 'package:apptoeic/provider/signin_provider.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Result/ShowAnswers.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptoeic/model/History.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryUser> lstHistory = [];
  List<List<HistoryDetail>> lstHistoryDetail = [];
  List<List<Question>> listQuestion = [];
  List<Map<int, List<int>>> lstAnswer = [];

  Future getHistory() async {
    final sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreference();

    final QuerySnapshot querySnapshotHistory = await FirebaseFirestore.instance
        .collection('history')
        .where('uid', isEqualTo: sp.uid)
        .get();

    lstAnswer = List.generate(querySnapshotHistory.docs.length, (index) => {});
    listQuestion =
        List.generate(querySnapshotHistory.docs.length, (index) => []);
    lstHistoryDetail =
        List.generate(querySnapshotHistory.docs.length, (index) => []);

    //print('${lstAnswer.length} ${listQuestion.length}');
    for (int j = 0; j < querySnapshotHistory.docs.length; j++) {
      lstHistory.add(HistoryUser.fromSnapshot(querySnapshotHistory.docs[j]));

      final QuerySnapshot querySnapshotHistoryDetail = await FirebaseFirestore
          .instance
          .collection('historyDetail')
          .where('historyId', isEqualTo: lstHistory[j].historyID)
          .get();
      //print('Test $j');

      for (int i = 0; i < querySnapshotHistoryDetail.docs.length; i++) {
        //Lấy ra chi tiết lịch sử
        lstHistoryDetail[j].add(
            HistoryDetail.fromSnapshot(querySnapshotHistoryDetail.docs[i]));

        //Add list câu trả lời và đáp án đúng của câu hỏi, phải tương ứng với list của lịch sử nào
        lstAnswer[j].addAll({
          i: [
            lstHistoryDetail[j][i].correctAnswer!,
            lstHistoryDetail[j][i].actualAnswer!
          ]
        });
        //print(
        //    '${lstHistoryDetail[j][i].correctAnswer!} , ${lstHistoryDetail[j][i].actualAnswer!}');
        //Lấy ra các câu hỏi của chi tiết lịch sử
        final QuerySnapshot querySnapshotQuestion = await FirebaseFirestore
            .instance
            .collection('questions')
            .where('id',
                isEqualTo: querySnapshotHistoryDetail.docs[i]['questionId'])
            .get();

        listQuestion[j]
            .add(Question.fromSnapShot(querySnapshotQuestion.docs.first));

        //print('');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkblue,
          title: const Text(
            'HISTORY',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: getHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.1,
                      vertical: MediaQuery.sizeOf(context).width * 0.1),
                  child: ListView.builder(
                      itemCount: lstHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            nextScreen(
                                context,
                                ShowAnswers(
                                  answerList: lstAnswer[index],
                                  lstQuestion: listQuestion[index],
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.sizeOf(context).width * 0.07),
                            margin: EdgeInsets.only(
                                left: MediaQuery.sizeOf(context).width * 0.01,
                                right: MediaQuery.sizeOf(context).width * 0.01,
                                bottom:
                                    MediaQuery.sizeOf(context).height * 0.01,
                                top: MediaQuery.sizeOf(context).height * 0.01),
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.sizeOf(context).height * 0.15,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      lstHistory[index]
                                              .type
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          lstHistory[index]
                                              .type
                                              .toString()
                                              .substring(1)
                                              .toLowerCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      lstHistory[index].date.toString(),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            children: <TextSpan>[
                                          const TextSpan(
                                            text: 'Number of question: ',
                                            style: TextStyle(),
                                          ),
                                          TextSpan(
                                            text:
                                                '${lstHistory[index].numberQuestion}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ))),
                                    Text(
                                      '${lstHistory[index].rate}%',
                                      style: TextStyle(
                                          color: lstHistory[index].rate! > 50
                                              ? darkblue
                                              : const Color.fromRGBO(
                                                  234, 67, 53, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
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
}
