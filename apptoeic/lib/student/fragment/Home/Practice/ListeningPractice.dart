import 'package:apptoeic/student/fragment/Home/Practice/FrameListQuestion.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Test.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constText.dart';

class CategoryTest extends StatefulWidget {
  const CategoryTest({super.key});

  @override
  State<CategoryTest> createState() => _CategoryTestState();
}

class _CategoryTestState extends State<CategoryTest> {
  List<String> itemCategory = <String>[
    'Complete the sentences',
    'Complete the passages',
    'Mixed tenses'
  ];
  List<int> selectedValue = <int>[5, 5, 5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkblue,
        centerTitle: true,
        title: TextAppbar('READING PRATICE'),
      ),
      body: Column(children: [
        Container(
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
          margin: EdgeInsets.fromLTRB(
              MediaQuery.sizeOf(context).width * 0.08,
              MediaQuery.sizeOf(context).height * 0.04,
              MediaQuery.sizeOf(context).width * 0.08,
              0),
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, 0, MediaQuery.sizeOf(context).width * 0.08, 0),
                child: Image.asset(
                  'assets/apptoeic/icon/icon_listening.png',
                  width: MediaQuery.sizeOf(context).width * 0.15,
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.45,
                height: MediaQuery.sizeOf(context).height * 0.08,
                child: const Text(
                  'SELECT THE FORM YOU WANT TO DO',
                  style: TextStyle(
                      fontSize: 18,
                      color: darkblue,
                      fontWeight: FontWeight.bold,
                      height: 1.5),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.005),
            child: ListView.builder(
                itemCount: itemCategory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.sizeOf(context).width * 0.08,
                        MediaQuery.sizeOf(context).height * 0.04,
                        MediaQuery.sizeOf(context).width * 0.08,
                        0),
                    child: InkWell(
                      onTap: () {
                        nextScreenReplace(
                            context,
                            FrameListQuestion(
                              numberQuestion: selectedValue[index],
                            ));
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.sizeOf(context).width * 0.07,
                            MediaQuery.sizeOf(context).height * 0.035,
                            0,
                            0),
                        decoration: BoxDecoration(
                          color: darkblue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemCategory[index],
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: yellowLight,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Text(
                                    'The number of question ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                DropdownButton<int>(
                                    dropdownColor: Colors.grey,
                                    value: selectedValue[index],
                                    items: List.generate(
                                        6,
                                        (index) => DropdownMenuItem(
                                            value: (index + 1) * 5,
                                            child: SizedBox(
                                              width: 20,
                                              child: Text(
                                                '${(index + 1) * 5}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue[index] = value!;
                                      });
                                    })
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        )
      ]),
    );
  }
}
