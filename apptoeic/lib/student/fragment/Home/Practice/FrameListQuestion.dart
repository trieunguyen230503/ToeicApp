import 'package:apptoeic/student/fragment/Home/Practice/Test.dart';
import 'package:apptoeic/utils/AltertDialog.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';

class FrameListQuestion extends StatefulWidget {
  const FrameListQuestion({super.key, this.numberQuestion});

  final numberQuestion;

  @override
  State<FrameListQuestion> createState() => _FrameListQuestionState();
}

class _FrameListQuestionState extends State<FrameListQuestion> {
  @override
  Widget build(BuildContext context) {
    void closePage() {}

    return DefaultTabController(
        length: widget.numberQuestion,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                openAlertDialog(
                    context,
                    'Do you want to quit ? ',
                    'You will lose the progress of the lesson '
                        'if you quit now.',
                    'Quit');
              },
            ),
            backgroundColor: darkblue,
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: yellowLight,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.white,
              labelColor: yellowLight,
              tabs: [
                for (int i = 0; i < widget.numberQuestion; i++)
                  Tab(
                    text: 'Câu ${i + 1}',
                  )
              ],
            ),
          ),
          body: TabBarView(
            //Giữ nguyên trạng thái giữa các trang
            children: [
              for (int i = 0; i < widget.numberQuestion; i++)
                const TestPractice(),
            ],
          ),
        ));
  }
}
