import 'package:apptoeic/student/fragment/Home/Practice/Test/FrameListQuestion.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Test/TestPractice.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constText.dart';

class CategoryTest extends StatefulWidget {
  const CategoryTest(
      {super.key, required this.title, required this.imageTitle});

  final title;
  final imageTitle;

  @override
  State<CategoryTest> createState() => _CategoryTestState();
}

class _CategoryTestState extends State<CategoryTest> {
  List<int> selectedValue = <int>[5, 5, 5];

  List<String> itemCategory = <String>[];
  List<String> itemCategoryId = <String>[];

  Future getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('PracticeCate')
        .where('Type', isEqualTo: widget.title.toString().toLowerCase())
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        itemCategory.add(document['Content']);
        itemCategoryId.add(document['IDPracticeCate']);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkblue,
        centerTitle: true,
        title: TextAppbar('${widget.title} PRATICE'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return OrientationBuilder(builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  double h = MediaQuery.sizeOf(context).height;
                  double w = MediaQuery.sizeOf(context).width;
                  return Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Column(children: [
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
                              w * 0.08, h * 0.04, w * 0.08, 0),
                          width: w,
                          height: h * 0.15,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, w * 0.08, 0),
                                child: Image.asset(
                                  widget.imageTitle,
                                  width: w * 0.15,
                                  height: h * 0.1,
                                ),
                              ),
                              Container(
                                width: w * 0.45,
                                height: h * 0.08,
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
                            padding: EdgeInsets.only(top: h * 0.005),
                            child: ListView.builder(
                                itemCount: itemCategory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        w * 0.08, h * 0.04, w * 0.08, 0),
                                    child: InkWell(
                                      onTap: () {
                                        nextScreenReplace(
                                            context,
                                            FrameListQuestion(
                                              numberQuestion:
                                                  selectedValue[index],
                                              isTest: false,
                                              type: widget.title
                                                      .substring(0, 1)
                                                      .toUpperCase() +
                                                  widget.title
                                                      .substring(1)
                                                      .toLowerCase(),
                                              itemCategoryId:
                                                  itemCategoryId[index],
                                            ));
                                      },
                                      child: Container(
                                        width: w,
                                        height: h * 0.15,
                                        padding: EdgeInsets.fromLTRB(
                                            w * 0.07, h * 0.035, 0, 0),
                                        decoration: BoxDecoration(
                                          color: darkblue,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Text(
                                                    'The number of question ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DropDownList(
                                                  selectedValue: selectedValue,
                                                  i: index,
                                                ),
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
                      ]));
                } else {
                  double h = MediaQuery.sizeOf(context).width;
                  double w = MediaQuery.sizeOf(context).height * 0.8;
                  return Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Column(children: [
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
                              w * 0.08, h * 0.04, w * 0.08, 0),
                          width: w,
                          height: h * 0.15,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, w * 0.08, 0),
                                child: Image.asset(
                                  widget.imageTitle,
                                  width: w * 0.15,
                                  height: h * 0.1,
                                ),
                              ),
                              Container(
                                width: w * 0.45,
                                height: h * 0.08,
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
                            padding: EdgeInsets.only(top: h * 0.005),
                            child: ListView.builder(
                                itemCount: itemCategory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        w * 0.08, h * 0.04, w * 0.08, h * 0.04),
                                    child: InkWell(
                                      onTap: () {
                                        nextScreenReplace(
                                            context,
                                            FrameListQuestion(
                                              numberQuestion:
                                                  selectedValue[index],
                                              isTest: false,
                                              type: widget.title
                                                      .substring(0, 1)
                                                      .toUpperCase() +
                                                  widget.title
                                                      .substring(1)
                                                      .toLowerCase(),
                                              itemCategoryId:
                                                  itemCategoryId[index],
                                            ));
                                      },
                                      child: Container(
                                        width: w,
                                        height: h * 0.15,
                                        padding: EdgeInsets.fromLTRB(
                                            w * 0.07, h * 0.035, 0, 0),
                                        decoration: BoxDecoration(
                                          color: darkblue,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Text(
                                                    'The number of question ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DropDownList(
                                                  selectedValue: selectedValue,
                                                  i: index,
                                                ),
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
                      ]));
                }
              });
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: darkblue,
                  strokeWidth: 5,
                ),
              );
            }
          }),
    );
  }
}

class DropDownList extends StatefulWidget {
  const DropDownList({super.key, required this.selectedValue, required this.i});

  final selectedValue;
  final i;

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
        dropdownColor: Colors.grey,
        value: widget.selectedValue[widget.i],
        items: List.generate(
            6,
            (index) => DropdownMenuItem(
                value: (index + 1) * 5,
                child: SizedBox(
                  width: 20,
                  child: Text(
                    '${(index + 1) * 5}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))),
        onChanged: (value) {
          setState(() {
            widget.selectedValue.removeAt(widget.i);
            widget.selectedValue.insert(widget.i, value!);
          });
        });
  }
}
