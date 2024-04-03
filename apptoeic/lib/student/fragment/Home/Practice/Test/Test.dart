import 'package:apptoeic/student/fragment/Home/Practice/Audio.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Result/Result.dart';
import 'package:apptoeic/utils/AltertDialog.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';

class TestPractice extends StatefulWidget {
  TestPractice(
      {super.key,
      required this.audioPlayer,
      required this.question,
      required this.isplaying,
      required this.answer});

  final question;
  final answer;
  final isplaying;
  final audioPlayer;

  @override
  State<TestPractice> createState() => _TestPracticeState();
}

class _TestPracticeState extends State<TestPractice>
    with AutomaticKeepAliveClientMixin {
  String? question;
  List<String> awsList = <String>[];
  List<String> optionList = <String>[
    "A",
    "B",
    "C",
    "D",
  ];

  String? linkImage;
  String? linkAudio;
  List<bool> isButtonPressed = <bool>[false, false, false, false];

  double lineHeight = 1.2;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    awsList = <String>[
      widget.question.opA,
      widget.question.opB,
      widget.question.opC,
      widget.question.opD,
    ];

    linkImage = widget.question.image;
    linkAudio = widget.question.audio;
    print(widget.question.content);
    linkAudio == null
        ? question = widget.question.content
        : question = 'Select the answer';
  }

  @override
  Widget build(BuildContext context) {
    lineHeight = getTextHeight(
      question!,
      const TextStyle(
        fontSize: 20.5,
        fontWeight: FontWeight.bold,
      ),
      MediaQuery.of(context)
          .size
          .width, // hoặc bất kỳ chiều rộng nào bạn muốn sử dụng
    );

    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.625 + lineHeight * 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            linkAudio != null
                ? AudioListening(
                    audioPlayer: widget.audioPlayer,
                    isplaying: widget.isplaying,
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
                  lineHeight * 1.2,
              child: Text(
                question!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17, color: darkblue),
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
              child: linkImage != null
                  ? Image.network(
                      linkImage!,
                      fit: BoxFit.cover,
                    )
                  : ListView.builder(
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.sizeOf(context).width * 0.05,
                              top: MediaQuery.sizeOf(context).height * 0.04),
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
            SizedBox(
              //color: Colors.black,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return buildSelectOption(index);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectOption(index) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromHeight(60),
            primary: !isButtonPressed[index] ? backGroundColor : darkblue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70),
              // Đặt độ cong của góc
              side: const BorderSide(
                  color: Colors.grey,
                  width: 1), // Đặt màu và độ dày của đường viền
            ), // Đặt màu nền
          ),
          child: Text(
            optionList[index],
            style: TextStyle(
                color: !isButtonPressed[index] ? Colors.black : Colors.white,
                fontSize: 18,
                fontWeight:
                    isButtonPressed[index] ? FontWeight.bold : FontWeight.w500),
          ),
          onPressed: () {
            setState(() {
              for (int i = 0; i < 4; i++) {
                if (i == index) {
                  widget.answer.removeAt(1);
                  widget.answer.add(i + 1);
                  print('${widget.answer[0]} , ${widget.answer[1]}');
                  isButtonPressed[i] = true;
                } else {
                  isButtonPressed[i] = false;
                }
              }
              setState(() {});
            });
          },
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
