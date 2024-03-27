import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';

class TestType extends StatefulWidget {
  const TestType({super.key});

  @override
  State<TestType> createState() => _TestTypeState();
}

class _TestTypeState extends State<TestType> {
  List<String> lstExam = <String>[
    'Exam 1',
    'Exam 2',
    'Exam 3',
    'Exam 4',
    'Exam 5'
  ];
  final List<String> image = <String>[
    'assets/apptoeic/icon/icon_listening.png',
    'assets/apptoeic/icon/icon_reading.png',
    'assets/apptoeic/icon/listening_reading.png',
    'assets/apptoeic/icon/vocab.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *
          0.206 *
          (lstExam.length / 4).ceil(),
      //làm tròn đến số nguyên gần nhất. VD: 3.1 => 4
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.07,
        0,
        MediaQuery.of(context).size.width * 0.07,
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
            child: const Text(
              'TOEIC LISTENING & READING Fulltest | 300-500',
              style: TextStyle(
                color: darkblue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            //color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *
                0.17 *
                (lstExam.length / 4).ceil(),
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lstExam.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1 / 1.8,
                    mainAxisSpacing: 0),
                itemBuilder: (BuildContext builder, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(alignment: Alignment.center, children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                        ),
                        Positioned(
                          child: Image.asset(
                            width: MediaQuery.sizeOf(context).width / 4.6,
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            image[1],
                          ),
                        )
                      ]),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.01,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          lstExam[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
