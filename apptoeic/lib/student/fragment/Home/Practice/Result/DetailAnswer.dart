import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constColor.dart';
import '../AudioListening.dart';

class DetailAnswer extends StatefulWidget {
  const DetailAnswer(
      {super.key,
      required this.answer,
      required this.numerQuestion,
      required this.question});

  final answer;
  final numerQuestion;
  final question;

  @override
  State<DetailAnswer> createState() => _DetailAnswerState();
}

class _DetailAnswerState extends State<DetailAnswer> {
  //String question = "Do you know who my father is?";
  List<String> awsList = <String>[];

  List<String> optionList = <String>[
    "A",
    "B",
    "C",
    "D",
  ];
  double lineHeight = 1.2;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    awsList = [
      widget.question.opA,
      widget.question.opB,
      widget.question.opC,
      widget.question.opD,
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.stop();
  }

  double getTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: maxWidth);

    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    lineHeight = getTextHeight(
      widget.question.content ?? 'Select the answer',
      const TextStyle(
        fontSize: 20.5,
        fontWeight: FontWeight.bold,
      ),
      MediaQuery.of(context)
          .size
          .width, // hoặc bất kỳ chiều rộng nào bạn muốn sử dụng
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: darkblue,
        centerTitle: true,
        title: Text(
          'Question ${widget.numerQuestion + 1}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: OrientationBuilder(builder: (context, orientaion) {
        if (orientaion == Orientation.portrait) {
          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height + lineHeight * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  widget.question.audio != null
                      ? AudioListening(
                          audioPlayer: audioPlayer,
                          isplaying: false,
                          audioLink: widget.question.audio,
                        )
                      : SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.05,
                        top: MediaQuery.sizeOf(context).height * 0.035,
                        right: MediaQuery.sizeOf(context).width * 0.05,
                        bottom: MediaQuery.sizeOf(context).height * 0.035),
                    decoration: BoxDecoration(
                        color: blueLight,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2))
                        ]),
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    //Chiều cao bằng padding top + bottom + top + right + chiều cao của text => co dãn theo câu hỏi
                    height: (MediaQuery.sizeOf(context).height * 0.035 * 2) +
                        lineHeight * 1.4,
                    child: Text(
                      widget.question.audio == null
                          ? widget.question.content
                          : 'Select the answer',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: darkblue),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2)),
                        ]),
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: widget.question.audio != null
                        ? Image.network(
                            widget.question.image,
                            fit: BoxFit.cover,
                          )
                        : ListView.builder(
                            itemCount: awsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.sizeOf(context).width * 0.05,
                                    top:
                                        MediaQuery.sizeOf(context).height * 0.04),
                                child: Text(
                                  '${optionList[index]}.  ${awsList[index]}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    //color: Colors.black,
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    height: MediaQuery.sizeOf(context).height * 0.09,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 40,
                              childAspectRatio: 1 / 1.5),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.answer?[1] == 5 &&
                                    index + 1 == widget.answer[0]
                                ? Colors.orange
                                : (index + 1 == widget.answer?[0]
                                    ? darkblue
                                    : (widget.answer?[1] != widget.answer?[0] &&
                                            index + 1 == widget.answer?[1]
                                        ? const Color.fromRGBO(234, 67, 53, 1)
                                        : Colors.white)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              optionList[index],
                              style: TextStyle(
                                  color: index + 1 == widget.answer[0] ||
                                          index + 1 == widget.answer[1]
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
        } else {
          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 1.2 + lineHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  widget.question.audio != null
                      ? AudioListening(
                          audioPlayer: audioPlayer,
                          isplaying: false,
                          audioLink: widget.question.audio,
                        )
                      : SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.05,
                        top: MediaQuery.sizeOf(context).height * 0.035,
                        right: MediaQuery.sizeOf(context).width * 0.05,
                        bottom: MediaQuery.sizeOf(context).height * 0.035),
                    decoration: BoxDecoration(
                        color: blueLight,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2))
                        ]),
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    //Chiều cao bằng padding top + bottom + top + right + chiều cao của text => co dãn theo câu hỏi
                    height: (MediaQuery.sizeOf(context).height * 0.035 * 2) +
                        lineHeight * 1.4,
                    child: Text(
                      widget.question.audio == null
                          ? widget.question.content
                          : 'Select the answer',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: darkblue),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2)),
                        ]),
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    child: widget.question.audio != null
                        ? Image.network(
                            widget.question.image,
                            fit: BoxFit.cover,
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: awsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                    top: MediaQuery.sizeOf(context).height *
                                        0.04),
                                child: Text(
                                  '${optionList[index]}.  ${awsList[index]}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    //color: Colors.black,
                    padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).height * 0.1,
                        right: MediaQuery.sizeOf(context).height * 0.1),
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 75,
                              childAspectRatio: 1 / 1.5),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.answer?[1] == 5 &&
                                    index + 1 == widget.answer[0]
                                ? Colors.orange
                                : (index + 1 == widget.answer?[0]
                                    ? darkblue
                                    : (widget.answer?[1] != widget.answer?[0] &&
                                            index + 1 == widget.answer?[1]
                                        ? const Color.fromRGBO(234, 67, 53, 1)
                                        : Colors.white)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              optionList[index],
                              style: TextStyle(
                                  color: index + 1 == widget.answer[0] ||
                                          index + 1 == widget.answer[1]
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
        }
      }),
    );
  }
}
