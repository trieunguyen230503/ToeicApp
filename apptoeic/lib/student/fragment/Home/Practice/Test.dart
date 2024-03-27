import 'package:apptoeic/utils/AltertDialog.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class TestPractice extends StatefulWidget {
  const TestPractice({super.key});

  @override
  State<TestPractice> createState() => _TestPracticeState();
}

class _TestPracticeState extends State<TestPractice>
    with AutomaticKeepAliveClientMixin {
  String question = "Do you know who my father is?";
  List<String> awsList = <String>[
    "Yes",
    "No",
    "Who care ?",
    "My dog",
  ];
  List<String> optionList = <String>[
    "A",
    "B",
    "C",
    "D",
  ];

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

  int? _selectedValue;

  @override
  Widget build(BuildContext context) {
    lineHeight = getTextHeight(
      question,
      const TextStyle(
        fontSize: 20.5,
        fontWeight: FontWeight.bold,
      ),
      MediaQuery.of(context)
          .size
          .width, // hoặc bất kỳ chiều rộng nào bạn muốn sử dụng
    );
    print(lineHeight);
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    lineHeight * 1.1,
                child: Text(
                  question,
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
                child: ListView.builder(
                    itemCount: awsList.length,
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
                height: 50,
              ),
              SizedBox(
                //color: Colors.black,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.1,
                child: GridView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size.fromHeight(60),
                            primary: !isButtonPressed[index]
                                ? backGroundColor
                                : darkblue,
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
                                color: !isButtonPressed[index]
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18,
                                fontWeight: isButtonPressed[index]
                                    ? FontWeight.bold
                                    : FontWeight.w500),
                          ),
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < 4; i++) {
                                if (i == index) {
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
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: darkblue,
                      fixedSize: const Size(140, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    openAlertDialog(
                        context,
                        'Submit ?',
                        'You can view the '
                            'results and answers, after you have submitted the '
                            'test',
                        'Submit');
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 15),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
