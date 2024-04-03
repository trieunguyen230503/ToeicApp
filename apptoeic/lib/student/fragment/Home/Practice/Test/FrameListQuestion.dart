import 'dart:async';
import 'dart:math';
import 'package:apptoeic/model/Question.dart';
import 'package:apptoeic/student/StudentMainPage.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Result/Result.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Test/Test.dart';
import 'package:apptoeic/student/fragment/Test/CountDown.dart';
import 'package:apptoeic/utils/AltertDialog.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FrameListQuestion extends StatefulWidget {
  const FrameListQuestion(
      {super.key,
      required this.numberQuestion,
      required this.isTest,
      required this.type,
      required this.itemCategoryId});

  final numberQuestion;
  final isTest;
  final type;
  final itemCategoryId;

  @override
  State<FrameListQuestion> createState() => _FrameListQuestionState();
}

class _FrameListQuestionState extends State<FrameListQuestion>
    with SingleTickerProviderStateMixin {
  int _secondLeft = 10000;

  late Timer _timer;
  late TabController _tabController;

  List<Question>? lstQuestion;
  List<AudioPlayer>? listAudioPlayer;
  List<bool>? isplaying;

  bool _dataLoaded = false;

  Map<int, List<int>> lstAnswer = {};

  @override
  void initState() {
    super.initState();

    getData().then((value) {
      setState(() {
        _dataLoaded = true;
      });
    });

    listAudioPlayer =
        List.generate(widget.numberQuestion, (index) => AudioPlayer());
    isplaying = List.generate(widget.numberQuestion, (index) => false);

    _tabController = TabController(length: widget.numberQuestion, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        listAudioPlayer?[_tabController.previousIndex].pause();
        setState(() {
          isplaying?[_tabController.previousIndex] =
              !isplaying![_tabController.previousIndex];
        });
      }
    });

    if (widget.isTest) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondLeft == 0) {
          openAlertDialogTimeUp(
              context,
              'Time\'s up',
              'Please click submit to be recivied your result',
              'Submit',
              Result(
                answerList: lstAnswer,
                type: widget.type,
                lstQuestion: lstQuestion,
              ));
          _timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (int i = 0; i < widget.numberQuestion; i++) {
      listAudioPlayer?[i].stop();
    }
    super.dispose();
  }

  List getRandomElements(List<Question> originalList, int count) {
    if (count >= originalList.length) {
      return originalList; // Nếu số lượng yêu cầu lớn hơn hoặc bằng số lượng phần tử trong danh sách, trả về toàn bộ danh sách
    }

    var random = Random();
    var shuffledList = List.from(originalList);
    shuffledList.shuffle(random); // Xáo trộn danh sách

    return shuffledList.sublist(
        0, count); // Lấy một phần của danh sách đã xáo trộn
  }

  Future getData() async {
    lstQuestion = [];

    QuerySnapshot querySnapshot = widget.isTest
        ? await FirebaseFirestore.instance
            .collection('questions')
            .where('level', isEqualTo: widget.itemCategoryId)
            .get()
        : await FirebaseFirestore.instance
            .collection('questions')
            .where('practiceCate', isEqualTo: widget.itemCategoryId)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        lstQuestion?.add(Question.fromSnapShot(document));
      }
    }

    lstQuestion =
        getRandomElements(lstQuestion!, widget.numberQuestion).cast<Question>();
    for (int i = 0; i < lstQuestion!.length; i++) {
      //Add số câu và đáp án ban đầu
      lstAnswer.addAll({
        i: [lstQuestion![i].answer!, 5]
      });
    }
    print(lstQuestion!.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.numberQuestion,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: darkblue,
                      fixedSize: const Size(140, 70),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(50))
                    ),
                    onPressed: () {
                      String announce = '';
                      for (int i = 0; i < lstAnswer.length; i++) {
                        if (lstAnswer[i]![1] == 5) {
                          announce += '${(i + 1)}, ';
                        }
                      }
                      announce == ''
                          ? openAlertDialog(
                              context,
                              'Submit ?',
                              'You can view the '
                                  'results and answers, after you have submitted the '
                                  'test',
                              'Submit',
                              Result(
                                answerList: lstAnswer,
                                type: widget.type,
                                lstQuestion: lstQuestion,
                              ))
                          : openAlertDialog(
                              context,
                              'Do you want to quit ? ',
                              'Question $announce haven\'t been answered',
                              'Quit',
                              Result(
                                answerList: lstAnswer,
                                type: widget.type,
                                lstQuestion: lstQuestion,
                              ));
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                          fontSize: 15,
                          color: yellowLight,
                          fontWeight: FontWeight.bold),
                    )),
              ],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  openAlertDialog(
                      context,
                      'Do you want to quit ? ',
                      'You will lose the progress of the lesson '
                          'if you quit now.',
                      'Quit',
                      const StudentMainPage());
                },
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.05,
                  ),
                  widget.isTest
                      ? CountDownTime(
                          secondLeft: _secondLeft,
                          updateSecondLeft: (value) {
                            _secondLeft = value;
                          },
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                ],
              ),
              backgroundColor: darkblue,
              centerTitle: true,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: yellowLight,
                indicatorWeight: 5,
                unselectedLabelColor: Colors.white,
                labelColor: yellowLight,
                tabs: [
                  for (int i = 0; i < widget.numberQuestion; i++)
                    Tab(
                      text: 'Question ${i + 1}',
                    )
                ],
              ),
            ),
            body: _dataLoaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            for (int i = 0; i < widget.numberQuestion; i++)
                              TestPractice(
                                audioPlayer:
                                    listAudioPlayer?[_tabController.index],
                                isplaying: isplaying?[_tabController.index],
                                question: lstQuestion?[i],
                                answer: lstAnswer[i],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.06,
                      )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: darkblue,
                      strokeWidth: 5,
                    ),
                  )));
  }
}
