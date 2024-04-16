import 'package:apptoeic/student/fragment/Home/Practice/Result/DetailAnswer.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';

class ShowAnswers extends StatefulWidget {
  const ShowAnswers(
      {super.key, required this.answerList, required this.lstQuestion});

  final answerList;
  final lstQuestion;

  @override
  State<ShowAnswers> createState() => _ShowAnswersState();
}

class _ShowAnswersState extends State<ShowAnswers> {
  List<String> lstOption = ['A', 'B', 'C', 'D'];
  int count = 5;

  //Option:  Correct Answer, Actual Answer
  // Map<int, List<int>> lstAnswer = {
  //   0: [0, 0],
  //   1: [1, 1],
  //   2: [2, 3],
  //   3: [1, 3],
  //   4: [3, 3],
  //   5: [3, 2],
  //   6: [1, 1],
  //   7: [1, 2],
  //   8: [3, 2],
  //   9: [2, 1],
  //   10: [3, 0],
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'SHOW ANSWERS',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            nextScreen(
                                context,
                                DetailAnswer(
                                  answer: widget.answerList[index],
                                  numerQuestion: index,
                                  question: widget.lstQuestion[index],
                                ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Question ${index + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 2),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 4,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // == 4 là chưa trả lời mà nộp bài -> Xanh -> Đỏ
                                          color: widget.answerList[index]?[1] ==
                                                      5 &&
                                                  i + 1 ==
                                                      widget.answerList[index]
                                                          ?[0]
                                              ? Colors.orange
                                              : (i + 1 ==
                                                      widget.answerList[index]
                                                          ?[0]
                                                  ? darkblue
                                                  : (widget.answerList[index]
                                                                  ?[1] !=
                                                              widget.answerList[index]
                                                                  ?[0] &&
                                                          i + 1 ==
                                                              widget.answerList[index]
                                                                  ?[1]
                                                      ? const Color.fromRGBO(
                                                          234, 67, 53, 1)
                                                      : Colors.white)),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            lstOption[i],
                                            style: TextStyle(
                                                color: i + 1 ==
                                                            widget.answerList[
                                                                index]?[0] ||
                                                        i + 1 ==
                                                            widget.answerList[
                                                                index]?[1]
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: widget.answerList.length,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            nextScreen(
                                context,
                                DetailAnswer(
                                  answer: widget.answerList[index],
                                  numerQuestion: index,
                                  question: widget.lstQuestion[index],
                                ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            // Chỉnh chiều cao của từng hàng
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Question ${index + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 2),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Container(
                                  //color: Colors.grey,
                                  padding: EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.035),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7, // Chỉnh chiều dài của khung chứa hình tròn đáp án
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 4,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 65,// khoảng cách giữa các hình
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (BuildContext context, int i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // == 4 là chưa trả lời mà nộp bài -> Xanh -> Đỏ
                                          color: widget.answerList[index]?[1] ==
                                                      5 &&
                                                  i + 1 ==
                                                      widget.answerList[index]
                                                          ?[0]
                                              ? Colors.orange
                                              : (i + 1 ==
                                                      widget.answerList[index]
                                                          ?[0]
                                                  ? darkblue
                                                  : (widget.answerList[index]
                                                                  ?[1] !=
                                                              widget.answerList[index]
                                                                  ?[0] &&
                                                          i + 1 ==
                                                              widget.answerList[index]
                                                                  ?[1]
                                                      ? const Color.fromRGBO(
                                                          234, 67, 53, 1)
                                                      : Colors.white)),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            lstOption[i],
                                            style: TextStyle(
                                                color: i + 1 ==
                                                            widget.answerList[
                                                                index]?[0] ||
                                                        i + 1 ==
                                                            widget.answerList[
                                                                index]?[1]
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: widget.answerList.length,
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}
